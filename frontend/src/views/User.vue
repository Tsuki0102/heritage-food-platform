<template>
  <div class="user-page">
    <Header />

    <!-- 顶部横幅 -->
    <BannerSection
      title="个人中心"
      subtitle="管理您的账户、订单、收藏和个人设置"
      badge-icon="👤"
      badge="用户中心"
    />

    <div class="container">
      <div class="user-content">

        <!-- 用户信息卡片 -->
        <template v-if="isLoggedIn">
          <div class="profile-card">
            <div class="profile-header">
              <div class="avatar-section">
                <div class="avatar-wrapper">
                  <img :src="userStore.userAvatar || '/images/avatar1.jpg'" :alt="user.nickname || '用户'" />
                  <span class="online-status"></span>
                </div>
                <div class="user-details">
                  <h2 class="username">{{ user.nickname || '美食爱好者' }}</h2>
                  <p class="phone">{{ user.phone || '未绑定手机号' }}</p>
                  <div class="user-badges">
                    <span class="badge vip-badge">
                      <span class="badge-icon">👑</span>
                      VIP会员
                    </span>
                    <span class="badge level-badge">
                      <span class="badge-icon">⭐</span>
                      Lv.{{ user.level || 5 }}
                    </span>
                  </div>
                </div>
              </div>

              <div class="profile-stats">
                <div class="stat-item">
                  <div class="stat-value">{{ user.orderCount || 12 }}</div>
                  <div class="stat-label">订单</div>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item">
                  <div class="stat-value">{{ user.collectionCount || 28 }}</div>
                  <div class="stat-label">收藏</div>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item">
                  <div class="stat-value">{{ user.commentCount || 56 }}</div>
                  <div class="stat-label">评价</div>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item">
                  <div class="stat-value">¥{{ user.totalSpent || 1280 }}</div>
                  <div class="stat-label">消费</div>
                </div>
              </div>
            </div>
          </div>
        </template>

        <!-- 未登录状态 -->
        <template v-else>
          <div class="guest-card">
            <div class="guest-content">
              <div class="guest-avatar">
                <span>👤</span>
              </div>
              <h3 class="guest-title">欢迎来到非遗美食文化平台</h3>
              <p class="guest-subtitle">登录后享受更多专属权益和服务</p>
              <button class="login-btn btn-primary" @click="toLogin">
                <span class="btn-icon">🚀</span>
                立即登录 / 注册
              </button>
            </div>
          </div>
        </template>

        <!-- 功能菜单区域 -->
        <div class="menu-section">

          <!-- 主要功能 -->
          <div class="menu-group">
            <div class="group-header">
              <h3 class="group-title">
                <span class="header-icon">📋</span>
                我的业务
              </h3>
            </div>
            <div class="menu-list">
              <router-link to="/user/orders" class="menu-item">
                <div class="item-left">
                  <span class="item-icon">📦</span>
                  <span class="item-text">我的订单</span>
                </div>
                <div class="item-right">
                  <span class="item-count" v-if="user.pendingOrders">{{ user.pendingOrders }}待处理</span>
                  <span class="arrow">›</span>
                </div>
              </router-link>

              <router-link to="/user/collections" class="menu-item">
                <div class="item-left">
                  <span class="item-icon">❤️</span>
                  <span class="item-text">我的收藏</span>
                </div>
                <div class="item-right">
                  <span class="arrow">›</span>
                </div>
              </router-link>

              <router-link to="/user/comments" class="menu-item">
                <div class="item-left">
                  <span class="item-icon">�</span>
                  <span class="item-text">我的评价</span>
                </div>
                <div class="item-right">
                  <span class="arrow">›</span>
                </div>
              </router-link>

              <router-link to="/user/history" class="menu-item">
                <div class="item-left">
                  <span class="item-icon">👣</span>
                  <span class="item-text">浏览足迹</span>
                </div>
                <div class="item-right">
                  <span class="arrow">›</span>
                </div>
              </router-link>

              <router-link to="/user/posts" class="menu-item">
                <div class="item-left">
                  <span class="item-icon">✍️</span>
                  <span class="item-text">我的发布</span>
                </div>
                <div class="item-right">
                  <span class="item-count" v-if="user.postCount">{{ user.postCount }}篇</span>
                  <span class="arrow">›</span>
                </div>
              </router-link>

              <router-link v-if="userStore.hasMerchantRole" to="/merchant/dashboard" class="menu-item">
                <div class="item-left">
                  <span class="item-icon">🏪</span>
                  <span class="item-text">商家中心</span>
                </div>
                <div class="item-right">
                  <span class="arrow">›</span>
                </div>
              </router-link>
            </div>
          </div>

          <!-- 设置与帮助 -->
          <div class="menu-group">
            <div class="group-header">
              <h3 class="group-title">
                <span class="header-icon">⚙️</span>
                设置与服务
              </h3>
            </div>
            <div class="menu-list">
              <router-link to="/user/profile" class="menu-item">
                <div class="item-left">
                  <span class="item-icon">👤</span>
                  <span class="item-text">个人资料</span>
                </div>
                <div class="item-right">
                  <span class="arrow">›</span>
                </div>
              </router-link>

              <router-link to="/user/settings" class="menu-item">
                <div class="item-left">
                  <span class="item-icon">🔧</span>
                  <span class="item-text">账号设置</span>
                </div>
                <div class="item-right">
                  <span class="arrow">›</span>
                </div>
              </router-link>

              <router-link to="/user/address" class="menu-item">
                <div class="item-left">
                  <span class="item-icon">📍</span>
                  <span class="item-text">收货地址</span>
                </div>
                <div class="item-right">
                  <span class="arrow">›</span>
                </div>
              </router-link>

              <router-link to="/user/help" class="menu-item">
                <div class="item-left">
                  <span class="item-icon">❓</span>
                  <span class="item-text">帮助中心</span>
                </div>
                <div class="item-right">
                  <span class="arrow">›</span>
                </div>
              </router-link>

              <router-link to="/user/about" class="menu-item">
                <div class="item-left">
                  <span class="item-icon">ℹ️</span>
                  <span class="item-text">关于我们</span>
                </div>
                <div class="item-right">
                  <span class="arrow">›</span>
                </div>
              </router-link>

              <router-link to="/admin" class="menu-item admin-item" v-if="userStore.user?.isAdmin === 1">
                <div class="item-left">
                  <span class="item-icon">🛠️</span>
                  <span class="item-text">进入后台管理</span>
                </div>
                <div class="item-right">
                  <span class="arrow admin-arrow">›</span>
                </div>
              </router-link>
            </div>
          </div>

          <!-- 退出登录按钮 -->
          <button class="logout-btn" v-if="isLoggedIn" @click="logout">
            <span class="btn-icon">🚪</span>
            退出登录
          </button>

        </div>

        <!-- 底部文化展示 -->
        <div class="culture-footer">
          <div class="culture-quote">
            <span class="quote-mark">"</span>
            <p>民以食为天，食以味为先</p>
            <span class="quote-author">—— 中国古谚</span>
          </div>
        </div>

      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/userStore'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'

