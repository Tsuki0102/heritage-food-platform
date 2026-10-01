<template>
  <div class="cart-page">
    <Header />

    <!-- 顶部横幅 -->
    <BannerSection
      title="我的购物车"
      subtitle="精选非遗美食商品，传承千年美味"
      badge-icon="🛒"
      badge="购物车"
    />

    <div class="container">
      <div class="cart-content" v-if="!cartStore.isEmpty">
        <div class="cart-items">
          <div class="cart-header">
            <label class="select-all">
              <input
                type="checkbox"
                v-model="selectAll"
                @change="handleSelectAll"
              />
              <span class="select-text">全选</span>
            </label>
            <button class="clear-btn" @click="handleClearCart">
              <span class="btn-icon">🗑️</span>
              清空购物车
            </button>
          </div>

          <div
            v-for="item in cartStore.items"
            :key="item.id"
            class="cart-item"
          >
            <div class="item-select">
              <input
                type="checkbox"
                v-model="selectedItems"
                :value="item.id"
                @change="handleItemSelect"
              />
            </div>

            <div class="item-image">
              <img :src="item.product?.coverImage" :alt="item.product?.name" @error="handleImageError" />
            </div>

            <div class="item-info">
              <h3 class="item-name">{{ item.product?.name }}</h3>
              <p class="item-price">¥{{ item.product?.price }}</p>
            </div>

            <div class="item-quantity">
              <button class="qty-btn" @click="handleDecrement(item)">−</button>
              <input
                type="number"
                v-model.number="item.quantity"
                min="1"
                :max="item.product?.stock || 1"
                @change="handleQuantityChange(item)"
              />
              <button class="qty-btn" @click="handleIncrement(item)">+</button>
            </div>

            <div class="item-subtotal">
              <span class="subtotal-label">小计：</span>
              <span class="subtotal-value">¥{{ ((item.product?.price || 0) * item.quantity).toFixed(2) }}</span>
            </div>

            <div class="item-actions">
              <button class="delete-btn" @click="handleRemoveItem(item.id)">
                <span>🗑️</span> 删除
              </button>
            </div>
          </div>
        </div>

        <div class="cart-summary">
          <div class="summary-header">
            <h3>
              <span class="header-icon">💰</span>
              订单摘要
            </h3>
          </div>
          <div class="summary-info">
            <div class="summary-row">
              <span class="row-label">
                <span class="label-icon">📦</span>
                商品件数
              </span>
              <span class="row-value">{{ selectedCount }} 件</span>
            </div>
            <div class="summary-row total-row">
              <span class="row-label">
                <span class="label-icon">💎</span>
                商品总价
              </span>
              <span class="total-price">¥{{ selectedTotal.toFixed(2) }}</span>
            </div>
          </div>

          <div class="summary-actions">
            <button class="continue-shopping-btn" @click="router.push('/shop')">
              <span class="btn-icon">🛍️</span>
              继续购物
            </button>
            <button
              class="checkout-btn btn-primary"
              :disabled="selectedCount === 0"
              @click="handleCheckout"
            >
              <span class="btn-icon">✅</span>
              去结算
            </button>
          </div>
        </div>
      </div>

      <div class="empty-cart" v-else>
        <div class="empty-container">
          <div class="empty-icon">🛒</div>
          <h2>购物车是空的</h2>
          <p>快去挑选心仪的非遗美食吧</p>
          <div class="empty-suggestions">
            <span class="suggestion-tag">🍜 探索美食</span>
            <span class="suggestion-tag">🏪 浏览店铺</span>
            <span class="suggestion-tag">⭐ 查看推荐</span>
          </div>
          <button class="go-shopping-btn btn-primary" @click="router.push('/shop')">
            <span class="btn-icon">🚀</span>
            去商城逛逛
          </button>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCartStore } from '../stores/cartStore'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { CartItem } from '../types/cart'

const router = useRouter()
const cartStore = useCartStore()

const selectedItems = ref<number[]>([])
const selectAll = ref(false)

const selectedCount = computed(() => {
  return cartStore.items
    .filter(item => selectedItems.value.includes(item.id))
    .reduce((sum, item) => sum + item.quantity, 0)
})

