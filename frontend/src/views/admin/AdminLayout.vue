<template>
  <div class="admin-layout heritage-cloud-pattern">
    <aside class="admin-sidebar" :class="{ 'collapsed': adminStore.isSidebarCollapsed }">
      <div class="sidebar-heritage-decoration"></div>
      <div class="admin-logo heritage-meander-border">
        <div class="logo-seal-wrapper">
          <span class="heritage-seal logo-seal">❋</span>
        </div>
        <h1 v-if="!adminStore.isSidebarCollapsed" class="logo-title">
          <span class="logo-heritage-symbol">龍</span>
          <span class="logo-text">非遗美食</span>
          <span class="logo-subtitle">管理系统</span>
        </h1>
        <span v-else class="logo-icon-collapsed">❋</span>
      </div>

      <nav class="admin-menu">
        <div class="menu-section-label" v-if="!adminStore.isSidebarCollapsed">
          <span>导航菜单</span>
          <span class="menu-divider"></span>
        </div>

        <router-link to="/admin/dashboard" class="menu-item heritage-menu-item">
          <span class="menu-icon-wrapper">
            <span class="menu-icon">📊</span>
            <span class="icon-bg"></span>
          </span>
          <span class="menu-text" v-if="!adminStore.isSidebarCollapsed">仪表盘</span>
          <span class="menu-indicator"></span>
          <span class="menu-dot"></span>
        </router-link>

        <router-link to="/admin/users" class="menu-item heritage-menu-item">
          <span class="menu-icon-wrapper">
            <span class="menu-icon">👥</span>
            <span class="icon-bg"></span>
          </span>
          <span class="menu-text" v-if="!adminStore.isSidebarCollapsed">用户管理</span>
          <span class="menu-indicator"></span>
          <span class="menu-dot"></span>
        </router-link>

        <router-link to="/admin/roles" class="menu-item heritage-menu-item">
          <span class="menu-icon-wrapper">
            <span class="menu-icon">🔐</span>
            <span class="icon-bg"></span>
          </span>
          <span class="menu-text" v-if="!adminStore.isSidebarCollapsed">角色管理</span>
          <span class="menu-indicator"></span>
          <span class="menu-dot"></span>
        </router-link>

        <router-link to="/admin/permissions" class="menu-item heritage-menu-item">
          <span class="menu-icon-wrapper">
            <span class="menu-icon">🔑</span>
            <span class="icon-bg"></span>
          </span>
          <span class="menu-text" v-if="!adminStore.isSidebarCollapsed">权限管理</span>
          <span class="menu-indicator"></span>
          <span class="menu-dot"></span>
        </router-link>

        <router-link to="/admin/statistics" class="menu-item heritage-menu-item">
          <span class="menu-icon-wrapper">
            <span class="menu-icon">📈</span>
            <span class="icon-bg"></span>
          </span>
          <span class="menu-text" v-if="!adminStore.isSidebarCollapsed">数据统计</span>
          <span class="menu-indicator"></span>
          <span class="menu-dot"></span>
        </router-link>

        <router-link to="/admin/settings" class="menu-item heritage-menu-item">
          <span class="menu-icon-wrapper">
            <span class="menu-icon">⚙️</span>
            <span class="icon-bg"></span>
          </span>
          <span class="menu-text" v-if="!adminStore.isSidebarCollapsed">系统配置</span>
          <span class="menu-indicator"></span>
          <span class="menu-dot"></span>
        </router-link>
      </nav>

      <div class="sidebar-footer" v-if="!adminStore.isSidebarCollapsed">
        <div class="footer-heritage-line"></div>
        <div class="footer-content">
          <span class="heritage-badge">🏮</span>
          <div class="footer-info">
            <span class="footer-text">中华非遗美食文化</span>
            <span class="footer-slogan">传承千年 · 匠心独运</span>
          </div>
          <span class="footer-version">v1.4.0</span>
        </div>
      </div>
    </aside>

    <div class="admin-content" :class="{ 'sidebar-collapsed': adminStore.isSidebarCollapsed }">
      <header class="admin-header gold-shimmer-border">
        <div class="header-left">
          <button class="sidebar-toggle" @click="toggleSidebar" title="切换侧边栏">
            <span class="toggle-icon">{{ adminStore.isSidebarCollapsed ? '☰' : '☰' }}</span>
            <span class="toggle-ring"></span>
          </button>
          <div class="breadcrumb-wrapper">
            <h2 class="page-title">{{ currentTitle }}</h2>
            <nav class="breadcrumb-nav">
              <span class="breadcrumb-item">
                <span class="breadcrumb-icon">🏠</span>
                后台管理
              </span>
              <span class="breadcrumb-separator heritage-divider-mini">/</span>
              <span class="breadcrumb-item active">{{ currentTitle }}</span>
            </nav>
          </div>
        </div>

        <div class="header-right">
          <div class="header-time-display">
            <span class="time-icon">🕐</span>
            <span class="current-time">{{ currentTime }}</span>
          </div>

          <div class="user-info-card heritage-corner-decoration">
            <div class="user-avatar-small">
              <img
                :src="userStore.user?.avatar || '/images/avatar1.jpg'"
                alt=""
                @error="(e: Event) => (e.target as HTMLImageElement).src = '/images/avatar1.jpg'"
              />
              <span class="avatar-status-online"></span>
            </div>
            <span class="user-name">{{ userStore.user?.nickname || '管理员' }}</span>
            <span class="user-role-badge">管理员</span>
          </div>

          <button class="logout-btn" @click="logout" title="退出登录">
            <span class="logout-icon">🚪</span>
            <span class="logout-text">退出</span>
          </button>
        </div>
      </header>

      <main class="admin-main">
        <router-view v-slot="{ Component }">
          <transition name="page-fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, onMounted, onUnmounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../../stores/userStore'
