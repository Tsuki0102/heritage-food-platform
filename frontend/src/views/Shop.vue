<template>
  <div class="shop-page">
    <Header />

    <!-- 顶部横幅 - 使用公共组件 -->
    <BannerSection
      title="非遗美食商城"
      subtitle="精选非遗美食，传承千年味道，品味文化精髓"
      badge-icon="🏪"
      badge="官方商城"
      :duration="120"
    />

    <div class="container">
      <div class="shop-content">

        <!-- 筛选区域 -->
        <div class="filter-section">
          <!-- 分类标签 -->
          <div class="category-tabs">
            <button
              v-for="(cat, index) in categories"
              :key="cat.id"
              :class="['category-tab', { active: selectedCategory === cat.name }]"
              @click="handleCategoryChange(cat.name)"
            >
              <span class="tab-icon">{{ getCategoryIcon(index) }}</span>
              {{ cat.name }}
            </button>
          </div>

          <!-- 搜索栏 -->
          <div class="search-bar">
            <div class="search-input-wrapper">
              <span class="search-icon">🔍</span>
              <input
                v-model="searchKeyword"
                type="text"
                placeholder="搜索心仪的非遗美食..."
                @keyup.enter="handleSearch"
              />
            </div>
            <button class="search-btn btn-primary" @click="handleSearch">
              <span class="btn-icon">🔎</span>
              搜索
            </button>
          </div>

          <!-- 排序选项 -->
          <div class="sort-options">
            <label class="sort-label">
              <span class="label-icon">📊</span>
              排序方式：
            </label>
            <select class="sort-select" v-model="sortBy" @change="handleSortChange">
              <option value="default">默认排序</option>
              <option value="price-asc">价格从低到高</option>
              <option value="price-desc">价格从高到低</option>
              <option value="sales">销量优先</option>
              <option value="rating">评分最高</option>
            </select>
          </div>
        </div>

        <!-- 商品网格 -->
        <div class="products-grid" v-if="!loading && products.length > 0">
          <div
            v-for="product in products"
            :key="product.id"
            class="product-card"
            @click="navigateToProduct(product.id)"
          >
            <!-- 商品图片 -->
            <div class="product-image">
              <img :src="getProductImage(product.coverImage)" :alt="product.name" loading="lazy" />
              <div class="image-overlay">
                <div class="overlay-content">
                  <span class="view-detail">查看详情 →</span>
                </div>
              </div>
              <span class="product-tag" v-if="product.originalPrice">
                <span class="tag-icon">🏷️</span>
                特惠
              </span>
              <span class="hot-tag" v-if="product.salesCount > 100">
                <span class="tag-icon">🔥</span>
                热销
              </span>
            </div>

            <!-- 商品信息 -->
            <div class="product-info">
              <h3 class="product-name">{{ product.name }}</h3>
              <p class="product-desc">{{ product.description || '传承经典，匠心制作' }}</p>

              <div class="product-price">
                <span class="current-price">
                  <span class="price-symbol">¥</span>{{ product.price }}
                </span>
                <span class="original-price" v-if="product.originalPrice">
                  ¥{{ product.originalPrice }}
                </span>
              </div>

              <div class="product-meta">
                <div class="meta-item sales">
                  <span class="meta-icon">📦</span>
                  已售 {{ product.salesCount || 0 }}
                </div>
                <div class="meta-item rating">
                  <span class="stars">★★★★★</span>
                  <span class="rating-value">{{ product.rating || '5.0' }}</span>
                </div>
              </div>
            </div>

            <!-- 操作按钮 -->
            <div class="product-actions">
              <button class="add-cart-btn btn-primary" @click.stop="handleAddToCart(product)">
                <span class="btn-icon">🛒</span>
                加入购物车
              </button>
              <button class="favorite-btn" @click.stop="toggleFavorite(product.id)">
                <span class="icon">⭐</span>
              </button>
            </div>
          </div>
        </div>

        <!-- 加载状态 -->
        <div class="loading-state" v-if="loading">
          <div class="loading-container">
            <div class="loading-spinner"></div>
            <p class="loading-text">
              <span class="text-icon">🍜</span>
              正在加载精选美食...
            </p>
          </div>
        </div>

        <!-- 空状态 -->
        <div class="empty-state" v-if="!loading && products.length === 0">
          <div class="empty-container">
            <div class="empty-icon">🏪</div>
            <h3>暂无商品</h3>
            <p>该分类下暂时没有商品，请尝试其他分类或搜索关键词</p>
            <button class="reset-btn" @click="resetFilters">
              <span class="btn-icon">🔄</span>
              重置筛选条件
            </button>
          </div>
        </div>

        <!-- 分页 -->
        <div class="pagination" v-if="!loading && totalPages > 1">
          <button class="page-btn prev-btn" @click="handlePageChange(currentPage - 1)" :disabled="currentPage === 1">
            <span>◀</span> 上一页
          </button>
          <div class="page-info-container">
            <span class="page-current">{{ currentPage }}</span>
            <span class="page-divider">/</span>
            <span class="page-total">{{ totalPages }}</span>
          </div>
          <button class="page-btn next-btn" @click="handlePageChange(currentPage + 1)" :disabled="currentPage === totalPages">
            下一页 <span>▶</span>
          </button>
        </div>

        <!-- 底部文化展示区 -->
        <div class="culture-showcase">
          <div class="showcase-header">
            <h2 class="showcase-title">探索非遗美食文化</h2>
            <p class="showcase-subtitle">每一道美食，都是一段历史的故事</p>
          </div>
          <div class="culture-cards">
            <div class="culture-card">
              <div class="card-icon">🥟</div>
              <h4>传统工艺</h4>
              <p>古法手工制作，保留原汁原味</p>
            </div>
            <div class="culture-card">
              <div class="card-icon">🎋</div>
              <h4>天然食材</h4>
              <p>严选优质原料，健康无添加</p>
            </div>
            <div class="culture-card">
              <div class="card-icon">🏮</div>
              <h4>文化传承</h4>
              <p>百年老字号，代代相传</p>
            </div>
            <div class="culture-card">
              <div class="card-icon">🎁</div>
              <h4>精美包装</h4>
              <p>礼盒装送礼佳品，体面过人</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useProductStore } from '../stores/productStore'
