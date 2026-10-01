<template>
  <div class="merchant-dashboard">
    <section class="metrics-grid">
      <article class="metric-card">
        <span class="metric-label">在售商品</span>
        <strong>{{ merchantStore.approvedProductCount }}</strong>
        <p>已审核通过并可继续经营</p>
      </article>
      <article class="metric-card">
        <span class="metric-label">待审商品</span>
        <strong>{{ merchantStore.pendingProductCount }}</strong>
        <p>等待平台完成上架审核</p>
      </article>
      <article class="metric-card">
        <span class="metric-label">待审内容</span>
        <strong>{{ merchantStore.pendingContentCount }}</strong>
        <p>文化内容和匠人信息待复核</p>
      </article>
      <article class="metric-card">
        <span class="metric-label">累计营业额</span>
        <strong>¥{{ formatMoney(merchantStore.totalTurnover) }}</strong>
        <p>按当前结算记录汇总</p>
      </article>
    </section>

    <section class="panel-grid">
      <div class="panel">
        <div class="panel-head">
          <div>
            <h3>店铺概况</h3>
            <p>快速查看店铺状态和经营配置</p>
          </div>
          <router-link to="/merchant/profile" class="link-text">编辑资料</router-link>
        </div>

        <div class="overview-list">
          <div class="overview-item">
            <span>店铺名称</span>
            <strong>{{ merchantStore.profile.storeName }}</strong>
          </div>
          <div class="overview-item">
            <span>店铺状态</span>
            <strong>{{ storeStatusText }}</strong>
          </div>
          <div class="overview-item">
            <span>非遗认证</span>
            <strong>{{ merchantStore.profile.heritageCertified ? '已通过' : '待认证' }}</strong>
          </div>
          <div class="overview-item">
            <span>平台抽佣</span>
            <strong>{{ merchantStore.profile.commissionRate }}%</strong>
          </div>
          <div class="overview-item">
            <span>待结算金额</span>
            <strong>¥{{ formatMoney(merchantStore.profile.settlementAmount) }}</strong>
          </div>
          <div class="overview-item">
            <span>待提现金额</span>
            <strong>¥{{ formatMoney(merchantStore.profile.withdrawPending) }}</strong>
          </div>
        </div>
      </div>

      <div class="panel">
        <div class="panel-head">
          <div>
            <h3>近期商品提审</h3>
            <p>查看最近提交的商品审核进度</p>
          </div>
          <router-link to="/merchant/products" class="link-text">去管理</router-link>
        </div>

        <div v-if="merchantStore.products.length" class="mini-list">
          <div v-for="item in recentProducts" :key="item.id" class="mini-item">
            <div>
              <strong>{{ item.productName }}</strong>
              <p>{{ item.category }} / {{ item.heritageTag }}</p>
            </div>
            <span class="status" :class="item.status">{{ productStatusText(item.status) }}</span>
          </div>
        </div>
        <div v-else class="empty-state">暂无商品记录</div>
      </div>

      <div class="panel">
        <div class="panel-head">
          <div>
            <h3>近期内容提审</h3>
            <p>文化内容和匠人专题的提交状态</p>
          </div>
          <router-link to="/merchant/content" class="link-text">去管理</router-link>
        </div>

        <div v-if="merchantStore.contents.length" class="mini-list">
          <div v-for="item in recentContents" :key="item.id" class="mini-item">
            <div>
              <strong>{{ item.title }}</strong>
              <p>{{ item.contentType }} / {{ item.riskPoint }}</p>
            </div>
            <span class="status" :class="item.status">{{ contentStatusText(item.status) }}</span>
          </div>
        </div>
        <div v-else class="empty-state">暂无内容记录</div>
      </div>

      <div class="panel">
        <div class="panel-head">
          <div>
            <h3>最近结算周期</h3>
            <p>查看平台对账和结算进度</p>
          </div>
          <router-link to="/merchant/finance" class="link-text">去结算</router-link>
        </div>

        <div v-if="merchantStore.latestSettlement" class="settlement-box">
          <strong>{{ merchantStore.latestSettlement.period }}</strong>
          <p>订单数：{{ merchantStore.latestSettlement.orderCount }}</p>
          <p>营业额：¥{{ formatMoney(merchantStore.latestSettlement.turnover) }}</p>
          <p>应结算：¥{{ formatMoney(merchantStore.latestSettlement.payableAmount) }}</p>
        </div>
        <div v-else class="empty-state">暂无结算记录</div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useMerchantWorkbenchStore } from '../../../stores/merchantWorkbenchStore'

