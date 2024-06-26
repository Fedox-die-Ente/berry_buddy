package de.fedustria.berrybuddy.api.database;

import de.fedustria.berrybuddy.api.model.Session;
import de.fedustria.berrybuddy.api.model.User;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface DatabaseProvider {
    List<User> getUsers() throws SQLException;

    List<User> getUsers(int page, int limit) throws SQLException;

    Optional<User> getUser(Integer id) throws SQLException;

    void addUser(User user) throws SQLException;

    void removeUser(User user) throws SQLException;

    void updateUser(User user);

    boolean isActiveSession(Integer userId, String token) throws SQLException;

    boolean isValidSessionId(Integer userId, String sessionId) throws SQLException;

    List<Session> getSessions(Integer userId) throws SQLException;

    void addSession(Integer userId, String sessionId, final String sessionIP, final String sessionDevice) throws SQLException;

    void removeSession(String sessionId) throws SQLException;
}
