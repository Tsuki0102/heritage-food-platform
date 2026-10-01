<template>
  <div class="map-page">
    <Header />

    <!-- 顶部横幅 - 使用公共组件 -->
    <BannerSection
      title="美食溯源地图"
      subtitle="探索非遗美食的发源地和传承店铺"
      badge-icon="🗺️"
      badge="文化探索"
    />

    <div class="container">
      <div class="map-content">
        <!-- 搜索筛选区域 -->
        <div class="filter-section">
          <div class="search-box">
            <span class="search-icon">🔍</span>
            <input type="text" v-model="searchKeyword" @input="searchStores" placeholder="搜索美食或店铺..." />
          </div>
          <div class="filter-group">
            <label class="filter-label">
              <span class="label-icon">📍</span>
              地区
            </label>
            <select class="custom-select" v-model="foodFilter" @change="filterStores">
              <option value="all">全部地区</option>
              <option value="beijing">北京</option>
              <option value="shanghai">上海</option>
              <option value="guangdong">广东</option>
              <option value="sichuan">四川</option>
              <option value="henan">河南</option>
            </select>
          </div>
          <div class="filter-group">
            <label class="filter-label">
              <span class="label-icon">🌶️</span>
              口味
            </label>
            <select class="custom-select" v-model="tasteFilter" @change="filterStores">
              <option value="all">全部口味</option>
              <option value="sweet">甜</option>
              <option value="salty">咸</option>
              <option value="spicy">辣</option>
              <option value="light">清淡</option>
            </select>
          </div>
        </div>

        <!-- 地图容器 -->
        <div class="map-container">
          <div id="map" class="map-area"></div>
          <div class="map-sidebar">
            <div class="sidebar-header">
              <h3>
                <span class="header-icon">🏪</span>
                美食店铺
              </h3>
              <span class="store-count">{{ filteredStores.length }} 家店铺</span>
            </div>
            <div class="store-list">
              <div class="store-item" v-for="store in filteredStores" :key="store.id">
                <div class="store-info">
                  <h4>{{ store.name }}</h4>
                  <p class="store-address">
                    <span class="detail-icon">📍</span>
                    {{ store.address }}
                  </p>
                  <p class="store-distance">
                    <span class="detail-icon">📏</span>
                    {{ store.distance }}km
                  </p>
                  <div class="store-rating">
                    <span class="rating-stars">★★★★★</span>
                    <span class="rating-value">{{ store.score }}</span>
                  </div>
                </div>
                <button class="view-btn btn-primary" @click="viewStoreDetail(store.id)">
                  查看详情 →
                </button>
              </div>
              <div v-if="filteredStores.length === 0" class="no-results">
                <div class="no-results-icon">🔍</div>
                <p>未找到匹配的店铺</p>
                <span class="no-results-hint">请尝试调整筛选条件</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 底部文化展示区 -->
        <div class="culture-showcase">
          <div class="showcase-header">
            <h2 class="showcase-title">探索中华美食版图</h2>
            <p class="showcase-subtitle">跨越千山万水 · 寻味地道传承</p>
          </div>
          <div class="culture-cards">
            <div class="culture-card">
              <div class="card-icon">🏛️</div>
              <h4>北方风味</h4>
              <p>京味烤鸭、豫式烩面、鲁菜经典</p>
            </div>
            <div class="culture-card">
              <div class="card-icon">🌸</div>
              <h4>江南雅韵</h4>
              <p>苏式糕点、上海小笼、杭帮美味</p>
            </div>
            <div class="culture-card">
              <div class="card-icon">🌶️</div>
              <h4>川渝麻辣</h4>
              <p>火锅串串、川菜精髓、巴蜀风情</p>
            </div>
            <div class="culture-card">
              <div class="card-icon">🥟</div>
              <h4>粤式经典</h4>
              <p>广式早茶、粤菜精粹、岭南味道</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed, nextTick } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import L from 'leaflet'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'
import { useStoreStore } from '../stores/storeStore'
import type { Store } from '../types/store'

const router = useRouter()
const storeStore = useStoreStore()

