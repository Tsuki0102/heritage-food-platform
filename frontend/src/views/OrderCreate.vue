<template>
  <div class="order-create-page">
    <Header />

    <!-- 页面横幅 -->
    <BannerSection
      title="确认订单"
      subtitle="请核对您的订单信息并完成支付"
      badge-icon="🧾"
      badge="订单确认"
    />

    <div class="container">
      <!-- 订单内容 -->
      <div class="order-content" v-if="!loading">
        <div class="order-main">
          <!-- 收货地址区域 -->
          <div class="section-card address-section" v-if="!isBuyNow">
            <div class="card-header">
              <span class="header-icon">📍</span>
              <h3 class="header-title">收货地址</h3>
            </div>

            <div class="address-list" v-if="addresses.length > 0">
              <div
                v-for="addr in addresses"
                :key="addr.id"
                :class="['address-card', { selected: selectedAddress?.id === addr.id }]"
                @click="selectedAddress = addr"
              >
                <div class="address-left">
                  <span class="user-icon">👤</span>
                  <div class="address-info">
                    <p class="receiver">
                      {{ addr.receiverName }}
                      <span class="phone">{{ addr.receiverPhone }}</span>
                      <span v-if="addr.isDefault" class="default-badge">默认</span>
                    </p>
                    <p class="detail">
                      <span class="location-icon">📍</span>
                      {{ addr.province }} {{ addr.city }} {{ addr.district }} {{ addr.detail }}
                    </p>
                  </div>
                </div>
                <div class="address-right">
                  <span class="check-icon">✓</span>
                </div>
              </div>
            </div>

            <button class="add-address-btn" @click="showAddressDialog = true">
              <span class="btn-icon">➕</span>
              添加新地址
            </button>
          </div>

          <!-- 商品信息区域 -->
          <div class="section-card product-section">
            <div class="card-header">
              <span class="header-icon">🛍️</span>
              <h3 class="header-title">商品信息</h3>
              <span class="item-count">{{ orderItems.length }}件商品</span>
            </div>

            <div class="product-list">
              <div
                v-for="(item, index) in orderItems"
                :key="item.id"
                :class="['product-item', { 'item-first': index === 0, 'item-last': index === orderItems.length - 1 }]"
              >
                <div class="item-image-area">
                  <img :src="item.coverImage || item.product?.coverImage" :alt="item.name || item.product?.name" @error="handleImageError" />
                  <div class="image-overlay">查看详情 →</div>
                </div>

                <div class="item-info">
                  <h4 class="item-name">{{ item.name || item.product?.name }}</h4>
                  <p class="item-price">
                    <span class="price-icon">💰</span>
                    ¥{{ (item.price || item.product?.price).toFixed(2) }}
                  </p>
                </div>

                <div class="item-quantity">
                  <span class="quantity-label">数量</span>
                  <span class="quantity-value">x{{ item.quantity }}</span>
                </div>

                <div class="item-subtotal">
                  <span class="subtotal-label">小计</span>
                  <span class="subtotal-value">¥{{ ((item.price || item.product?.price || 0) * item.quantity).toFixed(2) }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 订单备注区域 -->
          <div class="section-card remark-section">
            <div class="card-header">
              <span class="header-icon">📝</span>
              <h3 class="header-title">订单备注</h3>
            </div>

            <textarea
              v-model="remark"
              placeholder="请输入订单备注（选填），如：不要辣、多放葱花等..."
              rows="4"
              class="remark-textarea"
            ></textarea>
          </div>

          <!-- 支付方式区域 -->
          <div class="section-card payment-section">
            <div class="card-header">
              <span class="header-icon">💳</span>
              <h3 class="header-title">支付方式</h3>
            </div>

            <div class="payment-methods">
              <div
                v-for="method in paymentMethods"
                :key="method.value"
                :class="['payment-method', { selected: selectedPayment === method.value, [`method-${method.value}`]: true }]"
                @click="selectedPayment = method.value"
              >
                <span class="method-icon">{{ method.icon }}</span>
                <span class="method-name">{{ method.name }}</span>
                <span class="method-check" v-if="selectedPayment === method.value">✓</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 订单金额摘要 -->
        <div class="order-summary-card">
          <div class="summary-header">
            <span class="summary-icon">💰</span>
            <h3 class="summary-title">订单金额</h3>
          </div>

          <div class="summary-body">
            <div class="summary-row">
              <span class="row-label">
                <span class="label-icon">🛒</span>
                商品总价
              </span>
              <span class="row-value">¥{{ totalAmount.toFixed(2) }}</span>
            </div>

            <div class="summary-row">
              <span class="row-label">
                <span class="label-icon">🚚</span>
                运费
              </span>
              <span :class="['row-value', { 'free-shipping': shippingFee === 0 }]">
                {{ shippingFee === 0 ? '免运费' : `¥${shippingFee.toFixed(2)}` }}
              </span>
            </div>

            <div class="divider"></div>

            <div class="summary-row total-row">
              <span class="total-label">实付金额</span>
              <span class="total-price">¥{{ (totalAmount + shippingFee).toFixed(2) }}</span>
            </div>
          </div>

          <button
            class="submit-order-btn btn-primary"
            :disabled="isSubmitting"
            @click="handleSubmitOrder"
          >
            <template v-if="isSubmitting">
              <span class="btn-loading"></span>
              提交中...
            </template>
            <template v-else>
              <span class="btn-icon">💳</span>
              提交订单
            </template>
          </button>

          <p class="security-tip">
            <span class="tip-icon">🔒</span>
            您的支付信息安全受保护
          </p>
        </div>
      </div>

      <!-- 加载状态 -->
      <div class="loading-state" v-else>
        <div class="loader-container">
          <div class="loader"></div>
          <p class="loading-text">正在加载订单信息...</p>
        </div>
      </div>
    </div>

    <Footer />

    <!-- 添加地址弹窗 -->
    <el-dialog
      v-model="showAddressDialog"
      title="添加收货地址"
      width="520px"
      class="address-dialog"
      :close-on-click-modal="false"
    >
      <el-form :model="addressForm" label-width="90px" class="address-form">
        <el-form-item label="收货人">
          <el-input v-model="addressForm.receiverName" placeholder="请输入收货人姓名" />
        </el-form-item>
        <el-form-item label="联系电话">
          <el-input v-model="addressForm.receiverPhone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="省份">
          <el-input v-model="addressForm.province" placeholder="请输入省份" />
        </el-form-item>
        <el-form-item label="城市">
          <el-input v-model="addressForm.city" placeholder="请输入城市" />
        </el-form-item>
        <el-form-item label="区县">
          <el-input v-model="addressForm.district" placeholder="请输入区县" />
        </el-form-item>
        <el-form-item label="详细地址">
          <el-input v-model="addressForm.detail" type="textarea" :rows="2" placeholder="请输入详细地址" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="showAddressDialog = false" size="large">取消</el-button>
          <el-button type="primary" @click="handleAddAddress" size="large" class="confirm-btn">
            ✓ 确定
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useCartStore } from '../stores/cartStore'
import { useOrderStore } from '../stores/orderStore'
import { useProductStore } from '../stores/productStore'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const cartStore = useCartStore()
const orderStore = useOrderStore()
const productStore = useProductStore()

