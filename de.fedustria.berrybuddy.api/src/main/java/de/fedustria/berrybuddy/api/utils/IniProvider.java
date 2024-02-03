package de.fedustria.berrybuddy.api.utils;

import org.ini4j.Ini;
import org.ini4j.IniPreferences;
import org.ini4j.Wini;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.Properties;
import java.util.prefs.Preferences;

public class IniProvider {
    private static final Logger LOG = LoggerFactory.getLogger(IniProvider.class);
    private final        File   file;

    public IniProvider(final File file) {
        this.file = file;
    }

    public void saveProperties(final Properties props) throws Exception {
        if (!file.exists()) {
            file.createNewFile();
        }

        final Wini ini = new Wini(file);

        for (final String key : props.stringPropertyNames()) {
            LOG.info("Saving property: " + key + " = " + props.getProperty(key, ""));
            ini.put("settings", key, props.getProperty(key, ""));
        }

        ini.store();
    }

    public Properties loadProperties() throws Exception {
        final Properties props = new Properties();
        if (!file.exists()) return props;

        final Ini ini = new Ini(file);
        final Preferences prefs = new IniPreferences(ini);

        final var node = prefs.node("settings");
        final var keys = node.keys();
        for (final String key : keys) {
            props.setProperty(key, node.get(key, null));
        }

        return props;
    }
}
