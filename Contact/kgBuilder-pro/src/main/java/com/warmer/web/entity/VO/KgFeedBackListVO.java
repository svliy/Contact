package com.warmer.web.entity.VO;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.Date;

@Data
public class KgFeedBackListVO {

    @ApiModelProperty("内容")
    private String content;

    @ApiModelProperty("姓名")
    private String name;

    @ApiModelProperty("时间")
    private Date time;


}
