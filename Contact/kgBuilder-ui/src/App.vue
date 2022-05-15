<template>
  <div id="app">
<!--    <kg-header-2 ref="header" v-show="isXianShi"></kg-header-2>-->
    <router-view />
  </div>
</template>
<script>
import KgHeader2 from "@/components/KGHeader2";
export default {
  components: {
    KgHeader2
  },
  data() {
    return {
      isXianShi: true
    };
  },
  created() {
    // console.log(this.$router);
  },
  // watch: {
  //   // 监听 this.$route.path     watch监听非DOM元素的改变
  //   "$route.path": function(newVal, oldVal) {
  //     // console.log(newVal + '---' +  oldVal);
  //     if (newVal === "/login") {
  //       this.isXianShi = !this.isXianShi;
  //       console.log("欢迎进入登录页面");
  //     } else if (newVal === "/register") {
  //       this.isXianShi = !this.isXianShi;
  //       console.log("欢迎进入注册页面");
  //     } else {
  //       location.reload();
  //       this.isXianShi = !this.isXianShi;
  //     }
  //   }
  // },
  // methods: {
  //   reload() {
  //     this.isRouterAlive = false;
  //     this.$nextTick(function() {
  //       this.isRouterAlive = true;
  //     });
  //   }
  // }
};
</script>
<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  // text-align: center;
  color: #2c3e50;
}

#nav {
  //padding: 30px;

  a {
    font-weight: bold;
    color: #2c3e50;

    &.router-link-exact-active {
      color: #42b983;
    }
  }
}
body {
  margin: 0px;
}
</style>
