<template>
  <div class="time-timeline-view">
    <Header />
    <TimeTimeline />
  </div>
</template>

<script setup lang="ts">
import Header from '../components/Header.vue'
import TimeTimeline from '../components/TimeTimeline.vue'
</script>

<style scoped>
.time-timeline-view {
  min-height: 100vh;
}
</style>
