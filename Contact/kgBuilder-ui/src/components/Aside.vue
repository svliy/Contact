<template>
  <el-menu
    :default-openeds="['1', '3']"
    style="min-height: 100%; overflow-x: hidden"
    background-color="#362290"
    text-color="#fff"
    active-text-color="#ffd04b"
    :collapse-transition="false"
    :collapse="isCollapse"
    router
  >
    <div style="height: 60px; line-height: 60px; text-align: center">
      <img
        src="../assets/logo2.png"
        alt=""
        style="width: 45px; position: relative; top: 13px; right: 5px"
      />
      <b style="color: white" v-show="logoTextShow">Contact系统</b>
    </div>
<!--    <el-menu-item index="/home">-->
<!--      <template slot="title">-->
<!--        <i class="el-icon-house"></i>-->
<!--        <span slot="title">主页</span>-->
<!--      </template>-->
<!--    </el-menu-item>-->
    <el-menu-item index="/">
      <template slot="title">
        <i class="el-icon-s-grid"></i>
        <span slot="title">公共知识图谱</span>
      </template>
    </el-menu-item>
    <el-menu-item index="mycontact">
      <template slot="title">
        <i class="el-icon-share"></i>
        <span slot="title">个人知识图谱</span>
      </template>
    </el-menu-item>
<!--    <el-menu-item index="mycontact">-->
<!--      <template slot="title">-->
<!--        <i class="el-icon-coin"></i>-->
<!--        <span slot="title">统计模块</span>-->
<!--      </template>-->
<!--    </el-menu-item>-->
    <el-submenu index="2">
      <template slot="title">
        <i class="el-icon-menu"></i>
        <span slot="title">系统管理</span>
      </template>
      <el-menu-item index="/user">
        <i class="el-icon-s-custom"></i>
        <span slot="title">用户管理</span>
      </el-menu-item>
    </el-submenu>

  </el-menu>
</template>

<script>
export default {
  name: "Aside",
  props: {
    isCollapse: Boolean,
    logoTextShow: Boolean,
  },
};
</script>

<style scoped></style>
