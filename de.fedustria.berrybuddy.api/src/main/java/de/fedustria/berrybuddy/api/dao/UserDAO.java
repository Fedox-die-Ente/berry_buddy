package de.fedustria.berrybuddy.api.dao;

import de.fedustria.berrybuddy.api.database.impl.MySQLProvider;
import de.fedustria.berrybuddy.api.model.User;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public class UserDAO implements DAO<User> {
    private final MySQLProvider mySQLProvider;

    public UserDAO(final Properties properties) {
        this.mySQLProvider = new MySQLProvider(properties);
    }

    @Override
    public void insert(final User user) {
        try {
            mySQLProvider.addUser(user);
        } catch (final Exception e) {
            e.printStackTrace();
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
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
