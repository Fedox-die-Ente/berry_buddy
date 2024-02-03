package de.fedustria.berrybuddy.api.rest.controller;

import de.fedustria.berrybuddy.api.rest.requests.LoginRequest;
import de.fedustria.berrybuddy.api.rest.response.DefaultResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RESTV1Controller {
    private static final Logger LOG    = LoggerFactory.getLogger(RESTV1Controller.class);
    private static final String PREFIX = "/api/v1";

    @PostMapping(PREFIX + "/login")
    public ResponseEntity<?> login(@RequestBody final LoginRequest body) {
        LOG.info("Login request received for user {}", body.getUsername());
        return new ResponseEntity<>(new DefaultResponse("test"), HttpStatus.OK);
    }

    @PostMapping(PREFIX + "/register")
    public void register(@RequestBody final String body) {

    }

    @PostMapping(PREFIX + "/logout")
    public void logout(@RequestBody final String body) {

    }

    @PostMapping(PREFIX + "/validateSession")
    public void validateSession(@RequestBody final String body) {

    }
}
