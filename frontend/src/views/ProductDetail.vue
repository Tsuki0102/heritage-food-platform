<template>
  <div class="product-detail">
    <Header />

    <div class="container" v-if="product">
      <div class="breadcrumb">
        <router-link to="/shop">商城</router-link>
        <span class="separator">/</span>
        <span class="current">{{ product.name }}</span>
      </div>

      <div class="product-main">
        <div class="product-gallery">
          <div class="main-image">
            <img :src="currentImage" :alt="product.name" @error="handleImageError" />
          </div>
          <div class="thumbnail-list" v-if="product.images && product.images.length > 0">
            <img
              v-for="(img, index) in product.images"
              :key="index"
              :src="img"
              :class="['thumbnail', { active: currentImage === img }]"
              @click="currentImage = img"
              @error="handleImageError"
            />
          </div>
        </div>

        <div class="product-info">
          <h1 class="product-name">{{ product.name }}</h1>

          <div class="product-description">
            <p>{{ product.description }}</p>
          </div>

          <div class="product-price">
            <span class="current-price">¥{{ product.price }}</span>
            <span class="original-price" v-if="product.originalPrice">
              ¥{{ product.originalPrice }}
            </span>
          </div>

          <div class="product-meta">
            <div class="meta-item">
              <span class="label">销量</span>
              <span class="value">{{ product.salesCount }}</span>
            </div>
            <div class="meta-item">
              <span class="label">评分</span>
              <span class="value rating">★ {{ product.rating }}</span>
            </div>
            <div class="meta-item">
              <span class="label">库存</span>
              <span class="value">{{ product.stock }}</span>
            </div>
          </div>

          <div class="quantity-selector">
            <span class="label">数量</span>
            <div class="quantity-control">
              <button class="qty-btn" @click="decreaseQty">-</button>
              <input
                type="number"
                v-model.number="quantity"
                min="1"
                :max="product.stock"
                @change="validateQuantity"
              />
              <button class="qty-btn" @click="increaseQty">+</button>
            </div>
          </div>

          <div class="product-actions">
            <button class="buy-now-btn" @click="handleBuyNow">立即购买</button>
            <button class="add-cart-btn" @click="handleAddToCart">加入购物车</button>
          </div>

          <div class="product-service">
            <div class="service-item">
              <span class="icon">✓</span>
              <span>正品保证</span>
            </div>
            <div class="service-item">
              <span class="icon">✓</span>
              <span>极速发货</span>
            </div>
            <div class="service-item">
              <span class="icon">✓</span>
              <span>售后无忧</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useProductStore } from '../stores/productStore'
import { useCartStore } from '../stores/cartStore'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const productStore = useProductStore()
const cartStore = useCartStore()

const productId = Number(route.params.id)
const product = computed(() => productStore.currentProduct)
const quantity = ref(1)
const currentImage = ref('')

const currentImageIndex = ref(0)

const handleImageError = (event: Event) => {
  const target = event.target as HTMLImageElement
  target.src = '/images/beijing-duck.jpg'
}

const decreaseQty = () => {
  if (quantity.value > 1) {
    quantity.value--
  }
}

const increaseQty = () => {
  if (product.value && quantity.value < product.value.stock) {
    quantity.value++
  }
}

const validateQuantity = () => {
  if (product.value) {
    if (quantity.value < 1) {
      quantity.value = 1
    } else if (quantity.value > product.value.stock) {
      quantity.value = product.value.stock
    }
  }
}

const handleAddToCart = async () => {
  try {
    await cartStore.addItem(productId, quantity.value)
    ElMessage.success('已加入购物车')
  } catch (error) {
    ElMessage.error('加入购物车失败')
  }
}

const handleBuyNow = () => {
  router.push({
    path: '/order/create',
    query: {
      productId: productId.toString(),
      quantity: quantity.value.toString()
    }
  })
}

onMounted(async () => {
  try {
    await productStore.fetchProductById(productId)
    if (product.value) {
      currentImage.value = product.value.coverImage
    }
  } catch (error) {
    ElMessage.error('获取商品详情失败')
  }
})
</script>

<style scoped>
.product-detail {
  min-height: 100vh;
  background: var(--bg-color);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--spacing-md);
}

