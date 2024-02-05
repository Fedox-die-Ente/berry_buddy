package de.fedustria.berrybuddy.api.rest.requests;

import lombok.Getter;

@Getter
public class UpdateProfileRequest {
    private String name;
    private String gender;
    private String birthdate;
    private String location;
}
