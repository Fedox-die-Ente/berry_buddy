package de.fedustria.berrybuddy.api.model;

import lombok.Getter;

@Getter
public class Session {
    private Integer id;
    private Integer linkedUserId;
    private long    expiresIn;
    private String  token;
}
