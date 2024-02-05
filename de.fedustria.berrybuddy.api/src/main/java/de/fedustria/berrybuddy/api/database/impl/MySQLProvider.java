package de.fedustria.berrybuddy.api.database.impl;

import de.fedustria.berrybuddy.api.data.user.UserRole;
import de.fedustria.berrybuddy.api.database.DatabaseProvider;
import de.fedustria.berrybuddy.api.model.Session;
import de.fedustria.berrybuddy.api.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Properties;

import static de.fedustria.berrybuddy.api.utils.Constants.*;

public class MySQLProvider implements DatabaseProvider {
    private static final Logger     LOG = LoggerFactory.getLogger(MySQLProvider.class);
    private final        Properties properties;
    private              Connection connection;

    public MySQLProvider(final Properties properties) {
        this.properties = properties;

        try {
            preQuery();

            try (final var stream = getClass().getClassLoader().getResourceAsStream("template/mysql.sql")) {
                if (stream == null) {
                    LOG.error("Could not find create.sql");
                    return;
                }

                try (final var reader = new BufferedReader(new InputStreamReader(stream))) {
                    final var builder = new StringBuilder();
                    for (String line; (line = reader.readLine()) != null; ) {
                        if (!line.isEmpty()) {
                            builder.append(line);

                            if (line.trim().endsWith(";")) {
                                final var query = connection.prepareStatement(builder.toString());
                                query.execute();
                                builder.setLength(0);
                            }
                        }
                    }
                }
            }

            postQuery();
        } catch (final Exception e) {
            LOG.error("Error while setting up database", e);
        }
    }

    private void preQuery() {
        String url = "jdbc:mysql://%s:%s@%s:%s/%s";

        url = String.format(
                url,
                properties.getProperty(DB_USER, ""),
                properties.getProperty(DB_PASSWORD, ""),
                properties.getProperty(DB_HOST, ""),
                properties.getProperty(DB_PORT, ""),
                properties.getProperty(DB_DATABASE, "")
        );

        try {
            connection = DriverManager.getConnection(url);
            if (connection == null) {
                LOG.error("Connection to database failed");
            }
        } catch (final SQLException e) {
            LOG.error("Error while connecting to database", e);
        }
    }

    private void postQuery() {
        try {
            connection.close();
        } catch (final SQLException e) {
            LOG.error("Error while closing connection", e);
        }
    }

    @Override
    public List<User> getUsers() throws SQLException {
        final List<User> list = new ArrayList<>();

        preQuery();

        final var query = connection.prepareStatement("SELECT * FROM users");
        final var result = query.executeQuery();
        while (result.next()) {
            final var user = User.create(
                    result.getInt("id"),
                    result.getString("name"),
                    result.getString("username"),
                    UserRole.valueOf(result.getString("role")),
                    result.getString("password"),
                    result.getString("avatar_url"),
                    result.getInt("session_id")
            );

            list.add(user);
        }

        postQuery();
        return list;
    }

    @Override
    public List<User> getUsers(final int page, final int limit) throws SQLException {
        final List<User> list = new ArrayList<>();

        preQuery();

        final var query = connection.prepareStatement("SELECT * FROM users LIMIT ? OFFSET ?");
        query.setInt(1, limit);
        query.setInt(2, page * limit);
        final var result = query.executeQuery();
        while (result.next()) {
            final var user = User.create(
                    result.getInt("id"),
                    result.getString("name"),
                    result.getString("username"),
                    UserRole.valueOf(result.getString("role")),
                    result.getString("password"),
                    result.getString("avatar_url"),
                    result.getInt("session_id")
            );

            list.add(user);
        }

        postQuery();
        return list;
    }

    @Override
    public Optional<User> getUser(final Integer id) throws SQLException {
        preQuery();

        final var query = connection.prepareStatement("SELECT * FROM users WHERE id = ?");
        query.setInt(1, id);
        final var result = query.executeQuery();
        if (result.next()) {
            final var user = User.create(
                    result.getInt("id"),
                    result.getString("name"),
                    result.getString("username"),
                    UserRole.valueOf(result.getString("role")),
                    result.getString("password"),
                    result.getString("avatar_url"),
                    result.getInt("session_id")
            );

            postQuery();
            return Optional.of(user);
        }

        postQuery();

        return Optional.empty();
    }

    @Override
    public void addUser(final User user) throws SQLException {
        preQuery();

        final var query = connection.prepareStatement("INSERT INTO users (name, username, password, avatar_url, session_id) VALUES (?, ?, ?, ?, ?)");
        query.setString(1, user.getName());
        query.setString(2, user.getUsername());
        query.setString(3, user.getHashedPassword());
        query.setString(4, user.getAvatarURL());
        query.setInt(5, user.getSessionId());
        query.execute();

        postQuery();
    }

    @Override
    public void removeUser(final User user) throws SQLException {
        preQuery();

        final var userId = user.getId();
        final var query = connection.prepareStatement("DELETE FROM users WHERE id = ?");
        query.setInt(1, userId);
        query.execute();

        postQuery();
    }

    @Override
    public void updateUser(final User user) {

    }

    @Override
    public List<Session> getSessions(final Integer userId) throws SQLException {
        final List<Session> list = new ArrayList<>();

        preQuery();

        final var query = connection.prepareStatement("SELECT * FROM sessions WHERE user_id = ?");
        query.setInt(1, userId);
        final var result = query.executeQuery();

        while (result.next()) {
            list.add(new Session(
                    result.getInt("user_id"),
                    result.getString("session_id"),
                    result.getInt("id"),
                    result.getString("session_ip"),
                    result.getString("session_device")
            ));
        }

        postQuery();

        return list;
    }

    @Override
    public boolean isActiveSession(final Integer userId, final String token) throws SQLException {
        preQuery();

        final var query = connection.prepareStatement("SELECT * FROM sessions WHERE user_id = ? AND token = ?");
        query.setInt(1, userId);
        query.setString(2, token);
        final var result = query.executeQuery();
        if (result.next()) {
            return true;
        }

        postQuery();

        return false;
    }

    @Override
    public boolean isValidSessionId(final Integer userId, final String sessionId) throws SQLException {
        preQuery();

        final var query = connection.prepareStatement("SELECT * FROM sessions WHERE user_id = ? AND session_id = ?");
        query.setInt(1, userId);
        query.setString(2, sessionId);
        final var result = query.executeQuery();

        if (result.next()) {
            return true;
        }

        postQuery();
        return false;
    }

    @Override
    public void addSession(final Integer userId, final String sessionId, final String sessionIP, final String sessionDevice) throws SQLException {
        preQuery();

        final var query = connection.prepareStatement("INSERT INTO sessions (user_id, session_id, session_ip, session_device) VALUES (?, ?, ?, ?)");
        query.setInt(1, userId);
        query.setString(2, sessionId);
        query.setString(3, sessionIP);
        query.setString(4, sessionDevice);
        query.execute();

        postQuery();
    }

    @Override
    public void removeSession(final String sessionId) throws SQLException {
        preQuery();

        final var query = connection.prepareStatement("DELETE FROM sessions WHERE session_id = ?");
        query.setString(1, sessionId);
        query.execute();

        postQuery();
    }
}
