<template>
  <div>
    <span class="previous w3-card-4" />
    <div class="w3-container w3-content w3-card w3-round-large room-container">
      <div class="w3-xxlarge w3-padding-large">
        {{roomName}}
      </div>
      <div class="w3-large w3-padding-large">
        Max. Threshold
        <div>
          <input
            type="text"
            v-model="maxThreshold"
            class="w3-center w3-input w3-padding-large temperature"
          />
        </div>
      </div>
      <div class="w3-large w3-padding-large">
        Min. Threshold
        <div>
          <input
            type="text"
            v-model="minThreshold"
            class="w3-center w3-input w3-padding-large temperature"
          />
        </div>
      </div>
      <div class="w3-large w3-padding-large">
        Enabled
      </div>
      <label class="switch">
        <input type="checkbox" v-model="enabled">
        <span class="slider round"></span>
      </label>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SmartHomeRoom',
  props: {
    roomName: {
      type: String,
      required: true,
    },
    maxThreshold: {
      type: Number,
      required: true,
    },
    minThreshold: {
      type: Number,
      required: true,
    },
    enabled: {
      type: Boolean,
      required: true,
    },
  },
};
</script>

<style lang="scss" scoped>
  .room-container {
    position: relative;
    top: 80px;
    min-height: 400px;
    max-width: 400px;
  }

  .temperature {
    width: auto;
    display: inline;
    border: 0px;
  }

  .previous {
    position: relative;
    top: 30px;
    display: inline-block;
    width: 50px;
    height: 50px;
    background-color: #ffffff;
    border-radius: 50px;
  }

  .previous::before {
    content: "<";
    position: relative;
    color: #313131;
    font-size: 20px;
    font-family: 'Courier New', Courier, monospace;
    font-weight: bold;
    top: 11px;
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
