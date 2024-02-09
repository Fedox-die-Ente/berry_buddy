package de.fedustria.berrybuddy.api.service;

import de.fedustria.berrybuddy.api.dao.UserDAO;
import de.fedustria.berrybuddy.api.model.User;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.List;
import java.util.Optional;

public class UserService {
    private final PasswordEncoder encoder;

    public UserService(final PasswordEncoder passwordEncoder) {
        this.encoder = passwordEncoder;
    }

    public Optional<User> getUser(final List<User> users, final String username, final String password) {
        return users.stream()
                .filter(user -> user.getUsername().equals(username) && encoder.matches(password, user.getHashedPassword()))
                .findFirst();
    }

    public Optional<User> getUser(final List<User> users, final String username) {
        return users.stream()
                .filter(user -> user.getUsername().equals(username))
                .findFirst();
    }

    public boolean userExists(final List<User> users, final String username) {
        return getUser(users, username).isPresent();
    }

    public boolean registerUser(final UserDAO userDAO, final String emailOrPhone, final String password) {
        if (userExists(userDAO.fetchAll(), emailOrPhone)) {
            return false;
        }

        final var user = User.create("", emailOrPhone, encoder.encode(password));
        userDAO.insert(user);

        return true;
    }
}
