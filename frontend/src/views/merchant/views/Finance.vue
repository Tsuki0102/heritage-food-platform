<template>
  <div class="merchant-finance">
    <section class="metrics-grid">
      <article class="metric-card">
        <span>待结算金额</span>
        <strong>¥{{ formatMoney(merchantStore.profile.settlementAmount) }}</strong>
      </article>
      <article class="metric-card">
        <span>待提现金额</span>
        <strong>¥{{ formatMoney(merchantStore.profile.withdrawPending) }}</strong>
      </article>
      <article class="metric-card">
        <span>最近结算时间</span>
        <strong>{{ merchantStore.profile.lastSettlementAt }}</strong>
      </article>
    </section>

    <div class="panel-grid">
      <section class="panel">
        <div class="panel-head">
          <h3>提现申请</h3>
          <p>提交后会进入平台提现审核流程。</p>
        </div>

        <el-form label-width="100px">
          <el-form-item label="提现金额">
            <el-input-number v-model="withdrawForm.amount" :min="1" :precision="2" :step="100" controls-position="right" />
          </el-form-item>
          <el-form-item label="收款人">
            <el-input v-model.trim="withdrawForm.accountName" />
          </el-form-item>
          <el-form-item label="收款账号">
            <el-input v-model.trim="withdrawForm.accountNo" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" :loading="submitting" @click="submitWithdraw">提交提现申请</el-button>
          </el-form-item>
        </el-form>
      </section>

      <section class="panel">
        <div class="panel-head">
          <h3>结算说明</h3>
          <p>当前展示的是平台对账后的经营汇总结果。</p>
        </div>

        <div class="note-list">
          <div class="note-item">平台抽佣比例：{{ merchantStore.profile.commissionRate }}%</div>
          <div class="note-item">非遗认证状态：{{ merchantStore.profile.heritageCertified ? '已通过' : '待补充' }}</div>
          <div class="note-item">店铺状态：{{ storeStatusText }}</div>
          <div class="note-item">如需修改联系人和简介，可在商家资料页维护。</div>
        </div>
      </section>
    </div>

    <section class="panel table-panel">
      <div class="panel-head">
        <h3>结算记录</h3>
        <p>按周期展示平台对账和应结算金额。</p>
      </div>

      <el-table :data="merchantStore.settlements" v-loading="merchantStore.loading">
        <el-table-column prop="period" label="结算周期" min-width="220" />
        <el-table-column prop="orderCount" label="订单数" width="100" />
        <el-table-column label="营业额" min-width="120">
          <template #default="{ row }">¥{{ formatMoney(row.turnover) }}</template>
        </el-table-column>
        <el-table-column label="平台抽佣" min-width="120">
          <template #default="{ row }">¥{{ formatMoney(row.commissionAmount) }}</template>
        </el-table-column>
        <el-table-column label="应结算" min-width="120">
          <template #default="{ row }">¥{{ formatMoney(row.payableAmount) }}</template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'paid' ? 'success' : 'warning'">
              {{ row.status === 'paid' ? '已结算' : '待结算' }}
            </el-tag>
          </template>
        </el-table-column>
      </el-table>
    </section>

    <section class="panel table-panel">
      <div class="panel-head">
        <h3>提现记录</h3>
        <p>跟踪提现审核结果和到账进度。</p>
      </div>

      <el-table :data="merchantStore.withdraws" v-loading="merchantStore.loading">
        <el-table-column prop="submittedAt" label="申请时间" min-width="170" />
        <el-table-column label="提现金额" min-width="120">
          <template #default="{ row }">¥{{ formatMoney(row.amount) }}</template>
        </el-table-column>
        <el-table-column prop="accountName" label="收款人" min-width="120" />
        <el-table-column prop="accountNo" label="收款账号" min-width="170" />
        <el-table-column label="状态" width="110">
          <template #default="{ row }">
            <el-tag :type="withdrawTagType(row.status)">{{ withdrawStatusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
      </el-table>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { useMerchantWorkbenchStore } from '../../../stores/merchantWorkbenchStore'

const merchantStore = useMerchantWorkbenchStore()
const submitting = ref(false)

const withdrawForm = reactive({
  amount: 100,
  accountName: '',
  accountNo: ''
})

const formatMoney = (value: number) => Number(value || 0).toFixed(2)

const storeStatusText = computed(() => {
  if (merchantStore.profile.storeStatus === 'banned') {
    return '封禁'
  }
  if (merchantStore.profile.storeStatus === 'limited') {
    return '限流'
  }
  return '正常'
})

const withdrawStatusText = (status: string) => {
  if (status === 'approved') {
    return '已通过'
  }
  if (status === 'rejected') {
    return '已驳回'
  }
  return '待审核'
}

const withdrawTagType = (status: string) => {
  if (status === 'approved') {
    return 'success'
  }
  if (status === 'rejected') {
    return 'danger'
  }
  return 'warning'
}

const syncWithdrawForm = () => {
  withdrawForm.accountName = merchantStore.meta.contactName || ''
}

const submitWithdraw = async () => {
  if (!withdrawForm.amount || !withdrawForm.accountName || !withdrawForm.accountNo) {
    ElMessage.warning('请完整填写提现信息')
    return
  }

  submitting.value = true

  try {
    await merchantStore.submitWithdraw(withdrawForm.amount, withdrawForm.accountName, withdrawForm.accountNo)
    withdrawForm.accountNo = ''
    ElMessage.success('提现申请已提交')
  } catch (error) {
    ElMessage.error('提现申请提交失败')
  } finally {
    submitting.value = false
  }
}

onMounted(async () => {
  await merchantStore.initialize()
  syncWithdrawForm()
})
</script>

<style scoped>
.merchant-finance {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.metrics-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
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

.metric-card span {
  display: block;
  color: #876f59;
  font-size: 13px;
  margin-bottom: 10px;
}

.metric-card strong {
  font-size: 26px;
  color: #c8161d;
}

.panel-grid {
  display: grid;
  grid-template-columns: 1.1fr 0.9fr;
  gap: 18px;
}

.panel {
  padding: 22px;
}

.table-panel {
  padding-bottom: 10px;
}

.panel-head h3 {
  margin: 0 0 6px;
  color: #2f2418;
}

.panel-head p {
  margin: 0 0 16px;
  color: #7c6a58;
  font-size: 13px;
}

.note-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.note-item {
  padding: 12px 14px;
  border-radius: 12px;
  background: #faf6ef;
  color: #5b4938;
}

@media (max-width: 960px) {
  .metrics-grid,
  .panel-grid {
    grid-template-columns: 1fr;
  }
}
</style>
