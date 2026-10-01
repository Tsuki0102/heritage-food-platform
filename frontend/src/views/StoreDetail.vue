<template>
  <div class="store-detail heritage-pattern">
    <Header />

    <BannerSection 
      v-if="store" 
      :title="store.name" 
      :subtitle="`${store.address} · ${store.openingHours}`" 
      badge-icon="🏪"
      badge="非遗店铺"
    />

    <div class="container">
      <div class="store-content" v-if="store">
        <div class="detail-hero-section store-header">
          <div class="store-header-top">
            <BackButton to="/" />
          </div>
          <div class="store-info">
            <h1>{{ store.name }}</h1>
            <div class="detail-info-grid store-meta">
              <div class="detail-stat-card">
                <span class="detail-stat-value">{{ store.score }}</span>
                <span class="detail-stat-label">评分</span>
              </div>
              <div class="detail-stat-card">
                <span class="detail-stat-value">📍</span>
                <span class="detail-stat-label">{{ store.address?.substring(0, 10) || '未知地址' }}</span>
              </div>
              <div class="detail-stat-card">
                <span class="detail-stat-value">🕐</span>
                <span class="detail-stat-label">{{ store.openingHours || '营业中' }}</span>
              </div>
            </div>
            <div class="store-contact">
              <p><strong>联系方式：</strong>{{ store.contact || '暂无联系方式' }}</p>
            </div>
            <div class="detail-action-buttons store-actions">
              <button class="detail-action-btn collect-btn" :class="{ active: isCollected, disabled: !userStore.isLoggedIn }" @click="handleCollect">
                <span class="icon">{{ isCollected ? '❤️' : '🤍' }}</span>
                {{ isCollected ? '已收藏' : '收藏' }}
              </button>
              <button class="detail-action-btn nav-btn" @click="handleNav">
                <span class="icon">🗺️</span>
                导航
              </button>
              <button class="detail-action-btn share-btn" :class="{ disabled: !userStore.isLoggedIn }" @click="handleShare">
                <span class="icon">📤</span>
                分享
              </button>
            </div>
          </div>
        </div>

        <div class="store-tabs heritage-corner-decoration">
          <div class="detail-tabs-nav tab-nav">
            <button 
              v-for="tab in tabs" 
              :key="tab.key" 
              :class="['detail-tab-btn', { active: activeTab === tab.key }]"
              @click="activeTab = tab.key"
            >
              {{ tab.label }}
            </button>
          </div>
          <div class="tab-content">
            <div v-if="activeTab === 'intro'" class="tab-pane">
              <h3>店铺介绍</h3>
              <p>{{ store.introduction }}</p>
            </div>
            <div v-if="activeTab === 'foods'" class="tab-pane">
              <h3>招牌美食</h3>
              <div class="food-list">
                <div class="food-item" v-for="food in storeFoods" :key="food.id">
                  <img 
                    :src="`/images/${food.image}`" 
                    :alt="food.name" 
                    class="food-img"
                    @error="(e) => e.target.src = '/images/error.png'"
                  />
                  <div class="food-info">
                    <h4>{{ food.name }}</h4>
                    <p class="food-desc">{{ food.description }}</p>
                    <div class="food-price">¥{{ food.price }}</div>
                  </div>
                </div>
              </div>
            </div>
            <div v-if="activeTab === 'activities'" class="tab-pane">
              <h3>店铺活动</h3>
              <div class="activity-list">
                <div class="activity-item" v-for="activity in storeActivities" :key="activity.id">
                  <h4>{{ activity.activityType }}</h4>
                  <p class="activity-rule">{{ activity.activityRule }}</p>
                  <p class="activity-time">{{ activity.startTime }} 至 {{ activity.endTime }}</p>
                  <span class="activity-status" :class="activity.status">{{ activity.statusText }}</span>
                </div>
              </div>
            </div>
            <div v-if="activeTab === 'comments'" class="tab-pane">
              <h3>用户评价</h3>
              <div class="comment-list">
                <div class="comment-item" v-for="comment in comments" :key="comment.id">
                  <div class="comment-header">
                    <img 
                      :src="`/images/${comment.avatar}`" 
                      :alt="comment.nickname" 
                      class="comment-avatar"
                      @error="(e) => e.target.src = '/images/avatar1.jpg'"
                    />
                    <div class="comment-user">
                      <span class="nickname">{{ comment.nickname }}</span>
                      <span class="time">{{ comment.createTime }}</span>
                    </div>
                    <div class="comment-rating">
                      <span class="stars" v-for="i in 5" :key="i">
                        {{ i <= comment.score ? '★' : '☆' }}
                      </span>
                    </div>
                  </div>
                  <div class="comment-content">{{ comment.content }}</div>
                </div>
              </div>
              <div class="comment-form">
                  <h4>发表评价</h4>
                  <div class="rating-input" :class="{ disabled: !userStore.isLoggedIn }">
                    <span class="label">评分：</span>
                    <span class="stars" v-for="i in 5" :key="i" @click="handleRatingClick(i)">
                      {{ i <= selectedScore ? '★' : '☆' }}
                    </span>
                  </div>
                  <textarea 
                    v-model="commentContent" 
                    :placeholder="userStore.isLoggedIn ? '请输入评价内容...' : '请先登录后再发表评价'"
                    :disabled="!userStore.isLoggedIn"
                  ></textarea>
                  <button 
                    class="submit-btn" 
                    @click="handleSubmitComment"
                    :disabled="!userStore.isLoggedIn"
                  >
                    提交评价
                  </button>
                </div>
            </div>
          </div>
        </div>

        <div class="store-map" v-if="store">
          <h3>店铺位置</h3>
          <div id="store-map" class="map-container"></div>
        </div>
      </div>
      
      <!-- 加载状态 -->
      <div v-else-if="loading" class="loading-container">
        <div class="loading-spinner">加载中...</div>
      </div>
      
      <!-- 错误状态 -->
      <div v-else-if="error" class="error-container">
        <div class="error-message">{{ error }}</div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed, nextTick } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'
