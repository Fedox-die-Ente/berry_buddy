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

    public static User create(final Integer id, final String name, final String username, final UserRole role, final String hashedPassword, final String avatarURL, final int sessionId) {
        final User user = new User();
        user.id = id;
        user.name = name;
        user.username = username;
        user.role = role;
        user.hashedPassword = hashedPassword;
        user.avatarURL = avatarURL;
        user.sessionId = sessionId;
        return user;
    }

    public static User create(final String name, final String username, final String hashedPassword) {
        return create(null, name, username, UserRole.USER, hashedPassword, "", 0);
    }

    public UserDTO toUserDTO() {
        return new UserDTO(id, name, username, role, avatarURL);
    }
}
