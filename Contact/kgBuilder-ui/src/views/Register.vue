<template>
  <div class="container">
    <div class="logo">
      <img class="icon" src="@/assets/logo1.png" />
    </div>

    <div class="title">Contact</div>

    <div class="inputs">
      <label>Username</label>
      <input type="text" v-model="user.username" placeholder="请输入用户名" />
<!--      <label>E-mail</label>-->
<!--      <input type="text" v-model="user.email" placeholder="请输入邮箱" />-->
      <label>Phone</label>
      <input type="text" v-model="user.phone" placeholder="请输入电话" />
      <label>Password</label>
      <input type="password" v-model="user.password" placeholder="请输入密码" />
      <label>Password Again</label>
      <input type="password" v-model="user.password2" placeholder="请再次输入密码" />
      <button type="submit" @click="signUp">注册</button>
      <button type="submit" @click="login">登录页</button>
    </div>

<!--    <div class="line">-->
<!--      <a href="#">Forgot password?</a>-->
<!--      <span id="dot"> . </span>-->
<!--      <a href="#">Sign Up for Contact</a>-->
<!--    </div>-->
  </div>
</template>

<script>
import { contactApi } from "@/api";

export default {
  name: "Register",
  data() {
    return {
      user: { username: "", password: "",email: "",phone: "",password2: ""},
    };
  },
  // created() {
  //   const token = localStorage.getItem("token");
  //   if (token) {
  //     this.$router.push("/");
  //   }
  // },
  methods: {
    login() {
      this.$router.push("/login");
    },
    signUp() {
      console.log(this.user)
      if (this.user.password  != this.user.password2){
        alert("密码不一致,请重新输入!")
      } else {
        contactApi.register(this.user).then((res) => {
          if (res) {
            // console.log(res)
            // localStorage.setItem("user", JSON.stringify(res.data)); // 存储用户信息到浏览器
            // localStorage.setItem("token", JSON.stringify(res.data.token));
            this.$notify({
              title: '注册成功',
              message: '注册成功，请登录',
              type: 'success'
            });
            this.$router.push("/login");
          } else {
            this.$message.error("注册失败");
          }
        });
      }
    },
  },
};
</script>

<style scoped>
* {
  text-decoration: none;
}

body {
  margin: 0;
  width: 100vw;
  height: 100vh;
  background: #ecf0f3;
  display: flex;
  align-items: center;
  text-align: center;
  place-items: center;
  overflow: hidden;
  font-family: sans-serif;
}

.container {
  width: 350px;
  height: 700px;
  background: #ecf0f3;
  padding: 40px;
  border-radius: 20px;
  box-sizing: border-box;
  box-shadow: 14px 14px 20px #cbced1, -14px -14px 20px white;
  position: absolute;
  /*居中显示*/
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  margin: auto;
}

.logo {
  height: 100px;
  width: 100px;
  background-size: 160px;
  background-position: -30px;
  margin: auto;
  border-radius: 50%;
  box-sizing: border-box;
  box-shadow: 7px 7px 10px #cbced1, -7px -7px 10px white;
}

.icon {
  height: 100px;
  width: 100px;
  border-radius: 50%;
}
.title {
  margin-top: 30px;
  font-weight: 900;
  font-size: 2rem;
  color: #1da1f2;
  letter-spacing: 1px;
}

/*输入部分*/
.inputs {
  text-align: left;
  margin-top: 60px;
}

label,
input,
button {
  display: block;
  width: 100%;
  padding: 0;
  border: none;
  outline: none;
  box-sizing: border-box;
}

label {
  margin-bottom: 4px;
  font-size: 16px;
}

label:nth-of-type(2) {
  margin-top: 14px;
}

input {
  background: #ecf0f3;
  padding: 10px;
  padding-left: 20px;
  font-size: 14px;
  border-radius: 50px;
  height: 50px;
  box-shadow: inset 6px 6px 6px #cbced1, inset -6px -6px 6px white;
}

input::placeholder {
  color: gray;
}

button {
  margin-top: 20px;
  background: #1da1f2;
  height: 40px;
  border-radius: 20px;
  cursor: pointer;
  font-weight: 900;
  font-family: sans-serif;
  letter-spacing: 1px;
  box-shadow: 6px 6px 6px #cbced1, -6px -6px 6px white;
}
button:hover {
  box-shadow: none;
}

.line {
  margin-left: 15px;
  color: #1da1f2;
  font-size: 13px;
  letter-spacing: 0.2px;
  margin-top: 15px;
}

#dot {
  vertical-align: super;
  font-weight: 600;
}
</style>
