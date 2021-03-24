<template>
  <div>
    <div class="w3-container">
      <img class="logo" src="../assets/smarthome-logo.png" />
      <span class="w3-xxxlarge">SmartHome</span>
    </div>
    <SmartHomeRoom :RoomName="rooms" />
  </div>
</template>

<script>
import SmartHomeRoom from './SmartHomeRoom.vue';

export default {
  name: 'SmartHomePage',
  components: {
    SmartHomeRoom,
  },
  created() {
    this.$store.dispatch('getRooms');
  },
  computed: {
    rooms() {
      return this.$store.state.rooms;
    },
  },
};
</script>

<style lang="scss" scoped>
.logo {
  width: 100px;
  position: relative;
  left: 0px;
}

h1 {
  position: relative;
}
</style>
