package de.fedustria.berrybuddy.api.rest.response;

import de.fedustria.berrybuddy.api.dto.UserDTO;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

@Getter
@AllArgsConstructor
public class UsersResponse {
    private List<UserDTO> users;
}
