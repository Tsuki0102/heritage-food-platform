<template>
  <div class="user-collections-page">
    <Header />

    <!-- 页面横幅 -->
    <BannerSection
      title="我的收藏"
      subtitle="收藏您喜爱的美食和店铺"
      badge-icon="❤️"
      badge="收藏中心"
    />

    <div class="container">
      <!-- 已登录状态 -->
      <template v-if="userStore.isLoggedIn">
        <!-- 标签页导航 -->
        <div class="tabs-section">
          <div class="tabs-wrapper">
            <button
              v-for="tab in tabs"
              :key="tab.key"
              :class="['tab-item', { active: activeTab === tab.key }]"
              @click="activeTab = tab.key"
            >
              <span class="tab-icon">{{ tab.icon }}</span>
              <span class="tab-text">{{ tab.label }}</span>
            </button>
          </div>
        </div>

        <!-- 收藏列表 -->
        <div class="collections-content">
          <!-- 美食收藏 -->
          <template v-if="activeTab === 'foods'">
            <div class="items-grid" v-if="foodCollections.length > 0">
              <div
                v-for="item in foodCollections"
                :key="item.id"
                class="collection-card"
              >
                <!-- 卡片图片区域 -->
                <div class="card-image-area">
                  <div v-if="item.image && item.image.trim()" class="image-container">
                    <img :src="item.image" :alt="item.name" />
                    <div class="image-overlay">
                      <span class="overlay-text">查看详情 →</span>
                    </div>
                  </div>
                  <div v-else class="image-placeholder">
                    <span class="placeholder-text">{{ item.name.charAt(0) }}</span>
                  </div>
                  <span class="favorite-badge">❤️</span>
                </div>

                <!-- 卡片信息区域 -->
                <div class="card-info">
                  <h3 class="card-title">{{ item.name }}</h3>
                  <p class="card-desc">{{ item.desc || '暂无描述' }}</p>

                  <div class="card-actions">
                    <router-link :to="`/food/${item.id}`" class="btn-view btn-primary">
                      <span class="btn-icon">👁️</span>
                      查看详情
                    </router-link>
                    <button class="btn-remove" @click="removeCollection('food', item.id)">
                      <span class="btn-icon">💔</span>
                      取消收藏
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- 空状态 - 美食 -->
            <div class="empty-state" v-else>
              <div class="empty-content">
                <div class="empty-icon">🍽️</div>
                <h3 class="empty-title">暂无美食收藏</h3>
                <p class="empty-desc">去发现更多美味佳肴吧！</p>
                <router-link to="/foodlist" class="go-explore-btn btn-primary">
                  <span class="btn-icon">🔍</span>
                  探索美食
                </router-link>
              </div>
            </div>
          </template>

          <!-- 店铺收藏 -->
          <template v-if="activeTab === 'stores'">
            <div class="items-grid" v-if="storeCollections.length > 0">
              <div
                v-for="item in storeCollections"
                :key="item.id"
                class="collection-card"
              >
                <!-- 卡片图片区域 -->
                <div class="card-image-area">
                  <div v-if="item.image && item.image.trim()" class="image-container">
                    <img :src="item.image" :alt="item.name" />
                    <div class="image-overlay">
                      <span class="overlay-text">查看详情 →</span>
                    </div>
                  </div>
                  <div v-else class="image-placeholder store-placeholder">
                    <span class="placeholder-icon">🏪</span>
                  </div>
                  <span class="favorite-badge">❤️</span>
                </div>

                <!-- 卡片信息区域 -->
                <div class="card-info">
                  <h3 class="card-title">{{ item.name }}</h3>
                  <p class="card-desc">{{ item.desc || '暂无描述' }}</p>

                  <div class="card-actions">
                    <router-link :to="`/store/${item.id}`" class="btn-view btn-primary">
                      <span class="btn-icon">🏪</span>
                      查看店铺
                    </router-link>
                    <button class="btn-remove" @click="removeCollection('store', item.id)">
                      <span class="btn-icon">💔</span>
                      取消收藏
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- 空状态 - 店铺 -->
            <div class="empty-state" v-else>
              <div class="empty-content">
                <div class="empty-icon">🏪</div>
                <h3 class="empty-title">暂无店铺收藏</h3>
                <p class="empty-desc">去发现更多优质店铺吧！</p>
                <router-link to="/map" class="go-explore-btn btn-primary">
                  <span class="btn-icon">🗺️</span>
                  探索店铺
                </router-link>
              </div>
            </div>
          </template>
        </div>
      </template>

      <!-- 未登录状态 -->
      <template v-else>
        <div class="login-required">
          <div class="login-card">
            <div class="login-icon">🔒</div>
            <h3 class="login-title">请先登录</h3>
            <p class="login-desc">登录后可以查看和管理您的收藏内容</p>
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

const activeTab = ref('foods')
const tabs = [
  { key: 'foods', label: '美食收藏', icon: '🍽️' },
  { key: 'stores', label: '店铺收藏', icon: '🏪' }
]

const userDataStore = useUserDataStore()
const userStore = useUserStore()

// 从userDataStore获取收藏数据
const foodCollections = computed(() => userDataStore.collections.foods)
const storeCollections = computed(() => userDataStore.collections.stores)

