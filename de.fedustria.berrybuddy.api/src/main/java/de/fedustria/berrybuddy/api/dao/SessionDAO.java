package de.fedustria.berrybuddy.api.dao;

import de.fedustria.berrybuddy.api.database.impl.MySQLProvider;
import de.fedustria.berrybuddy.api.model.Session;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public class SessionDAO implements DAO<Session> {
    private final MySQLProvider mySQLProvider;

    public SessionDAO(final Properties properties) {
        this.mySQLProvider = new MySQLProvider(properties);
    }

    @Override
    public void insert(final Session session) {
        try {
            mySQLProvider.addSession(session.getLinkedUserId(), session.getSessionId(), session.getSessionIP(), session.getSessionDevice());
        } catch (final SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(final Session session) {

    }

    @Override
    public void delete(final Session session) {

    }

    @Override
    public List<Session> fetchAll() {
        return null;
    }

    public List<Session> fetchAll(final Integer userId) {
        try {
            return mySQLProvider.getSessions(userId);
        } catch (final SQLException e) {
            return new ArrayList<>();
        }
    }

    public boolean isValidSessionId(final Integer userId, final String sessionId) {
        try {
            return mySQLProvider.isValidSessionId(userId, sessionId);
        } catch (final SQLException e) {
            return false;
        }
    }

    public void deleteSession(final String sessionId) {
        try {
            mySQLProvider.removeSession(sessionId);
        } catch (final SQLException e) {
            e.printStackTrace();
        }
    }
}
