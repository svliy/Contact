package com.warmer.web.request;

import lombok.Data;

@Data
public class ShortPathQuery {
    private String domain;
    private String startNode;
    private String endNode;
}
