import { createRouter, createWebHistory } from "vue-router";
import testView from "../views/testView.vue";

const routes = [
  {
    path: "/",
    name: "home",
    component: testView,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
