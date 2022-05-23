package com.warmer.web.entity.VO;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class RegisterVO {

    private String username;

    private String password;

    @ApiModelProperty("邮箱")
    private String email;

    @ApiModelProperty("电话")
    private String phone;

    @ApiModelProperty("地址")
    private String address;

}
