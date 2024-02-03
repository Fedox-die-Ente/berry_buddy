package de.fedustria.berrybuddy.api.dto;

import de.fedustria.berrybuddy.api.data.user.UserRole;
import lombok.Getter;

@Getter
public class UserDTO {
    private Integer  id;
    private String   name;
    private String   username;
    private UserRole role;
    private String   avatarURL;

    public UserDTO(final Integer id, final String name, final String username, final UserRole role, final String avatarURL) {
        this.id = id;
        this.name = name;
        this.username = username;
        this.role = role;
        this.avatarURL = avatarURL;
    }

    public UserDTO() {}
}
