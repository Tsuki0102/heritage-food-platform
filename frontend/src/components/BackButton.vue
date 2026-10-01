<template>
  <button class="back-button" @click="goBack" :title="tooltip">
    <span class="icon">←</span>
    <span class="text">{{ text }}</span>
  </button>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

interface Props {
  to?: string
  text?: string
  tooltip?: string
}

const props = withDefaults(defineProps<Props>(), {
  to: '',
  text: '返回',
  tooltip: '返回上一页'
})

const router = useRouter()

const goBack = () => {
  if (props.to) {
    router.push(props.to)
  } else {
    router.back()
  }
}
</script>

<style scoped>
.back-button {
  display: inline-flex;
  align-items: center;
  gap: var(--spacing-sm);
  padding: var(--spacing-sm) var(--spacing-md);
  background: #f5f5f5;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-sm);
  color: var(--text-color);
  font-size: 14px;
  cursor: pointer;
  transition: var(--transition);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.back-button:hover {
  background: #e8e8e8;
  border-color: var(--primary-color);
  color: var(--primary-color);
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.icon {
  font-size: 18px;
  font-weight: bold;
  transition: var(--transition);
}

.back-button:hover .icon {
  transform: translateX(-2px);
}

@media (max-width: 768px) {
  .back-button {
    padding: var(--spacing-xs) var(--spacing-md);
    font-size: 13px;
  }
  
  .text {
    display: none;
  }
}
</style>
