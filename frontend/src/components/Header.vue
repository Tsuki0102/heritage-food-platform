<template>
  <header class="header">
    <div class="header-decoration">
      <span class="deco-line left"></span>
      <span class="deco-symbol">❋</span>
      <span class="deco-line right"></span>
    </div>

    <div class="container">
      <router-link to="/" class="logo">
        <span class="logo-icon">🏛️</span>
        {{ APP_CONFIG.NAME }}
      </router-link>

      <nav class="nav">
        <router-link
          v-for="item in navItems"
          :key="item.path"
          :to="item.path"
          class="nav-item"
          :class="{ active: currentRoute === item.path }"
        >
          <span class="nav-icon">{{ getNavIcon(item.label) }}</span>
          <span class="nav-text">{{ item.label }}</span>
        </router-link>

        <router-link
          v-if="userStore.isLoggedIn"
          :to="ROUTES.CART"
          class="cart-icon"
        >
          🛒
          <span class="cart-badge" v-if="cartCount > 0">{{ cartCount > 99 ? '99+' : cartCount }}</span>
        </router-link>

        <ThemeSwitcher class="theme-switcher" />

        <router-link
          v-if="!userStore.isLoggedIn"
          :to="ROUTES.LOGIN"
          class="login-btn btn btn-primary"
        >
          登录
        </router-link>

        <div v-else class="user-avatar" @click="$router.push(ROUTES.USER_PROFILE)">
          <img
            :src="userStore.userAvatar"
            :alt="userStore.userInfo?.nickname"
            @error="handleAvatarError"
          />
          <div class="avatar-ring"></div>
        </div>
      </nav>
    </div>
  </header>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useUserStore } from '../stores/userStore'
import { useCartStore } from '../stores/cartStore'
import { APP_CONFIG, ROUTES, DEFAULT_AVATAR } from '../constants'
import { logger, LogCategory } from '../utils/logger'
import ThemeSwitcher from './ThemeSwitcher.vue'

const route = useRoute()
const userStore = useUserStore()
const cartStore = useCartStore()

const navItems = computed(() => [
  { path: ROUTES.HOME, label: '首页' },
  { path: ROUTES.MAP, label: '美食地图' },
  { path: ROUTES.COMMUNITY, label: '社区' },
  { path: ROUTES.TASTE_TEST, label: '口味测试' },
  { path: ROUTES.TIME_TIMELINE, label: '时光复刻' },
  { path: ROUTES.SHOP, label: '商城' },
  { path: ROUTES.USER, label: '个人中心' }
])

const cartCount = computed(() => cartStore.totalCount)
const currentRoute = computed(() => route.path)

const getNavIcon = (label: string) => {
  const iconMap: Record<string, string> = {
    '首页': '🏠',
    '美食地图': '🗺️',
    '社区': '💬',
    '口味测试': '🧪',
    '时光复刻': '⏳',
    '商城': '🛍️',
    '个人中心': '👤'
  }
  return iconMap[label] || ''
}

const handleAvatarError = () => {
  logger.warn(LogCategory.UI, 'Avatar load failed', {
    avatar: userStore.user?.avatar
  })
}

onMounted(async () => {
  try {
    userStore.loadUser()
    if (userStore.isLoggedIn) {
      await cartStore.fetchCartList()
    }
  } catch (error) {
    logger.error(LogCategory.UI, 'Failed to load user', undefined, error instanceof Error ? error.stack : undefined)
  }
})
</script>

<style scoped>
.header {
  background: linear-gradient(135deg, rgba(255,255,255,0.98), rgba(250,245,240,0.98));
  box-shadow: var(--shadow-md);
  position: sticky;
  top: 0;
  z-index: 100;
  backdrop-filter: blur(12px);
  border-bottom: 1px solid var(--border-gold);
  position: relative;
  overflow: hidden;
}

.header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

.header-decoration {
  position: absolute;
  top: 50%;
  left: 20px;
  transform: translateY(-50%);
  display: flex;
  align-items: center;
  gap: 8px;
  opacity: 0.15;
  pointer-events: none;
  z-index: 1;
}

.deco-line {
  width: 30px;
  height: 2px;
  background: var(--secondary-color);
}

.deco-symbol {
  font-size: 14px;
  color: var(--secondary-color);
}

.container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 68px;
  position: relative;
  z-index: 2;
}