import { useAdminStore } from '../../stores/admin/adminStore'

const userStore = useUserStore()
const adminStore = useAdminStore()
const router = useRouter()

const currentTime = ref('')
let timeInterval: number | null = null

const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleTimeString('zh-CN', {
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false
  })
}

const currentTitle = computed(() => {
  const routeName = router.currentRoute.value.name as string
  const titleMap: Record<string, string> = {
    adminDashboard: '仪表盘',
    adminUsers: '用户管理',
    adminRoles: '角色管理',
    adminPermissions: '权限管理',
    adminStatistics: '数据统计',
    adminSettings: '系统配置'
  }
  return titleMap[routeName] || '后台管理'
})

const toggleSidebar = () => {
  adminStore.toggleSidebar()
}

const logout = () => {
  userStore.logout()
  router.push('/login')
}

const updateBreadcrumbs = () => {
  const route = router.currentRoute.value
  const breadcrumbs = [{ name: '后台管理', path: '/admin' }]
  
  if (route.name === 'adminDashboard') {
    breadcrumbs.push({ name: '仪表盘', path: '/admin/dashboard' })
  } else if (route.name === 'adminUsers') {
    breadcrumbs.push({ name: '用户管理', path: '/admin/users' })
  } else if (route.name === 'adminRoles') {
    breadcrumbs.push({ name: '角色管理', path: '/admin/roles' })
  } else if (route.name === 'adminPermissions') {
    breadcrumbs.push({ name: '权限管理', path: '/admin/permissions' })
  } else if (route.name === 'adminStatistics') {
    breadcrumbs.push({ name: '数据统计', path: '/admin/statistics' })
  } else if (route.name === 'adminSettings') {
    breadcrumbs.push({ name: '系统配置', path: '/admin/settings' })
  }
  
  adminStore.setBreadcrumbs(breadcrumbs)
}

onMounted(() => {
  adminStore.setCurrentRoute(router.currentRoute.value.name as string)
  updateBreadcrumbs()
  updateTime()
  timeInterval = window.setInterval(updateTime, 1000)
})

onUnmounted(() => {
  if (timeInterval) {
    clearInterval(timeInterval)
  }
})

watch(
  () => router.currentRoute.value,
  () => {
    adminStore.setCurrentRoute(router.currentRoute.value.name as string)
    updateBreadcrumbs()
  },
  { immediate: true }
)
</script>

