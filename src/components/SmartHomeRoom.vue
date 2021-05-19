<template>
  <div>
    <div class="w3-container w3-content w3-card w3-round-large room-container">
      <div class="w3-xxlarge w3-padding-large">
        {{localeRoomName}}
      </div>
      <div v-if="wrongThresholds" class="w3-small thresholds-wrong">
        Max. Threshold should be greater or equal than Min. Threshold
      </div>
      <div class="w3-large w3-padding-large">
        Max. Threshold
        <div>
          <input
            type="text"
            v-model="roomMaxThreshold"
            :class="['w3-center', 'w3-input', 'w3-padding-large', 'temperature', wrongMaxThreshold]"
            @blur="sendRoomParameters()"
          />
        </div>
      </div>
      <div class="w3-large w3-padding-large">
        Min. Threshold
        <div>
          <input
            type="text"
            v-model="roomMinThreshold"
            :class="['w3-center', 'w3-input', 'w3-padding-large', 'temperature', wrongMinThreshold]"
            @blur="sendRoomParameters()"
          />
        </div>
      </div>
      <div class="w3-large w3-padding-large">
        Enabled
      </div>
      <label class="switch">
        <input type="checkbox" v-model="roomEnabled" @change="sendRoomParameters()">
        <span class="slider round"></span>
      </label>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import locales from '../locales/index';

const wrongTemperature = 'temperature-wrong';

export default {
  name: 'SmartHomeRoom',
  methods: {
    ...mapActions(['updateRoom']),
    sendRoomParameters() {
      this.wrongMaxThreshold = '';
      this.wrongMinThreshold = '';
      this.wrongThresholds = false;

      this.roomMinThreshold = this.roomMinThreshold.replaceAll(',', '.');
      this.roomMaxThreshold = this.roomMaxThreshold.replaceAll(',', '.');

      const min = parseFloat(this.roomMinThreshold);
      const max = parseFloat(this.roomMaxThreshold);

      let mustReturn = false;

      if (Number.isNaN(min)) {
        mustReturn = true;
        this.wrongMinThreshold = wrongTemperature;
      }

      if (Number.isNaN(max)) {
        mustReturn = true;
        this.wrongMaxThreshold = wrongTemperature;
      }

      if (max < min) {
        mustReturn = true;
        this.wrongMaxThreshold = wrongTemperature;
        this.wrongMinThreshold = wrongTemperature;
        this.wrongThresholds = true;
      }

      if (mustReturn) {
        return;
      }

      this.updateRoom({
        name: this.roomName,
        threshold_on: min,
        threshold_off: max,
        enabled: this.roomEnabled,
      }).catch((error) => {
        if (error.response !== undefined && error.response.status === 401) {
          this.$store.commit('setToken', '');
          this.$router.push({ name: 'Login' });
        }
      });
    },
  },
  props: {
    roomName: {
      type: String,
      required: true,
    },
    maxThreshold: {
      type: String,
      required: true,
    },
    minThreshold: {
      type: String,
      required: true,
    },
    enabled: {
      type: Boolean,
      required: true,
    },
  },
  computed: {
    localeRoomName() {
      return locales[this.roomName];
    },
  },
  data() {
    return {
      roomEnabled: this.enabled,
      roomMaxThreshold: this.maxThreshold,
      roomMinThreshold: this.minThreshold,
      wrongMaxThreshold: '',
      wrongMinThreshold: '',
      wrongThresholds: false,
    };
  },
};
</script>

<style lang="scss" scoped>
  .room-container {
    position: relative;
    height: 400px;
    max-width: 400px;
  }

  .temperature {
    width: auto;
    display: inline;
    border: 0px;
  }

  .temperature-wrong {
    border: 1px solid red;
    border-radius: 15px;
    color: red;
  }

  .thresholds-wrong {
    color: red;
  }

  /* The switch - the box around the slider */
  .switch {
    position: relative;
    display: inline-block;
    width: 60px;
    height: 34px;
  }

  /* Hide default HTML checkbox */
  .switch input {
    opacity: 0;
    width: 0;
    height: 0;
  }

  /* The slider */
  .slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #ccc;
    -webkit-transition: .4s;
    transition: .4s;
  }

  .slider::before {
    position: absolute;
    content: "";
    height: 26px;
    width: 26px;
    left: 4px;
    bottom: 4px;
    background-color: white;
    -webkit-transition: .4s;
    transition: .4s;
  }

  input:checked + .slider {
    background-color: #2196F3;
  }

  input:focus + .slider {
    box-shadow: 0 0 1px #2196F3;
  }

  input:checked + .slider::before {
    -webkit-transform: translateX(26px);
    -ms-transform: translateX(26px);
    transform: translateX(26px);
  }

  /* Rounded sliders */
  .slider.round {
    border-radius: 34px;
  }

  .slider.round::before {
    border-radius: 50%;
  }
</style>
