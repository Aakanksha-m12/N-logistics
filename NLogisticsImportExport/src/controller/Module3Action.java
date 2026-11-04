package controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Module3Action implements Action {

    private static final String DEFAULT_MODULE3_URL =
            "http://localhost:8081/NLogisticsModule3/module3-sso";

    private static final SecureRandom RANDOM =
            new SecureRandom();

    @Override
    public void execute(HttpServletRequest req,
                        HttpServletResponse resp)
            throws Exception {

        HttpSession session =
                req.getSession(false);

        /*
         * User must already be logged in to Module 1.
         */
        Integer userId =
                Authorization.requireLogin(session);

        String roleName =
                (String) session.getAttribute("roleName");

        if (roleName == null ||
                roleName.trim().isEmpty()) {

            throw new SecurityException(
                    "User role is missing.");
        }

        /*
         * Super Admin may not have a company ID.
         */
        Object companyValue =
                session.getAttribute("companyId");

        String companyId = "";

        if (companyValue != null) {
            companyId =
                    String.valueOf(companyValue);
        }

        /*
         * Issue time.
         */
        long issuedAt =
                System.currentTimeMillis();

        /*
         * Generate random nonce.
         */
        byte[] nonceBytes =
                new byte[16];

        RANDOM.nextBytes(nonceBytes);

        String nonce =
                Base64.getUrlEncoder()
                        .withoutPadding()
                        .encodeToString(nonceBytes);

        /*
         * Payload format:
         *
         * userId|roleName|companyId|issuedAt|nonce
         */
        String payload =
                userId
                + "|"
                + roleName
                + "|"
                + companyId
                + "|"
                + issuedAt
                + "|"
                + nonce;

        /*
         * Read the shared secret from the environment first, then fall
         * back to web.xml. The two applications must agree on this value.
         */
        String sharedSecret =
                System.getenv("NLOGISTICS_SSO_SECRET");

        if (sharedSecret == null ||
                sharedSecret.trim().isEmpty()) {

            sharedSecret =
                    req.getServletContext()
                            .getInitParameter(
                                    "module3SharedSecret");
        }

        /*
         * Fail closed rather than falling back to a value that is
         * published in source control.
         */
        if (sharedSecret == null ||
                sharedSecret.trim().isEmpty()) {

            throw new SecurityException(
                    "SSO shared secret is not configured.");
        }

        /*
         * Encode payload first.
         */
        String encodedPayload =
                Base64.getUrlEncoder()
                        .withoutPadding()
                        .encodeToString(
                                payload.getBytes(
                                        StandardCharsets.UTF_8));

        /*
         * IMPORTANT:
         * Module 3 verifies the signature against
         * encodedPayload.
         */
        String signature =
                createSignature(
                        encodedPayload,
                        sharedSecret);

        /*
         * Final token:
         *
         * encodedPayload.signature
         */
        String token =
                encodedPayload
                + "."
                + signature;

        /*
         * Redirect to Module 3 SSO endpoint.
         */
        
        String redirectUrl =
                DEFAULT_MODULE3_URL
                + "?token="
                + URLEncoder.encode(
                        token,
                        "UTF-8");
      

        resp.sendRedirect(redirectUrl);
    }

    private String createSignature(
            String payload,
            String sharedSecret)
            throws Exception {

        Mac mac =
                Mac.getInstance("HmacSHA256");

        SecretKeySpec key =
                new SecretKeySpec(
                        sharedSecret.getBytes(
                                StandardCharsets.UTF_8),
                        "HmacSHA256");

        mac.init(key);

        byte[] signature =
                mac.doFinal(
                        payload.getBytes(
                                StandardCharsets.UTF_8));

        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(signature);
    }
}