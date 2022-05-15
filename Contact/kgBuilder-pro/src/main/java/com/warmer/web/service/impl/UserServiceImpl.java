package com.warmer.web.service.impl;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.warmer.web.common.Constants;
import com.warmer.web.entity.DTO.UserDTO;
import com.warmer.web.entity.User;
import com.warmer.web.dao.UserMapper;
import com.warmer.web.entity.VO.UserVO;
import com.warmer.web.exception.ServiceException;
import com.warmer.web.service.UserService;
import com.warmer.web.utils.TokenUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public Page<User> findPage(Page<User> objectPage, String username, String email, String address) {
        Long current = objectPage.getCurrent();
        Long size = objectPage.getSize();
        Page<User> page = new Page<>(current,size);
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        if(StringUtils.isNotBlank(username)){
            queryWrapper.like("username",username);
        }
        if(StringUtils.isNotBlank(email)){
            queryWrapper.like("email",email);
        }
        if(StringUtils.isNotBlank(address)){
            queryWrapper.like("address",address);
        }
        // 设置倒序
        queryWrapper.orderByDesc("id");
        queryWrapper.last("limit "+ (current-1)*size + ", " +size);
        userMapper.selectPage(page, queryWrapper);
        page.setTotal(userMapper.selectCount(null));
        return page;
    }

    @Override
    public UserDTO login(UserDTO userDTO) {
        User one = getUserInfo(userDTO);
        if (one != null) {
            BeanUtil.copyProperties(one, userDTO, true);
            // 设置token
            String token = TokenUtils.genToken(one.getId().toString(), one.getPassword());
            userDTO.setToken(token);
            return userDTO;
        } else {
            throw new ServiceException(Constants.CODE_600, "用户名或密码错误");
        }
    }

    @Override
    public User register(UserDTO userDTO) {
        User one = getUserInfo(userDTO);
        if (one == null) {
            one = new User();
            BeanUtil.copyProperties(userDTO, one, true);
            save(one);  // 把 copy完之后的用户对象存储到数据库
        } else {
            throw new ServiceException(Constants.CODE_600, "用户已存在");
        }
        return one;
    }

    private User getUserInfo(UserDTO userDTO) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", userDTO.getUsername());
        queryWrapper.eq("password", userDTO.getPassword());
        User one;
        try {
            one = getOne(queryWrapper); // 从数据库查询用户信息
        } catch (Exception e) {
            throw new ServiceException(Constants.CODE_500, "系统错误");
        }
        return one;
    }
}
