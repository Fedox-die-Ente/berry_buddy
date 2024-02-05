package de.fedustria.berrybuddy.api.utils;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Arrays;
import java.util.Optional;

public class HttpUtils {
    public static Optional<Cookie> getCookie(final HttpServletRequest request, final String name) {
        return Arrays.stream(request.getCookies()).filter(c -> c.getName().equals(name)).findFirst();
    }
}
