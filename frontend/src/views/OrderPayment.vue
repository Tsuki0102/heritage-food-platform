<template>
  <div class="order-payment-page">
    <Header />

    <!-- 页面横幅 -->
    <BannerSection
      title="订单支付"
      subtitle="请选择您的支付方式完成付款"
      badge-icon="💳"
      badge="安全支付"
    />

    <div class="container" v-if="order">
      <!-- 支付内容区 -->
      <div class="payment-wrapper">
        <!-- 左侧：主要支付流程 -->
        <div class="payment-main">
          <!-- 订单信息卡片 -->
          <div class="section-card order-info-card">
            <div class="card-header">
              <span class="header-icon">🧾</span>
              <h3 class="header-title">订单信息</h3>
              <span class="status-badge pending">待支付</span>
            </div>

            <div class="info-grid">
              <div class="info-item">
                <span class="info-label">
                  <span class="label-icon">📋</span>
                  订单编号
                </span>
                <span class="info-value order-no">{{ order.orderNo }}</span>
                <button class="copy-btn" @click="copyOrderNo" title="复制订单号">
                  📋
                </button>
              </div>

              <div class="info-divider"></div>

              <div class="info-item amount-item">
                <span class="info-label">
                  <span class="label-icon">💰</span>
                  应付金额
                </span>
                <div class="amount-display">
                  <span class="currency">¥</span>
                  <span class="amount-value">{{ formatAmount(order.totalAmount) }}</span>
                  <span class="amount-decimal">{{ getDecimal(order.totalAmount) }}</span>
                </div>
              </div>
            </div>

            <!-- 倒计时提示 -->
            <div class="countdown-bar">
              <span class="countdown-icon">⏰</span>
              <span class="countdown-text">请在</span>
              <span class="countdown-time">29:59</span>
              <span class="countdown-text">内完成支付</span>
            </div>
          </div>

          <!-- 支付方式选择 -->
          <div class="section-card payment-methods-card">
            <div class="card-header">
              <span class="header-icon">💳</span>
              <h3 class="header-title">选择支付方式</h3>
            </div>

            <div class="methods-grid">
              <div
                v-for="method in paymentMethods"
                :key="method.value"
                :class="['method-card', { selected: selectedPayment === method.value, [`method-${method.value}`]: true }]"
                @click="selectedPayment = method.value"
              >
                <div class="method-top">
                  <span class="method-icon">{{ method.icon }}</span>
                  <span class="method-check" v-if="selectedPayment === method.value">✓</span>
                </div>
                <h4 class="method-name">{{ method.name }}</h4>
                <p class="method-desc">{{ method.desc }}</p>
              </div>
            </div>
          </div>

          <!-- 操作按钮组 -->
          <div class="action-section">
            <button class="cancel-btn" @click="handleCancelPayment">
              <span class="btn-icon">✖️</span>
              取消支付
            </button>
            <button class="confirm-pay-btn btn-primary" @click="handleConfirmPayment" :disabled="isPaying">
              <template v-if="isPaying">
                <span class="btn-loading"></span>
                支付中...
              </template>
              <template v-else>
                <span class="btn-icon">🔒</span>
                确认支付
              </template>
            </button>
          </div>

          <!-- 支付提示信息 -->
          <div class="tips-card">
            <div class="tips-header">
              <span class="tips-icon">ℹ️</span>
              <h4 class="tips-title">支付提示</h4>
            </div>
            <ul class="tips-list">
              <li class="tip-item">
                <span class="tip-bullet">⏱️</span>
                <span>请在30分钟内完成支付，逾期订单将自动取消</span>
              </li>
              <li class="tip-item">
                <span class="tip-bullet">⚡</span>
                <span>支付完成后，订单状态将在5分钟内更新</span>
              </li>
              <li class="tip-item">
                <span class="tip-bullet">💬</span>
                <span>如遇支付问题，请联系客服：400-888-8888</span>
              </li>
            </ul>
          </div>
        </div>

        <!-- 右侧：金额摘要（可选） -->
        <div class="payment-sidebar">
          <div class="sidebar-card">
            <div class="sidebar-header">
              <span class="sidebar-icon">💵</span>
              <h4 class="sidebar-title">订单详情</h4>
            </div>

            <div class="summary-list">
              <div class="summary-row">
                <span class="row-label">商品数量</span>
                <span class="row-value">{{ order.items?.length || 1 }}件</span>
              </div>
              <div class="summary-row">
                <span class="row-label">商品总价</span>
                <span class="row-value">¥{{ (order.totalAmount || 0).toFixed(2) }}</span>
              </div>
              <div class="summary-row">
                <span class="row-label">运费</span>
                <span class="row-value free-shipping">免运费</span>
              </div>
              <div class="divider-line"></div>
              <div class="summary-row total-row">
                <span class="total-label">实付金额</span>
                <span class="total-price">¥{{ order.totalAmount.toFixed(2) }}</span>
              </div>
            </div>

            <div class="security-badge">
              <span class="badge-icon">🔒</span>
              <span class="badge-text">SSL加密传输 · 资金安全保障</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 加载状态 -->
    <div class="loading-state" v-else-if="!order">
      <div class="loader-container">
        <div class="loader"></div>
        <p class="loading-text">正在加载订单信息...</p>
      </div>
    </div>

    <!-- 二维码支付弹窗 -->
    <Transition name="modal-fade">
      <div class="qrcode-modal" v-if="showQrcode" @click.self="handleCloseQrcode">
        <div class="modal-content">
          <div class="modal-header">
            <span class="modal-icon">📱</span>
            <h3 class="modal-title">请扫描二维码支付</h3>
            <button class="close-btn" @click="handleCloseQrcode">✕</button>
          </div>

          <div class="qrcode-body">
            <div class="qrcode-wrapper">
              <div class="qrcode-box">
                <img v-if="qrcodeUrl" :src="qrcodeUrl" alt="支付二维码" />
                <div v-else class="loading-qrcode">
                  <div class="mini-loader"></div>
                  <span>正在生成...</span>
                </div>
              </div>
            </div>

            <div class="qrcode-info">
              <div class="amount-highlight">
                <span class="amount-label">支付金额</span>
                <span class="amount-big">¥{{ order.totalAmount.toFixed(2) }}</span>
              </div>
              <p class="scan-tip">
                <span class="tip-icon">👆</span>
                请使用{{ getPaymentName() }}扫描二维码
              </p>
            </div>
          </div>

          <div class="modal-footer">
            <button class="close-action-btn" @click="handleCloseQrcode">
              关闭窗口
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useOrderStore } from '../stores/orderStore'
import { usePaymentStore } from '../stores/paymentStore'
import { useCartStore } from '../stores/cartStore'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const orderStore = useOrderStore()
const paymentStore = usePaymentStore()
const cartStore = useCartStore()

