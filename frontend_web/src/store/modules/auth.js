import axios from "axios";

const state = {
  user: null,
};

const getters = {
  isAuthenticated: (state) => !!state.user,
  StateUser: (state) => state.user,
};

const actions = {
  //   async Register({ dispatch }, form) {
  //     const user = await axios.post("http://localhost:5000/signUp", form);
  //     //await dispatch("LogIn", user.data);
  //   },

  async LogIn({ commit }, user) {
    //await axios.post("http://localhost:5000/logIn", user);
    await commit("setUser", user);
  },

  async LogOut({ commit }) {
    let user = null;
    commit("logout", user);
  },
};

const mutations = {
  setUser(state, username) {
    state.user = username;
  },
  logout(state, user) {
    state.user = user;
  },
};

export default {
  state,
  getters,
  actions,
  mutations,
};
