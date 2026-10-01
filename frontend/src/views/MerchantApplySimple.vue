<template>
  <div class="merchant-apply">
    <h2>商家入驻申请</h2>
    <p style="color: #666; margin-bottom: 24px;">
      提交店铺信息和基础材料后，管理员会进行入驻审核。
    </p>

    <form @submit.prevent="submitApplication">
      <div class="form-group">
        <label>申请人姓名</label>
        <input type="text" v-model="form.applicantName" placeholder="请输入联系人姓名" required />
      </div>

      <div class="form-group">
        <label>店铺名称</label>
        <input type="text" v-model="form.storeName" placeholder="请输入店铺名称" required />
      </div>

      <div class="form-group">
        <label>经营类目</label>
        <input type="text" v-model="form.category" placeholder="例如：非遗熟食、手工糕点" required />
      </div>

      <div class="form-group">
        <label>所在地区</label>
        <input type="text" v-model="form.region" placeholder="例如：成都、杭州" />
      </div>

      <div class="form-group">
        <label>补充说明</label>
        <textarea v-model="form.note" rows="4" placeholder="可填写营业资质或经营特色"></textarea>
      </div>

      <button type="submit" class="submit-btn" :disabled="submitting">
        {{ submitting ? '提交中...' : '提交入驻申请' }}
      </button>
    </form>

    <div v-if="message" :class="['message', messageType]">
      {{ message }}
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { submitMerchantOnboardingApplication } from '../api/merchantApi'

const form = reactive({
  applicantName: '',
  storeName: '',
  category: '',
  region: '',
  note: ''
})

const submitting = ref(false)
const message = ref('')
const messageType = ref('info')

const submitApplication = async () => {
  if (!form.applicantName || !form.storeName || !form.category) {
    showMessage('请填写完整信息', 'error')
    return
  }

  submitting.value = true

  try {
    await submitMerchantOnboardingApplication(form)
    showMessage('入驻申请已提交，请等待审核', 'success')
    resetForm()
  } catch (error) {
    console.error(error)
    showMessage('提交失败，请重试', 'error')
  } finally {
    submitting.value = false
  }
}

const showMessage = (msg, type) => {
  message.value = msg
  messageType.value = type
  setTimeout(() => {
    message.value = ''
  }, 5000)
}

const resetForm = () => {
  form.applicantName = ''
  form.storeName = ''
  form.category = ''
  form.region = ''
  form.note = ''
}
</script>

<style scoped>
.merchant-apply {
  max-width: 600px;
  margin: 40px auto;
  padding: 0 20px;
}

h2 {
  color: #2f2418;
  margin-bottom: 10px;
}

.form-group {
  margin-bottom: 20px;
}

label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #5a4432;
}

input, textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #d4c7b8;
  border-radius: 8px;
  font-size: 14px;
  box-sizing: border-box;
}

input:focus, textarea:focus {
  outline: none;
  border-color: #c8161d;
}

.submit-btn {
  width: 100%;
  padding: 14px;
  background: linear-gradient(135deg, #c8161d, #e23d2a);
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s;
}

.submit-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.3);
}

.submit-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.message {
  margin-top: 20px;
  padding: 12px;
  border-radius: 8px;
  text-align: center;
}

.message.success {
  background: #f0f9ff;
  color: #0c625a;
  border: 1px solid #a5f3fc;
}

.message.error {
  background: #fff1f2;
  color: #991b1b;
  border: 1px solid #fecdd3;
}

.message.info {
  background: #fef9c3;
  color: #854d0e;
  border: 1px solid #fef08a;
}
</style>
