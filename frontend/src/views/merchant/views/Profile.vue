<template>
  <div class="merchant-profile">
    <div class="panel">
      <div class="panel-head">
        <div>
          <h3>商家资料</h3>
          <p>维护店铺展示信息、联系人资料和简介。</p>
        </div>
      </div>

      <div class="profile-layout">
        <div class="form-card">
          <el-form label-width="100px">
            <el-form-item label="店铺名称">
              <el-input v-model.trim="form.storeName" />
            </el-form-item>
            <el-form-item label="联系人">
              <el-input v-model.trim="form.contactName" />
            </el-form-item>
            <el-form-item label="联系电话">
              <el-input v-model.trim="form.contactPhone" />
            </el-form-item>
            <el-form-item label="店铺介绍">
              <el-input v-model.trim="form.introduction" type="textarea" :rows="5" />
            </el-form-item>
            <el-form-item label="店铺状态">
              <el-tag :type="storeStatusTag">{{ storeStatusText }}</el-tag>
            </el-form-item>
            <el-form-item label="非遗认证">
              <el-tag :type="merchantStore.profile.heritageCertified ? 'success' : 'warning'">
                {{ merchantStore.profile.heritageCertified ? '已认证' : '待认证' }}
              </el-tag>
            </el-form-item>
            <el-form-item label="平台抽佣">
              <span class="plain-text">{{ merchantStore.profile.commissionRate }}%</span>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" :loading="saving" @click="saveProfile">保存资料</el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { useMerchantWorkbenchStore } from '../../../stores/merchantWorkbenchStore'

const merchantStore = useMerchantWorkbenchStore()
const saving = ref(false)

const form = reactive({
  storeName: '',
  contactName: '',
  contactPhone: '',
  introduction: ''
})

const syncForm = () => {
  form.storeName = merchantStore.profile.storeName
  form.contactName = merchantStore.meta.contactName
  form.contactPhone = merchantStore.meta.contactPhone
  form.introduction = merchantStore.meta.introduction
}

const storeStatusText = computed(() => {
  if (merchantStore.profile.storeStatus === 'banned') {
    return '店铺已封禁'
  }
  if (merchantStore.profile.storeStatus === 'limited') {
    return '店铺已限流'
  }
  return '店铺正常营业'
})

const storeStatusTag = computed(() => {
  if (merchantStore.profile.storeStatus === 'banned') {
    return 'danger'
  }
  if (merchantStore.profile.storeStatus === 'limited') {
    return 'warning'
  }
  return 'success'
})

const saveProfile = async () => {
  if (!form.storeName) {
    ElMessage.warning('请填写店铺名称')
    return
  }

  saving.value = true

  try {
    await merchantStore.saveProfile({
      storeName: form.storeName,
      contactName: form.contactName,
      contactPhone: form.contactPhone,
      introduction: form.introduction
    })
    ElMessage.success('商家资料已保存')
  } catch (error) {
    ElMessage.error('保存商家资料失败')
  } finally {
    saving.value = false
  }
}

onMounted(async () => {
  await merchantStore.initialize()
  syncForm()
})
</script>

<style scoped>
.merchant-profile {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.panel {
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid rgba(199, 155, 74, 0.18);
  border-radius: 20px;
  box-shadow: 0 18px 40px rgba(92, 55, 20, 0.06);
  padding: 22px;
}

.panel-head h3 {
  margin: 0 0 6px;
  color: #2f2418;
}

.panel-head p {
  margin: 0 0 18px;
  color: #7c6a58;
  font-size: 13px;
}

.profile-layout {
  display: grid;
  grid-template-columns: minmax(0, 1fr);
}

.form-card {
  padding: 18px;
  border-radius: 18px;
  background: #faf6ef;
}

.plain-text {
  color: #2f2418;
  font-weight: 600;
}
</style>
