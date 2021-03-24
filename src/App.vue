<template>
  <div id="app">
    <div class="w3-panel w3-red" :v-if="showAlert">
      <h3>Error!</h3>
      <p>{{alertMessage}}</p>
    </div>
    <SmartHomePage />
  </div>
</template>

<script>
import SmartHomePage from './components/SmartHomePage.vue';

export default {
  name: 'App',
  components: {
    SmartHomePage,
  },
  computed: {
    showAlert() {
      return this.$store.showAlert;
    },
    alertMessage() {
      return this.$store.alertMessage;
    },
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
  margin-top: 60px;
}
</style>
