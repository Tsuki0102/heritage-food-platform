<template>
  <div class="food-list-page">
    <Header />

    <!-- 顶部横幅 - 使用公共组件 -->
    <BannerSection
      title="探索非遗美食文化"
      subtitle="传承中华传统美食，体验地道风味"
      badge="非物质文化遗产"
      badge-icon="🏛️"
      :duration="120"
    >
      <template #extra>
        <div class="content-tags">
          <span class="content-tag">🍜 传统技艺</span>
          <span class="content-tag">🏮 百年传承</span>
          <span class="content-tag">🎋 匠心独运</span>
          <span class="content-tag">🎨 文化瑰宝</span>
        </div>
      </template>
    </BannerSection>

    <div class="container">

      <!-- 页面标题 - 使用公共组件 -->
      <PageHeader
        title="美食列表"
        left-icon="🥢"
        right-icon="🍽️"
      />

      <!-- 筛选区域 -->
      <div class="filter-section">
        <div class="filter-header">
          <h3 class="filter-title">
            <span class="filter-icon">🔍</span>
            精选筛选
          </h3>
          <div class="filter-stats">
            <span class="stat-item">共 <strong>{{ total || foods.length }}</strong> 道非遗美食</span>
          </div>
        </div>

        <div class="filter-content">
          <div class="filter-group">
            <label class="filter-label">
              <span class="label-icon">📍</span>
              地区
            </label>
            <select v-model="regionFilter" @change="handleFilterChange" class="custom-select">
              <option value="">全部地区</option>
              <option value="北京">北京</option>
              <option value="上海">上海</option>
              <option value="广东">广东</option>
              <option value="河南">河南</option>
              <option value="四川">四川</option>
              <option value="陕西">陕西</option>
              <option value="浙江">浙江</option>
              <option value="江苏">江苏</option>
              <option value="重庆">重庆</option>
            </select>
          </div>

          <div class="filter-group">
            <label class="filter-label">
              <span class="label-icon">🌶️</span>
              口味
            </label>
            <select v-model="tasteFilter" @change="handleFilterChange" class="custom-select">
              <option value="">全部口味</option>
              <option value="咸香">咸香</option>
              <option value="鲜美">鲜美</option>
              <option value="清淡">清淡</option>
              <option value="酸辣">酸辣</option>
              <option value="鲜香">鲜香</option>
              <option value="麻辣">麻辣</option>
              <option value="酸甜">酸甜</option>
              <option value="甜香">甜香</option>
              <option value="双味">双味</option>
            </select>
          </div>

          <div class="filter-group">
            <label class="filter-label">
              <span class="label-icon">🏆</span>
              级别
            </label>
            <select v-model="levelFilter" @change="handleFilterChange" class="custom-select">
              <option value="">全部级别</option>
              <option value="国家级">国家级</option>
              <option value="省级">省级</option>
              <option value="市级">市级</option>
            </select>
          </div>

          <div class="search-box">
            <input type="text" v-model="searchKeyword" placeholder="搜索美食..." @keyup.enter="handleSearch" />
            <button class="search-btn btn-primary" @click="handleSearch">
              <span class="btn-icon">🔎</span>
              搜索
            </button>
          </div>
        </div>
      </div>

      <!-- 美食网格 - 使用公共组件 -->
      <div class="food-grid" v-if="!loading">
        <FoodCard
          v-for="food in foods"
          :key="food.id"
          :id="food.id"
          :name="food.name"
          :cover-image="food.coverImage"
          :region="food.region"
          :taste="food.taste"
          :heritage-level="food.heritageLevel"
          :average-score="food.averageScore"
          :collection-count="food.collectionCount"
          route-path="/food"
          show-favorite
        />
      </div>

      <!-- 加载状态 -->
      <div class="loading-state" v-else>
        <div class="loading-container">
          <div class="loading-spinner"></div>
          <p class="loading-text">正在加载非遗美食...</p>
          <div class="loading-dots">
            <span></span><span></span><span></span>
          </div>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination" v-if="!loading && total > 0">
        <button class="page-btn prev-btn" :disabled="currentPage === 1" @click="changePage(currentPage - 1)">
          <span>◀</span> 上一页
        </button>
        <div class="page-info-container">
          <span class="page-current">{{ currentPage }}</span>
          <span class="page-divider">/</span>
          <span class="page-total">{{ totalPages }}</span>
          <span class="page-hint">页</span>
        </div>
        <button class="page-btn next-btn" :disabled="currentPage === totalPages" @click="changePage(currentPage + 1)">
          下一页 <span>▶</span>
        </button>
      </div>

      <!-- 空状态 -->
      <div class="empty-state" v-if="!loading && foods.length === 0">
        <div class="empty-container">
          <div class="empty-icon">🍽️</div>
          <h2>没有找到美食</h2>
          <p>请尝试调整筛选条件</p>
          <div class="empty-suggestions">
            <span class="suggestion-tag">尝试其他地区</span>
            <span class="suggestion-tag">更换口味</span>
            <span class="suggestion-tag">清空筛选</span>
          </div>
        </div>
      </div>

      <!-- 底部文化展示区 -->
      <div class="culture-showcase">
        <div class="showcase-header">
          <h2 class="showcase-title">中华美食文化精髓</h2>
          <p class="showcase-subtitle">千年传承 · 匠心独运 · 味蕾传奇</p>
        </div>

        <div class="culture-cards">
          <div class="culture-card">
            <div class="card-icon">🏛️</div>
            <h4>历史传承</h4>
            <p>承载千年的饮食智慧</p>
          </div>
          <div class="culture-card">
            <div class="card-icon">🎨</div>
            <h4>工艺精湛</h4>
            <p>代代相传的烹饪技艺</p>
          </div>
          <div class="culture-card">
            <div class="card-icon">🌿</div>
            <h4>天然食材</h4>
            <p>精选地道优质原料</p>
          </div>
          <div class="culture-card">
            <div class="card-icon">🏮</div>
            <h4>文化底蕴</h4>
            <p>融合传统与现代美学</p>
          </div>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getFoodList } from '../api/foodApi'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'
