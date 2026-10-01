<template>
  <div class="user-orders-page">
    <Header />

    <!-- 页面横幅 -->
    <BannerSection
      title="我的订单"
      subtitle="查看和管理您的所有订单记录"
      badge-icon="📦"
      badge="订单中心"
    />

    <div class="container">
      <!-- 标签页导航 -->
      <div class="tabs-section">
        <div class="tabs-wrapper">
          <button
            v-for="tab in tabs"
            :key="tab.value"
            :class="['tab-item', { active: activeTab === tab.value }]"
            @click="handleTabChange(tab.value)"
          >
            <span class="tab-icon">{{ getTabIcon(tab.value) }}</span>
            <span class="tab-text">{{ tab.label }}</span>
          </button>
        </div>
      </div>

      <!-- 订单列表 -->
      <div class="orders-content">
        <template v-if="!loading && orders.length > 0">
          <div v-for="order in orders" :key="order.id" class="order-card">
            <!-- 订单头部 -->
            <div class="card-header">
              <div class="header-left">
                <span class="order-icon">🧾</span>
                <span class="order-no">订单号：{{ order.orderNo }}</span>
              </div>
              <span :class="['status-badge', getStatusClass(order.status)]">
                {{ getStatusText(order.status) }}
              </span>
            </div>

            <!-- 商品列表 -->
            <div class="items-list">
              <div
                v-for="item in order.items"
                :key="item.id"
                class="item-row"
                @click="router.push(`/product/${item.productId}`)"
              >
                <div class="item-image">
                  <img :src="item.coverImage" :alt="item.productName" @error="handleImageError" />
                  <div class="image-overlay">查看详情 →</div>
                </div>
                <div class="item-details">
                  <h4 class="item-name">{{ item.productName }}</h4>
                  <p class="item-price">¥{{ item.price.toFixed(2) }}</p>
                </div>
                <div class="item-quantity">x{{ item.quantity }}</div>
              </div>
            </div>

            <!-- 订单底部 -->
            <div class="card-footer">
              <div class="footer-info">
                <span class="date-info">
                  <span class="info-icon">📅</span>
                  {{ formatDate(order.createdAt) }}
                </span>
                <span class="total-amount">
                  合计：<strong>¥{{ order.totalAmount.toFixed(2) }}</strong>
                </span>
              </div>
              <div class="action-buttons">
                <button
                  v-if="order.status === 0"
                  class="btn-action btn-pay"
                  @click="handlePayOrder(order)"
                >
                  <span class="btn-icon">💳</span>
                  去支付
                </button>
                <button
                  v-if="order.status === 2"
                  class="btn-action btn-receive"
                  @click="handleConfirmReceive(order.id)"
                >
                  <span class="btn-icon">✅</span>
                  确认收货
                </button>
                <button
                  v-if="order.status === 0"
                  class="btn-action btn-cancel"
                  @click="handleCancelOrder(order.id)"
                >
                  <span class="btn-icon">❌</span>
                  取消订单
                </button>
              </div>
            </div>
          </div>

          <!-- 分页器 -->
          <div class="pagination-wrapper" v-if="totalPages > 1">
            <button
              class="page-btn"
              :disabled="currentPage === 1"
              @click="handlePageChange(currentPage - 1)"
            >
              ← 上一页
            </button>
            <div class="page-info">
              第 <strong>{{ currentPage }}</strong> / 共 <strong>{{ totalPages }}</strong> 页
            </div>
            <button
              class="page-btn"
              :disabled="currentPage === totalPages"
              @click="handlePageChange(currentPage + 1)"
            >
              下一页 →
            </button>
          </div>
        </template>

        <!-- 空状态 -->
        <div class="empty-state" v-if="!loading && orders.length === 0">
          <div class="empty-content">
            <div class="empty-icon">📦</div>
            <h3 class="empty-title">暂无订单</h3>
            <p class="empty-desc">您还没有任何订单记录</p>
            <button class="go-shopping-btn btn-primary" @click="router.push('/shop')">
              <span class="btn-icon">🛒</span>
              去商城逛逛
            </button>
          </div>
        </div>

        <!-- 加载状态 -->
        <div class="loading-state" v-if="loading">
          <div class="loader"></div>
          <p class="loading-text">正在加载订单...</p>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useOrderStore } from '../stores/orderStore'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ORDER_STATUS_TEXT } from '../types/order'

const router = useRouter()
const orderStore = useOrderStore()

const activeTab = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const loading = computed(() => orderStore.loading)

const tabs = [
  { label: '全部', value: 0 },
  { label: '待支付', value: 1 },
  { label: '待发货', value: 2 },
  { label: '待收货', value: 3 },
  { label: '已完成', value: 4 },
  { label: '已取消', value: 5 }
]

const orders = computed(() => orderStore.orders)
const totalPages = computed(() => orderStore.pagination.totalPages)