import L from 'leaflet'
import { getStoreById } from '../api/storeApi'
import type { Store } from '../types/store'
import BackButton from '../components/BackButton.vue'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'
import { useUserDataStore } from '../stores/userDataStore'
import { useUserStore } from '../stores/userStore'

// 配置Leaflet图标路径
delete (L.Icon.Default.prototype as any)._getIconUrl
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png'
})

const route = useRoute()
const storeId = Number(route.params.id)
const userDataStore = useUserDataStore()
const userStore = useUserStore()

// 获取店铺信息
const store = ref<Store | null>(null)
const loading = ref(true)
const error = ref('')

// 计算属性获取店铺相关数据，只显示前3个不重复的美食
const storeFoods = computed(() => {
  const foods = store.value?.foods || []
  const seen = new Set()
  const uniqueFoods = []
  
  for (const food of foods) {
    if (!seen.has(food.name)) {
      seen.add(food.name)
      uniqueFoods.push(food)
      if (uniqueFoods.length >= 3) break
    }
  }
  
  return uniqueFoods
})
const storeActivities = computed(() => store.value?.activities || [])
const comments = computed(() => store.value?.comments || [])

// 检查是否已收藏
const isCollected = computed(() => store.value ? userDataStore.isCollected('stores', storeId) : false)

const tabs = [
  { key: 'intro', label: '店铺介绍' },
  { key: 'foods', label: '招牌美食' },
  { key: 'activities', label: '店铺活动' },
  { key: 'comments', label: '用户评价' }
]

const activeTab = ref('intro')

const selectedScore = ref(5)
const commentContent = ref('')

let map: any = null

// 处理收藏
const handleCollect = () => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再收藏')
    return
  }
  
  if (!store.value) {
    alert('店铺信息加载中')
    return
  }
  
  if (isCollected.value) {
    userDataStore.removeCollection('stores', storeId)
  } else {
    userDataStore.addCollection('stores', {
      id: store.value.id,
      name: store.value.name,
      desc: store.value.introduction.substring(0, 50) + '...',
      image: store.value.images && store.value.images.length > 0 ? `/images/${store.value.images[0]}` : ''
    })
  }
}

