package com.warmer.web.controller;


import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.conditions.update.UpdateChainWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.warmer.base.util.BeanUtils;
import com.warmer.web.common.Constants;
import com.warmer.web.common.Result;
import com.warmer.web.entity.DTO.UserDTO;
import com.warmer.web.entity.KgDomain;
import com.warmer.web.entity.KgFeedBack;
import com.warmer.web.entity.User;
import com.warmer.web.entity.VO.KgFeedBackListVO;
import com.warmer.web.entity.VO.KgFeedBackVO;
import com.warmer.web.entity.VO.RegisterVO;
import com.warmer.web.entity.VO.UserVO;
import com.warmer.web.service.KgDomainService;
import com.warmer.web.service.KgFeedBackService;
import com.warmer.web.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;


@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private KgDomainService kgDomainService;
    @Autowired
    private KgFeedBackService kgFeedBackService;

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String username,
                           @RequestParam(defaultValue = "") String email,
                           @RequestParam(defaultValue = "") String address) {
        return Result.success(userService.findPage(new Page<>(pageNum, pageSize), username, email, address));
    }

    @GetMapping("/pageFeebBack")
    public Result findPageOfFeedBack(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String fbId,
                           @RequestParam(defaultValue = "") String domainId) {
        return Result.success(userService.findPageOfFb(new Page<>(pageNum, pageSize), fbId, domainId));
    }


    @PostMapping("/addUser")
    public Result addUser(@RequestBody UserVO uservo) {
        User user = new User();
        if(StringUtils.isNotBlank(uservo.getId())){
            BeanUtils.copyProperties(uservo,user);
            boolean update = userService.update(new UpdateWrapper<User>().eq("id", Integer.valueOf(uservo.getId()))
                    .set("username",user.getUsername())
                    .set("nickname",user.getNickname())
                    .set("email",user.getEmail())
                    .set("phone",user.getPhone())
                    .set("address",user.getAddress()));
            if(!update) {
                return Result.error("400","编辑用户失败！");
            }
        }else {
            BeanUtils.copyProperties(uservo,user);
            boolean save = userService.saveOrUpdate(user);
            if(!save) {
                return Result.error("400","用户注册失败！");
            }
        }
        return Result.success();
    }

    @GetMapping("/username/{username}")
    public Result findByUsername(@PathVariable String username) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        return Result.success(userService.getOne(queryWrapper));
    }

    @PostMapping("/deleteUser/{id}")
    public Result deleteUser(@PathVariable Integer id, HttpServletResponse response){
        boolean remove = userService.removeById(id);
        if(!remove) {
            return Result.error("400","删除用户失败！");
        }
        return Result.success();
    }

    @PostMapping("/selectFb/{id}")
    public Result selectFb(@PathVariable Integer id, HttpServletResponse response){
        KgFeedBack kgFeedBack = new KgFeedBack();
        kgFeedBack.setId(id);
        kgFeedBack.setIsActive(String.valueOf(1));
        boolean remove = kgFeedBackService.updateById(kgFeedBack);
        if(!remove) {
            return Result.error("400","删除用户失败！");
        }
        return Result.success();
    }

    /**
     * 批量删除
     * @param ids
     * @return
     */
    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        return Result.success(userService.removeByIds(ids));
    }


    /**
     * 登录功能
     * @param userDTO
     * @return
     */
    @PostMapping("/login")
    public Result login(@RequestBody UserDTO userDTO) {
        String username = userDTO.getUsername();
        String password = userDTO.getPassword();
        if (StringUtils.isBlank(username) || StringUtils.isBlank(password)) {
            return Result.error(Constants.CODE_400, "参数错误");
        }
        UserDTO dto = userService.login(userDTO);
        return Result.success(dto);
    }

    /**
     * 公开图谱
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/opendomain/{domainName}")
    public Boolean opendomain(@PathVariable String domainName){
        UpdateWrapper<KgDomain> updateWrapper = new UpdateWrapper<>();
        updateWrapper.set("pub",1)
                .eq("name",domainName);
        return kgDomainService.update(updateWrapper);
    }
    /**
     * 关闭图谱
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/closeddomain/{domainName}")
    public Boolean closeddomain(@PathVariable String domainName){
        UpdateWrapper<KgDomain> updateWrapper = new UpdateWrapper<>();
        updateWrapper.set("pub",0)
                .eq("name",domainName);
        return kgDomainService.update(updateWrapper);
    }

    @ResponseBody
    @PostMapping(value = "/addfeedback")
    public Boolean addfeedback(@RequestBody KgFeedBackVO kgFeedBackVO){
        KgFeedBack kgFeedBack = new KgFeedBack();
        kgFeedBack.setDomainId(kgFeedBackVO.getDomainId());
        kgFeedBack.setUserId(kgFeedBackVO.getUserId());
        kgFeedBack.setContent(kgFeedBackVO.getContent());
        return kgFeedBackService.save(kgFeedBack);
    }

    @GetMapping("/getFeedBackList/{domainId}")
    public Result getFeedBackListById(@PathVariable Integer domainId) {
        QueryWrapper<KgFeedBack> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("domain_id", domainId);
        queryWrapper.eq("is_active", 1);
        List<KgFeedBack> kgFeedBackList = kgFeedBackService.list(queryWrapper);
        List<KgFeedBackListVO> listVOS = new ArrayList<>();
        for(int i = 0; i < kgFeedBackList.size(); i++) {
            KgFeedBack kgFeedBack = kgFeedBackList.get(i);
            KgFeedBackListVO kgFeedBackListVO = new KgFeedBackListVO();
            kgFeedBackListVO.setContent(kgFeedBack.getContent());
            kgFeedBackListVO.setTime(kgFeedBack.getCreateTime());
            // 根据评论图谱的用户id查询所有的用户名字
            QueryWrapper<User> queryWrapper1 = new QueryWrapper<>();
            queryWrapper1.eq("id",kgFeedBack.getUserId());
            User user = userService.getOne(queryWrapper1);
            kgFeedBackListVO.setName(user.getUsername());
            listVOS.add(kgFeedBackListVO);
        }
        return Result.success(listVOS);
    }

    @ResponseBody
    @PostMapping(value = "/register")
    public Boolean addfeedback(@RequestBody RegisterVO registerVO){
        User user = new User();
        user.setUsername(registerVO.getUsername());
        user.setPassword(registerVO.getPassword());
        user.setAddress(registerVO.getAddress());
        user.setEmail(registerVO.getEmail());
        user.setPhone(registerVO.getPhone());
        return userService.save(user);
    }

}