import { useCartStore } from '../stores/cartStore'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'
import { ElMessage } from 'element-plus'
import type { Product } from '../types/product'

const router = useRouter()
const productStore = useProductStore()
const cartStore = useCartStore()

const searchKeyword = ref('')
const selectedCategory = ref('全部')
const currentPage = ref(1)
const pageSize = ref(12)
const sortBy = ref('default')
const loading = computed(() => productStore.loading)

const categories = ref([
  { id: 1, name: '全部' },
  { id: 2, name: '糕点' },
  { id: 3, name: '卤味' },
  { id: 4, name: '面食' },
  { id: 5, name: '腌制' },
  { id: 6, name: '糖果' }
])

const products = computed(() => productStore.products)
const totalPages = computed(() => productStore.pagination.totalPages)

// 获取分类图标
const getCategoryIcon = (index: number): string => {
  const icons = ['📋', '🧁', '🍖', '🍜', '🥩', '🍬']
  return icons[index] || '📦'
}

// 获取商品图片（处理错误图片）
const getProductImage = (coverImage: string | undefined): string => {
  if (!coverImage) {
    return '/images/beijing-duck.jpg'
  }
  return coverImage
}

// 导航到商品详情
const navigateToProduct = (id: number) => {
  router.push(`/product/${id}`)
}

// 切换分类
const handleCategoryChange = async (category: string) => {
  selectedCategory.value = category
  currentPage.value = 1
  await fetchProducts()
}

// 搜索
const handleSearch = async () => {
  currentPage.value = 1
  await fetchProducts()
}

// 排序变化
const handleSortChange = async () => {
  currentPage.value = 1
  // TODO: 实现排序逻辑
  await fetchProducts()
}

// 翻页
const handlePageChange = async (page: number) => {
  currentPage.value = page
  await fetchProducts()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

// 获取商品列表
const fetchProducts = async () => {
  try {
    if (searchKeyword.value) {
      await productStore.searchProducts(searchKeyword.value, currentPage.value, pageSize.value)
    } else if (selectedCategory.value && selectedCategory.value !== '全部') {
      await productStore.fetchProductsByCategory(selectedCategory.value, currentPage.value, pageSize.value)
    } else {
      await productStore.fetchProducts({
        page: currentPage.value,
        pageSize: pageSize.value
      })
    }
  } catch (error) {
    ElMessage.error('获取商品列表失败')
  }
}

// 加入购物车
const handleAddToCart = async (product: Product) => {
  try {
    await cartStore.addItem(product.id, 1)
    ElMessage.success({
      message: `✅ ${product.name} 已加入购物车`,
      duration: 2000,
      showClose: true
    })
  } catch (error) {
    ElMessage.error('加入购物车失败')
  }
}

// 切换收藏
const toggleFavorite = (productId: number) => {
  ElMessage.info('收藏功能开发中...')
}

// 重置筛选
const resetFilters = async () => {
  selectedCategory.value = '全部'
  searchKeyword.value = ''
  sortBy.value = 'default'
  currentPage.value = 1
  await fetchProducts()
}

onMounted(async () => {
  await fetchProducts()
})
</script>

<style scoped>
.shop-page {
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

.shop-content {
  margin: 40px 0 60px;
}

/* ====== 筛选区域 ====== */
.filter-section {
  display: flex;
  flex-direction: column;
  gap: 20px;
  margin-bottom: 36px;
  padding: 28px;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
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

/* 分类标签 */
.category-tabs {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  padding-bottom: 16px;
  border-bottom: 2px dashed rgba(212, 175, 55, 0.25);
}

.category-tab {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 22px;
  border: 2px solid var(--border-gold);
  background: white;
  color: var(--text-light);
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 0.5px;
  position: relative;
  overflow: hidden;
}

.category-tab::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
  transition: left 0.5s ease;
}

.category-tab:hover::before {
  left: 100%;
}

.tab-icon { font-size: 17px; }

.category-tab:hover {
  border-color: var(--primary-color);
  color: var(--primary-color);
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(200, 22, 29, 0.15);
}

.category-tab.active {
  background: var(--gradient-primary);
  border-color: var(--primary-color);
  color: white;
  font-weight: 700;
  box-shadow: 0 6px 20px rgba(200, 22, 29, 0.35);
  transform: scale(1.05);
}

/* 搜索栏 */
.search-bar {
  display: flex;
  gap: 14px;
  align-items: stretch;
}

.search-input-wrapper {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 13px 20px;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-sm);
  background: white;
  transition: all 0.3s ease;
}

.search-input-wrapper:focus-within {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.1);
}