const order = ref<any>(null)
const selectedPayment = ref('alipay')
const isPaying = ref(false)
const showQrcode = ref(false)
const qrcodeUrl = ref('')
let countdownInterval: any = null

const paymentMethods = [
  {
    value: 'alipay',
    name: '支付宝',
    icon: '💙',
    desc: '推荐有支付宝的用户使用'
  },
  {
    value: 'wechat',
    name: '微信支付',
    icon: '💚',
    desc: '推荐有微信的用户使用'
  },
  {
    value: 'card',
    name: '银行卡',
    icon: '💳',
    desc: '支持各大银行的银行卡支付'
  }
]

// 格式化金额（整数部分）
const formatAmount = (amount: number) => {
  return Math.floor(amount).toString()
}

// 获取小数部分
const getDecimal = (amount: number) => {
  const decimal = amount.toFixed(2).split('.')[1]
  return '.' + decimal
}

// 复制订单号
const copyOrderNo = () => {
  if (order.value?.orderNo) {
    navigator.clipboard.writeText(order.value.orderNo)
    ElMessage.success('订单号已复制到剪贴板')
  }
}

// 获取支付方式名称
const getPaymentName = () => {
  return selectedPayment.value === 'alipay' ? '支付宝' :
         selectedPayment.value === 'wechat' ? '微信' : '银行卡APP'
}

