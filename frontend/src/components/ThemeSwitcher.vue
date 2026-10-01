<template>
  <div class="theme-switcher">
    <el-dropdown @command="handleThemeChange">
      <button class="theme-switcher-btn">
        <i :class="themeIcon" class="theme-icon"></i>
        <span class="theme-text">{{ themeText }}</span>
        <el-icon class="el-icon--right"><arrow-down /></el-icon>
      </button>
      <template #dropdown>
        <el-dropdown-menu>
          <el-dropdown-item command="light">
            <i class="el-icon-sunny"></i>
            <span>亮色模式</span>
          </el-dropdown-item>
          <el-dropdown-item command="dark">
            <i class="el-icon-moon"></i>
            <span>深色模式</span>
          </el-dropdown-item>
          <el-dropdown-item command="eye-care">
            <i class="el-icon-light"></i>
            <span>护眼模式</span>
          </el-dropdown-item>
        </el-dropdown-menu>
      </template>
    </el-dropdown>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useThemeStore, ThemeType } from '../stores/themeStore'
import { ArrowDown, Sunny, Moon, Light } from '@element-plus/icons-vue'

const themeStore = useThemeStore()

const themeIcon = computed(() => {
  switch (themeStore.theme) {
    case 'light':
      return 'el-icon-sunny'
    case 'dark':
      return 'el-icon-moon'
    case 'eye-care':
      return 'el-icon-light'
    default:
      return 'el-icon-sunny'
  }
})

const themeText = computed(() => {
  switch (themeStore.theme) {
    case 'light':
      return '亮色'
    case 'dark':
      return '深色'
    case 'eye-care':
      return '护眼'
    default:
      return '亮色'
  }
})

const handleThemeChange = (theme: ThemeType) => {
  themeStore.setTheme(theme)
}
</script>

<style scoped>
.theme-switcher {
  position: relative;
}

.theme-switcher-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: var(--bg-white);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  cursor: pointer;
  font-size: 14px;
  color: var(--text-color);
  transition: var(--transition);
}

.theme-switcher-btn:hover {
  background: var(--bg-color);
  box-shadow: var(--shadow);
}

.theme-icon {
  font-size: 16px;
}

.theme-text {
  font-weight: 500;
}

:deep(.el-dropdown-menu) {
  background: var(--bg-white) !important;
  border: 1px solid var(--border-color) !important;
  border-radius: var(--radius-md) !important;
  box-shadow: var(--shadow) !important;
}

:deep(.el-dropdown-item) {
  color: var(--text-color) !important;
  transition: var(--transition) !important;
}

:deep(.el-dropdown-item:hover) {
  background: var(--bg-color) !important;
  color: var(--primary-color) !important;
}

:deep(.el-dropdown-item i) {
  margin-right: 8px;
  font-size: 14px;
}
</style>