// 处理导航
const handleNav = () => {
  // 实际项目中这里会打开导航应用
  alert('导航功能开发中')
}

// 处理分享
const handleShare = () => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再分享')
    return
  }
  
  // 实际项目中这里会打开分享弹窗
  alert('分享功能开发中')
}

// 处理评分点击
const handleRatingClick = (score: number) => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再评分')
    return
  }
  selectedScore.value = score
}

// 处理评论提交
const handleSubmitComment = () => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再发表评价')
    return
  }
  
  if (!commentContent.value.trim()) {
    alert('请输入评价内容')
    return
  }
  
  // 实际项目中这里会调用API提交评论
  alert('评价提交成功！')
  commentContent.value = ''
  selectedScore.value = 5
}

onMounted(async () => {
  loading.value = true
  error.value = ''
  
  try {
    const storeData = await getStoreById(storeId)
    store.value = storeData
    
    if (store.value) {
    userDataStore.addHistory({
      id: store.value.id,
      name: store.value.name,
      desc: store.value.introduction.substring(0, 50) + '...',
      image: store.value.images && store.value.images.length > 0 ? `/images/${store.value.images[0]}` : ''
    }, 'store')
  }
    
    nextTick(() => initMap())
  } catch (err) {
    console.error('获取店铺详情失败:', err)
    error.value = '获取店铺详情失败'
  } finally {
    loading.value = false
  }
})

onUnmounted(() => {
  if (map) {
    map.remove()
  }
})

const initMap = () => {
  // 检查店铺数据是否存在
  if (!store.value) {
    console.error('店铺数据不存在，无法初始化地图')
    return
  }
  
  // 检查经纬度是否存在
  if (!store.value.latitude || !store.value.longitude) {
    console.error('店铺经纬度不存在，无法初始化地图')
    return
  }
  
  // 检查地图容器是否存在
  const mapContainer = document.getElementById('store-map')
  if (!mapContainer) {
    console.error('地图容器不存在')
    return
  }
  
  // 初始化地图
  map = L.map('store-map').setView([store.value.latitude, store.value.longitude], 15)
  
  // 添加底图 - 使用高德地图瓦片服务
  L.tileLayer('https://webst01.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}', {
    attribution: '© 高德地图'
  }).addTo(map)
  
  // 添加店铺标记
  L.marker([store.value.latitude, store.value.longitude])
    .addTo(map)
    .bindPopup(`<b>${store.value.name}</b><br>${store.value.address}`)
    .openPopup()
}
</script>

<style scoped>
.store-detail {
  min-height: 100vh;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 var(--spacing-lg);
}

.store-content {
  margin: var(--spacing-xl) 0;
}

.store-header {
  position: relative;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  padding: var(--spacing-xxl) var(--spacing-xl);
  box-shadow: var(--shadow-md);
  margin-bottom: var(--spacing-xl);
  animation: fadeIn 0.6s ease-out;
}

.store-header-top {
  margin-bottom: var(--spacing-lg);
}

.store-info h1 {
  font-size: 36px;
  margin-bottom: var(--spacing-lg);
  color: var(--text-color);
  letter-spacing: 3px;
  position: relative;
  display: inline-block;
}

.store-info h1::after {
  content: '';
  position: absolute;
  bottom: -8px;
  left: 0;
  width: 60px;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  border-radius: 2px;
}

.store-meta {
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-lg);
}

.store-contact {
  margin-bottom: var(--spacing-xl);
  font-size: 16px;
  color: var(--text-light);
  line-height: 1.7;
}

.store-contact strong {
  color: var(--text-color);
  font-weight: 600;
}

.store-actions {
  gap: var(--spacing-md);
}

.store-tabs {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  overflow: hidden;
  box-shadow: var(--shadow-md);
  margin-bottom: var(--spacing-xl);
  border: 1px solid var(--border-gold);
  animation: fadeInUp 0.6s ease-out 0.2s both;
}

.tab-content {
  padding: var(--spacing-xxl) var(--spacing-xl);
}

.tab-pane h3 {
  font-size: 22px;
  margin-bottom: var(--spacing-lg);
  color: var(--text-color);
  position: relative;
  padding-left: 16px;
}

