package de.fedustria.berrybuddy.api.rest.requests;

import lombok.Getter;

@Getter
public class LoginRequest {
    private String username;
    private String password;
}
