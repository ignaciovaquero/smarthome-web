<template>
  <div class="w3-container w3-content w3-card w3-round-large ">
    {{RoomName}}
  </div>
</template>

<script>
export default {
  name: 'SmartHomeRoom',
  props: {
    RoomName: {
      type: String,
      required: true,
    },
  },
};
</script>

<style lang="scss" scoped>

</style>
