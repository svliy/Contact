import Vue from "vue";
import VueRouter from "vue-router";
import store from "@/store";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    component: () => import("../views/Manage.vue"),
    children: [
      {
        path: "/",
        name: "公共知识图谱",
        component: () => import("../views/Contact"),
      },
      {
        path: "mycontact",
        name: "个人知识图谱",
        component: () => import("../views/MyContact"),
      },
      {
        path: "user",
        name: "用户管理",
        component: () => import("../views/User.vue"),
      },
      {
        path: "/home",
        name: "首页",
        component: () => import("../views/Home"),
      },
      {
        path: 'person',
        name: 'Person',
        component: () => import('../views/Person')
      },
    ],
  },
  {
    path: "/builder",
    name: "builder",
    component: () => import("../views/kgbuilder/index.vue")
  },
  {
    path: "/er",
    name: "er",
    component: () => import("../views/erbuilder/index.vue")
  },
  {
    path: "/ds",
    name: "ds",
    component: () => import("../views/datasource/index.vue")
  },
  {
    path: "/login",
    name: "Login",
    component: () => import("../views/Login.vue"),
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

// 导航守卫
// router.beforeEach((to, from, next) => {
//   // 跳转到登录页肯定放行 用户认证通过也放行
//   const token = localStorage.getItem("token");
//   if (to.name == "Login" || token) next();
//   else next({ name: "Login" });
// });

// router.beforeEach((to, from, next) => {
//   // 设置当前的路由名称，为了在Header组件中去使用
//   localStorage.setItem("currentPathName", to.name);
//   // 跳转到登录页肯定放行 用户认证通过也放行
//   const user = localStorage.getItem("user")
//     ? JSON.parse(localStorage.getItem("user"))
//     : null;
//   if (to.name === "Login" || user !== null) {
//     store.commit("setPath"); // 触发store的数据更新
//     next();
//   } else {
//     next({ name: "Login" });
//   }
// });

export default router;
