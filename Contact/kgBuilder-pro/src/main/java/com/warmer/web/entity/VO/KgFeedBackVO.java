package com.warmer.web.entity.VO;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class KgFeedBackVO {

    private Integer domainId;

    private Integer userId;

    @ApiModelProperty("内容")
    private String content;


}