// 配置Leaflet图标路径
delete (L.Icon.Default.prototype as any)._getIconUrl
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png'
})

const stores = ref<Store[]>([])

// 搜索和筛选相关数据
const searchKeyword = ref('')
const foodFilter = ref('all')
const tasteFilter = ref('all')

onMounted(async () => {
  try {
    const allStores = await storeStore.fetchAllStores()
    stores.value = allStores
    await nextTick()
    initMap()
  } catch (error) {
    console.error('获取店铺数据失败:', error)
  }
})

// 过滤后的店铺列表
const filteredStores = computed(() => {
  return stores.value.filter(store => {
    // 搜索关键词过滤
    const matchesSearch = !searchKeyword.value || 
      store.name.toLowerCase().includes(searchKeyword.value.toLowerCase()) ||
      store.address.toLowerCase().includes(searchKeyword.value.toLowerCase())
    
    // 地区过滤
    let matchesFood = true
    if (foodFilter.value !== 'all') {
      const areaMap: Record<string, string> = {
        beijing: '北京',
        shanghai: '上海',
        guangdong: '广州',
        sichuan: '成都',
        henan: '郑州|开封|洛阳'
      }
      const areaRegex = new RegExp(areaMap[foodFilter.value], 'i')
      matchesFood = areaRegex.test(store.address)
    }
    
    // 口味过滤（这里简化处理，实际项目中需要根据店铺类型判断）
    let matchesTaste = true
    if (tasteFilter.value !== 'all') {
      const tasteMap: Record<string, string[]> = {
        sweet: ['南翔馒头店', '小笼包馆', '陶陶居'],
        salty: ['全聚德烤鸭店', '便宜坊烤鸭店', '大董烤鸭店'],
        spicy: ['海底捞火锅', '小龙坎火锅'],
        light: ['广州酒家', '郑州烩面馆', '开封第一楼', '洛阳水席楼']
      }
      matchesTaste = tasteMap[tasteFilter.value].includes(store.name)
    }
    
    return matchesSearch && matchesFood && matchesTaste
  })
})

let map: any = null

onUnmounted(() => {
  if (map) {
    map.remove()
  }
})

const viewStoreDetail = (storeId: number) => {
  // 跳转到店铺详情页
  router.push(`/store/${storeId}`)
}

const searchStores = () => {
  // 搜索功能已通过computed属性实现
  updateMapMarkers()
}

const filterStores = () => {
  // 筛选功能已通过computed属性实现
  updateMapMarkers()
}

const updateMapMarkers = () => {
  // 清除现有标记
  if (map) {
    map.eachLayer(layer => {
      if (layer instanceof L.Marker) {
        map.removeLayer(layer)
      }
    })
    
    // 添加过滤后的店铺标记
    filteredStores.value.forEach(store => {
      L.marker([store.latitude, store.longitude])
        .addTo(map)
        .bindPopup(`<b>${store.name}</b><br>${store.address}<br>评分: ${store.score}`)
    })
  }
}

const initMap = () => {
  // 初始化地图 - 设置为中国中心位置，缩放级别为5，这样可以看到全国的店铺
  map = L.map('map').setView([35.86166, 104.195397], 5)
  
  // 添加底图 - 使用高德地图瓦片服务
  L.tileLayer('https://webst01.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}', {
    attribution: '© 高德地图'
  }).addTo(map)
  
  // 也可以尝试使用其他瓦片服务
  // L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
  //   attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  // }).addTo(map)
  
  // 添加店铺标记
  filteredStores.value.forEach(store => {
    L.marker([store.latitude, store.longitude])
      .addTo(map)
      .bindPopup(`<b>${store.name}</b><br>${store.address}<br>评分: ${store.score}`)
  })
  
  // 获取真实位置
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { latitude, longitude } = position.coords
        L.marker([latitude, longitude])
          .addTo(map)
          .bindPopup('当前位置 (真实)')
          .openPopup()
      },
      (error) => {
        console.error('获取地理位置失败:', error)
        // 使用默认位置
        L.marker([34.7579, 113.6654]) // 郑州位置
          .addTo(map)
          .bindPopup('当前位置 (默认: 郑州)')
          .openPopup()
      }
    )
  } else {
    // 浏览器不支持地理位置
    L.marker([34.7579, 113.6654]) // 郑州位置
      .addTo(map)
      .bindPopup('当前位置 (默认: 郑州)')
      .openPopup()
  }
}
</script>

