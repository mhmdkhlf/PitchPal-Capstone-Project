import { createRouter, createWebHistory } from "vue-router";
import homePage from "../views/homePage.vue";
import logInPage from "../views/logInView.vue";
import signUpPage from "../views/signUpView.vue";
//import error from "../components/errorPopup.vue";
const routes = [
  {
    path: "/",
    name: "home",
    component: homePage,
    //component: error,
  },
  {
    path: "/logIn",
    name: "logIn",
    component: logInPage,
  },
  {
    path: "/SignUp",
    name: "signUp",
    component: signUpPage,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
