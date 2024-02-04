package de.fedustria.berrybuddy.api.model;

import lombok.Getter;

@Getter
public class Session {
    private final Integer linkedUserId;
    private final String  sessionId;
    private       Integer id;
    private final String  sessionIP;
    private final String  sessionDevice;

    public Session(final Integer linkedUserId, final String sessionId, final String sessionIP, final String sessionDevice) {
        this.linkedUserId = linkedUserId;
        this.sessionId = sessionId;
        this.sessionIP = sessionIP;
        this.sessionDevice = sessionDevice;
    }
}
