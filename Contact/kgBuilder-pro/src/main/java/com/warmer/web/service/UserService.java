package com.warmer.web.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.warmer.web.entity.DTO.UserDTO;
import com.warmer.web.entity.User;
import com.warmer.web.entity.VO.UserVO;

public interface UserService extends IService<User> {
    // 分页查询
    Page<User> findPage(Page<User> objectPage, String username, String email, String address);
    // 登录功能
    UserDTO login(UserDTO userDTO);
    // 注册功能
    User register(UserDTO userDTO);
}
