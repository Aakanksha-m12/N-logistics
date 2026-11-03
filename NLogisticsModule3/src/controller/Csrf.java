package controller;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public final class Csrf {

    private static final String SESSION_KEY =
            "csrfToken";

    private static final String REQUEST_PARAMETER =
            "csrfToken";

    private static final SecureRandom RANDOM =
            new SecureRandom();

    private Csrf() {
    }

    public static String ensureToken(
            HttpServletRequest request) {

        HttpSession session =
                request.getSession(true);

        Object existing =
                session.getAttribute(
                        SESSION_KEY);

        if (existing instanceof String
                && !((String) existing).isEmpty()) {

            return (String) existing;
        }

        byte[] bytes =
                new byte[32];

        RANDOM.nextBytes(bytes);

        String token =
                Base64.getUrlEncoder()
                        .withoutPadding()
                        .encodeToString(bytes);

        session.setAttribute(
                SESSION_KEY,
                token);

        return token;
    }


    public static boolean isValid(
            HttpServletRequest request) {

        if (request == null) {
            return false;
        }

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            return false;
        }

        Object expected =
                session.getAttribute(
                        SESSION_KEY);

        String supplied =
                request.getParameter(
                        REQUEST_PARAMETER);

        if (!(expected instanceof String)
                || supplied == null
                || supplied.trim().isEmpty()) {

            return false;
        }

        return MessageDigest.isEqual(
                ((String) expected)
                        .getBytes(
                                StandardCharsets.UTF_8),

                supplied
                        .getBytes(
                                StandardCharsets.UTF_8)
        );
    }
}