const router = useRouter()
const userStore = useUserStore()
const user = ref<any>({})
const isLoggedIn = ref(false)

onMounted(() => {
  userStore.loadUser()
  if (userStore.user) {
    user.value = userStore.user
    isLoggedIn.value = true
    // 检查是否为管理员手机号
    if (userStore.user.phone === '13800138000' && userStore.user.isAdmin !== 1) {
      userStore.updateUserInfo({ isAdmin: 1 })
    }
  }
})

const toLogin = () => {
  router.push('/login')
}

const logout = () => {
  if (confirm('确定要退出登录吗？')) {
    userStore.logout()
    user.value = {}
    isLoggedIn.value = false
  }
}
</script>

<style scoped>
.user-page {
  min-height: 100vh;
  background: var(--gradient-bg);
  position: relative;
  overflow-x: hidden;
}

.container {
  max-width: 960px;
  margin: 0 auto;
  padding: 0 24px;
}

.user-content {
  margin: 40px 0 60px;
  display: flex;
  flex-direction: column;
  gap: 28px;
}

/* ====== 用户信息卡片 ====== */
.profile-card,
.guest-card {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  position: relative;
  overflow: hidden;
}

.profile-card::before,
.guest-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 5px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

/* 已登录状态 - 用户信息 */
.profile-header {
  padding: 32px;
  display: flex;
  align-items: center;
  gap: 24px;
  background: linear-gradient(135deg, rgba(200,22,29,0.03), rgba(212,175,55,0.03));
}

.avatar-section {
  flex-shrink: 0;
}

