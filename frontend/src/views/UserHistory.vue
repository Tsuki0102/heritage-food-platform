<template>
  <div class="user-history-page">
    <Header />

    <!-- 页面横幅 -->
    <BannerSection
      title="浏览足迹"
      subtitle="回顾您的浏览历史"
      badge-icon="👣"
      badge="足迹中心"
    />

    <div class="container">
      <!-- 已登录状态 -->
      <template v-if="userStore.isLoggedIn">
        <!-- 工具栏 -->
        <div class="toolbar" v-if="history.length > 0">
          <div class="toolbar-left">
            <span class="total-count">共 {{ getTotalRecords() }} 条记录</span>
          </div>
          <button class="clear-btn" @click="clearHistory">
            <span class="btn-icon">🗑️</span>
            清空历史
          </button>
        </div>

        <!-- 时间线列表 -->
        <div class="timeline-content">
          <template v-if="history.length > 0">
            <div v-for="(item, index) in history" :key="item.id" class="timeline-group">
              <!-- 时间标签 -->
              <div class="timeline-label">
                <div class="label-dot"></div>
                <div class="label-line" v-if="index !== history.length - 1"></div>
                <span class="label-text">{{ item.date }}</span>
                <span class="label-count">{{ item.records.length }}条记录</span>
              </div>

              <!-- 记录卡片组 -->
              <div class="timeline-records">
                <div
                  v-for="record in item.records"
                  :key="record.id"
                  class="record-card"
                >
                  <!-- 记录图片/头像 -->
                  <div class="record-image-area">
                    <div v-if="record.image && record.image.trim()" class="image-wrapper">
                      <img :src="record.image" :alt="record.name" />
                    </div>
                    <div v-else class="avatar-placeholder">
                      <span>{{ record.name.charAt(0) }}</span>
                    </div>
                    <span class="type-badge" :class="record.type === 'food' ? 'food-type' : 'store-type'">
                      {{ record.type === 'food' ? '🍽️' : '🏪' }}
                    </span>
                  </div>

                  <!-- 记录信息 -->
                  <div class="record-info">
                    <h4 class="record-name">{{ record.name }}</h4>
                    <p class="record-desc">{{ record.desc || '暂无描述' }}</p>
                    <div class="record-meta">
                      <span class="time-badge">
                        <span class="meta-icon">⏰</span>
                        {{ record.time }}
                      </span>
                    </div>
                  </div>

                  <!-- 查看按钮 -->
                  <router-link
                    :to="record.type === 'food' ? `/food/${record.id}` : `/store/${record.id}`"
                    class="view-btn btn-primary"
                  >
                    <span class="btn-icon">👁️</span>
                    查看
                  </router-link>
                </div>
              </div>
            </div>
          </template>

          <!-- 空状态 -->
          <div class="empty-state" v-else>
            <div class="empty-content">
              <div class="empty-icon">👣</div>
              <h3 class="empty-title">暂无浏览记录</h3>
              <p class="empty-desc">您还没有浏览过任何内容</p>
              <div class="action-buttons">
                <router-link to="/foodlist" class="explore-food-btn btn-primary">
                  <span class="btn-icon">🍽️</span>
                  探索美食
                </router-link>
                <router-link to="/map" class="explore-store-btn">
                  <span class="btn-icon">🗺️</span>
                  探索店铺
                </router-link>
              </div>
            </div>
          </div>
        </div>
      </template>

      <!-- 未登录状态 -->
      <template v-else>
        <div class="login-required">
          <div class="login-card">
            <div class="login-icon">🔒</div>
            <h3 class="login-title">请先登录</h3>
            <p class="login-desc">登录后可以查看和管理您的浏览记录</p>
            <router-link to="/login" class="login-btn btn-primary">
              <span class="btn-icon">🚀</span>
              立即登录
            </router-link>
          </div>
        </div>
      </template>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'
import { useUserDataStore } from '../stores/userDataStore'
import { useUserStore } from '../stores/userStore'

const userDataStore = useUserDataStore()
const userStore = useUserStore()

// 从userDataStore获取历史数据
const history = computed(() => userDataStore.history)

// 获取总记录数
const getTotalRecords = () => {
  return history.value.reduce((total, item) => total + item.records.length, 0)
}

const clearHistory = () => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再清空历史记录')
    return
  }

  if (confirm('确定要清空所有浏览记录吗？')) {
    userDataStore.clearHistory()
    alert('历史记录已清空')
  }
}

