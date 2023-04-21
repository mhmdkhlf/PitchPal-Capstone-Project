import { createStore } from "vuex";

export default createStore({
  state: {
    isLoading: false,
    userEmail: "",
    playerInfo: null,
    managerInfo: null,
    sportCenterInfo: null,
    sportCenterFields: null,
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