const loading = ref(false)
const isSubmitting = ref(false)
const isBuyNow = ref(false)
const showAddressDialog = ref(false)

const selectedAddress = ref<any>(null)
const remark = ref('')
const selectedPayment = ref('alipay')

const orderItems = ref<any[]>([])

const addresses = ref([
  {
    id: 1,
    receiverName: '张三',
    receiverPhone: '13800138000',
    province: '河南省',
    city: '郑州市',
    district: '金水区',
    detail: '文化路1号',
    isDefault: true
  }
])

const addressForm = ref({
  receiverName: '',
  receiverPhone: '',
  province: '',
  city: '',
  district: '',
  detail: ''
})

const paymentMethods = [
  { value: 'alipay', name: '支付宝', icon: '💙' },
  { value: 'wechat', name: '微信支付', icon: '💚' },
  { value: 'card', name: '银行卡', icon: '💳' }
]

const shippingFee = computed(() => {
  return totalAmount.value >= 99 ? 0 : 10
})

const totalAmount = computed(() => {
  return orderItems.value.reduce((sum, item) => {
    const price = item.price || item.product?.price || 0
    return sum + price * item.quantity
  }, 0)
})

const handleImageError = (event: Event) => {
  const target = event.target as HTMLImageElement
  target.src = '/images/beijing-duck.jpg'
}