const selectedTotal = computed(() => {
  return cartStore.items
    .filter(item => selectedItems.value.includes(item.id))
    .reduce((sum, item) => sum + (item.product?.price || 0) * item.quantity, 0)
})

const handleSelectAll = () => {
  if (selectAll.value) {
    selectedItems.value = cartStore.items.map(item => item.id)
  } else {
    selectedItems.value = []
  }
}

const handleItemSelect = () => {
  selectAll.value = selectedItems.value.length === cartStore.items.length
}

const handleIncrement = async (item: CartItem) => {
  if (item.product && item.quantity < item.product.stock) {
    try {
      await cartStore.updateItem(item.id, item.quantity + 1)
    } catch (error) {
      ElMessage.error('更新数量失败')
    }
  }
}

const handleDecrement = async (item: CartItem) => {
  if (item.quantity > 1) {
    try {
      await cartStore.updateItem(item.id, item.quantity - 1)
    } catch (error) {
      ElMessage.error('更新数量失败')
    }
  }
}

const handleQuantityChange = async (item: CartItem) => {
  if (item.quantity < 1) {
    item.quantity = 1
  } else if (item.product && item.quantity > item.product.stock) {
    item.quantity = item.product.stock
  }
  try {
    await cartStore.updateItem(item.id, item.quantity)
  } catch (error) {
    ElMessage.error('更新数量失败')
  }
}