<style scoped>
.admin-layout {
  display: flex;
  min-height: 100vh;
  background: var(--admin-bg);
  background-image:
    radial-gradient(circle at 10% 20%, rgba(200, 22, 29, 0.03) 0%, transparent 20%),
    radial-gradient(circle at 90% 80%, rgba(212, 175, 55, 0.04) 0%, transparent 20%);
  background-attachment: fixed;
  position: relative;
  overflow-x: hidden;
}

/* ====== 侧边栏 - 深度融入非遗文化 ====== */
.admin-sidebar {
  width: 280px;
  background:
    linear-gradient(180deg,
      rgba(26, 10, 10, 0.98) 0%,
      rgba(45, 21, 21, 0.97) 30%,
      rgba(26, 22, 20, 0.98) 70%,
      rgba(20, 15, 12, 0.99) 100%
    );
  box-shadow:
    6px 0 24px rgba(0, 0, 0, 0.3),
    inset -1px 0 0 rgba(212, 175, 55, 0.08);
  padding: 0;
  position: fixed;
  height: 100vh;
  overflow-y: auto;
  overflow-x: hidden;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  z-index: 1000;
  display: flex;
  flex-direction: column;
}

.sidebar-heritage-decoration {
  position: absolute;
  top: 50%;
  right: 8px;
  transform: translateY(-50%);
  width: 3px;
  height: 60%;
  background: linear-gradient(
    180deg,
    transparent 0%,
    rgba(212, 175, 55, 0.15) 20%,
    rgba(200, 22, 29, 0.25) 50%,
    rgba(212, 175, 55, 0.15) 80%,
    transparent 100%
  );
  border-radius: 2px;
  pointer-events: none;
}

.admin-sidebar::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 180px;
  background:
    radial-gradient(ellipse at 50% 0%, rgba(200, 22, 29, 0.08) 0%, transparent 70%),
    radial-gradient(circle at 80% 40%, rgba(212, 175, 55, 0.05) 0%, transparent 50%);
  pointer-events: none;
}

.admin-sidebar.collapsed {
  width: 80px;
}

/* Logo区域 - 传统印章风格 */
.admin-logo {
  padding: 28px 20px 32px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  min-height: 120px;
  background:
    linear-gradient(135deg, rgba(200, 22, 29, 0.06) 0%, transparent 50%),
    linear-gradient(225deg, rgba(212, 175, 55, 0.04) 0%, transparent 50%);
}

.logo-seal-wrapper {
  margin-right: 16px;
  animation: iconPulse 4s ease-in-out infinite;
}

.logo-seal {
  font-size: 28px !important;
  min-width: 52px;
  height: 52px;
  border-width: 2px !important;
}

.logo-title {
  font-size: 17px;
  color: #ffffff;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
  z-index: 1;
  animation: fadeInLeft 0.6s ease-out;
}

.logo-heritage-symbol {
  font-size: 22px;
  color: var(--secondary-color);
  text-shadow: 0 0 12px rgba(212, 175, 55, 0.4);
  line-height: 1;
  letter-spacing: 2px;
}

.logo-text {
  font-size: 18px;
  font-weight: 800;
  letter-spacing: 3px;
  background: linear-gradient(90deg, #ffffff, #f5f5dc, #ffffff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.logo-subtitle {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.45);
  letter-spacing: 4px;
  font-weight: 400;
}

.logo-icon-collapsed {
  font-size: 28px;
  color: var(--secondary-color);
  animation: iconPulse 3s ease-in-out infinite;
}

.admin-sidebar.collapsed .admin-logo {
  padding: 24px 8px;
  min-height: 88px;
}

.admin-sidebar.collapsed .logo-title {
  display: none;
}

.admin-sidebar.collapsed .logo-seal-wrapper {
  margin-right: 0;
}

/* 菜单区域 */
.admin-menu {
  margin-top: 20px;
  flex: 1;
  padding: 8px 14px;
}

.menu-section-label {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 14px 12px;
  margin-bottom: 4px;
}

.menu-section-label span:first-child {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.3);
  text-transform: uppercase;
  letter-spacing: 2px;
  font-weight: 600;
}