<style scoped>
.map-page {
  min-height: 100vh;
  background: var(--gradient-bg);
  position: relative;
  overflow-x: hidden;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 24px;
}

.map-content {
  margin: 40px 0 60px;
}

/* ====== 筛选区域 ====== */
.filter-section {
  display: flex;
  gap: 20px;
  margin-bottom: 32px;
  padding: 24px 28px;
  background: linear-gradient(135deg, rgba(255,255,255,0.98), rgba(255,250,245,0.98));
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  align-items: flex-end;
  flex-wrap: wrap;
  position: relative;
  overflow: hidden;
}

.filter-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

.search-box {
  flex: 1;
  min-width: 280px;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 20px;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-sm);
  background: white;
  transition: all 0.3s ease;
}

.search-box:focus-within {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.1);
}

.search-icon { font-size: 18px; }

.search-box input {
  flex: 1;
  border: none;
  outline: none;
  font-size: 15px;
  background: transparent;
  color: var(--text-color);
}

.search-box input::placeholder {
  color: var(--text-lighter);
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 160px;
}

.filter-label {
  font-size: 13px;
  color: var(--text-light);
  font-weight: 600;
  letter-spacing: 1px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.label-icon { font-size: 14px; }

.custom-select {
  padding: 12px 16px;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-sm);
  font-size: 14px;
  outline: none;
  transition: all 0.3s ease;
  background: white;
  color: var(--text-color);
  cursor: pointer;
  font-weight: 500;
}

.custom-select:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.1);
}

/* ====== 地图容器 ====== */
.map-container {
  display: grid;
  grid-template-columns: 1fr 340px;
  gap: 28px;
  margin-bottom: 56px;
}

.map-area {
  width: 100%;
  height: 600px;
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-lg);
  border: 2px solid var(--border-gold);
  overflow: hidden;
  position: relative;
}

.map-area::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
  z-index: 1000;
  pointer-events: none;
}

.map-sidebar {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  padding: 24px;
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  max-height: 600px;
  overflow-y: auto;
  position: relative;
}

.map-sidebar::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--secondary-color), var(--primary-color), var(--secondary-color));
}

.sidebar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 16px;
  border-bottom: 2px dashed var(--border-gold);
}

.sidebar-header h3 {
  font-size: 18px;
  color: var(--text-color);
  margin: 0;
  font-weight: 700;
  letter-spacing: 2px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.header-icon { font-size: 22px; animation: iconPulse 3s ease-in-out infinite; }

.store-count {
  font-size: 13px;
  color: var(--text-light);
  background: linear-gradient(135deg, rgba(212,175,55,0.1), rgba(200,22,29,0.08));
  padding: 6px 14px;
  border-radius: 15px;
  font-weight: 600;
}

.store-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.store-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px;
  border: 1.5px solid var(--border-gold);
  border-radius: var(--radius-md);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  background: white;
  cursor: default;
  position: relative;
  overflow: hidden;
}