const handleAddAddress = () => {
  if (!addressForm.value.receiverName || !addressForm.value.receiverPhone || !addressForm.value.detail) {
    ElMessage.warning('请填写完整的收货信息')
    return
  }

  const newAddress = {
    id: Date.now(),
    ...addressForm.value,
    isDefault: false
  }
  addresses.value.push(newAddress)
  selectedAddress.value = newAddress
  showAddressDialog.value = false
  addressForm.value = {
    receiverName: '',
    receiverPhone: '',
    province: '',
    city: '',
    district: '',
    detail: ''
  }
  ElMessage.success('地址添加成功')
}

const handleSubmitOrder = async () => {
  if (!isBuyNow.value && !selectedAddress.value) {
    ElMessage.warning('请选择收货地址')
    return
  }

  isSubmitting.value = true

  try {
    const receiverName = isBuyNow.value ? '匿名用户' : selectedAddress.value.receiverName
    const receiverPhone = isBuyNow.value ? '13800138000' : selectedAddress.value.receiverPhone
    const receiverAddress = isBuyNow.value
      ? '郑州市金水区文化路1号'
      : `${selectedAddress.value.province}${selectedAddress.value.city}${selectedAddress.value.district}${selectedAddress.value.detail}`

    const order = await orderStore.createOrder({
      receiverName,
      receiverPhone,
      receiverAddress,
      remark: remark.value,
      paymentMethod: selectedPayment.value,
      items: orderItems.value
    })

    ElMessage.success('订单提交成功')
    router.push({
      path: '/order/payment',
      query: { orderNo: order.orderNo }
    })
  } catch (error) {
    ElMessage.error('订单提交失败')
  } finally {
    isSubmitting.value = false
  }
}

onMounted(async () => {
  loading.value = true

  const { productId, quantity, cartItems } = route.query

  if (productId && quantity) {
    isBuyNow.value = true
    try {
      const product = await productStore.fetchProductById(Number(productId))
      orderItems.value = [{
        id: Date.now(),
        productId: product.id,
        name: product.name,
        price: product.price,
        coverImage: product.coverImage,
        quantity: Number(quantity)
      }]
    } catch (error) {
      ElMessage.error('获取商品信息失败')
    }
  } else if (cartItems) {
    try {
      await cartStore.fetchCartList()
      const itemIds = (cartItems as string).split(',').map(Number)
      orderItems.value = cartStore.items
        .filter(item => itemIds.includes(item.id))
        .map(item => ({
          id: item.id,
          productId: item.productId,
          name: item.product?.name,
          price: item.product?.price,
          coverImage: item.product?.coverImage,
          quantity: item.quantity
        }))
    } catch (error) {
      ElMessage.error('获取购物车信息失败')
    }
  } else {
    ElMessage.warning('无效的订单信息')
    router.push('/cart')
  }

  if (addresses.value.length > 0) {
    selectedAddress.value = addresses.value.find(a => a.isDefault) || addresses.value[0]
  }

  loading.value = false
})
</script>

<style scoped>
.order-create-page {
  min-height: 100vh;
  background: var(--gradient-bg);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 24px 80px;
}

/* ====== 订单内容布局 ====== */
.order-content {
  display: grid;
  grid-template-columns: 1fr 400px;
  gap: 28px;
  animation: fadeInUp 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.order-main {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* ====== 区块卡片通用样式 ====== */
.section-card {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  padding: 28px;
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.section-card::before {
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

.section-card:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-4px);
}

.section-card:hover::before {
  opacity: 1;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 22px;
  padding-bottom: 16px;
  border-bottom: 2px dashed rgba(212, 175, 55, 0.25);
}

.header-icon {
  font-size: 24px;
}

.header-title {
  font-size: 19px;
  color: var(--text-color);
  font-weight: 700;
  letter-spacing: 0.5px;
  flex: 1;
}

.item-count {
  font-size: 13px;
  color: var(--primary-color);
  background: linear-gradient(135deg, rgba(200,22,29,0.08), rgba(212,175,55,0.08));
  padding: 4px 12px;
  border-radius: 12px;
  font-weight: 600;
}

/* ====== 收货地址区域 ====== */
.address-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
  margin-bottom: 20px;
}

.address-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 22px;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  background: white;
}

