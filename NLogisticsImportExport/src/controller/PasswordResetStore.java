package controller;

import java.security.SecureRandom;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public final class PasswordResetStore {
	public static final class Token {
		public final int userId;
		public final String token;
		public final long expiresAt;
		public boolean used;

		Token(int u, String t, long e) {
			userId = u;
			token = t;
			expiresAt = e;
		}
	}

	private static final Map<String, Token> TOKENS = new ConcurrentHashMap<>();
	private static final SecureRandom RNG = new SecureRandom();

	private PasswordResetStore() {
	}

	public static String create(int userId) {
		StringBuilder b = new StringBuilder();
		for (int i = 0; i < 6; i++)
			b.append(RNG.nextInt(10));
		String t = b.toString();
		TOKENS.put(t, new Token(userId, t, System.currentTimeMillis() + 10 * 60 * 1000));
		return t;
	}

	public static Token consume(String token) {
		Token x = TOKENS.get(token);
		if (x == null || x.used || System.currentTimeMillis() > x.expiresAt)
			return null;
		x.used = true;
		TOKENS.remove(token);
		return x;
	}
}