.menu-divider {
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, rgba(212, 175, 55, 0.2), transparent);
}

/* 菜单项 - 非遗文化风格 */
.heritage-menu-item {
  display: flex;
  align-items: center;
  padding: 13px 16px;
  text-decoration: none;
  color: rgba(255, 255, 255, 0.6);
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: var(--radius-sm);
  margin-bottom: 4px;
  position: relative;
  gap: 12px;
  overflow: hidden;
}

.admin-sidebar.collapsed .heritage-menu-item {
  padding: 14px 0;
  justify-content: center;
  margin-bottom: 8px;
}

.menu-icon-wrapper {
  position: relative;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.menu-icon {
  font-size: 19px;
  z-index: 1;
  transition: all 0.35s ease;
  position: relative;
}

.icon-bg {
  position: absolute;
  inset: 0;
  border-radius: 10px;
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.1), rgba(212, 175, 55, 0.05));
  opacity: 0;
  transform: scale(0.7);
  transition: all 0.35s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

.heritage-menu-item:hover .icon-bg {
  opacity: 1;
  transform: scale(1);
}

.heritage-menu-item:hover .menu-icon {
  transform: scale(1.15) rotate(-5deg);
}

.menu-text {
  transition: all 0.3s ease;
  white-space: nowrap;
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.8px;
  position: relative;
  z-index: 1;
}

.admin-sidebar.collapsed .menu-text {
  display: none;
}

.menu-indicator {
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 0;
  background: linear-gradient(180deg, var(--secondary-color), var(--primary-color));
  border-radius: 0 3px 3px 0;
  transition: height 0.35s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  box-shadow: 0 0 8px rgba(212, 175, 55, 0.4);
}

.menu-dot {
  position: absolute;
  right: 14px;
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  transition: all 0.35s ease;
}

.admin-sidebar.collapsed .menu-dot {
  display: none;
}

.heritage-menu-item:hover {
  background: linear-gradient(90deg, rgba(255, 255, 255, 0.07), transparent);
  color: #ffffff;
  transform: translateX(6px);
}

.heritage-menu-item:hover .menu-indicator {
  height: 50%;
}

.heritage-menu-item:hover .menu-dot {
  background: var(--secondary-color);
  box-shadow: 0 0 10px rgba(212, 175, 55, 0.5);
}

.heritage-menu-item.router-link-active {
  background:
    linear-gradient(90deg, rgba(200, 22, 29, 0.2), rgba(200, 22, 29, 0.05)),
    linear-gradient(270deg, rgba(212, 175, 55, 0.03), transparent);
  color: #ffffff;
  font-weight: 600;
  transform: translateX(6px);
  box-shadow:
    inset 3px 0 0 var(--primary-color),
    inset 0 0 20px rgba(200, 22, 29, 0.05);
}

.heritage-menu-item.router-link-active .menu-indicator {
  height: 65%;
  background: linear-gradient(180deg, var(--secondary-color), var(--primary-color), var(--secondary-color));
  animation: glow 2s ease-in-out infinite;
}

.heritage-menu-item.router-link-active .menu-dot {
  background: var(--secondary-color);
  box-shadow: 0 0 12px rgba(212, 175, 55, 0.6);
  animation: iconPulse 2s ease-in-out infinite;
}

.heritage-menu-item.router-link-active .icon-bg {
  opacity: 1;
  transform: scale(1);
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.2), rgba(212, 175, 55, 0.1));
}

/* 侧边栏底部 */
.sidebar-footer {
  padding: 20px 18px;
  border-top: 1px solid rgba(255, 255, 255, 0.06);
  background: rgba(0, 0, 0, 0.25);
  position: relative;
}

.footer-heritage-line {
  position: absolute;
  top: 0;
  left: 20px;
  right: 20px;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(212, 175, 55, 0.3), transparent);
}

.footer-content {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-top: 8px;
}

.heritage-badge {
  font-size: 22px;
  animation: iconPulse 3s ease-in-out infinite;
}