const handleCancelPayment = async () => {
  try {
    await orderStore.cancelOrderById(order.value.id)
    ElMessage.success('订单已取消')
    router.push('/user/orders')
  } catch (error) {
    ElMessage.error('取消失败')
  }
}

const handleCloseQrcode = () => {
  showQrcode.value = false
  qrcodeUrl.value = ''
}

const handleConfirmPayment = async () => {
  isPaying.value = true

  try {
    const paymentResponse = await paymentStore.createPayment({
      orderId: order.value.id,
      paymentMethod: selectedPayment.value
    })

    if (paymentResponse.qrCode) {
      qrcodeUrl.value = paymentResponse.qrCode
      showQrcode.value = true
      pollPaymentStatus(paymentResponse.paymentNo)
    } else if (paymentResponse.payUrl) {
      window.open(paymentResponse.payUrl, '_blank')
      pollPaymentStatus(paymentResponse.paymentNo)
    } else {
      ElMessage.success('支付成功')
      await clearCartItems()
      router.push({
        path: '/order/success',
        query: { orderNo: order.value.orderNo }
      })
    }
  } catch (error) {
    ElMessage.error('支付失败')
  } finally {
    isPaying.value = false
  }
}

const pollPaymentStatus = (paymentNo: string) => {
  const interval = setInterval(async () => {
    try {
      const payment = await paymentStore.fetchPaymentStatus(paymentNo)
      if (payment.paymentStatus === 1) {
        clearInterval(interval)
        showQrcode.value = false
        ElMessage.success('支付成功')
        await clearCartItems()
        router.push({
          path: '/order/success',
          query: { orderNo: order.value.orderNo }
        })
      }
    } catch (error) {
      console.error('查询支付状态失败')
    }
  }, 2000)

  setTimeout(() => {
    clearInterval(interval)
  }, 30 * 60 * 1000)
}

const clearCartItems = async () => {
  try {
    await cartStore.fetchCartList()
    if (cartStore.items.length > 0) {
      await cartStore.clearAll()
    }
  } catch (error) {
    console.error('清空购物车失败')
  }
}

onMounted(async () => {
  const { orderNo } = route.query

  if (!orderNo) {
    ElMessage.error('无效的订单信息')
    router.push('/')
    return
  }

  try {
    order.value = await orderStore.fetchOrderByNo(orderNo as string)
  } catch (error) {
    ElMessage.error('获取订单信息失败')
    router.push('/')
  }
})

onUnmounted(() => {
  if (countdownInterval) {
    clearInterval(countdownInterval)
  }
})
</script>

<style scoped>
.order-payment-page {
  min-height: 100vh;
  background: var(--gradient-bg);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 24px 80px;
}