.logo {
  font-size: 22px;
  font-weight: 800;
  color: var(--primary-color);
  white-space: nowrap;
  transition: var(--transition);
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 10px;
  letter-spacing: 2px;
  position: relative;
}

.logo::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 0;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  border-radius: 2px;
  opacity: 0;
  transition: opacity var(--transition);
}

.logo:hover {
  transform: scale(1.03);
}

.logo:hover::after {
  opacity: 1;
}

.logo-icon {
  font-size: 28px;
  animation: iconBounce 2s ease-in-out infinite;
}

.nav {
  display: flex;
  align-items: center;
  gap: 6px;
}

.theme-switcher {
  margin-right: 8px;
}

.nav-item {
  color: var(--text-color);
  text-decoration: none;
  font-size: 14px;
  padding: 8px 14px;
  border-radius: var(--radius-xs);
  transition: var(--transition);
  white-space: nowrap;
  position: relative;
  display: flex;
  align-items: center;
  gap: 5px;
  font-weight: 500;
  letter-spacing: 0.5px;
}

.nav-icon {
  font-size: 15px;
  transition: transform var(--transition);
}

.nav-item:hover {
  color: var(--primary-color);
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.06), rgba(212, 175, 55, 0.06));
  transform: translateY(-1px);
}

.nav-item:hover .nav-icon {
  transform: scale(1.15) rotate(-8deg);
}

.nav-item.active {
  color: white;
  background: var(--gradient-primary);
  box-shadow: 0 4px 12px rgba(200, 22, 29, 0.25);
  font-weight: 600;
}

.nav-item.active::after {
  content: '';
  position: absolute;
  bottom: -12px;
  left: 50%;
  transform: translateX(-50%);
  width: 6px;
  height: 6px;
  background: var(--primary-color);
  border-radius: 50%;
  box-shadow: 0 0 8px var(--primary-color);
}

.cart-icon {
  position: relative;
  font-size: 22px;
  padding: 8px 12px;
  transition: var(--transition);
  border-radius: var(--radius-xs);
  cursor: pointer;
}

.cart-icon:hover {
  transform: scale(1.15) rotate(-5deg);
  background: linear-gradient(135deg, rgba(212, 175, 55, 0.1), rgba(200, 22, 29, 0.06));
}

.cart-badge {
  position: absolute;
  top: 2px;
  right: 2px;
  background: var(--gradient-primary);
  color: white;
  font-size: 11px;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 10px;
  min-width: 18px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(200, 22, 29, 0.35);
  animation: pulse 2s ease-in-out infinite;
}

.login-btn {
  padding: 9px 22px !important;
  font-size: 14px !important;
  border-radius: var(--radius-sm) !important;
  letter-spacing: 2px;
}

.user-avatar {
  margin-left: 8px;
  position: relative;
  cursor: pointer;
}

.user-avatar img {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid transparent;
  background: linear-gradient(white, white) padding-box,
              linear-gradient(135deg, var(--primary-color), var(--secondary-color)) border-box;
  transition: var(--transition-slow);
  position: relative;
  z-index: 2;
}

.user-avatar:hover img {
  transform: scale(1.08);
  box-shadow: 0 4px 16px rgba(200, 22, 29, 0.3);
}

.avatar-ring {
  position: absolute;
  top: -3px;
  left: -3px;
  right: -3px;
  bottom: -3px;
  border-radius: 50%;
  border: 2px solid transparent;
  border-top-color: var(--primary-color);
  border-right-color: var(--secondary-color);
  animation: avatarSpin 3s linear infinite;
  z-index: 1;
}

@keyframes avatarSpin {
  to { transform: rotate(360deg); }
}

@media (max-width: 1024px) {
  .nav-item .nav-text {
    display: none;
  }

  .nav-item {
    padding: 10px 12px;
  }

  .logo span:not(.logo-icon) {
    display: none;
  }
}

@media (max-width: 768px) {
  .container {
    flex-direction: column;
    height: auto;
    padding: 16px 20px;
    gap: 12px;
  }

  .header-decoration {
    display: none;
  }

  .nav {
    flex-wrap: wrap;
    justify-content: center;
    gap: 6px;
    width: 100%;
  }

  .nav-item {
    font-size: 13px;
    padding: 8px 12px;
  }

  .nav-item .nav-text {
    display: inline;
  }

  .user-avatar {
    margin-left: 0;
  }
}
</style>