import PageHeader from '../components/PageHeader.vue'
import FoodCard from '../components/FoodCard.vue'

const router = useRouter()

const loading = ref(false)
const foods = ref<any[]>([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(12)
const totalPages = computed(() => Math.ceil(total.value / pageSize.value))

const regionFilter = ref('')
const tasteFilter = ref('')
const levelFilter = ref('')
const searchKeyword = ref('')

const navigateToFoodDetail = (foodId: number) => {
  router.push(`/food/${foodId}`)
}

const fetchFoods = async () => {
  loading.value = true
  try {
    const res = await getFoodList(currentPage.value, pageSize.value, {
      region: regionFilter.value,
      taste: tasteFilter.value,
      heritage_level: levelFilter.value,
      keyword: searchKeyword.value
    })
    foods.value = res.records
    total.value = res.total
  } catch (error) {
    console.error('获取美食数据失败:', error)
  } finally {
    loading.value = false
  }
}

const changePage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    fetchFoods()
  }
}

const handleFilterChange = () => {
  currentPage.value = 1
  fetchFoods()
}

const handleSearch = () => {
  currentPage.value = 1
  fetchFoods()
}

onMounted(() => {
  fetchFoods()
})
</script>

<style scoped>
.food-list-page {
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

/* 标签样式 */
.content-tags {
  display: flex;
  justify-content: center;
  gap: 14px;
  flex-wrap: wrap;
  margin-bottom: 24px;
}

.content-tag {
  padding: 8px 20px;
  background: rgba(255, 255, 255, 0.95);
  border: 1.5px solid rgba(212, 175, 55, 0.3);
  border-radius: 25px;
  font-size: 14px;
  color: var(--text-light);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-weight: 500;
}

.content-tag:hover {
  background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
  color: white;
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.25);
  border-color: transparent;
}

/* ====== 筛选区域 ====== */
.filter-section {
  margin-bottom: 40px;
  background: linear-gradient(135deg, rgba(255,255,255,0.98), rgba(255,250,245,0.98));
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  overflow: hidden;
  position: relative;
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

.filter-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 28px;
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.03), rgba(212, 175, 55, 0.03));
  border-bottom: 1px solid var(--border-gold);
}

.filter-title {
  font-size: 18px;
  color: var(--text-color);
  margin: 0;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-icon { font-size: 20px; }

.filter-stats {
  display: flex;
  gap: 16px;
}

.stat-item {
  font-size: 13px;
  color: var(--text-light);
  padding: 6px 14px;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 20px;
  border: 1px solid var(--border-gold);
}

.stat-item strong {
  color: var(--primary-color);
  font-weight: 700;
}

.filter-content {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  padding: 24px 28px;
  align-items: flex-end;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 140px;
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
  min-width: 140px;
  font-weight: 500;
}

.custom-select:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.1);
}

.search-box {
  display: flex;
  margin-left: auto;
  gap: 10px;
}

.search-box input {
  padding: 12px 20px;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-sm);
  font-size: 14px;
  outline: none;
  transition: all 0.3s ease;
  width: 220px;
  background: white;
  color: var(--text-color);
}

.search-box input:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.1);
}

.search-box input::placeholder {
  color: var(--text-lighter);
}

.search-btn {
  padding: 12px 24px !important;
  font-size: 14px !important;
  border-radius: var(--radius-sm) !important;
  display: flex !important;
  align-items: center;
  gap: 6px;
}

