import { createStore } from "vuex";

export default createStore({
  state: {
    isLoading: false,
  },
  getters: {},
  mutations: {
    setLoading: (state) => {
      state.isLoading = true;
    },
    stopLoading: (state) => {
      state.isLoading = false;
    },
  },
  actions: {
    setLoading: (context) => {
      context.commit("setLoading");
    },
    stopLoading: (context) => {
      context.commit("stopLoading");
    },
  },
  modules: {},
});
