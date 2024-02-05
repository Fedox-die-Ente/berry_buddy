package de.fedustria.berrybuddy.api.rest.requests;

import lombok.Getter;

@Getter
public class UserListRequest {
    private Integer page;
    private Integer limit;
}
