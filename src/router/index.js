import Vue from 'vue';
import Router from 'vue-router';

import LoginPage from '../components/LoginPage.vue';
import SmartHomePage from '../components/SmartHomePage.vue';

Vue.use(Router);

export default new Router({
  routes: [{
    path: '/',
    name: 'Login',
    component: LoginPage,
  }, {
    path: '/smarthome',
    name: 'SmartHome',
    component: SmartHomePage,
  }],
});