.avatar-wrapper {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  border: 4px solid var(--secondary-color);
  padding: 3px;
  background: white;
  position: relative;
  box-shadow: 0 8px 24px rgba(212, 175, 55, 0.25);
  transition: all 0.3s ease;
}

.avatar-wrapper:hover {
  transform: scale(1.08) rotate(3deg);
  box-shadow: 0 12px 32px rgba(212, 175, 55, 0.35);
}

.avatar-wrapper img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 50%;
}

.online-status {
  position: absolute;
  bottom: 6px;
  right: 6px;
  width: 16px;
  height: 16px;
  background: #52c41a;
  border: 3px solid white;
  border-radius: 50%;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.7; transform: scale(1.1); }
}

.user-details {
  flex: 1;
}

.username {
  font-size: 26px;
  color: var(--text-color);
  margin-bottom: 8px;
  font-weight: 800;
  letter-spacing: 1px;
}

.phone {
  font-size: 15px;
  color: var(--text-light);
  margin-bottom: 14px;
  font-weight: 500;
}

.user-badges {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.badge-icon { font-size: 14px; }

.vip-badge {
  background: linear-gradient(135deg, var(--secondary-color), #d4a520);
  color: white;
  box-shadow: 0 4px 12px rgba(212, 175, 55, 0.3);
}

.level-badge {
  background: linear-gradient(135deg, rgba(200,22,29,0.08), rgba(212,175,55,0.08));
  color: var(--primary-color);
  border: 1.5px solid var(--border-gold);
}

/* 统计数据 */
.profile-stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 0;
  padding: 24px 32px;
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
  border-top: 1.5px solid rgba(212, 175, 55, 0.2);
}

.stat-item {
  text-align: center;
  padding: 16px 10px;
  transition: all 0.3s ease;
}

.stat-item:hover {
  background: rgba(200, 22, 29, 0.04);
  border-radius: var(--radius-sm);
}

.stat-value {
  font-size: 26px;
  font-weight: 800;
  color: var(--primary-color);
  margin-bottom: 6px;
  letter-spacing: 0.5px;
}

.stat-label {
  font-size: 14px;
  color: var(--text-light);
  font-weight: 500;
}

.stat-divider {
  width: 1px;
  background: linear-gradient(180deg, transparent, var(--border-gold), transparent);
  margin: auto 0;
}

/* 未登录状态 */
.guest-card {
  padding: 60px 40px;
  text-align: center;
}

.guest-content {
  max-width: 450px;
  margin: 0 auto;
}

.guest-avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--bg-color), var(--border-color));
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 24px;
  font-size: 48px;
  animation: float 3s ease-in-out infinite;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-15px); }
}

.guest-title {
  font-size: 26px;
  color: var(--text-color);
  margin-bottom: 12px;
  font-weight: 700;
  letter-spacing: 2px;
}

.guest-subtitle {
  font-size: 15px;
  color: var(--text-light);
  margin-bottom: 32px;
  line-height: 1.6;
}

.login-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 16px 48px;
  font-size: 17px;
  font-weight: 700;
  letter-spacing: 2px;
  border-radius: var(--radius-xxl) !important;
  background: var(--gradient-primary) !important;
  color: #ffffff !important;
  border: none !important;
  box-shadow: var(--shadow-primary) !important;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.login-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.25), transparent);
  transition: left 0.5s ease;
}

.login-btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.03);
  box-shadow: 0 12px 32px rgba(200, 22, 29, 0.45), 0 0 40px rgba(212, 175, 55, 0.15) !important;
}

.login-btn:hover::before {
  left: 100%;
}

.login-btn:active:not(:disabled) {
  transform: translateY(-1px) scale(1);
}

.btn-icon { font-size: 18px; }

/* ====== 菜单区域 ====== */
.menu-section {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.menu-group {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  overflow: hidden;
  position: relative;
}

.menu-group::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  opacity: 0.6;
}

.group-header {
  padding: 20px 24px 16px;
  border-bottom: 1.5px dashed rgba(212, 175, 55, 0.25);
}

.group-title {
  font-size: 17px;
  color: var(--text-color);
  margin: 0;
  font-weight: 700;
  letter-spacing: 1px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-icon { font-size: 20px; }

.menu-list {
  display: flex;
  flex-direction: column;
}

.menu-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 24px;
  text-decoration: none;
  color: var(--text-color);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border-bottom: 1px solid rgba(212, 175, 55, 0.12);
  position: relative;
  overflow: hidden;
}

