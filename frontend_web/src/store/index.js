import { createStore } from "vuex";

export default createStore({
  state: {
    isLoading: false,
    userEmail: "",
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
  },
  modules: {},
});