.tab-pane h3::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 22px;
  background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
  border-radius: 2px;
}

.tab-pane p {
  line-height: 1.8;
  color: var(--text-light);
  margin-bottom: var(--spacing-lg);
  font-size: 15px;
}

.food-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: var(--spacing-lg);
}

.food-item {
  display: flex;
  gap: var(--spacing-md);
  padding: var(--spacing-lg);
  border: 1px solid var(--border-gold);
  border-radius: var(--radius-md);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  background: var(--bg-white);
}

.food-item:hover {
  transform: translateY(-5px);
  box-shadow: var(--shadow-primary);
  border-color: var(--primary-color);
}

.food-img {
  width: 110px;
  height: 110px;
  object-fit: cover;
  border-radius: var(--radius-sm);
  transition: transform 0.3s ease;
}

.food-item:hover .food-img {
  transform: scale(1.05);
}

.food-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.food-info h4 {
  font-size: 17px;
  margin-bottom: var(--spacing-sm);
  color: var(--text-color);
  font-weight: 600;
  letter-spacing: 0.5px;
}

.food-desc {
  font-size: 14px;
  color: var(--text-light);
  margin-bottom: var(--spacing-sm);
  line-height: 1.5;
}

.food-price {
  font-size: 18px;
  font-weight: 700;
  color: var(--primary-color);
  letter-spacing: 0.5px;
}

.activity-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-lg);
}

.activity-item {
  padding: var(--spacing-lg);
  border: 1px solid var(--border-gold);
  border-radius: var(--radius-md);
  position: relative;
  transition: all 0.3s ease;
  background: var(--bg-white);
}

.activity-item:hover {
  border-color: var(--secondary-color);
  box-shadow: var(--shadow-sm);
  transform: translateX(4px);
}

.activity-item h4 {
  font-size: 17px;
  margin-bottom: var(--spacing-sm);
  color: var(--text-color);
  font-weight: 600;
}

.activity-rule {
  font-size: 14px;
  color: var(--text-light);
  margin-bottom: var(--spacing-sm);
  line-height: 1.5;
}

.activity-time {
  font-size: 13px;
  color: var(--text-lighter);
  margin-bottom: var(--spacing-sm);
}

.activity-status {
  position: absolute;
  top: var(--spacing-lg);
  right: var(--spacing-lg);
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.activity-status.active {
  background: rgba(82, 196, 26, 0.1);
  color: #52c41a;
  border: 1px solid rgba(82, 196, 26, 0.2);
}

.activity-status.ended {
  background: rgba(255, 77, 79, 0.08);
  color: #ff4d4f;
  border: 1px solid rgba(255, 77, 79, 0.15);
}

.comment-list {
  margin-bottom: var(--spacing-xl);
}

.comment-item {
  padding: var(--spacing-lg) 0;
  border-bottom: 1px solid var(--border-gold);
  transition: all 0.3s ease;
}

.comment-item:hover {
  background: rgba(200, 22, 29, 0.02);
  padding-left: var(--spacing-md);
  padding-right: var(--spacing-md);
  margin-left: calc(-1 * var(--spacing-lg));
  margin-right: calc(-1 * var(--spacing-lg));
  padding-top: var(--spacing-md);
  padding-bottom: var(--spacing-md);
  border-radius: var(--radius-sm);
}

.comment-header {
  display: flex;
  align-items: center;
  margin-bottom: var(--spacing-sm);
}

.comment-avatar {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  margin-right: var(--spacing-md);
  object-fit: cover;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.comment-user {
  flex: 1;
}

.nickname {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-color);
  margin-right: var(--spacing-sm);
  letter-spacing: 0.5px;
}

.time {
  font-size: 12px;
  color: var(--text-lighter);
}

.comment-rating {
  color: var(--secondary-color);
  font-size: 16px;
}

.comment-content {
  font-size: 14px;
  line-height: 1.7;
  color: var(--text-light);
  padding-left: calc(44px + var(--spacing-md));
}

.comment-form {
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.03), rgba(212, 175, 55, 0.03));
  padding: var(--spacing-xl);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-gold);
}

