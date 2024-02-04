package de.fedustria.berrybuddy.api.rest.response;

import de.fedustria.berrybuddy.api.dto.SessionDTO;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

@Getter
@AllArgsConstructor
public class SessionResponse {
    private List<SessionDTO> sessions;
}