.address-card::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 4px;
  background: transparent;
  transition: all 0.3s ease;
}

.address-card:hover {
  border-color: var(--secondary-color);
  box-shadow: 0 6px 18px rgba(200, 22, 29, 0.15);
  transform: translateX(6px);
}

.address-card.selected {
  border-color: var(--primary-color);
  background: linear-gradient(135deg, rgba(200,22,29,0.03), rgba(255,245,240,0.98));
  box-shadow: 0 6px 18px rgba(200, 22, 29, 0.15);
}

.address-card.selected::before {
  background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
}

.address-left {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  flex: 1;
}

.user-icon {
  font-size: 26px;
  margin-top: 2px;
}

.address-info {
  flex: 1;
}

.receiver {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-color);
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.phone {
  font-weight: 500;
  color: var(--text-light);
  font-size: 15px;
}

.default-badge {
  background: linear-gradient(135deg, var(--primary-color), #a8131a);
  color: white;
  padding: 3px 11px;
  border-radius: 10px;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.5px;
  box-shadow: 0 2px 6px rgba(200, 22, 29, 0.25);
}

.detail {
  font-size: 14px;
  color: var(--text-light);
  line-height: 1.6;
  display: flex;
  align-items: flex-start;
  gap: 6px;
}

.location-icon {
  font-size: 15px;
  margin-top: 2px;
  flex-shrink: 0;
}

.address-right {
  flex-shrink: 0;
}

.check-icon {
  width: 32px;
  height: 32px;
  background: var(--primary-color);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  font-weight: 800;
  opacity: 0;
  transform: scale(0.5);
  transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

.address-card.selected .check-icon {
  opacity: 1;
  transform: scale(1);
}

.add-address-btn {
  width: 100%;
  padding: 14px;
  border: 2px dashed var(--border-gold);
  background: transparent;
  border-radius: var(--radius-lg);
  color: var(--text-light);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-size: 15px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.btn-icon { font-size: 18px; }

.add-address-btn:hover {
  border-color: var(--primary-color);
  color: var(--primary-color);
  background: linear-gradient(135deg, rgba(200,22,29,0.03), rgba(212,175,55,0.03));
  transform: translateY(-2px);
  border-style: solid;
}

/* ====== 商品信息区域 ====== */
.product-list {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.product-item {
  display: grid;
  grid-template-columns: 100px 1fr auto auto;
  gap: 20px;
  align-items: center;
  padding: 20px 0;
  border-bottom: 1px solid rgba(212, 175, 55, 0.15);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}

.product-item:first-child {
  padding-top: 0;
}

.product-item:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.product-item:hover {
  background: linear-gradient(135deg, rgba(200,22,29,0.02), rgba(212,175,55,0.02));
  padding-left: 12px;
  padding-right: 12px;
  margin-left: -12px;
  margin-right: -12px;
  border-radius: var(--radius-md);
}

.item-image-area {
  width: 100px;
  height: 100px;
  border-radius: var(--radius-md);
  overflow: hidden;
  border: 2px solid var(--border-gold);
  position: relative;
  transition: all 0.3s ease;
}

.item-image-area img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: all 0.3s ease;
}

.product-item:hover .item-image-area img {
  transform: scale(1.08);
}

.product-item:hover .item-image-area {
  border-color: var(--primary-color);
  box-shadow: 0 6px 16px rgba(200, 22, 29, 0.15);
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
  color: white;
  font-size: 13px;
  font-weight: 700;
  opacity: 0;
  transition: all 0.3s ease;
}

.product-item:hover .image-overlay {
  opacity: 1;
}

.item-info {
  min-width: 0;
}

.item-name {
  font-size: 16px;
  color: var(--text-color);
  margin-bottom: 8px;
  font-weight: 600;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  transition: all 0.3s ease;
}

.product-item:hover .item-name {
  color: var(--primary-color);
}

.item-price {
  font-size: 17px;
  color: var(--primary-color);
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 6px;
}

.price-icon { font-size: 16px; }

.item-quantity,
.item-subtotal {
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.quantity-label,
.subtotal-label {
  font-size: 12px;
  color: var(--text-lighter);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.quantity-value {
  font-size: 17px;
  color: var(--text-light);
  font-weight: 700;
  padding: 6px 14px;
  background: linear-gradient(135deg, rgba(212,175,55,0.06), rgba(212,175,55,0.02));
  border-radius: var(--radius-sm);
  border: 1px solid var(--border-gold);
}

.subtotal-value {
  font-size: 20px;
  color: var(--primary-color);
  font-weight: 800;
  text-shadow: 0 2px 4px rgba(200, 22, 29, 0.1);
}

/* ====== 订单备注区域 ====== */
.remark-textarea {
  width: 100%;
  padding: 16px 20px;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-lg);
  resize: vertical;
  min-height: 100px;
  font-size: 14px;
  outline: none;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.04);
  font-family: inherit;
  line-height: 1.6;
  color: var(--text-color);
}

.remark-textarea:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.08), inset 0 2px 4px rgba(0, 0, 0, 0.04);
  transform: translateY(-2px);
}

.remark-textarea::placeholder {
  color: var(--text-lighter);
  font-style: italic;
}

/* ====== 支付方式区域 ====== */
.payment-methods {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 14px;
}

.payment-method {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 18px 16px;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  background: white;
  overflow: hidden;
}

.payment-method::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.payment-method.method-alipay::before {
  background: linear-gradient(135deg, rgba(24,144,255,0.06), rgba(24,144,255,0.02));
}

.payment-method.method-wechat::before {
  background: linear-gradient(135deg, rgba(7,193,96,0.06), rgba(7,193,96,0.02));
}

.payment-method.method-card::before {
  background: linear-gradient(135deg, rgba(250,173,20,0.06), rgba(250,173,20,0.02));
}

.payment-method:hover {
  border-color: var(--secondary-color);
  transform: translateY(-3px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
}

.payment-method:hover::before {
  opacity: 1;
}

.payment-method.selected {
  border-color: var(--primary-color);
  box-shadow: 0 6px 16px rgba(200, 22, 29, 0.2);
  transform: translateY(-3px) scale(1.02);
}

.payment-method.selected::before {
  opacity: 1;
}

.method-icon {
  font-size: 36px;
  z-index: 1;
  transition: all 0.3s ease;
}

.payment-method:hover .method-icon {
  transform: scale(1.15) rotate(5deg);
}

.method-name {
  font-size: 15px;
  color: var(--text-color);
  font-weight: 600;
  z-index: 1;
  letter-spacing: 0.5px;
}

.method-check {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 24px;
  height: 24px;
  background: var(--primary-color);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 800;
  animation: popIn 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

@keyframes popIn {
  from {
    opacity: 0;
    transform: scale(0);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

/* ====== 订单金额摘要 ====== */
.order-summary-card {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  padding: 28px;
  position: sticky;
  top: 80px;
  height: fit-content;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}

.order-summary-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

.order-summary-card:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-4px);
}

.summary-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 24px;
  padding-bottom: 18px;
  border-bottom: 2px dashed rgba(212, 175, 55, 0.25);
}

.summary-icon { font-size: 26px; }

.summary-title {
  font-size: 20px;
  color: var(--text-color);
  font-weight: 800;
  letter-spacing: 1px;
}

.summary-body {
  margin-bottom: 24px;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  font-size: 15px;
  color: var(--text-light);
  transition: all 0.3s ease;
}

.summary-row:hover {
  color: var(--text-color);
  transform: translateX(4px);
}

.row-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 500;
}

.label-icon { font-size: 17px; }

.row-value {
  font-weight: 600;
  font-size: 16px;
  color: var(--text-color);
}

.free-shipping {
  color: #52c41a !important;
  font-weight: 700 !important;
}

.divider {
  height: 2px;
  background: linear-gradient(90deg, transparent, var(--border-gold), transparent);
  margin: 16px 0;
}

.total-row {
  padding-top: 20px;
  margin-top: 8px;
  border-top: 2px solid rgba(212, 175, 55, 0.25);
}

.total-label {
  font-size: 18px;
  font-weight: 700;
  color: var(--text-color);
  letter-spacing: 0.5px;
}

.total-price {
  font-size: 32px;
  color: var(--primary-color);
  font-weight: 900;
  text-shadow: 0 2px 8px rgba(200, 22, 29, 0.15);
  letter-spacing: -0.5px;
}

.submit-order-btn {
  width: 100%;
  padding: 16px 24px;
  font-size: 18px;
  font-weight: 700;
  letter-spacing: 1px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  margin-bottom: 16px;
}

.submit-order-btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 12px 28px rgba(200, 22, 29, 0.4);
}

