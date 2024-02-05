package de.fedustria.berrybuddy.api.dao;

import de.fedustria.berrybuddy.api.database.impl.MySQLProvider;
import de.fedustria.berrybuddy.api.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Properties;

public class UserDAO implements DAO<User> {
    private static final Logger        LOG = LoggerFactory.getLogger(UserDAO.class);
    private final        MySQLProvider mySQLProvider;

    public UserDAO(final Properties properties) {
        this.mySQLProvider = new MySQLProvider(properties);
    }

    @Override
    public void insert(final User user) {
        try {
            mySQLProvider.addUser(user);
        } catch (final Exception e) {
            LOG.error("Error while adding user", e);
        }
    }

    @Override
    public void update(final User user) {

    }

    @Override
    public void delete(final User user) {

    }

    @Override
    public List<User> fetchAll() {
        try {
            return mySQLProvider.getUsers();
        } catch (final Exception e) {
            LOG.error("Error while fetching users", e);
            return new ArrayList<>();
        }
    }

    public Optional<User> fetchById(final Integer id) {
        try {
            return mySQLProvider.getUser(id);
        } catch (final Exception e) {
            LOG.error("Error while fetching user", e);
            return Optional.empty();
        }
    }
}
