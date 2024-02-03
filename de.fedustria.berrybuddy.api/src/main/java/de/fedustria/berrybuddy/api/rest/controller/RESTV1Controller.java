package de.fedustria.berrybuddy.api.rest.controller;

import de.fedustria.berrybuddy.api.dao.UserDAO;
import de.fedustria.berrybuddy.api.rest.requests.LoginRequest;
import de.fedustria.berrybuddy.api.rest.requests.RegisterRequest;
import de.fedustria.berrybuddy.api.rest.response.DefaultResponse;
import de.fedustria.berrybuddy.api.service.UserService;
import de.fedustria.berrybuddy.api.utils.IniProvider;
import de.fedustria.berrybuddy.api.utils.JWTGenerator;
import jakarta.servlet.http.Cookie;
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

import static de.fedustria.berrybuddy.api.utils.Constants.*;

@RestController
public class RESTV1Controller {
    private static final Logger          LOG     = LoggerFactory.getLogger(RESTV1Controller.class);
    private static final String          PREFIX  = "/api/v1";
    private final        PasswordEncoder encoder = new BCryptPasswordEncoder();

    @PostMapping(PREFIX + "/login")
    public ResponseEntity<?> login(@RequestBody final LoginRequest body, final HttpServletResponse response) {
        LOG.info("Login request received for user {}", body.getUsername());

        try {
            final var props = new IniProvider(new File(CONF_DIR, DB_INI));
            final var userDAO = new UserDAO(props.loadProperties());

            final var optUser = UserService.getUser(userDAO.fetchAll(), encoder, body.getUsername(), body.getPassword());

            if (optUser.isPresent()) {
                final var jwt = JWTGenerator.generateToken(optUser.get(), 3600, JWT_SECRET);
                final var cookie = new Cookie("_auth", jwt);
                cookie.setPath("/");
                cookie.setMaxAge(3600);
                cookie.setSecure(true);
                response.addCookie(cookie);
                return new ResponseEntity<>(new DefaultResponse("Successfully logged in"), HttpStatus.OK);
            }
        } catch (final Exception e) {
            return new ResponseEntity<>(new DefaultResponse("Failed to check login."), HttpStatus.UNAUTHORIZED);
        }

        return new ResponseEntity<>(new DefaultResponse("Username or password is wrong."), HttpStatus.UNAUTHORIZED);
    }

    @PostMapping(PREFIX + "/register")
    public ResponseEntity<?> register(@RequestBody final RegisterRequest body) {
        LOG.info("Register request received for user {}", body.getEmailOrPhone());

        try {
            final var props = new IniProvider(new File(CONF_DIR, DB_INI));
            final var userDAO = new UserDAO(props.loadProperties());

            if (UserService.registerUser(userDAO, encoder, body.getEmailOrPhone(), body.getPassword())) {
                return new ResponseEntity<>(new DefaultResponse("Successfully registered"), HttpStatus.OK);
            }
        } catch (final Exception e) {
            return new ResponseEntity<>(new DefaultResponse("Failed to register user."), HttpStatus.INTERNAL_SERVER_ERROR);
        }

        return new ResponseEntity<>(new DefaultResponse("Failed to register user."), HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @PostMapping(PREFIX + "/logout")
    public void logout(@RequestBody final String body) {

    }

    @PostMapping(PREFIX + "/validateSession")
    public void validateSession(@RequestBody final String body) {

    }
}
