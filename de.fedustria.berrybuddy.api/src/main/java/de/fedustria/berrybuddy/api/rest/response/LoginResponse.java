package de.fedustria.berrybuddy.api.rest.response;

import de.fedustria.berrybuddy.api.dto.UserDTO;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class LoginResponse {
    private UserDTO userData;
    private String  sessionId;
}