.search-icon { font-size: 18px; }

.search-input-wrapper input {
  flex: 1;
  border: none;
  outline: none;
  font-size: 15px;
  background: transparent;
  color: var(--text-color);
}

.search-input-wrapper input::placeholder {
  color: var(--text-lighter);
  font-style: italic;
}

.search-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 14px 28px;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 1px;
  white-space: nowrap;
}

.btn-icon { font-size: 16px; }

/* 排序选项 */
.sort-options {
  display: flex;
  align-items: center;
  gap: 12px;
  padding-top: 16px;
  border-top: 2px dashed rgba(212, 175, 55, 0.25);
}

.sort-label {
  font-size: 14px;
  color: var(--text-light);
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 6px;
  letter-spacing: 1px;
}

.label-icon { font-size: 16px; }

.sort-select {
  padding: 10px 18px;
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

.sort-select:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.1);
}

/* ====== 商品网格 ====== */
.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 28px;
  margin-bottom: 48px;
}

/* ====== 商品卡片 ====== */
.product-card {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  overflow: hidden;
  box-shadow: var(--shadow-md);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  border: 1px solid var(--border-gold);
  position: relative;
}

.product-card::before {
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

.product-card:hover {
  transform: translateY(-10px);
  box-shadow: var(--shadow-lg);
  border-color: var(--border-gold-hover);
}

.product-card:hover::before {
  opacity: 1;
}

.product-image {
  position: relative;
  width: 100%;
  height: 240px;
  overflow: hidden;
}

.product-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.product-card:hover .product-image img {
  transform: scale(1.08);
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.85), rgba(168, 19, 26, 0.9));
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: all 0.4s ease;
}

.product-card:hover .image-overlay {
  opacity: 1;
}

.overlay-content {
  text-align: center;
  color: white;
}

.view-detail {
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 2px;
  animation: pulseText 1.5s ease-in-out infinite;
}

@keyframes pulseText {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}

