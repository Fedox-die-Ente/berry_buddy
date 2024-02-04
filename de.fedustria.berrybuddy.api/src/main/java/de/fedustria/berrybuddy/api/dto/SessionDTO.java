package de.fedustria.berrybuddy.api.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class SessionDTO {
    private String sessionIP;
    private String sessionDevice;
}
