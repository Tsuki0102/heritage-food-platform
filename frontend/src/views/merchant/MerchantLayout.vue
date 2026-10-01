<template>
  <div class="merchant-layout">
    <aside class="merchant-sidebar">
      <div class="brand">
        <div class="brand-icon">商</div>
        <div>
          <h1>商家中心</h1>
          <p>{{ merchantStore.profile.storeName }}</p>
        </div>
      </div>

      <nav class="menu">
        <router-link v-for="item in menuItems" :key="item.to" :to="item.to" class="menu-item">
          <span class="menu-icon">{{ item.icon }}</span>
          <span>{{ item.label }}</span>
        </router-link>
      </nav>

      <div class="sidebar-footer">
        <router-link to="/user" class="link-btn">返回个人中心</router-link>
      </div>
    </aside>

    <div class="merchant-main">
      <header class="merchant-header">
        <div>
          <h2>{{ currentTitle }}</h2>
          <p>管理商品、文化内容、经营结算和商家资料。</p>
        </div>

        <div class="header-user">
          <div class="status-pill" :class="merchantStore.profile.storeStatus">
            {{ storeStatusText }}
          </div>
          <img :src="userStore.userAvatar" :alt="userStore.user?.nickname || '商家'" class="header-avatar" />
          <div>
            <strong>{{ userStore.user?.nickname || '商家用户' }}</strong>
            <p>{{ userStore.user?.phone || '未绑定手机号' }}</p>
          </div>
        </div>
      </header>

      <main class="merchant-content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useUserStore } from '../../stores/userStore'
import { useMerchantWorkbenchStore } from '../../stores/merchantWorkbenchStore'

const route = useRoute()
const userStore = useUserStore()
const merchantStore = useMerchantWorkbenchStore()

const menuItems = [
  { to: '/merchant/dashboard', label: '工作台', icon: '台' },
  { to: '/merchant/products', label: '商品管理', icon: '品' },
  { to: '/merchant/content', label: '内容管理', icon: '文' },
  { to: '/merchant/finance', label: '经营结算', icon: '账' },
  { to: '/merchant/profile', label: '商家资料', icon: '店' }
]

const titleMap: Record<string, string> = {
  merchantDashboard: '商家工作台',
  merchantProducts: '商品管理',
  merchantContent: '内容管理',
  merchantFinance: '经营结算',
  merchantProfile: '商家资料'
}

const currentTitle = computed(() => titleMap[String(route.name)] || '商家中心')

const storeStatusText = computed(() => {
  if (merchantStore.profile.storeStatus === 'banned') {
    return '店铺已封禁'
  }
  if (merchantStore.profile.storeStatus === 'limited') {
    return '店铺已限流'
  }
  return '店铺经营正常'
})

onMounted(async () => {
  await merchantStore.initialize()
})
</script>

<style scoped>
.merchant-layout {
  min-height: 100vh;
  display: grid;
  grid-template-columns: 260px minmax(0, 1fr);
  background:
    radial-gradient(circle at top right, rgba(200, 22, 29, 0.08), transparent 30%),
    linear-gradient(180deg, #faf6ef 0%, #f7f1e7 100%);
}

.merchant-sidebar {
  padding: 24px 18px;
  background: rgba(55, 32, 20, 0.96);
  color: #f8efe3;
  display: flex;
  flex-direction: column;
  gap: 24px;
  position: sticky;
  top: 0;
  height: 100vh;
}

.brand {
  display: flex;
  align-items: center;
  gap: 14px;
}

.brand-icon {
  width: 48px;
  height: 48px;
  border-radius: 16px;
  background: linear-gradient(135deg, #f0b24b, #c8161d);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-weight: 700;
  color: #fff;
}

.brand h1 {
  margin: 0 0 4px;
  font-size: 22px;
}

.brand p {
  margin: 0;
  font-size: 13px;
  color: rgba(248, 239, 227, 0.72);
}

.menu {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.menu-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 16px;
  border-radius: 14px;
  text-decoration: none;
  color: rgba(248, 239, 227, 0.88);
  transition: background 0.2s ease, transform 0.2s ease, color 0.2s ease;
}

.menu-item:hover,
.menu-item.router-link-active {
  background: rgba(255, 255, 255, 0.12);
  color: #fff;
  transform: translateX(2px);
}

.menu-icon {
  width: 28px;
  height: 28px;
  border-radius: 10px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.12);
  font-size: 13px;
}

.sidebar-footer {
  margin-top: auto;
}

.link-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 12px 16px;
  border-radius: 12px;
  text-decoration: none;
  color: #fff;
  background: rgba(255, 255, 255, 0.08);
}

.merchant-main {
  min-width: 0;
  padding: 24px;
}

.merchant-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  padding: 22px 26px;
  border-radius: 22px;
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid rgba(199, 155, 74, 0.18);
  box-shadow: 0 18px 40px rgba(92, 55, 20, 0.08);
}

.merchant-header h2 {
  margin: 0 0 6px;
  font-size: 24px;
  color: #2f2418;
}

.merchant-header p {
  margin: 0;
  color: #7f6b59;
}

.header-user {
  display: flex;
  align-items: center;
  gap: 12px;
}

.status-pill {
  padding: 8px 12px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 700;
}

.status-pill.active {
  background: #e7f8ee;
  color: #1f8f52;
}

.status-pill.limited {
  background: #fff4dc;
  color: #b76a08;
}

.status-pill.banned {
  background: #fdeceb;
  color: #c5443d;
}

.header-avatar {
  width: 46px;
  height: 46px;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid rgba(199, 155, 74, 0.2);
}

.header-user strong {
  display: block;
  color: #2f2418;
}

.header-user p {
  margin: 2px 0 0;
  font-size: 12px;
}

.merchant-content {
  margin-top: 22px;
}

@media (max-width: 980px) {
  .merchant-layout {
    grid-template-columns: 1fr;
  }

  .merchant-sidebar {
    position: static;
    height: auto;
  }
}

@media (max-width: 720px) {
  .merchant-main {
    padding: 16px;
  }

  .merchant-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .header-user {
    width: 100%;
    flex-wrap: wrap;
  }
}
</style>
