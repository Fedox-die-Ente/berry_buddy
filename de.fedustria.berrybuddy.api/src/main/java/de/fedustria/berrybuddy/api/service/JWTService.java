package de.fedustria.berrybuddy.api.service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import de.fedustria.berrybuddy.api.model.User;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static de.fedustria.berrybuddy.api.utils.Constants.JWT_ISSUER;
import static de.fedustria.berrybuddy.api.utils.Constants.JWT_SECRET;

public class JWTService {
    public static String generateToken(final User user, final String sessionId) {
        final Algorithm algorithm = Algorithm.HMAC256(JWT_SECRET);
        final Map<String, Object> headerClaims = new HashMap<>();
        headerClaims.put("userId", user.getId());
        headerClaims.put("username", user.getUsername());
        headerClaims.put("sessionId", sessionId);

        return JWT.create()
                .withIssuer(JWT_ISSUER)
                .withHeader(headerClaims)
                .withIssuedAt(new Date())
                .sign(algorithm);
    }

    public static Optional<DecodedJWT> decodeToken(final String token) {
        try {
            final Algorithm algorithm = Algorithm.HMAC256(JWT_SECRET);
            return Optional.of(JWT.require(algorithm)
                    .withIssuer(JWT_ISSUER)
                    .build()
                    .verify(token));
        } catch (final Exception e) {
            return Optional.empty();
        }
    }
}
