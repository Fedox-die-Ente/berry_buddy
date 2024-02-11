package de.fedustria.berrybuddy.api.rest.requests;

import de.fedustria.berrybuddy.api.data.geo.GeoLocation;
import lombok.Getter;

@Getter
public class UpdateProfileRequest {
    private String      sessionId;
    private Integer     userId;
    private String      name;
    private String      gender;
    private long        age;
    private GeoLocation location;
}
