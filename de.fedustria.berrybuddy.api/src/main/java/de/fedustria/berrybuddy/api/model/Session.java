package de.fedustria.berrybuddy.api.model;

import de.fedustria.berrybuddy.api.dto.SessionDTO;
import lombok.Getter;

@Getter
public class Session {
    private final Integer linkedUserId;
    private final String  sessionId;
    private final String  sessionIP;
    private final String  sessionDevice;
    private       Integer id;

    public Session(final Integer linkedUserId, final String sessionId, final Integer id, final String sessionIP, final String sessionDevice) {
        this.linkedUserId = linkedUserId;
        this.sessionId = sessionId;
        this.id = id;
        this.sessionIP = sessionIP;
        this.sessionDevice = sessionDevice;
    }

    public Session(final Integer linkedUserId, final String sessionId, final String sessionIP, final String sessionDevice) {
        this.linkedUserId = linkedUserId;
        this.sessionId = sessionId;
        this.sessionIP = sessionIP;
        this.sessionDevice = sessionDevice;
    }

    public SessionDTO toSessionDTO() {
        final var dto = new SessionDTO(sessionIP, sessionDevice);
        return dto;
    }
}
