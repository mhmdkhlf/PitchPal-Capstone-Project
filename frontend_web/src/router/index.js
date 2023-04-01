import { createRouter, createWebHistory } from "vue-router";
import homePage from "../views/homePage.vue";
import logInPage from "../views/logInView.vue";
import signUpPage from "../views/signUpView.vue";
import profilePage from "../views/playerProfilePage.vue";
import firstPlayerProfilePage from "../views/firstTimePlayerProfilePage.vue";
import firstManagerProfilePage from "../views/firstTimeManagerProfile.vue";
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
    path: "/player-profile/:id/:isSelfVisit",
    name: "Profile",
    component: profilePage,
    params: true,
    // props: (route) => ({
    //   playerInfo: route.query.playerInfo,
    //   isSelfVisit: route.query.isSelfVisit,
    // }),
  },
  {
    path: "/first-player-profile",
    name: "FirstPlayerProfile",
    component: firstPlayerProfilePage,
  },
  {
    path: "/first-manager-profile",
    name: "FirstManagerProfile",
    component: firstManagerProfilePage,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