.breadcrumb {
  padding: var(--spacing-md) 0;
  font-size: 14px;
  color: var(--text-light);
}

.breadcrumb a {
  color: var(--text-color);
  text-decoration: none;
}

.breadcrumb a:hover {
  color: var(--primary-color);
}

.separator {
  margin: 0 var(--spacing-sm);
}

.breadcrumb .current {
  color: var(--text-lighter);
}

.product-main {
  display: grid;
  grid-template-columns: 400px 1fr;
  gap: var(--spacing-xl);
  background: var(--bg-white);
  border-radius: var(--radius-md);
  padding: var(--spacing-xl);
  margin-bottom: var(--spacing-xxl);
  box-shadow: var(--shadow);
}

.product-gallery {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-md);
}

.main-image {
  width: 100%;
  height: 400px;
  border-radius: var(--radius-sm);
  overflow: hidden;
  background: #f9f9f9;
}

.main-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.thumbnail-list {
  display: flex;
  gap: var(--spacing-sm);
  overflow-x: auto;
}

.thumbnail {
  width: 80px;
  height: 80px;
  border-radius: var(--radius-sm);
  cursor: pointer;
  object-fit: cover;
  border: 2px solid transparent;
  transition: var(--transition);
}

.thumbnail:hover {
  border-color: var(--primary-color);
}

.thumbnail.active {
  border-color: var(--primary-color);
}

.product-info {
  display: flex;
  flex-direction: column;
}

.product-name {
  font-size: 28px;
  margin-bottom: var(--spacing-md);
  color: var(--text-color);
}

.product-description {
  font-size: 14px;
  color: var(--text-light);
  line-height: 1.6;
  margin-bottom: var(--spacing-lg);
}

.product-price {
  display: flex;
  align-items: baseline;
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-lg);
  padding: var(--spacing-md);
  background: #fff5f5;
  border-radius: var(--radius-sm);
}

.current-price {
  font-size: 32px;
  font-weight: bold;
  color: var(--primary-color);
}

.original-price {
  font-size: 16px;
  color: var(--text-lighter);
  text-decoration: line-through;
}

.product-meta {
  display: flex;
  gap: var(--spacing-xl);
  margin-bottom: var(--spacing-lg);
  padding-bottom: var(--spacing-lg);
  border-bottom: 1px solid var(--border-color);
}

.meta-item {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.meta-item .label {
  font-size: 14px;
  color: var(--text-light);
}

.meta-item .value {
  font-size: 16px;
  font-weight: bold;
  color: var(--text-color);
}

.meta-item .value.rating {
  color: var(--secondary-color);
}

.quantity-selector {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-lg);
}

.quantity-selector .label {
  font-size: 14px;
  color: var(--text-color);
}

.quantity-control {
  display: flex;
  align-items: center;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-sm);
}

.qty-btn {
  width: 40px;
  height: 40px;
  border: none;
  background: #f5f5f5;
  cursor: pointer;
  font-size: 18px;
  transition: var(--transition);
}

.qty-btn:hover {
  background: #e5e5e5;
}

.quantity-control input {
  width: 60px;
  height: 40px;
  border: none;
  text-align: center;
  font-size: 16px;
  outline: none;
}

.product-actions {
  display: flex;
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-lg);
}

.buy-now-btn,
.add-cart-btn {
  flex: 1;
  padding: var(--spacing-md) var(--spacing-lg);
  border: none;
  border-radius: var(--radius-sm);
  font-size: 16px;
  cursor: pointer;
  transition: var(--transition);
}

.buy-now-btn {
  background: var(--secondary-color);
  color: white;
}

.buy-now-btn:hover {
  background: #e68a00;
}

.add-cart-btn {
  background: var(--primary-color);
  color: white;
}

.add-cart-btn:hover {
  background: #a8131a;
}

.product-service {
  display: flex;
  gap: var(--spacing-xl);
}

.service-item {
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
  font-size: 14px;
  color: var(--text-light);
}

.service-item .icon {
  color: var(--primary-color);
}

@media (max-width: 768px) {
  .product-main {
    grid-template-columns: 1fr;
  }

  .main-image {
    height: 300px;
  }

  .product-actions {
    flex-direction: column;
  }
}
</style>