onMounted(() => {
  // 初始化数据
  userDataStore.$subscribe((mutation, state) => {
    console.log('UserDataStore changed:', mutation.type, state)
  })
})
</script>

<style scoped>
.user-history-page {
  min-height: 100vh;
  background: var(--gradient-bg);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 24px 60px;
}

/* ====== 工具栏 ====== */
.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 24px;
  background: var(--gradient-card);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  margin-bottom: 32px;
}

.toolbar-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.total-count {
  font-size: 15px;
  color: var(--text-light);
  font-weight: 600;
}

.clear-btn {
  padding: 10px 20px;
  background: white;
  color: #e74c3c;
  border: 2px solid #e74c3c;
  border-radius: var(--radius-sm);
  cursor: pointer;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  gap: 6px;
  letter-spacing: 0.5px;
}

.btn-icon { font-size: 16px; }

.clear-btn:hover {
  background: #e74c3c;
  color: white;
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 6px 16px rgba(231, 76, 60, 0.3);
}

/* ====== 时间线内容 ====== */
.timeline-content {
  display: flex;
  flex-direction: column;
  gap: 28px;
}

/* 时间线分组 */
.timeline-group {
  position: relative;
}

/* 时间标签 */
.timeline-label {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 18px;
  position: relative;
  padding-left: 36px;
}

.label-dot {
  position: absolute;
  left: 8px;
  top: 50%;
  transform: translateY(-50%);
  width: 16px;
  height: 16px;
  background: var(--secondary-color);
  border-radius: 50%;
  border: 4px solid white;
  box-shadow: 0 0 0 3px var(--secondary-color);
  z-index: 2;
}

.label-line {
  position: absolute;
  left: 15px;
  top: 100%;
  width: 2px;
  height: calc(100% + 18px);
  background: linear-gradient(180deg, var(--border-gold), transparent);
}

.label-text {
  font-size: 17px;
  color: var(--text-color);
  font-weight: 700;
  letter-spacing: 1px;
}

.label-count {
  font-size: 13px;
  color: var(--primary-color);
  background: linear-gradient(135deg, rgba(200,22,29,0.08), rgba(212,175,55,0.08));
  padding: 4px 12px;
  border-radius: 12px;
  font-weight: 600;
}

/* 记录卡片组 */
.timeline-records {
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding-left: 36px;
}

/* 记录卡片 */
.record-card {
  display: grid;
  grid-template-columns: 80px 1fr auto;
  gap: 20px;
  align-items: center;
  padding: 20px;
  background: var(--gradient-card);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--border-gold);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.record-card::before {
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

.record-card:hover {
  transform: translateX(8px);
  box-shadow: var(--shadow-md);
  border-color: var(--primary-color);
}

.record-card:hover::before {
  opacity: 1;
}

/* 图片区域 */
.record-image-area {
  width: 80px;
  height: 80px;
  position: relative;
  flex-shrink: 0;
}

.image-wrapper,
.avatar-placeholder {
  width: 100%;
  height: 100%;
  border-radius: var(--radius-md);
  overflow: hidden;
  border: 2px solid var(--border-gold);
  transition: all 0.3s ease;
}

.record-card:hover .image-wrapper,
.record-card:hover .avatar-placeholder {
  border-color: var(--primary-color);
  box-shadow: 0 6px 16px rgba(200, 22, 29, 0.15);
}

.image-wrapper img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: all 0.3s ease;
}

.record-card:hover .image-wrapper img {
  transform: scale(1.1);
}

.avatar-placeholder {
  background: linear-gradient(135deg, rgba(200,22,29,0.06), rgba(212,175,55,0.06));
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 32px;
  font-weight: 800;
  color: var(--primary-color);
}

.type-badge {
  position: absolute;
  bottom: -6px;
  right: -6px;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  border: 3px solid white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
}

