package de.fedustria.berrybuddy.api.utils;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import de.fedustria.berrybuddy.api.model.User;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class JWTGenerator {
    public static String generateToken(final User user, final long expiresIn, final String secret) {
        final Algorithm algorithm = Algorithm.HMAC256(secret);
        final Map<String, Object> headerClaims = new HashMap<>();
        headerClaims.put("userId", user.getId());
        headerClaims.put("username", user.getUsername());

        final Date now = new Date();
        final Date expiresAt = new Date(now.getTime() + expiresIn);

        return JWT.create()
                .withHeader(headerClaims)
                .withIssuedAt(now)
                .withExpiresAt(expiresAt)
                .sign(algorithm);
    }
}