/* ====== 支付内容布局 ====== */
.payment-wrapper {
  display: grid;
  grid-template-columns: 1fr 340px;
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

.payment-main {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* ====== 区块卡片通用样式 ====== */
.section-card,
.tips-card {
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

.header-icon { font-size: 24px; }

.header-title {
  font-size: 19px;
  color: var(--text-color);
  font-weight: 700;
  letter-spacing: 0.5px;
  flex: 1;
}

.status-badge {
  padding: 5px 14px;
  border-radius: 12px;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.5px;
}

.status-badge.pending {
  background: linear-gradient(135deg, #fff3e0, #ffe0b2);
  color: #e65100;
  box-shadow: 0 4px 12px rgba(230, 81, 0, 0.15);
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.85; transform: scale(1.02); }
}

/* ====== 订单信息区域 ====== */
.info-grid {
  display: grid;
  gap: 20px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.info-label {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 15px;
  color: var(--text-light);
  font-weight: 500;
  white-space: nowrap;
}

.label-icon { font-size: 17px; }

.info-value {
  font-size: 15px;
  color: var(--text-color);
  font-weight: 600;
  letter-spacing: 0.5px;
}

.order-no {
  font-family: 'Courier New', monospace;
  background: linear-gradient(135deg, rgba(200,22,29,0.04), rgba(212,175,55,0.04));
  padding: 6px 12px;
  border-radius: var(--radius-sm);
  border: 1px solid var(--border-gold);
}

.copy-btn {
  width: 32px;
  height: 32px;
  background: transparent;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
}

.copy-btn:hover {
  background: var(--secondary-color);
  border-color: var(--secondary-color);
  transform: scale(1.1) rotate(5deg);
}

.info-divider {
  height: 1px;
  background: linear-gradient(90deg, transparent, var(--border-gold), transparent);
}

.amount-item {
  justify-content: space-between;
  padding: 20px;
  background: linear-gradient(135deg, rgba(200,22,29,0.03), rgba(212,175,55,0.03));
  border-radius: var(--radius-md);
  border: 1px solid var(--border-gold);
}

.amount-display {
  display: flex;
  align-items: baseline;
  gap: 2px;
}

.currency {
  font-size: 24px;
  color: var(--primary-color);
  font-weight: 800;
}

.amount-value {
  font-size: 42px;
  color: var(--primary-color);
  font-weight: 900;
  line-height: 1;
  letter-spacing: -2px;
}

.amount-decimal {
  font-size: 24px;
  color: var(--primary-color);
  font-weight: 800;
}

/* 倒计时条 */
.countdown-bar {
  margin-top: 18px;
  padding: 14px 20px;
  background: linear-gradient(135deg, #fff3e0, #ffe0b2);
  border-radius: var(--radius-md);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  animation: countdownPulse 2s ease-in-out infinite;
}

@keyframes countdownPulse {
  0%, 100% { box-shadow: 0 0 0 0 rgba(230, 81, 0, 0.2); }
  50% { box-shadow: 0 0 0 10px rgba(230, 81, 0, 0); }
}

.countdown-icon { font-size: 18px; }

.countdown-text {
  font-size: 14px;
  color: #e65100;
  font-weight: 600;
}

.countdown-time {
  font-size: 22px;
  color: #e65100;
  font-weight: 900;
  letter-spacing: 2px;
  font-family: 'Courier New', monospace;
}

/* ====== 支付方式选择 ====== */
.methods-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 16px;
}

.method-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 24px 18px;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  background: white;
}

.method-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.method-card.method-alipay::before {
  background: linear-gradient(135deg, rgba(24,144,255,0.06), rgba(24,144,255,0.02));
}

.method-card.method-wechat::before {
  background: linear-gradient(135deg, rgba(7,193,96,0.06), rgba(7,193,96,0.02));
}

.method-card.method-card::before {
  background: linear-gradient(135deg, rgba(250,173,20,0.06), rgba(250,173,20,0.02));
}

.method-card:hover {
  border-color: var(--secondary-color);
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
}

.method-card:hover::before {
  opacity: 1;
}

.method-card.selected {
  border-color: var(--primary-color);
  box-shadow: 0 8px 24px rgba(200, 22, 29, 0.25);
  transform: translateY(-4px) scale(1.02);
}

.method-card.selected::before {
  opacity: 1;
}

.method-top {
  position: relative;
  width: 100%;
  display: flex;
  justify-content: center;
  margin-bottom: 4px;
}

.method-icon {
  font-size: 48px;
  z-index: 1;
  transition: all 0.3s ease;
}

.method-card:hover .method-icon {
  transform: scale(1.15) rotate(-5deg);
}

.method-check {
  position: absolute;
  top: -4px;
  right: 8px;
  width: 26px;
  height: 26px;
  background: var(--primary-color);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 15px;
  font-weight: 800;
  animation: popIn 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

@keyframes popIn {
  from { opacity: 0; transform: scale(0); }
  to { opacity: 1; transform: scale(1); }
}

.method-name {
  font-size: 17px;
  color: var(--text-color);
  font-weight: 700;
  z-index: 1;
  letter-spacing: 0.5px;
}

.method-desc {
  font-size: 12px;
  color: var(--text-lighter);
  text-align: center;
  z-index: 1;
  line-height: 1.4;
}

/* ====== 操作按钮区域 ====== */
.action-section {
  display: flex;
  gap: 16px;
}

.cancel-btn,
.confirm-pay-btn {
  flex: 1;
  padding: 16px 24px;
  border-radius: var(--radius-lg);
  font-size: 17px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  letter-spacing: 1px;
  border: none;
}

.btn-icon { font-size: 18px; }

.cancel-btn {
  background: white;
  color: var(--text-light);
  border: 2px solid var(--border-gold);
}

.cancel-btn:hover {
  border-color: #e74c3c;
  color: #e74c3c;
  background: linear-gradient(135deg, rgba(231,76,60,0.04), rgba(231,76,60,0.02));
  transform: translateY(-2px);
}

.confirm-pay-btn:hover:not(:disabled) {
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
  to { transform: rotate(360deg); }
}

/* ====== 支付提示区域 ====== */
.tips-card {
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
  border: 1px solid var(--border-gold);
}

.tips-card::before {
  display: none;
}

.tips-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 16px;
}

.tips-icon { font-size: 20px; }

.tips-title {
  font-size: 16px;
  color: var(--text-color);
  font-weight: 700;
}

.tips-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.tip-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  font-size: 14px;
  color: var(--text-light);
  line-height: 1.6;
  font-weight: 500;
}

.tip-bullet {
  font-size: 16px;
  flex-shrink: 0;
  margin-top: 2px;
}

/* ====== 右侧边栏 ====== */
.payment-sidebar {
  position: sticky;
  top: 80px;
  height: fit-content;
}

.sidebar-card {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  padding: 24px;
  position: relative;
  overflow: hidden;
}

.sidebar-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--secondary-color), var(--primary-color));
}

