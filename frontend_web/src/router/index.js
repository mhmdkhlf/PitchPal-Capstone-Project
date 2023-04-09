import { createRouter, createWebHistory } from "vue-router";
import homePage from "../views/homePage.vue";
import logInPage from "../views/logInView.vue";
import signUpPage from "../views/signUpView.vue";
import profilePage from "../views/playerProfilePage.vue";
import firstPlayerProfilePage from "../views/firstTimePlayerProfilePage.vue";
import firstManagerProfilePage from "../views/firstTimeManagerProfile.vue";
import sportCenterForm from "../views/sportCenterFormPage.vue";
import managerHomePage from "../views/managerHomePage.vue";
import sportCenterView from "../views/sportCenterPage.vue";
import managerProfile from "../views/managerProfileView.vue";
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
  {
    path: "/sport-center-form",
    name: "sportCenterForm",
    component: sportCenterForm,
  },
  {
    path: "/manager-home-page",
    name: "managerHomePage",
    component: managerHomePage,
  },
  {
    path: "/sport-center-view",
    name: "sportCenterView",
    component: sportCenterView,
  },
  {
    path: "/manager-profile",
    name: "managerProfile",
    component: managerProfile,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
