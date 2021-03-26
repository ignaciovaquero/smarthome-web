import axios from 'axios';
import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    rooms: [],
    // eslint-disable-next-line no-undef
    smartHomeBaseURL: config.SMARTHOME_BASE_URL,
    // eslint-disable-next-line no-undef
    smartHomeAPIKey: config.SMARTHOME_API_KEY,
    // eslint-disable-next-line no-undef
    smartHomeJWTToken: config.SMARTHOME_JWT_TOKEN,
  },
  mutations: {
    updateRooms(state, rooms) {
      state.rooms = rooms;
    },
  },
  actions: {
    getRooms({ commit, state }) {
      return axios.get(
        `${state.smartHomeBaseURL}/all`,
        { headers: { 'x-api-key': state.smartHomeAPIKey, Authorization: `Bearer ${state.smartHomeJWTToken}` } },
      ).then((response) => commit('updateRooms', response.data));
    },
  },
});
