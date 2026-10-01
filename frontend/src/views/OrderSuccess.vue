<template>
  <div class="order-success">
    <Header />

    <div class="container" v-if="order">
      <div class="success-content">
        <div class="success-icon">✓</div>
        <h1>订单提交成功</h1>
        <p class="order-no">订单编号：{{ order.orderNo }}</p>
        <p class="order-amount">订单金额：¥{{ order.totalAmount.toFixed(2) }}</p>

        <div class="success-actions">
          <button class="view-orders-btn" @click="router.push('/user/orders')">
            查看我的订单
          </button>
          <button class="continue-shopping-btn" @click="router.push('/shop')">
            继续购物
          </button>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useOrderStore } from '../stores/orderStore'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const orderStore = useOrderStore()

const order = ref<any>(null)

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
  }
})
</script>

<style scoped>
.order-success {
  min-height: 100vh;
  background: var(--bg-color);
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 var(--spacing-md);
}

.success-content {
  background: var(--bg-white);
  border-radius: var(--radius-md);
  padding: var(--spacing-xxl);
  text-align: center;
  box-shadow: var(--shadow);
  margin-top: var(--spacing-xl);
}

.success-icon {
  width: 80px;
  height: 80px;
  background: var(--primary-color);
  color: white;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 40px;
  margin: 0 auto var(--spacing-lg);
}

.success-content h1 {
  font-size: 28px;
  color: var(--text-color);
  margin-bottom: var(--spacing-lg);
}

.order-no,
.order-amount {
  font-size: 16px;
  color: var(--text-light);
  margin-bottom: var(--spacing-sm);
}

.order-amount {
  font-size: 20px;
  font-weight: bold;
  color: var(--primary-color);
  margin-bottom: var(--spacing-xl);
}

.success-actions {
  display: flex;
  gap: var(--spacing-md);
  justify-content: center;
}

.view-orders-btn,
.continue-shopping-btn {
  padding: var(--spacing-md) var(--spacing-xl);
  border-radius: var(--radius-sm);
  font-size: 16px;
  cursor: pointer;
  transition: var(--transition);
}

.view-orders-btn {
  background: var(--primary-color);
  color: white;
  border: none;
}

.view-orders-btn:hover {
  background: #a8131a;
}

.continue-shopping-btn {
  background: var(--bg-white);
  color: var(--text-color);
  border: 1px solid var(--border-color);
}

.continue-shopping-btn:hover {
  border-color: var(--primary-color);
  color: var(--primary-color);
}
</style>
