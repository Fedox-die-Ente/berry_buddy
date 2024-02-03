package de.fedustria.berrybuddy.api.rest.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RESTV2Controller {
    public static final String PREFIX = "/api/v2";

    @GetMapping(PREFIX + "/profile/{id}")
    public void getProfile(@RequestParam final Integer id) {

    }

    @GetMapping(PREFIX + "/chats")
    public void getChats() {

    }

    @GetMapping(PREFIX + "/notifications")
    public void getNotifications() {

    }

    @GetMapping(PREFIX + "/notifications/{id}")
    public void getNotification(@RequestParam final Integer id) {

    }
}
