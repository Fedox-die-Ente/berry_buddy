package de.fedustria.berrybuddy.api.rest.requests;

import de.fedustria.berrybuddy.api.data.geo.GeoLocation;
import jakarta.annotation.Nullable;
import lombok.Getter;

@Getter
public class UpdateProfileRequest {
    @Nullable
    private String      sessionId;
    private String      name;
    private String      gender;
    private long        age;
    private GeoLocation location;
}
