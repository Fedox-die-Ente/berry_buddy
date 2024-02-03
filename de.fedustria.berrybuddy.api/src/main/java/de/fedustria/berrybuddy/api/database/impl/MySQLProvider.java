package de.fedustria.berrybuddy.api.database.impl;

import de.fedustria.berrybuddy.api.data.user.UserRole;
import de.fedustria.berrybuddy.api.database.DatabaseProvider;
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
import java.util.Properties;

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
                    reader.lines().forEach(builder::append);
                    final var query = connection.prepareStatement(builder.toString());
                    query.execute();
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
                properties.getProperty("user", ""),
                properties.getProperty("password", ""),
                properties.getProperty("host", ""),
                properties.getProperty("port", ""),
                properties.getProperty("database", "")
        );

        LOG.info("URL: {}", url);

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
            LOG.info("User: {}", result.getString("username"));

            final var user = User.create(
                    result.getInt("id"),
                    result.getString("name"),
                    result.getString("username"),
                    UserRole.OWNER,
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
    public void removeUser(final User user) {

    }

    @Override
    public void updateUser(final User user) {

    }
}