.sidebar-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 20px;
  padding-bottom: 14px;
  border-bottom: 2px dashed rgba(212, 175, 55, 0.25);
}

.sidebar-icon { font-size: 22px; }

.sidebar-title {
  font-size: 17px;
  color: var(--text-color);
  font-weight: 700;
  letter-spacing: 0.5px;
}

.summary-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 14px;
  color: var(--text-light);
  padding: 8px 0;
  transition: all 0.3s ease;
}

.summary-row:hover {
  color: var(--text-color);
  transform: translateX(4px);
}

.row-label {
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 6px;
}

.row-value {
  font-weight: 600;
  font-size: 15px;
  color: var(--text-color);
}

.free-shipping {
  color: #52c41a !important;
  font-weight: 700 !important;
}

.divider-line {
  height: 2px;
  background: linear-gradient(90deg, transparent, var(--border-gold), transparent);
  margin: 8px 0;
}

.total-row {
  padding-top: 16px;
  margin-top: 4px;
  border-top: 2px solid rgba(212, 175, 55, 0.25);
}

.total-label {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-color);
}

.total-price {
  font-size: 26px;
  color: var(--primary-color);
  font-weight: 900;
  text-shadow: 0 2px 6px rgba(200, 22, 29, 0.12);
}

.security-badge {
  margin-top: 20px;
  padding: 12px 16px;
  background: linear-gradient(135deg, rgba(82,196,26,0.06), rgba(82,196,26,0.02));
  border: 1px solid rgba(82,196,26,0.2);
  border-radius: var(--radius-md);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.badge-icon { font-size: 18px; }

.badge-text {
  font-size: 13px;
  color: #52c41a;
  font-weight: 600;
  letter-spacing: 0.5px;
}

/* ====== 二维码弹窗 ====== */
.qrcode-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(8px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  padding: 20px;
}

.modal-content {
  background: white;
  border-radius: var(--radius-xl);
  box-shadow: 0 25px 60px rgba(0, 0, 0, 0.3);
  max-width: 420px;
  width: 100%;
  overflow: hidden;
  animation: modalSlideIn 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: scale(0.9) translateY(30px);
  }
  to {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

.modal-header {
  background: linear-gradient(135deg, var(--primary-color), #a8131a);
  color: white;
  padding: 24px 28px;
  display: flex;
  align-items: center;
  gap: 10px;
  position: relative;
}

.modal-icon { font-size: 26px; }

.modal-title {
  font-size: 19px;
  font-weight: 700;
  letter-spacing: 1px;
  flex: 1;
}

.close-btn {
  width: 36px;
  height: 36px;
  background: rgba(255, 255, 255, 0.2);
  border: none;
  border-radius: 50%;
  color: white;
  cursor: pointer;
  font-size: 20px;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  background: rgba(255, 255, 255, 0.35);
  transform: rotate(90deg);
}

.qrcode-body {
  padding: 32px 28px;
}

.qrcode-wrapper {
  display: flex;
  justify-content: center;
  margin-bottom: 24px;
}

.qrcode-box {
  width: 220px;
  height: 220px;
  border: 3px solid var(--border-gold);
  border-radius: var(--radius-lg);
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: white;
  box-shadow: inset 0 2px 8px rgba(0, 0, 0, 0.06);
}

.qrcode-box img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.loading-qrcode {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  color: var(--text-light);
  font-size: 14px;
  font-weight: 500;
}

.mini-loader {
  width: 40px;
  height: 40px;
  border: 3px solid var(--border-gold);
  border-top-color: var(--primary-color);
  border-right-color: var(--secondary-color);
  border-radius: 50%;
  animation: spin 1s cubic-bezier(0.68, -0.55, 0.265, 1.55) infinite;
}

.qrcode-info {
  text-align: center;
}

.amount-highlight {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  margin-bottom: 16px;
  padding: 16px;
  background: linear-gradient(135deg, rgba(200,22,29,0.04), rgba(212,175,55,0.04));
  border-radius: var(--radius-md);
  border: 1px solid var(--border-gold);
}

.amount-label {
  font-size: 13px;
  color: var(--text-light);
  font-weight: 500;
}

.amount-big {
  font-size: 32px;
  color: var(--primary-color);
  font-weight: 900;
  text-shadow: 0 2px 6px rgba(200, 22, 29, 0.12);
}

.scan-tip {
  font-size: 14px;
  color: var(--text-light);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  font-weight: 500;
}

.tip-icon { font-size: 16px; }

.modal-footer {
  padding: 20px 28px;
  border-top: 1px solid var(--border-gold);
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
}

.close-action-btn {
  width: 100%;
  padding: 14px;
  background: white;
  color: var(--text-light);
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-md);
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.close-action-btn:hover {
  border-color: var(--primary-color);
  color: var(--primary-color);
  background: linear-gradient(135deg, rgba(200,22,29,0.04), rgba(212,175,55,0.04));
  transform: translateY(-2px);
}

/* 弹窗过渡动画 */
.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.3s ease;
}

.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}

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

/* ====== 响应式设计 ====== */
@media (max-width: 1024px) {
  .payment-wrapper {
    grid-template-columns: 1fr 300px;
    gap: 24px;
  }

  .container {
    padding: 32px 20px 70px;
  }
}

@media (max-width: 768px) {
  .payment-wrapper {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .container {
    padding: 28px 16px 60px;
  }

  .payment-sidebar {
    position: static;
  }

  .section-card,
  .tips-card {
    padding: 20px;
  }

  .card-header,
  .sidebar-header {
    margin-bottom: 18px;
    padding-bottom: 14px;
  }

  .action-section {
    flex-direction: column;
  }

  .cancel-btn,
  .confirm-pay-btn {
    width: 100%;
  }

  .methods-grid {
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
  }

  .method-card {
    padding: 18px 12px;
  }

  .method-icon {
    font-size: 38px;
  }

  .method-name {
    font-size: 15px;
  }

  .method-desc {
    font-size: 11px;
  }

  .info-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .copy-btn {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
  }

  .amount-display {
    justify-content: center;
  }

  .currency { font-size: 20px; }
  .amount-value { font-size: 34px; }
  .amount-decimal { font-size: 20px; }

  .total-price {
    font-size: 22px;
  }

  .qrcode-modal {
    padding: 16px;
  }

  .modal-content {
    max-width: 100%;
  }

  .qrcode-box {
    width: 180px;
    height: 180px;
  }

  .amount-big {
    font-size: 26px;
  }

  .countdown-bar {
    flex-wrap: wrap;
    gap: 6px;
  }
}
</style>