const handleRemoveItem = async (id: number) => {
  try {
    await ElMessageBox.confirm('确定要从购物车中删除该商品吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await cartStore.removeItem(id)
    selectedItems.value = selectedItems.value.filter(itemId => itemId !== id)
    ElMessage.success('删除成功')
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const handleClearCart = async () => {
  try {
    await ElMessageBox.confirm('确定要清空购物车吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await cartStore.clearAll()
    selectedItems.value = []
    selectAll.value = false
    ElMessage.success('清空成功')
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('清空失败')
    }
  }
}

const handleCheckout = () => {
  if (selectedItems.value.length === 0) {
    ElMessage.warning('请选择要结算的商品')
    return
  }
  const selectedIds = selectedItems.value.join(',')
  router.push({
    path: '/order/create',
    query: { cartItems: selectedIds }
  })
}

const handleImageError = (event: Event) => {
  const target = event.target as HTMLImageElement
  target.src = '/images/beijing-duck.jpg'
}

onMounted(async () => {
  try {
    await cartStore.fetchCartList()
    selectedItems.value = cartStore.items.map(item => item.id)
    selectAll.value = cartStore.items.length > 0
  } catch (error) {
    ElMessage.error('获取购物车失败')
  }
})
</script>

<style scoped>
.cart-page {
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

/* ====== 购物车内容 ====== */
.cart-content {
  display: grid;
  grid-template-columns: 1fr 360px;
  gap: 32px;
  margin-top: 40px;
  animation: fadeIn 0.5s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.cart-items {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  padding: 28px;
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
}

.cart-items::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

.cart-items:hover {
  box-shadow: var(--shadow-lg);
}

.cart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 20px;
  border-bottom: 2px dashed rgba(212, 175, 55, 0.25);
  margin-bottom: 24px;
}

.select-all {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  font-size: 15px;
  font-weight: 600;
  color: var(--text-color);
  transition: all 0.3s ease;
  padding: 8px 16px;
  border-radius: var(--radius-sm);
}

.select-all:hover {
  color: var(--primary-color);
  background: rgba(200, 22, 29, 0.04);
}

.select-all input {
  cursor: pointer;
  width: 18px;
  height: 18px;
  accent-color: var(--primary-color);
}

.select-text { letter-spacing: 1px; }

.clear-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  background: none;
  border: 2px solid var(--border-gold);
  color: var(--text-light);
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
  padding: 8px 18px;
  border-radius: var(--radius-sm);
  font-weight: 500;
}

.clear-btn:hover {
  color: var(--primary-color);
  background: rgba(200, 22, 29, 0.05);
  border-color: var(--primary-color);
  transform: translateY(-2px);
}

.btn-icon { font-size: 16px; }

/* ====== 购物车商品项 ====== */
.cart-item {
  display: grid;
  grid-template-columns: 40px 100px 1fr 130px 120px 90px;
  gap: 20px;
  align-items: center;
  padding: 20px 0;
  border-bottom: 1px solid rgba(212, 175, 55, 0.15);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}

.cart-item::before {
  content: '';
  position: absolute;
  left: -20px;
  right: -20px;
  top: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(200,22,29,0.02), rgba(212,175,55,0.02));
  border-radius: var(--radius-sm);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.cart-item:hover::before {
  opacity: 1;
}

.cart-item:hover {
  transform: translateX(6px);
  border-radius: var(--radius-sm);
  padding-left: 24px;
  padding-right: 24px;
  margin-left: -24px;
  margin-right: -24px;
}

.cart-item:last-child { border-bottom: none; }

.item-select input {
  cursor: pointer;
  width: 18px;
  height: 18px;
  accent-color: var(--primary-color);
}

.item-image {
  width: 100px;
  height: 100px;
  border-radius: var(--radius-md);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
  position: relative;
  z-index: 1;
}

.item-image:hover {
  transform: scale(1.08) rotate(2deg);
  box-shadow: var(--shadow-md);
}

.item-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.item-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
  position: relative;
  z-index: 1;
}

.item-name {
  font-size: 17px;
  color: var(--text-color);
  font-weight: 600;
  line-height: 1.4;
  transition: all 0.3s ease;
  letter-spacing: 0.5px;
}

.cart-item:hover .item-name {
  color: var(--primary-color);
}

.item-price {
  font-size: 15px;
  color: var(--secondary-color);
  font-weight: 700;
  display: flex;
  align-items: center;
}

/* ====== 数量控制 ====== */
.item-quantity {
  display: flex;
  align-items: center;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-md);
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  position: relative;
  z-index: 1;
}

.qty-btn {
  width: 38px;
  height: 38px;
  border: none;
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 18px;
  font-weight: 600;
  color: var(--text-color);
  display: flex;
  align-items: center;
  justify-content: center;
}

.qty-btn:hover {
  background: var(--gradient-primary);
  color: white;
  transform: scale(1.05);
}

.item-quantity input {
  width: 54px;
  height: 38px;
  border: none;
  text-align: center;
  font-size: 15px;
  outline: none;
  background: white;
  color: var(--text-color);
  font-weight: 600;
}

/* ====== 小计 ====== */
.item-subtotal {
  font-size: 18px;
  font-weight: 700;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  justify-content: center;
  gap: 4px;
  position: relative;
  z-index: 1;
}

.subtotal-label {
  font-size: 12px;
  color: var(--text-lighter);
  font-weight: 500;
}

.subtotal-value {
  font-size: 20px;
  color: var(--primary-color);
  letter-spacing: 0.5px;
}

/* ====== 删除按钮 ====== */
.delete-btn {
  display: flex;
  align-items: center;
  gap: 5px;
  background: none;
  border: 2px solid transparent;
  color: var(--text-light);
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 13px;
  padding: 8px 14px;
  border-radius: var(--radius-sm);
  font-weight: 500;
  position: relative;
  z-index: 1;
}

.delete-btn:hover {
  color: #f44336;
  background: rgba(244, 67, 54, 0.06);
  border-color: #f44336;
  transform: scale(1.05);
}

/* ====== 订单摘要 ====== */
.cart-summary {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  padding: 28px;
  box-shadow: var(--shadow-md);
  height: fit-content;
  position: sticky;
  top: 80px;
  transition: all 0.3s ease;
  border: 1px solid var(--border-gold);
  position: relative;
  overflow: hidden;
}

.cart-summary::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--secondary-color), var(--primary-color), var(--secondary-color));
}

.cart-summary:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-4px);
}

.summary-header {
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 2px dashed rgba(212, 175, 55, 0.25);
}

.summary-header h3 {
  font-size: 19px;
  color: var(--text-color);
  margin: 0;
  font-weight: 700;
  letter-spacing: 2px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-icon { font-size: 24px; animation: iconPulse 3s ease-in-out infinite; }

@keyframes iconPulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.15) rotate(5deg); }
}

.summary-info {
  margin-bottom: 28px;
  padding-bottom: 24px;
  border-bottom: 1px solid rgba(212, 175, 55, 0.15);
}

.summary-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 14px;
  font-size: 15px;
  padding: 8px 12px;
  border-radius: var(--radius-xs);
  transition: all 0.3s ease;
}

