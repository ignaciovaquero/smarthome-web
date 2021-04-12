<template>
  <div>
    <div class="w3-container title">
      <img class="logo" src="../assets/smarthome-logo.png" />
      <span class="w3-xxxlarge">SmartHome</span>
    </div>
    <SmartHomeRoom
      v-if="selectedRoom"
      :roomName="selectedRoom.room.Value"
      :maxThreshold="selectedRoom.threshold_off.Value"
      :minThreshold="selectedRoom.threshold_on.Value"
      :enabled="selectedRoom.enabled.Value"
    />
  </div>
</template>

<script>
import SmartHomeRoom from './SmartHomeRoom.vue';

function getPreviousValidIndex(index, length) {
  const deprecatedIndex = index - 1;
  return deprecatedIndex < 0 ? length - 1 : deprecatedIndex;
}

function getNextValidIndex(index, length) {
  const incrementedIndex = index + 1;
  return incrementedIndex > length - 1 ? 0 : incrementedIndex;
}

export default {
  name: 'SmartHomePage',
  components: {
    SmartHomeRoom,
  },
  data() {
    return {
      selectedRoomIndex: 0,
    };
  },
  computed: {
    rooms() {
      return this.$store.state.rooms;
    },
    selectedRoom() {
      return this.rooms[this.selectedRoomIndex];
    },
  },
  methods: {
    selectNextRoom() {
      this.selectedRoomIndex = getNextValidIndex(
        this.selectedRoomIndex,
        this.rooms.length,
      );
    },
    selectPreviousRoom() {
      this.selectedRoomIndex = getPreviousValidIndex(
        this.selectedRoomIndex,
        this.rooms.length,
      );
    },
  },
};
</script>

<style lang="scss" scoped>
  .title {
    position: relative;
    top: 30px;
  }

  .logo {
    width: 100px;
    position: relative;
    left: 0px;
  }

  h1 {
    position: relative;
  }
</style>
