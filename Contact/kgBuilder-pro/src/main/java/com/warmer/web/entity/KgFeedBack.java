package com.warmer.web.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.ToString;

import java.util.Date;

@Data
@TableName("kg_feedback")
@ToString
public class KgFeedBack {

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer domainId;

    private Integer userId;

    private String content;

    private String isActive;

    @ApiModelProperty("创建时间")
    private Date createTime;
}