.footer-info {
  flex: 1;
}

.footer-text {
  display: block;
  color: rgba(255, 255, 255, 0.5);
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 1px;
}

.footer-slogan {
  display: block;
  color: rgba(212, 175, 55, 0.5);
  font-size: 10px;
  letter-spacing: 2px;
  margin-top: 2px;
}

.footer-version {
  color: rgba(212, 175, 55, 0.4);
  font-size: 10px;
  font-weight: 700;
  padding: 4px 8px;
  background: rgba(212, 175, 55, 0.08);
  border-radius: 10px;
  border: 1px solid rgba(212, 175, 55, 0.15);
}

/* ====== 主内容区 ====== */
.admin-content {
  flex: 1;
  margin-left: 280px;
  min-height: 100vh;
  transition: margin-left 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
}

.admin-content.sidebar-collapsed {
  margin-left: 80px;
}

/* Header - 金色装饰 */
.admin-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 32px;
  background:
    linear-gradient(135deg, rgba(255, 255, 255, 0.98) 0%, rgba(250, 245, 235, 0.98) 100%);
  box-shadow:
    0 2px 16px rgba(0, 0, 0, 0.06),
    0 1px 0 rgba(212, 175, 55, 0.1);
  position: sticky;
  top: 0;
  z-index: 999;
  backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(212, 175, 55, 0.12);
  animation: fadeInDown 0.5s ease-out;
}

.header-left {
  display: flex;
  align-items: center;
  gap: var(--spacing-lg);
}

.breadcrumb-wrapper {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.page-title {
  font-size: 22px;
  color: var(--admin-text-primary);
  margin: 0;
  font-weight: 800;
  letter-spacing: 1.5px;
  position: relative;
  display: inline-block;
}

.page-title::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 0;
  width: 40px;
  height: 3px;
  background: var(--gradient-imperial);
  border-radius: 2px;
  animation: shimmerMove 3s ease-in-out infinite;
}

.breadcrumb-nav {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
}

.breadcrumb-item {
  color: var(--admin-text-muted);
  display: flex;
  align-items: center;
  gap: 4px;
  transition: color 0.2s ease;
}

.breadcrumb-icon {
  font-size: 14px;
}

.breadcrumb-item.active {
  color: var(--primary-color);
  font-weight: 600;
}

.breadcrumb-separator {
  color: var(--admin-text-muted);
  opacity: 0.4;
  font-weight: 300;
}

/* 侧边栏切换按钮 */
.sidebar-toggle {
  background:
    linear-gradient(135deg, rgba(200, 22, 29, 0.06), rgba(212, 175, 55, 0.08));
  border: 1px solid rgba(200, 22, 29, 0.1);
  cursor: pointer;
  color: var(--admin-text-secondary);
  padding: 10px;
  border-radius: var(--radius-sm);
  transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  display: flex;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  position: relative;
  overflow: hidden;
}

.toggle-ring {
  position: absolute;
  inset: 0;
  border-radius: inherit;
  border: 2px solid transparent;
  transition: all 0.3s ease;
}

.sidebar-toggle:hover {
  background: var(--gradient-primary);
  color: white;
  transform: rotate(90deg) scale(1.1);
  box-shadow: var(--shadow-golden);
  border-color: transparent;
}

.sidebar-toggle:hover .toggle-ring {
  border-color: rgba(255, 255, 255, 0.3);
}

.toggle-icon {
  font-size: 18px;
  line-height: 1;
  z-index: 1;
}

.header-right {
  display: flex;
  align-items: center;
  gap: var(--spacing-lg);
}

.header-time-display {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.04), rgba(212, 175, 55, 0.04));
  border-radius: 20px;
  border: 1px solid rgba(212, 175, 55, 0.12);
  font-family: 'Courier New', monospace;
}

.time-icon {
  font-size: 16px;
}

.current-time {
  font-size: 14px;
  font-weight: 600;
  color: var(--admin-text-primary);
  letter-spacing: 1px;
}

.user-info-card {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 18px;
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.04), rgba(212, 175, 55, 0.04));
  border-radius: 26px;
  border: 1px solid var(--border-gold);
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  position: relative;
  overflow: hidden;
}

