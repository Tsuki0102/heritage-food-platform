<template>
  <div class="page-header">
    <div class="page-title-decoration left">
      <span class="page-title-line"></span>
      <span class="page-title-dot">◆</span>
    </div>

    <h2 class="page-title">
      <span v-if="leftIcon" class="title-icon">{{ leftIcon }}</span>
      {{ title }}
      <span v-if="rightIcon" class="title-icon">{{ rightIcon }}</span>
    </h2>

    <div class="page-title-decoration right">
      <span class="page-title-dot">◆</span>
      <span class="page-title-line right"></span>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  title: string
  leftIcon?: string
  rightIcon?: string
}

withDefaults(defineProps<Props>(), {
  leftIcon: '',
  rightIcon: ''
})
</script>

<style scoped>
.page-header {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
  margin-bottom: 40px;
  padding: 24px 0;
}

.page-title-decoration {
  display: flex;
  align-items: center;
  gap: 10px;
}

.page-title-line {
  width: 80px;
  height: 2.5px;
  background: linear-gradient(90deg, transparent, var(--secondary-color));
  border-radius: 2px;
}

.page-title-line.right {
  background: linear-gradient(90deg, var(--secondary-color), transparent);
}

.page-title-dot {
  color: var(--secondary-color);
  font-size: 14px;
}

.page-title {
  font-size: 36px;
  color: var(--text-color);
  margin: 0;
  padding: 0;
  border: none;
  text-align: center;
  letter-spacing: 6px;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 12px;
}

.title-icon {
  font-size: 32px;
  animation: iconBounce 2s ease-in-out infinite;
}

.title-icon:last-child {
  animation-delay: 1s;
}

.page-title::after {
  display: none;
}

@keyframes iconBounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-5px); }
}
</style>
