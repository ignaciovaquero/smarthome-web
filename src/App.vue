<template>
  <div id="app">
    <div class="w3-panel w3-red header" v-if="alertMessage.length > 0">
      <h3>Error!</h3>
      <p>{{alertMessage}}</p>
    </div>
    <SmartHomePage v-if="alertMessage.length == 0" />
  </div>
</template>

<script>
import SmartHomePage from './components/SmartHomePage.vue';

export default {
  name: 'App',
  components: {
    SmartHomePage,
  },
  data() {
    return {
      alertMessage: '',
    };
  },
  created() {
    this.$store.dispatch('getRooms').catch((error) => {
      this.alertMessage = error;
      this.showAlert = true;
    });
  },
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

.header {
  position: relative;
  margin: 0px;
}
</style>