.comment-form h4 {
  font-size: 18px;
  margin-bottom: var(--spacing-lg);
  color: var(--text-color);
  font-weight: 700;
  position: relative;
  padding-left: 16px;
}

.comment-form h4::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 18px;
  background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
  border-radius: 2px;
}

.rating-input {
  display: flex;
  align-items: center;
  margin-bottom: var(--spacing-lg);
}

.rating-input .label {
  font-size: 14px;
  color: var(--text-light);
  margin-right: var(--spacing-sm);
  font-weight: 500;
}

.rating-input .stars {
  font-size: 22px;
  color: var(--secondary-color);
  cursor: pointer;
  transition: transform 0.2s ease;
}

.rating-input .stars:hover {
  transform: scale(1.2);
}

.rating-input.disabled .stars {
  cursor: not-allowed;
  opacity: 0.5;
}

.comment-form textarea {
  width: 100%;
  height: 120px;
  padding: var(--spacing-md);
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-sm);
  resize: vertical;
  margin-bottom: var(--spacing-lg);
  font-size: 14px;
  line-height: 1.6;
  transition: all 0.3s ease;
  background: var(--bg-white);
  color: var(--text-color);
}

.comment-form textarea:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.1);
}

.submit-btn {
  background: var(--gradient-primary);
  color: white;
  border: none;
  padding: 12px 32px;
  border-radius: var(--radius-xxl);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-weight: 600;
  letter-spacing: 1px;
  box-shadow: var(--shadow-primary);
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(200, 22, 29, 0.35);
}

.store-map {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  padding: var(--spacing-xxl) var(--spacing-xl);
  box-shadow: var(--shadow-md);
  margin-bottom: var(--spacing-xxl);
  border: 1px solid var(--border-gold);
  animation: fadeInUp 0.6s ease-out 0.4s both;
}

.store-map h3 {
  font-size: 22px;
  margin-bottom: var(--spacing-lg);
  color: var(--text-color);
  position: relative;
  padding-left: 16px;
}

.store-map h3::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 22px;
  background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
  border-radius: 2px;
}

.map-container {
  width: 100%;
  height: 420px;
  border-radius: var(--radius-md);
  margin-top: var(--spacing-lg);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  border: 2px solid var(--border-gold);
}

.loading-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 420px;
  font-size: 18px;
  color: var(--text-light);
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-sm);
}

.loading-spinner {
  text-align: center;
}

.loading-spinner::after {
  content: '';
  display: block;
  width: 48px;
  height: 48px;
  margin: 0 auto 20px;
  border: 4px solid rgba(212, 175, 55, 0.2);
  border-top-color: var(--primary-color);
  border-right-color: var(--secondary-color);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.error-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 420px;
}

.error-message {
  color: var(--primary-color);
  font-size: 16px;
  padding: var(--spacing-xl);
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.05), rgba(255, 245, 245, 0.5));
  border-radius: var(--radius-md);
  border: 1px solid rgba(200, 22, 29, 0.15);
  text-align: center;
  max-width: 500px;
}

@media (max-width: 768px) {
  .container {
    padding: 0 var(--spacing-md);
  }

  .store-header {
    padding: var(--spacing-xl) var(--spacing-lg);
  }

  .store-info h1 {
    font-size: 28px;
    letter-spacing: 2px;
  }

  .detail-info-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: var(--spacing-sm);
  }

  .detail-action-buttons {
    flex-direction: column;
  }

  .detail-action-btn {
    width: 100%;
    justify-content: center;
  }

  .tab-content {
    padding: var(--spacing-xl) var(--spacing-md);
  }

  .food-list {
    grid-template-columns: 1fr;
  }

  .food-item {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .food-img {
    width: 160px;
    height: 160px;
  }

  .comment-content {
    padding-left: 0;
  }

  .map-container {
    height: 320px;
  }

  .store-map {
    padding: var(--spacing-xl) var(--spacing-md);
  }
}

@media (max-width: 480px) {
  .store-info h1 {
    font-size: 24px;
    letter-spacing: 1px;
  }

  .detail-info-grid {
    grid-template-columns: 1fr;
  }

  .tab-btn {
    padding: 10px 12px;
    font-size: 13px;
  }
}
</style>