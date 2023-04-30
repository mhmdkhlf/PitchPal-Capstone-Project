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
import teamForm from "../views/teamFormPage.vue";
import teamProfile from "../views/teamProfilePage.vue";
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
  },
  {
    path: "/first-player-profile",
    name: "FirstPlayerProfile",
    component: firstPlayerProfilePage,
    query: { info: null },
  },
  {
    path: "/first-manager-profile",
    name: "FirstManagerProfile",
    component: firstManagerProfilePage,
    query: { info: null },
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
    path: "/sport-center-view/:name/:isManager",
    name: "sportCenterView",
    component: sportCenterView,
  },
  {
    path: "/manager-profile/:email/:isSelfVisit",
    name: "managerProfile",
    component: managerProfile,
    params: true,
  },
  {
    path: "/team-form",
    name: "teamForm",
    component: teamForm,
  },
  {
    path: "/team-profile/:name/:captainVisit",
    name: "teamProfile",
    component: teamProfile,
    params: true,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