.btn-loading {
  width: 18px;
  height: 18px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.security-tip {
  text-align: center;
  font-size: 13px;
  color: var(--text-lighter);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  font-weight: 500;
}

.tip-icon { font-size: 14px; }

/* ====== 加载状态 ====== */
.loading-state {
  text-align: center;
  padding: 120px 20px;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
}

.loader-container {
  max-width: 300px;
  margin: 0 auto;
}

.loader {
  width: 56px;
  height: 56px;
  border: 4px solid var(--border-gold);
  border-top-color: var(--primary-color);
  border-right-color: var(--secondary-color);
  border-radius: 50%;
  animation: spin 1s cubic-bezier(0.68, -0.55, 0.265, 1.55) infinite;
  margin: 0 auto 24px;
  box-shadow: 0 6px 20px rgba(200, 22, 29, 0.15);
}

.loading-text {
  font-size: 16px;
  color: var(--text-light);
  font-weight: 500;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

/* ====== 弹窗样式增强 ====== */
.address-dialog :deep(.el-dialog__header) {
  background: linear-gradient(135deg, var(--primary-color), #a8131a);
  color: white;
  padding: 20px 24px;
  margin-right: 0;
  border-radius: var(--radius-xl) var(--radius-xl) 0 0;
}

.address-dialog :deep(.el-dialog__title) {
  color: white;
  font-size: 18px;
  font-weight: 700;
  letter-spacing: 1px;
}

.address-dialog :deep(.el-dialog__close) {
  color: white;
  font-size: 20px;
}

.address-dialog :deep(.el-dialog__body) {
  padding: 28px 24px;
}

.address-dialog :deep(.el-dialog__footer) {
  padding: 16px 24px 24px;
  border-top: 1px solid var(--border-gold);
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.confirm-btn {
  background: var(--gradient-primary) !important;
  border: none !important;
  font-weight: 700 !important;
  letter-spacing: 0.5px !important;
}

.confirm-btn:hover {
  transform: translateY(-2px) !important;
  box-shadow: 0 6px 16px rgba(200, 22, 29, 0.35) !important;
}

/* ====== 响应式设计 ====== */
@media (max-width: 1024px) {
  .order-content {
    grid-template-columns: 1fr 360px;
    gap: 24px;
  }

  .container {
    padding: 32px 20px 70px;
  }
}

@media (max-width: 768px) {
  .order-content {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .container {
    padding: 28px 16px 60px;
  }

  .order-summary-card {
    position: static;
  }

  .section-card {
    padding: 20px;
  }

  .card-header {
    margin-bottom: 18px;
    padding-bottom: 14px;
  }

  .product-item {
    grid-template-columns: 80px 1fr;
    gap: 14px;
    padding: 16px 0;
  }

  .item-image-area {
    width: 80px;
    height: 80px;
  }

  .item-quantity,
  .item-subtotal {
    grid-column: 1 / -1;
    flex-direction: row;
    justify-content: space-between;
    padding-top: 12px;
    border-top: 1px dashed rgba(212, 175, 55, 0.2);
  }

  .payment-methods {
    grid-template-columns: repeat(3, 1fr);
  }

  .payment-method {
    padding: 14px 10px;
  }

  .method-icon {
    font-size: 28px;
  }

  .method-name {
    font-size: 13px;
  }

  .address-card {
    padding: 14px 16px;
  }

  .user-icon {
    font-size: 22px;
  }

  .receiver {
    font-size: 14px;
    flex-wrap: wrap;
  }

  .detail {
    font-size: 13px;
  }

  .total-price {
    font-size: 26px;
  }

  .submit-order-btn {
    font-size: 16px;
    padding: 14px 20px;
  }

  .address-dialog :deep(.el-dialog) {
    width: 95% !important;
    margin: 0 auto;
  }
}
</style>
