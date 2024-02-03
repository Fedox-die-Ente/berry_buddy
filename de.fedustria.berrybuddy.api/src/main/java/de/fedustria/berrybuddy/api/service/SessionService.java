package de.fedustria.berrybuddy.api.service;

import de.fedustria.berrybuddy.api.dao.SessionDAO;

public class SessionService {
    public static boolean isValidSession(final SessionDAO sessionDAO, final Integer userId, final String token) {
        final var tokenOpt = JWTService.decodeToken(token);
        if (tokenOpt.isPresent()) {
            final var decodedToken = tokenOpt.get();
            final var sessionId = decodedToken.getHeaderClaim("sessionId").asString();
            return sessionDAO.isValidSessionId(userId, sessionId);
        }

        return false;
    }
}
