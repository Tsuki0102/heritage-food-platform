<template>
  <div class="merchant-test">
    <div class="container">
      <h1>🏪 商家系统测试页面</h1>
      
      <div class="info-card">
        <h3>📝 当前登录用户</h3>
        <div v-if="userStore.user">
          <p><strong>用户ID：</strong>{{ userStore.user.id }}</p>
          <p><strong>昵称：</strong>{{ userStore.user.nickname }}</p>
          <p><strong>手机号：</strong>{{ userStore.user.phone }}</p>
          <p><strong>是否管理员：</strong>{{ userStore.user.isAdmin === 1 ? '是' : '否' }}</p>
        </div>
        <div v-else>
          <p class="warning">⚠️ 请先登录</p>
          <router-link to="/login" class="btn btn-primary">去登录</router-link>
        </div>
      </div>

      <div class="actions">
        <button class="btn btn-success" @click="testMerchantWorkspace" :disabled="loading">
          {{ loading ? '加载中...' : '获取商家工作台' }}
        </button>
        
        <button class="btn btn-info" @click="testAdminWorkspace" :disabled="loading">
          {{ loading ? '加载中...' : '获取管理端工作台' }}
        </button>
      </div>

      <div v-if="workspaceData" class="result-card">
        <h3>📊 返回结果</h3>
        <pre>{{ JSON.stringify(workspaceData, null, 2) }}</pre>
      </div>

      <div v-if="errorMsg" class="error-card">
        <h3>❌ 错误信息</h3>
        <p>{{ errorMsg }}</p>
      </div>

      <div class="tips-card">
        <h3>💡 使用提示</h3>
        <ul>
          <li>使用商家账号 (13800138003) 登录，然后测试商家工作台</li>
          <li>使用管理员账号 (13800138001) 登录，然后测试管理端工作台</li>
          <li>确保数据库中已执行 merchant-schema.sql 和 merchant-test-data.sql</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useUserStore } from '../stores/userStore'
import { getMerchantWorkspace, getAdminMerchantWorkspace } from '../api/merchantApi'

const userStore = useUserStore()
const loading = ref(false)
const workspaceData = ref(null)
const errorMsg = ref('')

const testMerchantWorkspace = async () => {
  loading.value = true
  errorMsg.value = ''
  workspaceData.value = null
  
  try {
    const userId = userStore.user?.id || 3
    const isAdmin = userStore.user?.isAdmin === 1
    const data = await getMerchantWorkspace(userId, isAdmin)
    workspaceData.value = data
    console.log('商家工作台数据：', data)
  } catch (error) {
    errorMsg.value = error.message || '获取商家工作台失败'
    console.error('获取商家工作台失败：', error)
  } finally {
    loading.value = false
  }
}

const testAdminWorkspace = async () => {
  loading.value = true
  errorMsg.value = ''
  workspaceData.value = null
  
  try {
    const data = await getAdminMerchantWorkspace()
    workspaceData.value = data
    console.log('管理端工作台数据：', data)
  } catch (error) {
    errorMsg.value = error.message || '获取管理端工作台失败'
    console.error('获取管理端工作台失败：', error)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.merchant-test {
  min-height: 100vh;
  background: linear-gradient(135deg, #fdf9f4 0%, #faf4eb 100%);
  padding: 40px 20px;
}

.container {
  max-width: 900px;
  margin: 0 auto;
}

h1 {
  color: #2f2418;
  text-align: center;
  margin-bottom: 30px;
  font-size: 32px;
}

.info-card, .tips-card, .result-card, .error-card {
  background: white;
  padding: 24px;
  border-radius: 16px;
  margin-bottom: 24px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  border: 1px solid #e8dcc8;
}

h3 {
  color: #c8161d;
  margin-bottom: 16px;
  display: flex;
  align-items: center;
  gap: 8px;
}

p {
  color: #5a4432;
  line-height: 1.8;
  margin: 8px 0;
}

strong {
  color: #2f2418;
}

.warning {
  color: #d48806;
  font-weight: 600;
}

.actions {
  display: flex;
  gap: 16px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}

.btn {
  padding: 14px 28px;
  border: none;
  border-radius: 12px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-primary {
  background: linear-gradient(135deg, #c8161d, #e23d2a);
  color: white;
}

.btn-primary:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.3);
}

.btn-success {
  background: linear-gradient(135deg, #10b981, #059669);
  color: white;
}

.btn-success:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
}

.btn-info {
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  color: white;
}

.btn-info:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
}

pre {
  background: #f5efe8;
  padding: 16px;
  border-radius: 8px;
  overflow-x: auto;
  font-size: 13px;
  line-height: 1.6;
  color: #333;
}

.error-card {
  background: #fef2f2;
  border-color: #fecdd3;
}

.error-card h3 {
  color: #dc2626;
}

.error-card p {
  color: #991b1b;
}

ul {
  color: #5a4432;
  line-height: 2;
}
</style>