.btn-icon { font-size: 16px; }

/* ====== 美食网格 ====== */
.food-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 28px;
  margin-bottom: 48px;
}

/* ====== 加载状态 ====== */
.loading-state {
  text-align: center;
  padding: 100px 0;
  color: var(--text-light);
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}

.loading-spinner {
  width: 56px;
  height: 56px;
  border: 4px solid rgba(212, 175, 55, 0.2);
  border-top-color: var(--primary-color);
  border-right-color: var(--secondary-color);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  box-shadow: 0 4px 20px rgba(200, 22, 29, 0.2);
}

.loading-text {
  font-size: 16px;
  color: var(--text-light);
  font-weight: 500;
  letter-spacing: 2px;
}

.loading-dots {
  display: flex;
  gap: 8px;
}

.loading-dots span {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: var(--secondary-color);
  animation: dotBounce 1.4s ease-in-out infinite;
}

.loading-dots span:nth-child(2) { animation-delay: 0.2s; }
.loading-dots span:nth-child(3) { animation-delay: 0.4s; }

@keyframes dotBounce {
  0%, 80%, 100% { transform: scale(0.6); opacity: 0.5; }
  40% { transform: scale(1); opacity: 1; }
}

/* ====== 分页 ====== */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 24px;
  margin-bottom: 48px;
  padding: 28px;
  background: linear-gradient(135deg, rgba(255,255,255,0.95), rgba(250,250,250,0.95));
  border-radius: var(--radius-lg);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  border: 1px solid var(--border-gold);
}

.page-btn {
  padding: 12px 24px;
  border: 2px solid var(--border-gold);
  background: white;
  border-radius: var(--radius-sm);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  color: var(--text-color);
  display: flex;
  align-items: center;
  gap: 6px;
  letter-spacing: 1px;
}

.page-btn:hover:not(:disabled) {
  border-color: var(--primary-color);
  color: var(--primary-color);
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.15);
}

.page-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.page-info-container {
  display: flex;
  align-items: baseline;
  gap: 8px;
  font-size: 15px;
  color: var(--text-light);
  padding: 8px 20px;
  background: linear-gradient(135deg, rgba(212, 175, 55, 0.08), rgba(200, 22, 29, 0.08));
  border-radius: var(--radius-sm);
  font-weight: 500;
}

.page-current {
  font-size: 24px;
  font-weight: 800;
  color: var(--primary-color);
}

.page-divider {
  color: var(--secondary-color);
  font-weight: 300;
}

.page-total {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-color);
}

.page-hint {
  font-size: 13px;
  color: var(--text-lighter);
}

/* ====== 空状态 ====== */
.empty-state {
  text-align: center;
  padding: 100px 0;
  background: linear-gradient(135deg, rgba(255,255,255,0.98), rgba(250,245,240,0.98));
  border-radius: var(--radius-xl);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.06);
  border: 1px solid var(--border-gold);
}

.empty-container {
  max-width: 400px;
  margin: 0 auto;
}

.empty-icon {
  font-size: 80px;
  margin-bottom: 20px;
  animation: float 3s ease-in-out infinite;
}

.empty-state h2 {
  font-size: 24px;
  color: var(--text-color);
  margin-bottom: 12px;
  font-weight: 600;
  letter-spacing: 2px;
}

.empty-state p {
  font-size: 16px;
  color: var(--text-light);
  margin-bottom: 24px;
}

.empty-suggestions {
  display: flex;
  justify-content: center;
  gap: 12px;
  flex-wrap: wrap;
}

.suggestion-tag {
  padding: 8px 18px;
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.06), rgba(212, 175, 55, 0.06));
  border: 1.5px solid var(--border-gold);
  border-radius: 20px;
  font-size: 13px;
  color: var(--text-light);
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.suggestion-tag:hover {
  background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
  color: white;
  border-color: transparent;
  transform: translateY(-2px);
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
@keyframes spin {
  to { transform: rotate(360deg); }
}

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
  .food-grid {
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  }

  .culture-cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .container {
    padding: 0 16px;
  }

  .filter-content {
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
    margin-left: 0;
    width: 100%;
  }

  .search-box input {
    flex: 1;
    width: 100%;
  }

  .food-grid {
    grid-template-columns: 1fr;
  }

  .culture-cards {
    grid-template-columns: 1fr;
  }

  .pagination {
    flex-wrap: wrap;
    gap: 16px;
    padding: 20px;
  }
}

@media (max-width: 480px) {
  .content-tags {
    flex-direction: column;
    gap: 10px;
    align-items: center;
  }

  .filter-header {
    flex-direction: column;
    gap: 12px;
    align-items: flex-start;
  }
}
</style>
