package de.fedustria.berrybuddy.api.database;

import de.fedustria.berrybuddy.api.model.User;

import java.sql.SQLException;
import java.util.List;

public interface DatabaseProvider {
    List<User> getUsers() throws SQLException;

    void addUser(User user) throws SQLException;

    void removeUser(User user);

    void updateUser(User user);
}