.user-info-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s ease;
}

.user-info-card:hover {
  box-shadow: var(--shadow-golden);
  transform: translateY(-3px);
  border-color: var(--primary-color);
}

.user-info-card:hover::before {
  left: 100%;
}

.user-avatar-small {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  overflow: hidden;
  border: 2px solid var(--secondary-color);
  flex-shrink: 0;
  position: relative;
  box-shadow: 0 2px 8px rgba(212, 175, 55, 0.2);
  transition: transform 0.3s ease;
}

.user-avatar-small img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-status-online {
  position: absolute;
  bottom: -1px;
  right: -1px;
  width: 10px;
  height: 10px;
  background: #52c41a;
  border: 2px solid white;
  border-radius: 50%;
  animation: iconPulse 2s ease-in-out infinite;
}

.user-info-card:hover .user-avatar-small {
  transform: scale(1.1) rotate(5deg);
}

.user-name {
  font-size: 13px;
  color: var(--admin-text-primary);
  font-weight: 700;
  letter-spacing: 0.5px;
}

.user-role-badge {
  font-size: 10px;
  color: var(--secondary-color);
  background: rgba(212, 175, 55, 0.12);
  padding: 2px 8px;
  border-radius: 10px;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.logout-btn {
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.08), rgba(200, 22, 29, 0.12));
  color: var(--primary-color);
  border: 1px solid rgba(200, 22, 29, 0.15);
  padding: 10px 22px;
  border-radius: 26px;
  cursor: pointer;
  font-size: 13px;
  transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 6px;
  letter-spacing: 0.8px;
  position: relative;
  overflow: hidden;
}

.logout-btn::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(200, 22, 29, 0.1);
  border-radius: 50%;
  transition: all 0.4s ease;
  transform: translate(-50%, -50%);
}

.logout-btn:hover {
  background: var(--gradient-primary);
  color: #fff;
  border-color: transparent;
  transform: translateY(-3px) scale(1.02);
  box-shadow: var(--shadow-golden);
}

.logout-btn:hover::after {
  width: 200px;
  height: 200px;
}

.logout-icon {
  font-size: 15px;
  z-index: 1;
  position: relative;
}

.logout-text {
  z-index: 1;
  position: relative;
}

/* 主内容区 */
.admin-main {
  padding: var(--spacing-xl);
  min-height: calc(100vh - 72px);
  flex: 1;
  position: relative;
}

/* 页面过渡动画 */
.page-fade-enter-active,
.page-fade-leave-active {
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
}

.page-fade-enter-from {
  opacity: 0;
  transform: translateY(15px);
}

.page-fade-leave-to {
  opacity: 0;
  transform: translateY(-15px);
}

/* ====== 响应式设计 ====== */
@media (max-width: 1024px) {
  .admin-sidebar { width: 240px; }
  .admin-content { margin-left: 240px; }
  .admin-sidebar.collapsed { width: 72px; }
  .admin-content.sidebar-collapsed { margin-left: 72px; }

  .page-title { font-size: 20px; }
  .header-time-display { display: none; }
}

@media (max-width: 768px) {
  .admin-sidebar {
    position: fixed;
    left: -280px;
    top: 0;
    height: 100vh;
    z-index: 1100;
    transition: left 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  }

  .admin-sidebar:not(.collapsed) { left: 0; }
  .admin-content { margin-left: 0 !important; }

  .admin-header {
    padding: 12px 16px;
    flex-wrap: wrap;
    gap: 10px;
  }

  .admin-main { padding: var(--spacing-md); }

  .header-right { gap: 8px; }

  .user-info-card { padding: 6px 12px; }
  .user-name, .user-role-badge, .logout-text { display: none; }
  .breadcrumb-nav { display: none; }

  .page-title { font-size: 18px; }
}

@media (max-width: 480px) {
  .admin-header { padding: 10px 12px; }
  .sidebar-toggle { width: 38px; height: 38px; padding: 8px; }
  .admin-main { padding: var(--spacing-sm); }
}
</style>