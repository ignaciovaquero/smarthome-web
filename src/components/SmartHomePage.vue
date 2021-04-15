<template>
  <div>
    <div class="w3-container title">
      <img class="logo" src="../assets/smarthome-logo.png" />
      <span class="w3-xxxlarge">SmartHome</span>
    </div>
    <carousel class="carousel" v-if="rooms.length" :perPage="1">
      <slide class="slide" v-for="(room, index) in rooms" :key="index">
        <SmartHomeRoom
          :roomName="room.room.Value"
          :maxThreshold="parseFloat(room.threshold_off.Value)"
          :minThreshold="parseFloat(room.threshold_on.Value)"
          :enabled="room.enabled.Value"
        />
      </slide>
    </carousel>
  </div>
</template>

<script>
import { Carousel, Slide } from 'vue-carousel';
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
    Carousel,
    Slide,
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

  .carousel {
    top: 80px;
  }

  .slide {
    position: relative;
    min-height: 410px;
    top: 5px;
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
