package de.fedustria.berrybuddy.api.model;

import lombok.Getter;

@Getter
public class Session {
    private       Integer id;
    private final Integer linkedUserId;
    private final String  sessionId;

    public Session(final Integer linkedUserId, final String sessionId) {
        this.linkedUserId = linkedUserId;
        this.sessionId = sessionId;
    }
}