.food-type {
  background: linear-gradient(135deg, var(--primary-color), #a8131a);
}

.store-type {
  background: linear-gradient(135deg, var(--secondary-color), #d4a520);
}

/* 信息区域 */
.record-info {
  min-width: 0;
}

.record-name {
  font-size: 16px;
  color: var(--text-color);
  margin-bottom: 6px;
  font-weight: 700;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.record-card:hover .record-name {
  color: var(--primary-color);
}

.record-desc {
  font-size: 14px;
  color: var(--text-light);
  margin-bottom: 8px;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.record-meta {
  display: flex;
  align-items: center;
  gap: 8px;
}

.time-badge {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 12px;
  color: var(--text-lighter);
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
  padding: 4px 10px;
  border-radius: 12px;
  border: 1px solid var(--border-gold);
  font-weight: 500;
}

.meta-icon { font-size: 13px; }

/* 查看按钮 */
.view-btn {
  padding: 11px 24px;
  font-size: 14px;
  font-weight: 600;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  letter-spacing: 0.5px;
  white-space: nowrap;
}

.view-btn:hover:not(:disabled) {
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.35);
}

.explore-store-btn {
  padding: 16px 36px;
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 1px;
  border-radius: var(--radius-sm);
  text-decoration: none;
  background: white;
  color: var(--text-color);
  border: 2px solid var(--border-gold);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.explore-store-btn:hover {
  border-color: var(--secondary-color);
  color: var(--secondary-color);
  background: linear-gradient(135deg, rgba(212,175,55,0.04), rgba(212,175,55,0.02));
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 12px 28px rgba(212, 175, 55, 0.25);
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 80px 20px;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
}

.empty-content {
  max-width: 500px;
  margin: 0 auto;
}

.empty-icon {
  font-size: 80px;
  margin-bottom: 24px;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-20px); }
}

.empty-title {
  font-size: 26px;
  color: var(--text-color);
  margin-bottom: 12px;
  font-weight: 700;
  letter-spacing: 2px;
}

.empty-desc {
  font-size: 16px;
  color: var(--text-light);
  margin-bottom: 32px;
  line-height: 1.6;
}

.action-buttons {
  display: flex;
  gap: 16px;
  justify-content: center;
  flex-wrap: wrap;
}

.explore-food-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 16px 36px;
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 1px;
  border-radius: var(--radius-sm);
  text-decoration: none;
}

.explore-food-btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 12px 28px rgba(200, 22, 29, 0.4);
}

/* 登录提示 */
.login-required {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 500px;
}

.login-card {
  text-align: center;
  padding: 60px 48px;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  max-width: 500px;
}

.login-icon {
  font-size: 80px;
  margin-bottom: 24px;
  animation: lockPulse 2s ease-in-out infinite;
}

@keyframes lockPulse {
  0%, 100% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.1); opacity: 0.8; }
}

.login-title {
  font-size: 26px;
  color: var(--text-color);
  margin-bottom: 12px;
  font-weight: 700;
  letter-spacing: 2px;
}

.login-desc {
  font-size: 16px;
  color: var(--text-light);
  margin-bottom: 36px;
  line-height: 1.6;
}

.login-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 16px 40px;
  font-size: 17px;
  font-weight: 700;
  letter-spacing: 1px;
  border-radius: var(--radius-sm);
  text-decoration: none;
}

.login-btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 12px 28px rgba(200, 22, 29, 0.4);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .container {
    padding: 30px 16px 50px;
  }

  .toolbar {
    flex-direction: column;
    gap: 14px;
    padding: 16px 20px;
  }

  .toolbar-left {
    width: 100%;
    justify-content: center;
  }

  .clear-btn {
    width: 100%;
    justify-content: center;
  }

  .timeline-label {
    padding-left: 28px;
  }

  .label-dot {
    left: 4px;
    width: 14px;
    height: 14px;
  }

  .label-line {
    left: 11px;
  }

  .timeline-records {
    padding-left: 28px;
  }

  .record-card {
    grid-template-columns: 60px 1fr;
    gap: 14px;
    padding: 16px;
  }

  .record-image-area {
    width: 60px;
    height: 60px;
  }

  .image-wrapper,
  .avatar-placeholder {
    border-radius: var(--radius-sm);
  }

  .avatar-placeholder {
    font-size: 24px;
  }

  .type-badge {
    width: 24px;
    height: 24px;
    font-size: 12px;
    bottom: -4px;
    right: -4px;
  }

  .view-btn {
    grid-column: 1 / -1;
    width: 100%;
    justify-content: center;
  }

  .record-name {
    font-size: 15px;
  }

  .record-desc {
    font-size: 13px;
  }

  .login-card {
    padding: 40px 28px;
  }

  .login-icon {
    font-size: 60px;
  }

  .empty-icon {
    font-size: 60px;
  }

  .empty-title {
    font-size: 22px;
  }

  .action-buttons {
    flex-direction: column;
  }

  .explore-food-btn,
  .explore-store-btn {
    width: 100%;
  }
}
</style>