const getTabIcon = (value: number) => {
  const iconMap: Record<number, string> = {
    0: '📋',
    1: '💰',
    2: '🚚',
    3: '📬',
    4: '✨',
    5: '❌'
  }
  return iconMap[value] || '📋'
}

const getStatusText = (status: number) => {
  const statusMap: Record<number, string> = {
    0: '待支付',
    1: '已支付',
    2: '已发货',
    3: '已完成',
    4: '已取消'
  }
  return statusMap[status] || '未知'
}

const getStatusClass = (status: number) => {
  const classMap: Record<number, string> = {
    0: 'status-pending',
    1: 'status-paid',
    2: 'status-shipped',
    3: 'status-completed',
    4: 'status-cancelled'
  }
  return classMap[status] || ''
}

const formatDate = (dateStr: string) => {
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const handleTabChange = async (tab: number) => {
  activeTab.value = tab
  currentPage.value = 1
  await fetchOrders()
}

const handlePageChange = async (page: number) => {
  currentPage.value = page
  await fetchOrders()
}

const fetchOrders = async () => {
  try {
    const params: any = {
      page: currentPage.value,
      pageSize: pageSize.value
    }

    if (activeTab.value === 1) params.status = 0
    else if (activeTab.value === 2) params.status = 1
    else if (activeTab.value === 3) params.status = 2
    else if (activeTab.value === 4) params.status = 3
    else if (activeTab.value === 5) params.status = 4

    await orderStore.fetchOrders(params)
  } catch (error) {
    ElMessage.error('获取订单列表失败')
  }
}

const handlePayOrder = (order: any) => {
  router.push({
    path: '/order/payment',
    query: { orderNo: order.orderNo }
  })
}

const handleConfirmReceive = async (id: number) => {
  try {
    await ElMessageBox.confirm('确定已收到货物吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await orderStore.confirmReceiveById(id)
    ElMessage.success('确认收货成功')
    await fetchOrders()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('确认收货失败')
    }
  }
}

const handleCancelOrder = async (id: number) => {
  try {
    await ElMessageBox.confirm('确定要取消该订单吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await orderStore.cancelOrderById(id)
    ElMessage.success('订单已取消')
    await fetchOrders()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('取消订单失败')
    }
  }
}

const handleImageError = (event: Event) => {
  const target = event.target as HTMLImageElement
  target.src = '/images/beijing-duck.jpg'
}

onMounted(async () => {
  await fetchOrders()
})
</script>

<style scoped>
.user-orders-page {
  min-height: 100vh;
  background: var(--gradient-bg);
}

.container {
  max-width: 1000px;
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
  overflow-x: auto;
}

.tab-item {
  flex: 1;
  min-width: fit-content;
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

/* ====== 订单内容 ====== */
.orders-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* 订单卡片 */
.order-card {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.order-card::before {
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

.order-card:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-lg);
}

.order-card:hover::before {
  opacity: 1;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px 28px;
  border-bottom: 1.5px dashed rgba(212, 175, 55, 0.25);
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
}

.header-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.order-icon {
  font-size: 22px;
}

.order-no {
  font-size: 14px;
  color: var(--text-light);
  font-weight: 500;
  letter-spacing: 0.5px;
}

.status-badge {
  padding: 7px 18px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.5px;
}

.status-pending {
  background: linear-gradient(135deg, #fff3e0, #ffe0b2);
  color: #e65100;
  box-shadow: 0 4px 12px rgba(230, 81, 0, 0.15);
}

.status-paid {
  background: linear-gradient(135deg, #e3f2fd, #bbdefb);
  color: #1565c0;
  box-shadow: 0 4px 12px rgba(21, 101, 192, 0.15);
}

.status-shipped {
  background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
  color: #2e7d32;
  box-shadow: 0 4px 12px rgba(46, 125, 50, 0.15);
}

.status-completed {
  background: linear-gradient(135deg, #f3e5f5, #e1bee7);
  color: #6a1b9a;
  box-shadow: 0 4px 12px rgba(106, 27, 154, 0.15);
}

.status-cancelled {
  background: linear-gradient(135deg, #fafafa, #f5f5f5);
  color: #757575;
  box-shadow: 0 4px 12px rgba(117, 117, 117, 0.15);
}

/* 商品列表 */
.items-list {
  padding: 20px 28px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.item-row {
  display: grid;
  grid-template-columns: 80px 1fr auto;
  gap: 20px;
  align-items: center;
  cursor: pointer;
  padding: 16px;
  border-radius: var(--radius-md);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.item-row:hover {
  background: linear-gradient(135deg, rgba(200,22,29,0.03), rgba(212,175,55,0.03));
  transform: translateX(6px);
}

.item-image {
  width: 80px;
  height: 80px;
  border-radius: var(--radius-md);
  overflow: hidden;
  border: 2px solid var(--border-gold);
  position: relative;
  transition: all 0.3s ease;
}

.item-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: all 0.3s ease;
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
  font-size: 12px;
  font-weight: 600;
  opacity: 0;
  transition: all 0.3s ease;
}

.item-row:hover .image-overlay {
  opacity: 1;
}

.item-row:hover .item-image img {
  transform: scale(1.08);
}

.item-row:hover .item-image {
  border-color: var(--primary-color);
  box-shadow: 0 6px 16px rgba(200, 22, 29, 0.2);
}

.item-details {
  flex: 1;
}

.item-name {
  font-size: 16px;
  color: var(--text-color);
  margin-bottom: 8px;
  font-weight: 600;
  line-height: 1.4;
}

.item-price {
  font-size: 17px;
  color: var(--primary-color);
  font-weight: 700;
}

.item-quantity {
  font-size: 16px;
  color: var(--text-light);
  font-weight: 600;
  text-align: right;
  padding: 8px 16px;
  background: linear-gradient(135deg, rgba(212,175,55,0.06), rgba(212,175,55,0.02));
  border-radius: var(--radius-sm);
  border: 1px solid var(--border-gold);
}

/* 订单底部 */
.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 28px;
  border-top: 1.5px dashed rgba(212, 175, 55, 0.25);
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
}

.footer-info {
  display: flex;
  align-items: center;
  gap: 20px;
  flex-wrap: wrap;
}

.date-info {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: var(--text-light);
  font-weight: 500;
}

.info-icon { font-size: 16px; }

.total-amount {
  font-size: 16px;
  color: var(--text-color);
  font-weight: 500;
}

.total-amount strong {
  font-size: 22px;
  color: var(--primary-color);
  font-weight: 800;
  margin-left: 4px;
}

.action-buttons {
  display: flex;
  gap: 12px;
}

.btn-action {
  padding: 11px 24px;
  border-radius: var(--radius-sm);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  gap: 6px;
  border: none;
  letter-spacing: 0.5px;
}

.btn-icon { font-size: 16px; }

.btn-pay {
  background: var(--gradient-primary);
  color: white;
  box-shadow: 0 4px 12px rgba(200, 22, 29, 0.25);
}

.btn-pay:hover {
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.35);
}

.btn-receive {
  background: linear-gradient(135deg, var(--secondary-color), #d4a520);
  color: white;
  box-shadow: 0 4px 12px rgba(212, 175, 55, 0.25);
}

.btn-receive:hover {
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 8px 20px rgba(212, 175, 55, 0.35);
}

.btn-cancel {
  background: white;
  color: var(--text-light);
  border: 2px solid var(--border-gold);
}

.btn-cancel:hover {
  border-color: var(--primary-color);
  color: var(--primary-color);
  background: linear-gradient(135deg, rgba(200,22,29,0.04), rgba(212,175,55,0.04));
  transform: translateY(-2px);
}

/* 分页器 */
.pagination-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
  padding: 28px 0;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
}

.page-btn {
  padding: 12px 24px;
  background: white;
  color: var(--text-color);
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.page-btn:hover:not(:disabled) {
  border-color: var(--primary-color);
  color: var(--primary-color);
  background: linear-gradient(135deg, rgba(200,22,29,0.04), rgba(212,175,55,0.04));
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(200, 22, 29, 0.12);
}

.page-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
  transform: none !important;
}

.page-info {
  font-size: 15px;
  color: var(--text-light);
  font-weight: 500;
}

.page-info strong {
  color: var(--primary-color);
  font-size: 18px;
  font-weight: 800;
  margin: 0 4px;
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

.go-shopping-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 16px 36px;
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 1px;
  border-radius: var(--radius-sm);
}

.go-shopping-btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 12px 28px rgba(200, 22, 29, 0.4);
}

/* 加载状态 */
.loading-state {
  text-align: center;
  padding: 80px 20px;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
}

.loader {
  width: 50px;
  height: 50px;
  border: 4px solid var(--border-gold);
  border-top-color: var(--primary-color);
  border-right-color: var(--secondary-color);
  border-radius: 50%;
  animation: spin 1s cubic-bezier(0.68, -0.55, 0.265, 1.55) infinite;
  margin: 0 auto 24px;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
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

/* 响应式设计 */
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

  .card-header,
  .items-list,
  .card-footer {
    padding: 16px 20px;
  }

  .header-left {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .item-row {
    grid-template-columns: 60px 1fr auto;
    gap: 12px;
    padding: 12px;
  }

  .item-image {
    width: 60px;
    height: 60px;
  }

  .item-name {
    font-size: 14px;
  }

  .item-price {
    font-size: 15px;
  }

  .footer-info {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }

  .action-buttons {
    flex-direction: column;
    width: 100%;
  }

  .btn-action {
    width: 100%;
    justify-content: center;
  }

  .total-amount strong {
    font-size: 18px;
  }

  .empty-icon {
    font-size: 60px;
  }

  .empty-title {
    font-size: 22px;
  }

  .pagination-wrapper {
    flex-direction: column;
    gap: 16px;
  }

  .page-btn {
    width: 100%;
  }
}
</style>
