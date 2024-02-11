package de.fedustria.berrybuddy.api.rest.requests;

import lombok.Getter;

@Getter
public class SessionRequest {
    private String  sessionId;
    private Integer userId;
}
