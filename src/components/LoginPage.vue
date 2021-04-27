<template>
  <div class="w3-content w3-card login-form">
    <h1 class="title w3-padding-large">{{title}}</h1>
    <form class="w3-container">
      <input
        class="input-username w3-input"
        type="text"
        placeholder="username"
        v-model="user"
      />
      <input
        class="input-password w3-input"
        type="password"
        placeholder="password"
        v-model="pass"
      />
      <button
        type="button"
        class="login-button w3-button w3-hover-shadow"
        @click="login()"
      >
        Login
      </button>
    </form>
  </div>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      default: 'SmartHome',
    },
  },
  data() {
    return {
      user: '',
      pass: '',
    };
  },
  methods: {
    login() {
      this.$store.dispatch('login', { username: this.user, password: this.pass })
        .then(() => this.$router.push({ name: 'SmartHome' }))
        .catch((error) => console.log(error.response.data.message));
    },
  },
};
</script>

<style scoped>
.title {
  position: relative;
  top: 10px;
}

input, button {
  font-size: 15px;
}

input {
  text-align: center;
  width: 100%;
  display: block;
  margin: 30px 0px;
  border: 1px solid #cccccc;
  border-radius: 30px;
}

input:focus {
  outline: none;
}

.login-button, .login-button:hover {
  background-color: #2196F3 !important;
  color: #FFFFFF !important;
  border-radius: 5px;
}

.login-form {
  width: 400px;
  height: 350px;
  position: relative;
  top: 100px;
  border-radius: 20px;
}
</style>
