package de.fedustria.berrybuddy.api.rest.controller;

import de.fedustria.berrybuddy.api.dao.UserDAO;
import de.fedustria.berrybuddy.api.model.User;
import de.fedustria.berrybuddy.api.rest.requests.UpdateProfileRequest;
import de.fedustria.berrybuddy.api.rest.requests.UserListRequest;
import de.fedustria.berrybuddy.api.rest.response.DefaultResponse;
import de.fedustria.berrybuddy.api.rest.response.UsersResponse;
import de.fedustria.berrybuddy.api.utils.IniProvider;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.util.Properties;

import static de.fedustria.berrybuddy.api.utils.Constants.CONF_DIR;
import static de.fedustria.berrybuddy.api.utils.Constants.DB_INI;

@RestController
public class RESTV2Controller {
    public static final String     PREFIX = "/api/v2";
    private final       Properties props  = new IniProvider(new File(CONF_DIR, DB_INI)).loadPropertiesNoEx();


    @GetMapping(PREFIX + "/user/{id}")
    public ResponseEntity<?> getUser(@RequestParam final Integer id) {
        final var userDAO = new UserDAO(props);
        final var user = userDAO.fetchById(id);

        if (user.isPresent()) {
            return new ResponseEntity<>(user.get().toUserDTO(), HttpStatus.OK);
        }

        return new ResponseEntity<>(new DefaultResponse("User not found"), HttpStatus.NOT_FOUND);
    }

    @GetMapping(PREFIX + "/users")
    public ResponseEntity<UsersResponse> getUsers(@RequestBody final UserListRequest request) {
        var page = 1;
        var limit = 50;

        if (request.getPage() != null) {
            page = Math.max(request.getPage(), 0);
        }

        if (request.getLimit() != null) {
            limit = Math.min(Math.max(request.getLimit(), 0), 100);
        }

        final var userDAO = new UserDAO(props);
        final var users = userDAO.fetchLimited(page, limit);

        return new ResponseEntity<>(new UsersResponse(users.stream().map(User::toUserDTO).toList()), HttpStatus.OK);
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

    @PostMapping(PREFIX + "/updateProfile")
    public void updateProfile(@RequestBody final UpdateProfileRequest request) {
        System.out.println(request.getName());
        System.out.println(request.getGender());
        System.out.println(request.getAge());
        System.out.println(request.getLocation().getLatitude() + ", " + request.getLocation().getLongitude());
    }
}
