package controller;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Timestamp;
import java.util.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import db_config.GetConnection;

public class LogoutAction extends BaseAction {

	/*
	 * A cross-module logout token is only useful for a few seconds.
	 * It is signed, single-use and bound to the Module 3 user ID.
	 */
	private static final long CROSS_MODULE_VALIDITY_MILLIS =
			60L * 1000L;

	private static final long CLOCK_SKEW_MILLIS =
			5L * 1000L;

	@Override
	public void execute(HttpServletRequest r, HttpServletResponse p)
			throws Exception {

		Integer tokenUserId = null;

		if ("POST".equalsIgnoreCase(r.getMethod())) {

			/*
			 * FrontController already validated the CSRF token for
			 * every POST request, so nothing else is needed here.
			 */

		} else if ("GET".equalsIgnoreCase(r.getMethod())) {

			/*
			 * GET logout is only accepted when Module 3 supplies a
			 * signed one-time token. This keeps cross-module logout
			 * working without allowing a plain link to log a user
			 * out.
			 */
			tokenUserId = verifyCrossModuleToken(r);

		} else {

			p.setHeader("Allow", "GET, POST");
			p.sendError(
					HttpServletResponse.SC_METHOD_NOT_ALLOWED,
					"Logout requires a POST request.");
			return;
		}

		HttpSession s = r.getSession(false);

		if (s != null) {

			Object sessionUserId = s.getAttribute("userId");

			/*
			 * If the token names a user, it must match the session
			 * being logged out. A token for another account cannot
			 * be used to end this user's session.
			 */
			if (tokenUserId != null
					&& tokenUserId.intValue() > 0
					&& sessionUserId instanceof Integer
					&& !tokenUserId.equals(sessionUserId)) {

				throw new SecurityException(
						"Logout token does not match the active session.");
			}

			if (sessionUserId instanceof Integer) {

				service.logout(
						(Integer) sessionUserId,
						ip(r));
			}

			try {

				s.invalidate();

			} catch (IllegalStateException ignored) {

				// Session was already invalidated.
			}
		}

		p.sendRedirect(r.getContextPath() + "/app?action=login");
	}

	/*
	 * ============================================================
	 * VERIFY CROSS-MODULE LOGOUT TOKEN
	 * ============================================================
	 *
	 * Format: base64url(userId|issuedAt|nonce).signature
	 *
	 * The signature uses the same shared secret as SSO. The nonce is
	 * consumed in the database, so a token can only be used once.
	 */

	private Integer verifyCrossModuleToken(
			HttpServletRequest r)
			throws Exception {

		String token = r.getParameter("logoutToken");

		if (token == null || token.trim().isEmpty()) {

			throw new SecurityException(
					"Logout requires a POST request.");
		}

		String[] parts = token.trim().split("\\.", 2);

		if (parts.length != 2) {

			throw new SecurityException(
					"Invalid logout token.");
		}

		String encodedPayload = parts[0];
		String suppliedSignature = parts[1];

		String sharedSecret = getSharedSecret(r);

		String expectedSignature =
				createSignature(encodedPayload, sharedSecret);

		if (!MessageDigest.isEqual(
				expectedSignature.getBytes(StandardCharsets.UTF_8),
				suppliedSignature.getBytes(StandardCharsets.UTF_8))) {

			throw new SecurityException(
					"Invalid logout token signature.");
		}

		String payload;

		try {

			payload = new String(
					Base64.getUrlDecoder().decode(encodedPayload),
					StandardCharsets.UTF_8);

		} catch (IllegalArgumentException e) {

			throw new SecurityException(
					"Invalid logout token encoding.");
		}

		String[] values = payload.split("\\|", -1);

		if (values.length != 3) {

			throw new SecurityException(
					"Invalid logout token payload.");
		}

		Integer tokenUserId;
		long issuedAt;

		try {

			tokenUserId = Integer.valueOf(values[0].trim());
			issuedAt = Long.parseLong(values[1].trim());

		} catch (NumberFormatException e) {

			throw new SecurityException(
					"Invalid logout token payload.");
		}

		String nonce = values[2] == null ? "" : values[2].trim();

		if (nonce.isEmpty()) {

			throw new SecurityException(
					"Invalid logout token nonce.");
		}

		long now = System.currentTimeMillis();

		if (issuedAt > now + CLOCK_SKEW_MILLIS) {

			throw new SecurityException(
					"Invalid logout token issue time.");
		}

		if (now - issuedAt > CROSS_MODULE_VALIDITY_MILLIS) {

			throw new SecurityException(
					"Logout token has expired.");
		}

		consumeNonce(nonce, issuedAt + CROSS_MODULE_VALIDITY_MILLIS);

		return tokenUserId;
	}

	private String getSharedSecret(HttpServletRequest r) {

		String sharedSecret =
				System.getenv("NLOGISTICS_SSO_SECRET");

		if (sharedSecret == null || sharedSecret.trim().isEmpty()) {

			sharedSecret = r.getServletContext()
					.getInitParameter("module3SharedSecret");
		}

		if (sharedSecret == null || sharedSecret.trim().isEmpty()) {

			throw new SecurityException(
					"SSO shared secret is not configured.");
		}

		return sharedSecret;
	}

	private String createSignature(
			String payload,
			String sharedSecret)
			throws Exception {

		Mac mac = Mac.getInstance("HmacSHA256");

		SecretKeySpec key = new SecretKeySpec(
				sharedSecret.getBytes(StandardCharsets.UTF_8),
				"HmacSHA256");

		mac.init(key);

		byte[] signature = mac.doFinal(
				payload.getBytes(StandardCharsets.UTF_8));

		return Base64.getUrlEncoder()
				.withoutPadding()
				.encodeToString(signature);
	}

	private void consumeNonce(
			String nonce,
			long expiresAtMillis) {

		Connection con = null;
		PreparedStatement cleanup = null;
		PreparedStatement insert = null;

		try {

			con = GetConnection.getConnection();

			if (con == null) {

				throw new SecurityException(
						"Unable to verify logout token replay protection.");
			}

			cleanup = con.prepareStatement(
					"DELETE FROM sso_nonce WHERE expires_at < NOW()");

			cleanup.executeUpdate();

			insert = con.prepareStatement(
					"INSERT INTO sso_nonce (nonce, expires_at) "
					+ "VALUES (?, ?)");

			insert.setString(1, nonce);
			insert.setTimestamp(2, new Timestamp(expiresAtMillis));

			insert.executeUpdate();

		} catch (SQLIntegrityConstraintViolationException e) {

			throw new SecurityException(
					"Logout token has already been used.");

		} catch (SQLException e) {

			if ("23000".equals(e.getSQLState())) {

				throw new SecurityException(
						"Logout token has already been used.");
			}

			throw new SecurityException(
					"Unable to verify logout token replay protection.");

		} finally {

			close(insert);
			close(cleanup);
			close(con);
		}
	}

	private void close(PreparedStatement ps) {

		if (ps != null) {

			try {

				ps.close();

			} catch (SQLException ignored) {

				// Ignore closing error.
			}
		}
	}

	private void close(Connection con) {

		if (con != null) {

			try {

				con.close();

			} catch (SQLException ignored) {

				// Ignore closing error.
			}
		}
	}
}
