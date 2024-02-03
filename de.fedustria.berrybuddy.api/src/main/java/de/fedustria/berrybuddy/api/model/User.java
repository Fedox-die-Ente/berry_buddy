package de.fedustria.berrybuddy.api.model;

import de.fedustria.berrybuddy.api.data.user.UserRole;
import de.fedustria.berrybuddy.api.dto.UserDTO;
import lombok.Getter;

@Getter
public class User {
    private Integer  id;
    private String   name;
    private String   username;
    private UserRole role;
    private String   hashedPassword;
    private String   avatarURL;
    private int      sessionId;

    public UserDTO toUserDTO() {
        return new UserDTO(id, name, username, role, avatarURL);
    }
}
