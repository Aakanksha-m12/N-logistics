package controller;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import javax.net.ssl.*;
import java.util.Base64;

/**
 * Sends reset codes through Gmail SMTP when environment variables are configured;
 * otherwise logs the code in development.
 */
public final class ResetMailer {

	private ResetMailer() {
	}

	public static void send(String to, String token) {

		String host = System.getenv("NLOGISTICS_SMTP_HOST");
		String user = System.getenv("NLOGISTICS_SMTP_USER");
		String pass = System.getenv("NLOGISTICS_SMTP_PASS");
		String from = System.getenv("NLOGISTICS_SMTP_FROM");
		String port = System.getenv("NLOGISTICS_SMTP_PORT");

		if (host == null || user == null || pass == null) {
			System.out.println(
					"[N-LOGISTICS PASSWORD RESET - DEV MODE] recipient=" + to + " OTP=" + token
							+ " expires=10-minutes");
			return;
		}

		try {
			sendSmtp(
					host,
					port == null ? "465" : port,
					user,
					pass,
					from == null ? user : from,
					to,
					token
			);

			System.out.println("[N-LOGISTICS] Password reset email sent successfully to " + to);

		} catch (Exception e) {
			System.err.println(
					"Password reset email could not be sent: " + e.getMessage());

			System.out.println(
					"[DEV FALLBACK] recipient=" + to + " OTP=" + token
							+ " expires=10-minutes");
		}
	}

	private static void sendSmtp(
			String host,
			String port,
			String user,
			String pass,
			String from,
			String to,
			String token) throws Exception {

		int smtpPort = Integer.parseInt(port);

		/*
		 * Gmail SMTP port 465 uses implicit SSL.
		 * Therefore SSL must be established BEFORE sending the SMTP commands.
		 */
		SSLSocketFactory factory =
				(SSLSocketFactory) SSLSocketFactory.getDefault();

		try (SSLSocket ssl =
				(SSLSocket) factory.createSocket(host, smtpPort)) {

			ssl.setSoTimeout(15000);

			ssl.startHandshake();

			BufferedReader in = new BufferedReader(
					new InputStreamReader(
							ssl.getInputStream(),
							StandardCharsets.US_ASCII));

			BufferedWriter out = new BufferedWriter(
					new OutputStreamWriter(
							ssl.getOutputStream(),
							StandardCharsets.US_ASCII));

			// SMTP server greeting
			expect(in, 220);

			// Identify client
			cmd(out, in, "EHLO nlogistics.local", 250);

			// Authenticate
			cmd(out, in, "AUTH LOGIN", 334);

			cmd(
					out,
					in,
					Base64.getEncoder().encodeToString(
							user.getBytes(StandardCharsets.UTF_8)),
					334
			);

			cmd(
					out,
					in,
					Base64.getEncoder().encodeToString(
							pass.getBytes(StandardCharsets.UTF_8)),
					235
			);

			// Sender
			cmd(out, in, "MAIL FROM:<" + from + ">", 250);

			// Recipient
			cmd(out, in, "RCPT TO:<" + to + ">", 250);

			// Message
			cmd(out, in, "DATA", 354);

			out.write("From: N Logistics <" + from + ">\r\n");
			out.write("To: <" + to + ">\r\n");
			out.write("Subject: N Logistics Password Reset Code\r\n");
			out.write("MIME-Version: 1.0\r\n");
			out.write("Content-Type: text/plain; charset=UTF-8\r\n");
			out.write("\r\n");

			out.write(
					"Your N Logistics password reset code is: "
							+ token
							+ "\r\n"
							+ "This code expires in 10 minutes and can be used only once.\r\n"
			);

			// End SMTP DATA section
			out.write(".\r\n");
			out.flush();

			expect(in, 250);

			// Close SMTP session
			cmd(out, in, "QUIT", 221);
		}
	}

	private static void cmd(
			BufferedWriter out,
			BufferedReader in,
			String command,
			int expected) throws Exception {

		out.write(command + "\r\n");
		out.flush();

		expect(in, expected);
	}

	private static void expect(
			BufferedReader in,
			int expected) throws Exception {

		String line = in.readLine();

		if (line == null || line.length() < 3) {
			throw new IOException("SMTP connection closed");
		}

		int code = Integer.parseInt(line.substring(0, 3));

		while (line.length() > 3 && line.charAt(3) == '-') {
			line = in.readLine();

			if (line == null) {
				throw new IOException("SMTP connection closed");
			}
		}

		if (code != expected) {
			throw new IOException(
					"SMTP expected " + expected + " but got " + code);
		}
	}
}