const removeCollection = (type: string, id: number) => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再取消收藏')
    return
  }

  const collectionType = type === 'food' ? 'foods' : 'stores'
  const success = userDataStore.removeCollection(collectionType as 'foods' | 'stores', id)
  if (success) {
    alert('取消收藏成功')
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
.user-collections-page {
  min-height: 100vh;
  background: var(--gradient-bg);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 24px 60px;
}

/* ====== 标签页区域 ====== */
.tabs-section {
  margin-bottom: 32px;
}

.tabs-wrapper {
  display: flex;
  gap: 12px;
  background: var(--gradient-card);
  padding: 8px;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
}

.tab-item {
  flex: 1;
  padding: 14px 20px;
  background: transparent;
  border: none;
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-size: 15px;
  font-weight: 600;
  color: var(--text-light);
}

.tab-item:hover:not(.active) {
  color: var(--primary-color);
  background: rgba(200, 22, 29, 0.04);
  transform: translateY(-2px);
}

.tab-item.active {
  background: var(--gradient-primary);
  color: white;
  box-shadow: 0 6px 16px rgba(200, 22, 29, 0.25);
  transform: translateY(-2px);
}

.tab-icon {
  font-size: 18px;
}

.tab-text {
  letter-spacing: 0.5px;
}

/* ====== 收藏内容 ====== */
.collections-content {
  display: flex;
  flex-direction: column;
  gap: 28px;
}

.items-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 24px;
}

/* 收藏卡片 */
.collection-card {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  overflow: hidden;
  position: relative;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.collection-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.collection-card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: var(--shadow-lg);
}

.collection-card:hover::before {
  opacity: 1;
}

/* 图片区域 */
.card-image-area {
  width: 100%;
  height: 220px;
  position: relative;
  overflow: hidden;
}

.image-container,
.image-placeholder {
  width: 100%;
  height: 100%;
}

.image-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: all 0.4s ease;
}

.collection-card:hover .image-container img {
  transform: scale(1.08);
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(200,22,29,0.85), rgba(168,19,26,0.85));
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: all 0.3s ease;
}

.collection-card:hover .image-overlay {
  opacity: 1;
}

.overlay-text {
  color: white;
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 1px;
  animation: pulseText 2s ease-in-out infinite;
}

@keyframes pulseText {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}

.image-placeholder {
  background: linear-gradient(135deg, var(--bg-color), var(--border-color));
  display: flex;
  align-items: center;
  justify-content: center;
}

.placeholder-text {
  font-size: 64px;
  font-weight: 800;
  color: var(--primary-color);
  text-transform: uppercase;
  opacity: 0.15;
}

.store-placeholder {
  background: linear-gradient(135deg, rgba(212,175,55,0.08), rgba(212,175,55,0.02));
}

.placeholder-icon {
  font-size: 72px;
  opacity: 0.25;
}

.favorite-badge {
  position: absolute;
  top: 14px;
  right: 14px;
  font-size: 28px;
  z-index: 10;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.2));
  animation: heartbeat 2s ease-in-out infinite;
}

@keyframes heartbeat {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.15); }
}

/* 信息区域 */
.card-info {
  padding: 24px;
  background: white;
}

.card-title {
  font-size: 18px;
  color: var(--text-color);
  margin-bottom: 10px;
  font-weight: 700;
  line-height: 1.4;
  letter-spacing: 0.5px;
}

.collection-card:hover .card-title {
  color: var(--primary-color);
}

.card-desc {
  font-size: 14px;
  color: var(--text-light);
  margin-bottom: 20px;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* 操作按钮 */
.card-actions {
  display: flex;
  gap: 12px;
}

.btn-view,
.btn-remove {
  flex: 1;
  padding: 11px 16px;
  border-radius: var(--radius-sm);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  text-decoration: none;
  border: none;
  letter-spacing: 0.5px;
}

.btn-icon { font-size: 16px; }

.btn-view {
  background: var(--gradient-primary);
  color: white;
  box-shadow: 0 4px 12px rgba(200, 22, 29, 0.25);
}

.btn-view:hover {
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.35);
}

.btn-remove {
  background: white;
  color: var(--text-light);
  border: 2px solid var(--border-gold);
}

.btn-remove:hover {
  border-color: #e74c3c;
  color: #e74c3c;
  background: linear-gradient(135deg, rgba(231,76,60,0.04), rgba(231,76,60,0.02));
  transform: translateY(-2px);
}

.btn-remove:hover .btn-icon {
  animation: shake 0.5s ease-in-out;
}

@keyframes shake {
  0%, 100% { transform: rotate(0deg); }
  25% { transform: rotate(-10deg); }
  75% { transform: rotate(10deg); }
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
  max-width: 400px;
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

.go-explore-btn {
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

.go-explore-btn:hover:not(:disabled) {
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
@media (max-width: 1024px) {
  .items-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  }
}

@media (max-width: 768px) {
  .container {
    padding: 30px 16px 50px;
  }

  .tabs-wrapper {
    flex-direction: column;
    gap: 8px;
  }

  .tab-item {
    padding: 12px 16px;
  }

  .items-grid {
    grid-template-columns: 1fr;
  }

  .card-image-area {
    height: 200px;
  }

  .card-info {
    padding: 20px;
  }

  .card-actions {
    flex-direction: column;
  }

  .btn-view,
  .btn-remove {
    width: 100%;
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
}
</style>
