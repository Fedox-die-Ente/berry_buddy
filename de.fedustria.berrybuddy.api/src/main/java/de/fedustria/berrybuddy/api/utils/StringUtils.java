package de.fedustria.berrybuddy.api.utils;

public class StringUtils {
    public static boolean isEmpty(final String... strings) {
        for (final String string : strings) {
            if (string == null || string.isEmpty()) {
                return true;
            }
        }
        
        return false;
    }
}
