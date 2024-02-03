package de.fedustria.berrybuddy.api.rest.requests;

import lombok.Getter;

@Getter
public class RegisterRequest {
    private String emailOrPhone;
    private String password;
}
