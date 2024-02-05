package de.fedustria.berrybuddy.api.rest.controller;

import de.fedustria.berrybuddy.api.dao.SessionDAO;
import de.fedustria.berrybuddy.api.dao.UserDAO;
import de.fedustria.berrybuddy.api.model.Session;
import de.fedustria.berrybuddy.api.rest.requests.LoginRequest;
import de.fedustria.berrybuddy.api.rest.requests.RegisterRequest;
import de.fedustria.berrybuddy.api.rest.response.DefaultResponse;
import de.fedustria.berrybuddy.api.rest.response.SessionResponse;
import de.fedustria.berrybuddy.api.service.JWTService;
import de.fedustria.berrybuddy.api.service.UserService;
import de.fedustria.berrybuddy.api.utils.HttpUtils;
import de.fedustria.berrybuddy.api.utils.IniProvider;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.io.File;
import java.util.Properties;
import java.util.UUID;

import static de.fedustria.berrybuddy.api.utils.Constants.CONF_DIR;
import static de.fedustria.berrybuddy.api.utils.Constants.DB_INI;
import static de.fedustria.berrybuddy.api.utils.StringUtils.isEmpty;

@RestController
public class RESTV1Controller {
    private static final Logger          LOG     = LoggerFactory.getLogger(RESTV1Controller.class);
    private static final String          PREFIX  = "/api/v1";
    private final        PasswordEncoder encoder = new BCryptPasswordEncoder();
    private final        Properties      props   = new IniProvider(new File(CONF_DIR, DB_INI)).loadPropertiesNoEx();

    @PostMapping(PREFIX + "/login")
    public ResponseEntity<?> login(@RequestBody final LoginRequest body, final HttpServletResponse response, final HttpServletRequest request) {
        try {
            final var userDAO = new UserDAO(props);

            final var optUser = UserService.getUser(userDAO.fetchAll(), encoder, body.getUsername(), body.getPassword());

            if (optUser.isPresent()) {
                final var user = optUser.get();
                final var sessionId = UUID.randomUUID().toString();

                final var jwt = JWTService.generateToken(user, sessionId);
                final var cookie = new Cookie("_auth", jwt);
                cookie.setPath("/");
                cookie.setSecure(true);
                response.addCookie(cookie);

                final Session session = new Session(user.getId(), sessionId, request.getRemoteAddr(), request.getHeader("User-Agent"));
                final var sessionDAO = new SessionDAO(props);
                sessionDAO.insert(session);

                return new ResponseEntity<>(user.toUserDTO(), HttpStatus.OK);
            }
        } catch (final Exception e) {
            return new ResponseEntity<>(new DefaultResponse("Failed to check login."), HttpStatus.UNAUTHORIZED);
        }

        return new ResponseEntity<>(new DefaultResponse("Username or password is wrong."), HttpStatus.UNAUTHORIZED);
    }

    @PostMapping(PREFIX + "/register")
    public ResponseEntity<?> register(@RequestBody final RegisterRequest body) {
        try {
            final var userDAO = new UserDAO(props);

            final var email = body.getEmailOrPhone();
            final var password = body.getPassword();

            if (!isEmpty(email, password) && UserService.registerUser(userDAO, encoder, email, password)) {
                return new ResponseEntity<>(new DefaultResponse("Successfully registered"), HttpStatus.OK);
            }
        } catch (final Exception e) {
            return new ResponseEntity<>(new DefaultResponse("Failed to register user."), HttpStatus.INTERNAL_SERVER_ERROR);
        }

        return new ResponseEntity<>(new DefaultResponse("Failed to register user."), HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @PostMapping(PREFIX + "/logout")
    public ResponseEntity<?> logout(final HttpServletRequest request) {
        try {
            final var sessionDAO = new SessionDAO(props);

            final var optCookie = HttpUtils.getCookie(request, "_auth");
            if (optCookie.isPresent()) {
                final var cookie = optCookie.get();
                final var tokenOpt = JWTService.decodeToken(cookie.getValue());
                if (tokenOpt.isPresent()) {
                    final var decodedToken = tokenOpt.get();
                    final var sessionId = decodedToken.getHeaderClaim("sessionId").asString();
                    sessionDAO.deleteSession(sessionId);

                    return new ResponseEntity<>(new DefaultResponse("Successfully logged out"), HttpStatus.OK);
                }
            }

            return new ResponseEntity<>(new DefaultResponse("Failed to logout"), HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (final Exception e) {
            return new ResponseEntity<>(new DefaultResponse("Failed to logout"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(PREFIX + "/validateSession")
    public ResponseEntity<?> validateSession(final HttpServletRequest request) {
        try {
            final var sessionDAO = new SessionDAO(props);

            final var optCookie = HttpUtils.getCookie(request, "_auth");
            if (optCookie.isPresent()) {
                final var cookie = optCookie.get();
                final var tokenOpt = JWTService.decodeToken(cookie.getValue());
                if (tokenOpt.isPresent()) {
                    final var decodedToken = tokenOpt.get();
                    final var userId = decodedToken.getHeaderClaim("userId").asInt();
                    final var sessionId = decodedToken.getHeaderClaim("sessionId").asString();

                    if (sessionDAO.isValidSessionId(userId, sessionId)) {
                        return new ResponseEntity<>(new DefaultResponse("Session is valid"), HttpStatus.OK);
                    }
                }
            }

            return new ResponseEntity<>(new DefaultResponse("Session is invalid"), HttpStatus.UNAUTHORIZED);
        } catch (final Exception e) {
            return new ResponseEntity<>(new DefaultResponse("Session is invalid"), HttpStatus.UNAUTHORIZED);
        }
    }

    @PostMapping(PREFIX + "/sessions")
    public ResponseEntity<?> getSessions(final HttpServletRequest request) {
        try {
            final var sessionDAO = new SessionDAO(props);

            final var optCookie = HttpUtils.getCookie(request, "_auth");
            if (optCookie.isPresent()) {
                final var cookie = optCookie.get();
                final var tokenOpt = JWTService.decodeToken(cookie.getValue());
                if (tokenOpt.isPresent()) {
                    final var decodedToken = tokenOpt.get();
                    final var userId = decodedToken.getHeaderClaim("userId").asInt();
                    final var sessionId = decodedToken.getHeaderClaim("sessionId").asString();

                    if (sessionDAO.isValidSessionId(userId, sessionId)) {
                        return new ResponseEntity<>(new SessionResponse(
                                sessionDAO.fetchAll(userId).stream()
                                        .map(Session::toSessionDTO).toList()
                        ), HttpStatus.OK);
                    }
                }
            }

            return new ResponseEntity<>(new DefaultResponse("Failed to get sessions"), HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (final Exception e) {
            return new ResponseEntity<>(new DefaultResponse("Failed to get sessions"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