const merchantStore = useMerchantWorkbenchStore()

const recentProducts = computed(() => merchantStore.products.slice(0, 3))
const recentContents = computed(() => merchantStore.contents.slice(0, 3))

const formatMoney = (value: number) => Number(value || 0).toFixed(2)

const storeStatusText = computed(() => {
  if (merchantStore.profile.storeStatus === 'banned') {
    return '已封禁'
  }
  if (merchantStore.profile.storeStatus === 'limited') {
    return '已限流'
  }
  return '正常'
})

const productStatusText = (status: string) => {
  if (status === 'approved') {
    return '已上架'
  }
  if (status === 'offline') {
    return '已下架'
  }
  if (status === 'rejected') {
    return '已驳回'
  }
  return '待审核'
}

const contentStatusText = (status: string) => {
  if (status === 'approved') {
    return '已发布'
  }
  if (status === 'rejected') {
    return '已驳回'
  }
  return '待审核'
}

onMounted(async () => {
  await merchantStore.initialize()
})
</script>

<style scoped>
.merchant-dashboard {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.metrics-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.metric-card,
.panel {
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid rgba(199, 155, 74, 0.18);
  border-radius: 20px;
  box-shadow: 0 18px 40px rgba(92, 55, 20, 0.06);
}

.metric-card {
  padding: 22px;
}

.metric-label {
  display: block;
  margin-bottom: 12px;
  color: #876f59;
  font-size: 13px;
}

.metric-card strong {
  display: block;
  font-size: 28px;
  color: #c8161d;
  margin-bottom: 8px;
}

.metric-card p {
  margin: 0;
  color: #7c6a58;
  font-size: 13px;
  line-height: 1.6;
}

.panel-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
}

.panel {
  padding: 22px;
}

.panel-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
  margin-bottom: 16px;
}

.panel-head h3 {
  margin: 0 0 6px;
  color: #2f2418;
}

.panel-head p {
  margin: 0;
  color: #7c6a58;
  font-size: 13px;
}

.link-text {
  color: #c8161d;
  text-decoration: none;
  font-size: 14px;
}

.overview-list {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

.overview-item {
  padding: 14px;
  border-radius: 14px;
  background: #faf6ef;
}

.overview-item span {
  display: block;
  color: #8a7766;
  font-size: 12px;
  margin-bottom: 6px;
}

.overview-item strong {
  color: #2f2418;
}

.mini-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.mini-item {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  padding: 14px;
  border-radius: 14px;
  background: #faf6ef;
}

.mini-item strong {
  color: #2f2418;
}

.mini-item p {
  margin: 6px 0 0;
  color: #7c6a58;
  font-size: 13px;
}

.status {
  align-self: center;
  padding: 6px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 700;
}

.status.pending {
  background: #fff4dc;
  color: #b76a08;
}

.status.approved {
  background: #e7f8ee;
  color: #1f8f52;
}

.status.rejected,
.status.offline {
  background: #fdeceb;
  color: #c5443d;
}

.settlement-box {
  padding: 16px;
  border-radius: 14px;
  background: #faf6ef;
  line-height: 1.8;
  color: #5b4938;
}

.settlement-box strong {
  display: block;
  color: #2f2418;
  margin-bottom: 4px;
}

.empty-state {
  padding: 24px 16px;
  border-radius: 14px;
  background: #faf6ef;
  color: #8a7766;
  text-align: center;
}

@media (max-width: 960px) {
  .metrics-grid,
  .panel-grid,
  .overview-list {
    grid-template-columns: 1fr;
  }
}
</style>