.menu-item:last-child {
  border-bottom: none;
}

.menu-item::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
  background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.menu-item:hover {
  background: linear-gradient(135deg, rgba(200,22,29,0.02), rgba(212,175,55,0.02));
  padding-left: 30px;
}

.menu-item:hover::before {
  opacity: 1;
}

.item-left {
  display: flex;
  align-items: center;
  gap: 14px;
}

.item-icon {
  font-size: 22px;
  transition: all 0.3s ease;
}

.menu-item:hover .item-icon {
  transform: scale(1.15) rotate(5deg);
}

.item-text {
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.item-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.item-count {
  font-size: 13px;
  color: var(--primary-color);
  background: linear-gradient(135deg, rgba(200,22,29,0.06), rgba(212,175,55,0.06));
  padding: 4px 12px;
  border-radius: 12px;
  font-weight: 600;
}

.arrow {
  font-size: 22px;
  color: var(--text-lighter);
  font-weight: 300;
  transition: all 0.3s ease;
}

.menu-item:hover .arrow {
  color: var(--primary-color);
  transform: translateX(4px);
}

/* 管理员特殊样式 */
.admin-item {
  background: linear-gradient(135deg, rgba(200,22,29,0.05), rgba(168,19,26,0.03)) !important;
  border-top: 2px solid var(--primary-color) !important;
  border-bottom: none !important;
}

.admin-item .item-text {
  color: var(--primary-color) !important;
  font-weight: 700 !important;
}

.admin-arrow {
  color: var(--primary-color) !important;
}

.admin-item:hover {
  background: linear-gradient(135deg, rgba(200,22,29,0.08), rgba(168,19,26,0.05)) !important;
}

/* 退出登录按钮 */
.logout-btn {
  width: 100%;
  padding: 16px 28px;
  background: white;
  color: var(--primary-color);
  border: 2px solid var(--primary-color);
  border-radius: var(--radius-lg);
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  letter-spacing: 1px;
  box-shadow: var(--shadow-md);
}

.logout-btn:hover {
  background: var(--gradient-primary);
  color: white;
  transform: translateY(-3px);
  box-shadow: 0 12px 28px rgba(200, 22, 29, 0.35);
}

/* 底部文化引用 */
.culture-footer {
  text-align: center;
  padding: 36px 20px;
  background: linear-gradient(135deg, rgba(200,22,29,0.02), rgba(212,175,55,0.02));
  border-radius: var(--radius-xl);
  border: 1px solid var(--border-gold);
}

.culture-quote {
  display: inline-block;
  padding: 24px 32px;
  background: white;
  border-radius: var(--radius-md);
  border-left: 4px solid var(--secondary-color);
  box-shadow: var(--shadow-sm);
}

.quote-mark {
  font-size: 36px;
  color: var(--secondary-color);
  line-height: 1;
  display: block;
  margin-bottom: 8px;
}

.culture-quote p {
  font-size: 18px;
  color: var(--text-color);
  font-style: italic;
  margin-bottom: 8px;
  font-weight: 500;
  letter-spacing: 1px;
}

.quote-author {
  font-size: 14px;
  color: var(--text-light);
  font-weight: 600;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .container {
    padding: 0 16px;
  }

  .profile-header {
    flex-direction: column;
    text-align: center;
    padding: 24px;
  }

  .avatar-wrapper {
    width: 80px;
    height: 80px;
  }

  .username {
    font-size: 22px;
  }

  .user-badges {
    justify-content: center;
  }

  .profile-stats {
    grid-template-columns: repeat(2, 1fr);
    gap: 0;
    padding: 20px;
  }

  .stat-divider {
    display: none;
  }

  .stat-item {
    border-right: 1px solid rgba(212, 175, 55, 0.2);
  }

  .stat-item:nth-child(even) {
    border-right: none;
  }

  .stat-item:nth-child(odd) {
    border-bottom: 1px solid rgba(212, 175, 55, 0.2);
  }

  .stat-value {
    font-size: 22px;
  }

  .guest-card {
    padding: 40px 24px;
  }

  .guest-title {
    font-size: 22px;
  }

  .login-btn {
    width: 100%;
    padding: 14px 28px;
  }

  .menu-item {
    padding: 14px 18px;
  }

  .item-icon {
    font-size: 20px;
  }

  .item-text {
    font-size: 15px;
  }
}
</style>