.product-tag,
.hot-tag {
  position: absolute;
  top: 14px;
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 12px;
  color: white;
  font-weight: 700;
  letter-spacing: 0.5px;
  display: flex;
  align-items: center;
  gap: 5px;
  z-index: 2;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.product-tag {
  left: 14px;
  background: linear-gradient(135deg, #ff6b35, #ff4444);
}

.hot-tag {
  right: 14px;
  background: linear-gradient(135deg, #ff4444, #cc0000);
  animation: hotPulse 2s ease-in-out infinite;
}

@keyframes hotPulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}

.tag-icon { font-size: 13px; }

/* 商品信息 */
.product-info {
  padding: 22px;
}

.product-name {
  font-size: 18px;
  margin-bottom: 10px;
  color: var(--text-color);
  font-weight: 700;
  line-height: 1.4;
  letter-spacing: 0.5px;
  transition: color 0.3s ease;
}

.product-card:hover .product-name {
  color: var(--primary-color);
}

.product-desc {
  font-size: 13px;
  color: var(--text-light);
  margin-bottom: 14px;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.product-price {
  display: flex;
  align-items: baseline;
  gap: 10px;
  margin-bottom: 14px;
  padding: 10px 14px;
  background: linear-gradient(135deg, rgba(200,22,29,0.04), rgba(212,175,55,0.04));
  border-radius: var(--radius-xs);
}

.current-price {
  font-size: 26px;
  font-weight: 800;
  color: var(--primary-color);
  letter-spacing: 0.5px;
}

.price-symbol {
  font-size: 18px;
  font-weight: 700;
}

.original-price {
  font-size: 15px;
  color: var(--text-lighter);
  text-decoration: line-through;
  font-weight: 500;
}

.product-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  color: var(--text-light);
  padding-top: 12px;
  border-top: 1px solid rgba(212, 175, 55, 0.2);
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-weight: 500;
}

.meta-icon { font-size: 14px; }

.stars {
  color: var(--secondary-color);
  font-size: 11px;
  letter-spacing: 2px;
}

.rating-value {
  font-weight: 700;
  color: var(--secondary-color);
  font-size: 14px;
}

/* 操作按钮 */
.product-actions {
  display: flex;
  gap: 12px;
  padding: 18px 22px;
  border-top: 1.5px solid rgba(212, 175, 55, 0.2);
}

.add-cart-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 13px 20px;
  font-size: 14px;
  font-weight: 700;
  letter-spacing: 1px;
  border-radius: var(--radius-sm);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.add-cart-btn:hover:not(:disabled) {
  transform: translateY(-2px) scale(1.02);
  box-shadow: 0 8px 24px rgba(200, 22, 29, 0.35);
}

.favorite-btn {
  width: 46px;
  height: 46px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid var(--border-gold);
  background: white;
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 20px;
}

.favorite-btn:hover {
  border-color: var(--secondary-color);
  background: linear-gradient(135deg, rgba(212,175,55,0.1), rgba(200,22,29,0.06));
  transform: scale(1.1) rotate(10deg);
}

.favorite-btn .icon {
  transition: all 0.3s ease;
}

.favorite-btn:hover .icon {
  transform: scale(1.2);
}

/* ====== 加载状态 ====== */
.loading-state {
  text-align: center;
  padding: 80px 20px;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  margin-bottom: 48px;
}

.loading-container {
  max-width: 400px;
  margin: 0 auto;
}

.loading-spinner {
  width: 56px;
  height: 56px;
  border: 4px solid rgba(212, 175, 55, 0.2);
  border-top-color: var(--primary-color);
  border-right-color: var(--secondary-color);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 24px;
  box-shadow: 0 4px 16px rgba(200, 22, 29, 0.15);
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-text {
  font-size: 16px;
  color: var(--text-light);
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.text-icon { font-size: 24px; animation: bounce 2s ease-in-out infinite; }

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

/* ====== 空状态 ====== */
.empty-state {
  text-align: center;
  padding: 80px 20px;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  margin-bottom: 48px;
}

.empty-container {
  max-width: 450px;
  margin: 0 auto;
}

.empty-icon {
  font-size: 80px;
  margin-bottom: 20px;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-15px); }
}

.empty-state h3 {
  font-size: 24px;
  color: var(--text-color);
  margin-bottom: 12px;
  font-weight: 700;
  letter-spacing: 2px;
}

.empty-state p {
  font-size: 15px;
  color: var(--text-light);
  margin-bottom: 28px;
  line-height: 1.6;
}

.reset-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 28px;
  border: 2px solid var(--border-gold);
  background: white;
  color: var(--text-color);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 1px;
}

.reset-btn:hover {
  border-color: var(--primary-color);
  color: var(--primary-color);
  background: rgba(200, 22, 29, 0.05);
  transform: translateY(-2px);
}

/* ====== 分页 ====== */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 28px;
  margin-bottom: 52px;
  padding: 28px;
  background: linear-gradient(135deg, rgba(255,255,255,0.95), rgba(250,250,250,0.95));
  border-radius: var(--radius-lg);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  border: 1px solid var(--border-gold);
}

.page-btn {
  padding: 12px 26px;
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
  font-size: 26px;
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

/* ====== 文化展示区 ====== */
.culture-showcase {
  margin-bottom: 40px;
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

@keyframes iconPulse {
  0%, 100% { transform: scale(1) rotate(0deg); }
  50% { transform: scale(1.1) rotate(5deg); }
}

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

/* 响应式设计 */
@media (max-width: 1024px) {
  .products-grid {
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 24px;
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
    padding: 20px;
  }

  .search-bar {
    flex-direction: column;
  }

  .sort-options {
    flex-direction: column;
    align-items: stretch;
    gap: 10px;
  }

  .products-grid {
    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
    gap: 16px;
  }

  .product-image {
    height: 180px;
  }

  .product-info {
    padding: 16px;
  }

  .product-name {
    font-size: 16px;
  }

  .current-price {
    font-size: 22px;
  }

  .product-actions {
    flex-direction: column;
    gap: 10px;
  }

  .add-cart-btn {
    width: 100%;
  }

  .favorite-btn {
    width: 100%;
    justify-content: center;
  }

  .culture-cards {
    grid-template-columns: 1fr;
  }

  .pagination {
    flex-direction: column;
    gap: 16px;
    padding: 20px;
  }
}
</style>
