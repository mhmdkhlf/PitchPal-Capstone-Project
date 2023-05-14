import { createStore } from "vuex";

export default createStore({
  state: {
    isLoading: false,
    userEmail: "",
    playerInfo: sessionStorage.getItem("playerInfo")
      ? JSON.parse(sessionStorage.getItem("playerInfo"))
      : null,
    managerInfo: sessionStorage.getItem("managerInfo")
      ? JSON.parse(sessionStorage.getItem("managerInfo"))
      : null,
    sportCenterInfo: sessionStorage.getItem("sportCenterInfo")
      ? JSON.parse(sessionStorage.getItem("sportCenterInfo"))
      : null,
    sportCenterFields: sessionStorage.getItem("sportCenterFields")
      ? JSON.parse(sessionStorage.getItem("sportCenterFields"))
      : null,
  },
  getters: {},
  mutations: {
    setLoading: (state) => {
      state.isLoading = true;
    },
    stopLoading: (state) => {
      state.isLoading = false;
    },
    setUser: (state, email) => {
      state.userEmail = email;
    },
    setPlayerInfo(state, info) {
      state.playerInfo = info;
    },
    setSportCenterInfo(state, info) {
      state.sportCenterInfo = info;
    },
    setManagerInfo(state, info) {
      state.managerInfo = info;
    },
    setSportCenterFields(state, info) {
      state.sportCenterFields = info;
    },
  },
  actions: {
    setLoading: (context) => {
      context.commit("setLoading");
    },
    stopLoading: (context) => {
      context.commit("stopLoading");
    },
    setUser: (context, email) => {
      context.commit("setUser", email);
    },
    setPlayerInfo(context, info) {
      context.commit("setPlayerInfo", info);
    },
    setSportCenterInfo(context, info) {
      context.commit("setSportCenterInfo", info);
    },
    setManagerInfo(context, info) {
      context.commit("setManagerInfo", info);
    },
    setSportCenterFields(context, info) {
      context.commit("setSportCenterFields", info);
    },
  },
  modules: {},
});
