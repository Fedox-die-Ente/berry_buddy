package de.fedustria.berrybuddy.api.utils;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Arrays;
import java.util.Optional;

public class HttpUtils {
    public static Optional<Cookie> getCookie(final HttpServletRequest request, final String name) {
        final var cookies = request.getCookies();
        if (cookies == null || cookies.length == 0) {
            return Optional.empty();
        }

        return Arrays.stream(cookies).filter(c -> c.getName().equals(name)).findFirst();
    }
}
