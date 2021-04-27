<template>
  <div>
    <div class="w3-container title">
      <img class="logo" src="../assets/smarthome-logo.png" />
      <span class="w3-xxxlarge">SmartHome</span>
    </div>
    <div class="w3-content carousel-container">
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
  </div>
</template>

<script>
import { Carousel, Slide } from 'vue-carousel';
import SmartHomeRoom from './SmartHomeRoom.vue';

export default {
  name: 'SmartHomePage',
  components: {
    SmartHomeRoom,
    Carousel,
    Slide,
  },
  created() {
    if (this.$store.state.smartHomeToken === '') {
      this.$router.push({ name: 'Login' });
      return;
    }
    this.$store.dispatch('getRooms');
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
  },
};
</script>

<style lang="scss" scoped>
.title {
  position: relative;
  top: 30px;
}

.carousel-container {
  max-width: 600px;
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
