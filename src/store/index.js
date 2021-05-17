import axios from 'axios';
import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    rooms: [],
    smartHomeToken: '',
    // eslint-disable-next-line no-undef
    smartHomeBaseURL: config.SMARTHOME_BASE_URL,
  },
  mutations: {
    setToken(state, token) {
      state.smartHomeToken = token;
    },
    updateRooms(state, rooms) {
      state.rooms = rooms;
    },
    updateSingleRoom(state, room) {
      state.rooms.map((r) => (r.room.Value === room.room.Value ? room : r));
    },
  },
  actions: {
    login({ commit, state }, { username, password }) {
      commit('setToken', '');
      return axios.post(
        `${state.smartHomeBaseURL}/login`,
        { username, password },
      ).then((response) => {
        commit('setToken', response.data.token);
      });
    },
    getRooms({ commit, state }) {
      return axios.get(
        `${state.smartHomeBaseURL}/room/all`,
        { headers: { Authorization: `Bearer ${state.smartHomeToken}` } },
      ).then((response) => commit('updateRooms', response.data));
    },
    updateRoom({ commit, state }, roomValues) {
      const { name, ...roomData } = roomValues;
      return axios.post(
        `${state.smartHomeBaseURL}/room/${name}`,
        roomData,
        {
          headers: { Authorization: `Bearer ${state.smartHomeToken}` },
        },
      ).then(() => commit('updateSingleRoom', {
        enabled: { Value: roomData.enabled },
        room: { Value: name },
        threshold_on: { Value: roomData.threshold_on },
        threshold_off: { Value: roomData.threshold_off },
      }));
    },
  },
});