.summary-row:hover {
  background: rgba(212, 175, 55, 0.04);
}

.row-label {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--text-light);
  font-weight: 500;
}

.label-icon { font-size: 16px; }

.row-value {
  color: var(--text-color);
  font-weight: 600;
}

.total-row {
  background: linear-gradient(135deg, rgba(200,22,29,0.04), rgba(212,175,55,0.04));
  padding: 16px 20px;
  border-radius: var(--radius-sm);
  margin-bottom: 0;
}

.total-row .row-label {
  font-weight: 700;
  color: var(--text-color);
  font-size: 16px;
}

.total-price {
  font-size: 30px !important;
  font-weight: 800 !important;
  color: var(--primary-color) !important;
  letter-spacing: 1px;
  text-shadow: 2px 2px 4px rgba(200, 22, 29, 0.15);
}

/* ====== 操作按钮 ====== */
.summary-actions {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.continue-shopping-btn,
.go-shopping-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 14px 24px;
  border: 2px solid var(--border-gold);
  background: white;
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-size: 15px;
  font-weight: 600;
  color: var(--text-color);
  text-align: center;
  box-shadow: var(--shadow-sm);
  letter-spacing: 1px;
}

.continue-shopping-btn:hover,
.go-shopping-btn:not(.btn-primary):hover {
  border-color: var(--primary-color);
  color: var(--primary-color);
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.15);
}

.checkout-btn {
  padding: 16px 28px;
  font-size: 17px;
  font-weight: 700;
  letter-spacing: 2px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.checkout-btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 12px 28px rgba(200, 22, 29, 0.4);
}

.checkout-btn:disabled {
  opacity: 0.45;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

/* ====== 空购物车 ====== */
.empty-cart {
  text-align: center;
  padding: 80px 20px;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  margin-top: 40px;
  border: 1px solid var(--border-gold);
  animation: fadeIn 0.5s ease-out;
  position: relative;
  overflow: hidden;
}

.empty-cart::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

.empty-container {
  max-width: 450px;
  margin: 0 auto;
}

.empty-icon {
  font-size: 100px;
  margin-bottom: 24px;
  animation: bounce 2s ease-in-out infinite;
  filter: drop-shadow(0 4px 12px rgba(200, 22, 29, 0.15));
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-15px); }
}

.empty-cart h2 {
  font-size: 26px;
  color: var(--text-color);
  margin-bottom: 12px;
  font-weight: 700;
  letter-spacing: 2px;
}

.empty-cart p {
  font-size: 16px;
  color: var(--text-light);
  margin-bottom: 28px;
  line-height: 1.6;
}

.empty-suggestions {
  display: flex;
  justify-content: center;
  gap: 12px;
  flex-wrap: wrap;
  margin-bottom: 32px;
}

.suggestion-tag {
  padding: 8px 18px;
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.06), rgba(212, 175, 55, 0.06));
  border: 1.5px solid var(--border-gold);
  border-radius: 20px;
  font-size: 13px;
  color: var(--text-light);
  font-weight: 500;
  cursor: default;
  transition: all 0.3s ease;
}

.suggestion-tag:hover {
  background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
  color: white;
  border-color: transparent;
  transform: translateY(-3px);
}

.go-shopping-btn {
  padding: 16px 40px;
  font-size: 17px;
  font-weight: 700;
  letter-spacing: 2px;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .cart-content {
    grid-template-columns: 1fr;
  }

  .cart-summary {
    position: static;
  }
}

@media (max-width: 768px) {
  .container {
    padding: 0 16px;
  }

  .cart-item {
    grid-template-columns: 40px 80px 1fr;
    grid-template-rows: auto auto auto;
    gap: 14px;
    padding: 16px 0;
  }

  .item-image {
    width: 80px;
    height: 80px;
  }

  .item-quantity {
    grid-column: 2 / 4;
    justify-self: start;
  }

  .item-subtotal {
    grid-column: 2 / 4;
    flex-direction: row;
    gap: 8px;
  }

  .item-actions {
    grid-column: 2 / 4;
    justify-self: start;
  }

  .cart-items {
    padding: 20px;
  }

  .cart-summary {
    padding: 24px;
  }
}
</style>
