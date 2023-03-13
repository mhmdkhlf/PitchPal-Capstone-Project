import { createRouter, createWebHistory } from "vue-router";
import homePage from "../views/homePage.vue";
import logInPage from "../views/logInView.vue";
import signUpPage from "../views/signUpView.vue";
import profilePage from "../components/Profile.vue";
import firstProfilePage from "../components/firstTimeProfile.vue";
const routes = [
  {
    path: "/",
    name: "home",
    component: homePage,
  },
  {
    path: "/logIn/:email?",
    name: "logIn",
    component: logInPage,
  },
  {
    path: "/SignUp",
    name: "signUp",
    component: signUpPage,
  },
  {
    path: "/profile",
    name: "Profile",
    component: profilePage,
  },
  {
    path: "/first-profile",
    name: "FirstProfile",
    component: firstProfilePage,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
