package controller;

/**
 * Minimal HTML escaping helper for JSP output.
 *
 * JSP scriptlets do not escape output automatically, so any value
 * that originated from a user (username, company name, audit text,
 * ...) must pass through this class before being written into HTML
 * or an attribute value.
 */
public final class Html {

    private Html() {
    }

    public static String escape(Object value) {

        if (value == null) {
            return "";
        }

        String text = String.valueOf(value);

        StringBuilder escaped =
                new StringBuilder(text.length() + 16);

        for (int i = 0; i < text.length(); i++) {

            char c = text.charAt(i);

            switch (c) {

                case '&':
                    escaped.append("&amp;");
                    break;

                case '<':
                    escaped.append("&lt;");
                    break;

                case '>':
                    escaped.append("&gt;");
                    break;

                case '"':
                    escaped.append("&quot;");
                    break;

                case '\'':
                    escaped.append("&#39;");
                    break;

                default:
                    escaped.append(c);
            }
        }

        return escaped.toString();
    }
}
