<template>
  <div class="merchant-management">
    <div class="page-header">
      <div>
        <h2>商家管理</h2>
        <p>统一处理商家入驻、非遗资质、账号状态、结算提现和商品内容审核。</p>
      </div>
      <el-button type="primary" plain :loading="merchantAdminStore.loading" @click="refreshData">刷新数据</el-button>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <span class="stat-label">待入驻审核</span>
        <strong>{{ merchantAdminStore.pendingOnboardingCount }}</strong>
      </div>
      <div class="stat-card">
        <span class="stat-label">待资质审核</span>
        <strong>{{ merchantAdminStore.pendingQualificationCount }}</strong>
      </div>
      <div class="stat-card">
        <span class="stat-label">商家账号数</span>
        <strong>{{ merchantAdminStore.merchantAccounts.length }}</strong>
      </div>
      <div class="stat-card">
        <span class="stat-label">待商品审核</span>
        <strong>{{ merchantAdminStore.pendingProductCount }}</strong>
      </div>
      <div class="stat-card">
        <span class="stat-label">待内容审核</span>
        <strong>{{ merchantAdminStore.pendingContentCount }}</strong>
      </div>
      <div class="stat-card">
        <span class="stat-label">待提现审核</span>
        <strong>{{ merchantAdminStore.pendingWithdrawCount }}</strong>
      </div>
    </div>

    <el-alert
      v-if="merchantAdminStore.error"
      class="error-alert"
      :title="merchantAdminStore.error"
      type="error"
      show-icon
      :closable="false"
    />

    <div class="content-card">
      <el-tabs v-model="activeTab">
        <el-tab-pane label="入驻审核" name="onboarding">
          <el-table :data="merchantAdminStore.onboardingApplications" v-loading="merchantAdminStore.loading">
            <el-table-column prop="applicantName" label="申请人" min-width="120" />
            <el-table-column prop="phone" label="手机号" min-width="140" />
            <el-table-column prop="storeName" label="店铺名称" min-width="180" />
            <el-table-column prop="category" label="经营类目" min-width="160" />
            <el-table-column prop="region" label="地区" width="120" />
            <el-table-column prop="submittedAt" label="提交时间" min-width="160" />
            <el-table-column label="附件材料" min-width="220">
              <template #default="{ row }">
                <div v-if="row.attachmentUrls.length" class="link-group">
                  <a v-for="(url, index) in row.attachmentUrls" :key="url" :href="url" target="_blank" rel="noreferrer">
                    材料 {{ index + 1 }}
                  </a>
                </div>
                <span v-else class="muted-text">未上传</span>
              </template>
            </el-table-column>
            <el-table-column prop="note" label="备注" min-width="220" show-overflow-tooltip />
            <el-table-column label="状态" width="110">
              <template #default="{ row }">
                <el-tag :type="auditTagType(row.status)">{{ auditStatusText(row.status) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="190" fixed="right">
              <template #default="{ row }">
                <el-button size="small" type="primary" :disabled="row.status !== 'pending'" @click="handleApproveOnboarding(row.id)">
                  通过
                </el-button>
                <el-button size="small" type="danger" plain :disabled="row.status !== 'pending'" @click="handleRejectOnboarding(row.id)">
                  驳回
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="资质审核" name="qualification">
          <el-table :data="merchantAdminStore.qualificationApplications" v-loading="merchantAdminStore.loading">
            <el-table-column prop="merchantName" label="商家" min-width="160" />
            <el-table-column prop="projectName" label="非遗项目" min-width="200" />
            <el-table-column prop="certificateNo" label="证书编号" min-width="170" />
            <el-table-column prop="issuer" label="发证机构" min-width="180" />
            <el-table-column prop="submittedAt" label="提交时间" min-width="160" />
            <el-table-column label="附件材料" min-width="220">
              <template #default="{ row }">
                <div v-if="row.attachmentUrls.length" class="link-group">
                  <a v-for="(url, index) in row.attachmentUrls" :key="url" :href="url" target="_blank" rel="noreferrer">
                    材料 {{ index + 1 }}
                  </a>
                </div>
                <span v-else class="muted-text">未上传</span>
              </template>
            </el-table-column>
            <el-table-column prop="note" label="审核说明" min-width="220" show-overflow-tooltip />
            <el-table-column label="状态" width="110">
              <template #default="{ row }">
                <el-tag :type="auditTagType(row.status)">{{ auditStatusText(row.status) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="190" fixed="right">
              <template #default="{ row }">
                <el-button size="small" type="primary" :disabled="row.status !== 'pending'" @click="handleApproveQualification(row.id)">
                  通过
                </el-button>
                <el-button size="small" type="danger" plain :disabled="row.status !== 'pending'" @click="handleRejectQualification(row.id)">
                  驳回
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="商家账号" name="accounts">
          <div class="toolbar">
            <el-input v-model="accountKeyword" placeholder="搜索昵称、手机号或店铺名" clearable style="width: 320px" />
          </div>

          <el-table :data="filteredAccounts" v-loading="merchantAdminStore.loading">
            <el-table-column prop="nickname" label="用户昵称" min-width="130" />
            <el-table-column prop="phone" label="手机号" min-width="140" />
            <el-table-column label="角色" min-width="180">
              <template #default="{ row }">
                <div class="tag-group">
                  <el-tag v-for="name in row.roleNames" :key="name" size="small" effect="plain">{{ name }}</el-tag>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="商家角色" width="110">
              <template #default="{ row }">
                <el-switch :model-value="row.isMerchant" @change="handleMerchantRoleChange(row.id, $event)" />
              </template>
            </el-table-column>
            <el-table-column label="店铺名称" min-width="180">
              <template #default="{ row }">
                <el-input
                  :model-value="row.storeName"
                  :disabled="!row.isMerchant"
                  placeholder="未设置"
                  @change="value => handleAccountProfileChange(row.id, { storeName: value })"
                />
              </template>
            </el-table-column>
            <el-table-column label="店铺状态" width="130">
              <template #default="{ row }">
                <el-select
                  :model-value="row.storeStatus"
                  :disabled="!row.isMerchant"
                  @change="value => handleAccountProfileChange(row.id, { storeStatus: value })"
                >
                  <el-option label="正常" value="active" />
                  <el-option label="限流" value="limited" />
                  <el-option label="封禁" value="banned" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column label="非遗认证" width="120">
              <template #default="{ row }">
                <el-switch
                  :model-value="row.heritageCertified"
                  :disabled="!row.isMerchant"
                  @change="value => handleAccountProfileChange(row.id, { heritageCertified: Boolean(value) })"
                />
              </template>
            </el-table-column>
            <el-table-column label="抽佣比例" width="150">
              <template #default="{ row }">
                <el-input-number
                  :model-value="row.commissionRate"
                  :disabled="!row.isMerchant"
                  :min="0"
                  :max="100"
                  :step="0.5"
                  @change="value => handleAccountProfileChange(row.id, { commissionRate: Number(value || 0) })"
                />
              </template>
            </el-table-column>
            <el-table-column label="待结算(元)" min-width="120">
              <template #default="{ row }">{{ formatMoney(row.settlementAmount) }}</template>
            </el-table-column>
            <el-table-column label="待提现(元)" min-width="120">
              <template #default="{ row }">{{ formatMoney(row.withdrawPending) }}</template>
            </el-table-column>
            <el-table-column prop="lastSettlementAt" label="最近结算" min-width="160" />
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="对账结算" name="finance">
          <h3 class="section-title">对账结算</h3>
          <el-table :data="merchantAdminStore.settlementRecords" v-loading="merchantAdminStore.loading">
            <el-table-column prop="merchantName" label="商家" min-width="150" />
            <el-table-column prop="period" label="结算周期" min-width="220" />
            <el-table-column prop="orderCount" label="订单数" width="100" />
            <el-table-column label="营业额(元)" min-width="120">
              <template #default="{ row }">{{ formatMoney(row.turnover) }}</template>
            </el-table-column>
            <el-table-column label="平台抽佣(元)" min-width="130">
              <template #default="{ row }">{{ formatMoney(row.commissionAmount) }}</template>
            </el-table-column>
            <el-table-column label="应结算(元)" min-width="120">
              <template #default="{ row }">{{ formatMoney(row.payableAmount) }}</template>
            </el-table-column>
            <el-table-column label="状态" width="100">
              <template #default="{ row }">
                <el-tag :type="auditTagType(row.status)">{{ financeStatusText(row.status) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="140">
              <template #default="{ row }">
                <el-button size="small" type="primary" :disabled="row.status === 'paid'" @click="handleSettlementPaid(row.id)">
                  确认结算
                </el-button>
              </template>
            </el-table-column>
          </el-table>

          <h3 class="section-title section-gap">提现审核</h3>
          <el-table :data="merchantAdminStore.withdrawRequests" v-loading="merchantAdminStore.loading">
            <el-table-column prop="merchantName" label="商家" min-width="150" />
            <el-table-column label="提现金额(元)" min-width="120">
              <template #default="{ row }">{{ formatMoney(row.amount) }}</template>
            </el-table-column>
            <el-table-column prop="accountName" label="收款人" min-width="120" />
            <el-table-column prop="accountNo" label="收款账号" min-width="170" />
            <el-table-column prop="submittedAt" label="申请时间" min-width="160" />
            <el-table-column label="状态" width="100">
              <template #default="{ row }">
                <el-tag :type="auditTagType(row.status)">{{ withdrawStatusText(row.status) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="190">
              <template #default="{ row }">
                <el-button size="small" type="primary" :disabled="row.status !== 'pending'" @click="handleWithdraw(row.id, 'approved')">
                  通过
                </el-button>
                <el-button size="small" type="danger" plain :disabled="row.status !== 'pending'" @click="handleWithdraw(row.id, 'rejected')">
                  驳回
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="商品审核" name="products">
          <el-table :data="merchantAdminStore.productAudits" v-loading="merchantAdminStore.loading">
            <el-table-column prop="merchantName" label="商家" min-width="150" />
            <el-table-column prop="productName" label="商品名称" min-width="180" />
            <el-table-column prop="category" label="分类" min-width="120" />
            <el-table-column label="价格(元)" min-width="110">
              <template #default="{ row }">{{ formatMoney(row.price) }}</template>
            </el-table-column>
            <el-table-column prop="heritageTag" label="非遗标签" min-width="160" />
            <el-table-column prop="submittedAt" label="提交时间" min-width="160" />
            <el-table-column label="状态" width="100">
              <template #default="{ row }">
                <el-tag :type="auditTagType(row.status)">{{ goodsStatusText(row.status) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="240">
              <template #default="{ row }">
                <el-button size="small" type="primary" :disabled="row.status !== 'pending'" @click="handleProductReview(row.id, 'approved')">
                  上架通过
                </el-button>
                <el-button size="small" type="danger" plain @click="handleProductReview(row.id, 'offline')">
                  下架
                </el-button>
                <el-button size="small" :disabled="row.status !== 'pending'" @click="handleProductReview(row.id, 'rejected')">
                  驳回
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="内容审核" name="contents">
          <h3 class="section-title">非遗文化内容审核</h3>
          <el-table :data="merchantAdminStore.contentAudits" v-loading="merchantAdminStore.loading">
            <el-table-column prop="merchantName" label="商家" min-width="150" />
            <el-table-column prop="title" label="内容标题" min-width="220" />
            <el-table-column prop="contentType" label="内容类型" min-width="130" />
            <el-table-column prop="riskPoint" label="风险点" min-width="180" />
            <el-table-column prop="submittedAt" label="提交时间" min-width="160" />
            <el-table-column label="状态" width="100">
              <template #default="{ row }">
                <el-tag :type="auditTagType(row.status)">{{ auditStatusText(row.status) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="190">
              <template #default="{ row }">
                <el-button size="small" type="primary" :disabled="row.status !== 'pending'" @click="handleContentReview(row.id, 'approved')">
                  通过
                </el-button>
                <el-button size="small" type="danger" plain :disabled="row.status !== 'pending'" @click="handleContentReview(row.id, 'rejected')">
                  驳回
                </el-button>
              </template>
            </el-table-column>
          </el-table>

          <h3 class="section-title section-gap">匠人信息管理</h3>
          <el-table :data="merchantAdminStore.artisanRecords" v-loading="merchantAdminStore.loading">
            <el-table-column prop="merchantName" label="商家" min-width="150" />
            <el-table-column prop="artisanName" label="匠人姓名" min-width="120" />
            <el-table-column prop="heritageSkill" label="非遗技艺" min-width="180" />
            <el-table-column prop="level" label="传承级别" min-width="130" />
            <el-table-column label="认证状态" width="110">
              <template #default="{ row }">
                <el-tag :type="row.verified ? 'success' : 'info'">{{ row.verified ? '已认证' : '未认证' }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="账号状态" width="120">
              <template #default="{ row }">
                <el-tag :type="row.status === 'active' ? 'success' : 'danger'">
                  {{ row.status === 'active' ? '启用' : '停用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="140">
              <template #default="{ row }">
                <el-button size="small" @click="handleArtisanStatus(row.id, row.status === 'active' ? 'disabled' : 'active')">
                  {{ row.status === 'active' ? '停用' : '启用' }}
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="评价审核" name="reviews">
          <div class="sensitive-panel">
            <div>
              <h3 class="section-title">敏感词过滤</h3>
              <p class="section-subtitle">新增命中词后，可辅助识别评价和文化内容中的风险表述。</p>
            </div>
            <div class="sensitive-editor">
              <el-input v-model="newSensitiveWord" placeholder="输入敏感词" clearable />
              <el-button type="primary" @click="handleAddSensitiveWord">新增敏感词</el-button>
            </div>
            <div class="tag-group words">
              <el-tag v-for="word in merchantAdminStore.sensitiveWords" :key="word" closable @close="handleRemoveSensitiveWord(word)">
                {{ word }}
              </el-tag>
            </div>
          </div>

          <el-table :data="merchantAdminStore.reviewAudits" class="review-table" v-loading="merchantAdminStore.loading">
            <el-table-column prop="userName" label="评价用户" min-width="120" />
            <el-table-column prop="merchantName" label="商家" min-width="150" />
            <el-table-column prop="content" label="评价内容" min-width="280" show-overflow-tooltip />
            <el-table-column label="命中词" min-width="180">
              <template #default="{ row }">
                <div class="tag-group">
                  <el-tag v-for="word in row.hitWords" :key="word" size="small" type="warning" effect="plain">
                    {{ word }}
                  </el-tag>
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="submittedAt" label="提交时间" min-width="160" />
            <el-table-column label="状态" width="110">
              <template #default="{ row }">
                <el-tag :type="auditTagType(row.status)">{{ reviewStatusText(row.status) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="220">
              <template #default="{ row }">
                <el-button size="small" type="primary" :disabled="row.status !== 'pending'" @click="handleReviewAudit(row.id, 'approved')">
                  放行
                </el-button>
                <el-button size="small" type="warning" plain :disabled="row.status !== 'pending'" @click="handleReviewAudit(row.id, 'hidden')">
                  隐藏
                </el-button>
                <el-button size="small" type="danger" plain :disabled="row.status !== 'pending'" @click="handleReviewAudit(row.id, 'rejected')">
                  驳回
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { useMerchantAdminStore } from '../../../stores/admin/merchantAdminStore'

const merchantAdminStore = useMerchantAdminStore()

const activeTab = ref('onboarding')
const accountKeyword = ref('')
const newSensitiveWord = ref('')

const filteredAccounts = computed(() => {
  const keyword = accountKeyword.value.trim().toLowerCase()
  if (!keyword) {
    return merchantAdminStore.accounts
  }

  return merchantAdminStore.accounts.filter(account => {
    const values = [account.nickname, account.phone, account.storeName]
    return values.some(value => String(value || '').toLowerCase().includes(keyword))
  })
})

const formatMoney = (value: number) => Number(value || 0).toFixed(2)

const auditStatusText = (status: string) => {
  if (status === 'approved') {
    return '已通过'
  }
  if (status === 'rejected') {
    return '已驳回'
  }
  if (status === 'offline') {
    return '已下架'
  }
  return '待审核'
}

const financeStatusText = (status: string) => {
  if (status === 'paid') {
    return '已结算'
  }
  return '待结算'
}

const withdrawStatusText = (status: string) => {
  if (status === 'approved') {
    return '已通过'
  }
  if (status === 'rejected') {
    return '已驳回'
  }
  return '待审核'
}

const goodsStatusText = (status: string) => {
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

const reviewStatusText = (status: string) => {
  if (status === 'approved') {
    return '已放行'
  }
  if (status === 'hidden') {
    return '已隐藏'
  }
  if (status === 'rejected') {
    return '已驳回'
  }
  return '待审核'
}

const auditTagType = (status: string) => {
  if (status === 'approved' || status === 'paid') {
    return 'success'
  }
  if (status === 'rejected' || status === 'offline' || status === 'hidden') {
    return 'danger'
  }
  return 'warning'
}

const refreshData = async () => {
  try {
    await merchantAdminStore.fetchMerchantAdminData()
  } catch (error) {
    ElMessage.error('刷新商家管理数据失败')
  }
}

const handleApproveOnboarding = async (id: number) => {
  const success = await merchantAdminStore.approveOnboarding(id)
  if (success) {
    ElMessage.success('已通过入驻审核')
  } else {
    ElMessage.error(merchantAdminStore.error || '入驻审核处理失败')
  }
}

const handleRejectOnboarding = async (id: number) => {
  const success = await merchantAdminStore.rejectOnboarding(id)
  if (success) {
    ElMessage.success('已驳回入驻申请')
  } else {
    ElMessage.error(merchantAdminStore.error || '入驻审核处理失败')
  }
}

const handleApproveQualification = async (id: number) => {
  const success = await merchantAdminStore.approveQualification(id)
  if (success) {
    ElMessage.success('非遗资质已通过')
  } else {
    ElMessage.error(merchantAdminStore.error || '资质审核处理失败')
  }
}

const handleRejectQualification = async (id: number) => {
  const success = await merchantAdminStore.rejectQualification(id)
  if (success) {
    ElMessage.success('非遗资质已驳回')
  } else {
    ElMessage.error(merchantAdminStore.error || '资质审核处理失败')
  }
}

const handleMerchantRoleChange = async (userId: number, enabled: string | number | boolean) => {
  const success = await merchantAdminStore.setMerchantRole(userId, Boolean(enabled))
  if (success) {
    ElMessage.success(Boolean(enabled) ? '已授予商家角色' : '已移除商家角色')
  } else {
    ElMessage.error(merchantAdminStore.error || '更新商家角色失败')
  }
}

const handleAccountProfileChange = async (
  userId: number,
  updates: {
    storeName?: string
    storeStatus?: 'active' | 'limited' | 'banned'
    heritageCertified?: boolean
    commissionRate?: number
  }
) => {
  const success = await merchantAdminStore.updateAccountProfile(userId, updates)
  if (success) {
    ElMessage.success('商家账号信息已更新')
  } else {
    ElMessage.error(merchantAdminStore.error || '更新商家账号信息失败')
  }
}

const handleSettlementPaid = async (id: number) => {
  const success = await merchantAdminStore.markSettlementPaid(id)
  if (success) {
    ElMessage.success('已完成结算')
  } else {
    ElMessage.error(merchantAdminStore.error || '结算处理失败')
  }
}

const handleWithdraw = async (id: number, status: 'approved' | 'rejected') => {
  const success = await merchantAdminStore.reviewWithdraw(id, status)
  if (success) {
    ElMessage.success(status === 'approved' ? '提现审核已通过' : '提现申请已驳回')
  } else {
    ElMessage.error(merchantAdminStore.error || '提现审核处理失败')
  }
}

const handleProductReview = async (id: number, status: 'approved' | 'rejected' | 'offline') => {
  const success = await merchantAdminStore.reviewProduct(id, status)
  if (success) {
    ElMessage.success(
      status === 'approved' ? '商品已审核通过并可上架' : status === 'offline' ? '商品已下架' : '商品已驳回'
    )
  } else {
    ElMessage.error(merchantAdminStore.error || '商品审核处理失败')
  }
}

const handleContentReview = async (id: number, status: 'approved' | 'rejected') => {
  const success = await merchantAdminStore.reviewContent(id, status)
  if (success) {
    ElMessage.success(status === 'approved' ? '内容审核已通过' : '内容已驳回')
  } else {
    ElMessage.error(merchantAdminStore.error || '内容审核处理失败')
  }
}

const handleArtisanStatus = async (id: number, status: 'active' | 'disabled') => {
  const success = await merchantAdminStore.toggleArtisanStatus(id, status)
  if (success) {
    ElMessage.success(status === 'active' ? '匠人信息已启用' : '匠人信息已停用')
  } else {
    ElMessage.error(merchantAdminStore.error || '匠人状态更新失败')
  }
}

const handleAddSensitiveWord = async () => {
  const success = await merchantAdminStore.addSensitiveWord(newSensitiveWord.value)
  if (!success) {
    ElMessage.warning(merchantAdminStore.error || '请输入未存在的敏感词')
    return
  }

  newSensitiveWord.value = ''
  ElMessage.success('敏感词已添加')
}

const handleRemoveSensitiveWord = async (word: string) => {
  const success = await merchantAdminStore.removeSensitiveWord(word)
  if (success) {
    ElMessage.success('敏感词已移除')
  } else {
    ElMessage.error(merchantAdminStore.error || '移除敏感词失败')
  }
}

const handleReviewAudit = async (id: number, status: 'approved' | 'hidden' | 'rejected') => {
  const success = await merchantAdminStore.reviewComment(id, status)
  if (success) {
    ElMessage.success(
      status === 'approved' ? '评价内容已放行' : status === 'hidden' ? '评价内容已隐藏' : '评价内容已驳回'
    )
  } else {
    ElMessage.error(merchantAdminStore.error || '评价审核处理失败')
  }
}

onMounted(async () => {
  await refreshData()
})
</script>

<style scoped>
.merchant-management {
  padding: 20px 0;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 20px;
}

.page-header h2 {
  margin: 0 0 6px;
  font-size: 20px;
  color: var(--text-color);
}

.page-header p {
  margin: 0;
  color: #7a8699;
  font-size: 14px;
  line-height: 1.6;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(6, minmax(0, 1fr));
  gap: 14px;
  margin-bottom: 20px;
}

.stat-card {
  background: linear-gradient(135deg, #fff9f6, #fffdf9);
  border: 1px solid rgba(200, 22, 29, 0.08);
  border-radius: 14px;
  padding: 18px;
  box-shadow: var(--shadow);
}

.stat-label {
  display: block;
  font-size: 13px;
  color: #8a7766;
  margin-bottom: 10px;
}

.stat-card strong {
  font-size: 28px;
  color: #c8161d;
}

.error-alert {
  margin-bottom: 20px;
}

.content-card {
  background: var(--bg-white);
  border-radius: 12px;
  box-shadow: var(--shadow);
  padding: 20px;
}
</style>
