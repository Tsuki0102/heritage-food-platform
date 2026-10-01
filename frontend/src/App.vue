<template>
  <div class="app">
    <router-view v-slot="{ Component }">
      <transition name="fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
  </div>
</template>

<script setup lang="ts">
// App.vue 根组件
import { onMounted } from 'vue'
import { useUserStore } from './stores/userStore'

const userStore = useUserStore()

// 应用启动时加载用户信息，确保登录状态能够在刷新页面后保持
onMounted(() => {
  userStore.loadUser()
})
</script>

<style>
/* 仅保留过渡动画样式，其他样式已移至全局样式文件 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>