.store-item::before {
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

.store-item:hover {
  transform: translateX(6px);
  box-shadow: var(--shadow-md);
  border-color: var(--border-gold-hover);
}

.store-item:hover::before {
  opacity: 1;
}

.store-info {
  flex: 1;
  min-width: 0;
}

.store-info h4 {
  font-size: 16px;
  margin: 0 0 10px 0;
  color: var(--text-color);
  font-weight: 700;
  letter-spacing: 1px;
  transition: color 0.3s ease;
}

.store-item:hover .store-info h4 {
  color: var(--primary-color);
}

.store-address,
.store-distance {
  font-size: 13px;
  color: var(--text-light);
  margin-bottom: 6px;
  line-height: 1.5;
  display: flex;
  align-items: center;
  gap: 6px;
}

.detail-icon { font-size: 14px; }

.store-rating {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
}

.rating-stars {
  color: var(--secondary-color);
  font-size: 12px;
  letter-spacing: 2px;
}

.rating-value {
  font-size: 17px;
  font-weight: 800;
  color: var(--secondary-color);
  letter-spacing: 1px;
}

.view-btn {
  padding: 10px 20px;
  border: none;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 1px;
  white-space: nowrap;
  margin-left: 16px;
}

.view-btn:hover {
  transform: translateY(-2px) scale(1.05);
}

.no-results {
  text-align: center;
  padding: 48px 24px;
  background: linear-gradient(135deg, rgba(212,175,55,0.03), rgba(200,22,29,0.02));
  border-radius: var(--radius-lg);
  border: 2px dashed var(--border-gold);
}

.no-results-icon {
  font-size: 48px;
  margin-bottom: 16px;
  animation: float 3s ease-in-out infinite;
}

.no-results p {
  font-size: 16px;
  color: var(--text-light);
  margin: 0 0 8px 0;
  font-weight: 600;
}

.no-results-hint {
  font-size: 13px;
  color: var(--text-lighter);
}

/* ====== 文化展示区 ====== */
.culture-showcase {
  margin-bottom: 60px;
  padding: 50px 0;
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.02), rgba(212, 175, 55, 0.02));
  border-radius: var(--radius-xl);
  position: relative;
  overflow: hidden;
}

.culture-showcase::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

.showcase-header {
  text-align: center;
  margin-bottom: 40px;
}

.showcase-title {
  font-size: 32px;
  color: var(--text-color);
  margin-bottom: 12px;
  font-weight: 700;
  letter-spacing: 4px;
}

.showcase-subtitle {
  font-size: 16px;
  color: var(--text-light);
  letter-spacing: 6px;
  font-weight: 500;
}

.culture-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 24px;
  padding: 0 20px;
}

.culture-card {
  background: linear-gradient(145deg, white, #fafafa);
  padding: 32px 24px;
  border-radius: var(--radius-lg);
  text-align: center;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid var(--border-gold);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
  position: relative;
  overflow: hidden;
}

.culture-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.culture-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 16px 40px rgba(200, 22, 29, 0.15);
  border-color: var(--border-gold-hover);
}

.culture-card:hover::before {
  opacity: 1;
}

.card-icon {
  font-size: 52px;
  margin-bottom: 16px;
  display: block;
  animation: iconPulse 3s ease-in-out infinite;
}

.culture-card:nth-child(2) .card-icon { animation-delay: 0.75s; }
.culture-card:nth-child(3) .card-icon { animation-delay: 1.5s; }
.culture-card:nth-child(4) .card-icon { animation-delay: 2.25s; }

.culture-card h4 {
  font-size: 18px;
  color: var(--text-color);
  margin-bottom: 10px;
  font-weight: 700;
  letter-spacing: 2px;
}

.culture-card p {
  font-size: 14px;
  color: var(--text-light);
  line-height: 1.6;
  margin: 0;
}

/* 动画关键帧 */
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-12px); }
}

@keyframes iconPulse {
  0%, 100% { transform: scale(1) rotate(0deg); }
  50% { transform: scale(1.1) rotate(5deg); }
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .map-container {
    grid-template-columns: 1fr;
  }
  
  .map-sidebar {
    max-height: 400px;
  }
  
  .culture-cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .container {
    padding: 0 16px;
  }
  
  .filter-section {
    flex-direction: column;
    align-items: stretch;
  }
  
  .filter-group {
    width: 100%;
  }
  
  .custom-select {
    width: 100%;
  }
  
  .search-box {
    width: 100%;
  }
  
  .store-item {
    flex-direction: column;
    align-items: stretch;
    gap: 12px;
  }
  
  .view-btn {
    margin-left: 0;
    width: 100%;
    justify-content: center;
  }
  
  .culture-cards {
    grid-template-columns: 1fr;
  }
}
</style>