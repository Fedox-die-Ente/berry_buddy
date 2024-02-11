package de.fedustria.berrybuddy.api.dto;

import de.fedustria.berrybuddy.api.data.user.UserRole;
import lombok.Getter;

@Getter
public class UserDTO {
    // TODO: Add new fields

    private final Integer  id;
    private final String   name;
    private final String   username;
    private final UserRole role;
    private final String   avatarURL;

    public UserDTO(final Integer id, final String name, final String username, final UserRole role, final String avatarURL) {
        this.id = id;
        this.name = name;
        this.username = username;
        this.role = role;
        this.avatarURL = avatarURL;
    }
}
