<template>
  <div class="settings heritage-pattern">
    <div class="admin-page-header">
      <h2 class="admin-page-title">系统配置</h2>
      <el-button type="primary" @click="saveSettings" :loading="settingsStore.loading">
        <span>💾</span>
        保存配置
      </el-button>
    </div>

    <div class="admin-chart-container settings-tabs heritage-corner-decoration" v-loading="settingsStore.loading">
      <el-tabs v-model="activeTab">
        <el-tab-pane label="基本设置" name="basic">
          <div class="settings-form">
            <el-form :model="settingsStore.basic" label-width="120px" :rules="basicRules" ref="basicFormRef">
              <el-form-item label="网站名称" prop="siteName">
                <el-input v-model="settingsStore.basic.siteName"></el-input>
              </el-form-item>
              <el-form-item label="网站域名" prop="siteDomain">
                <el-input v-model="settingsStore.basic.siteDomain"></el-input>
              </el-form-item>
              <el-form-item label="网站描述" prop="siteDescription">
                <el-input v-model="settingsStore.basic.siteDescription" type="textarea"></el-input>
              </el-form-item>
              <el-form-item label="网站关键词" prop="siteKeywords">
                <el-input v-model="settingsStore.basic.siteKeywords"></el-input>
              </el-form-item>
              <el-form-item label="联系邮箱" prop="contactEmail">
                <el-input v-model="settingsStore.basic.contactEmail"></el-input>
              </el-form-item>
              <el-form-item label="联系电话" prop="contactPhone">
                <el-input v-model="settingsStore.basic.contactPhone"></el-input>
              </el-form-item>
              <el-form-item label="ICP备案号" prop="icpNumber">
                <el-input v-model="settingsStore.basic.icpNumber"></el-input>
              </el-form-item>
              <el-form-item label="版权信息" prop="copyright">
                <el-input v-model="settingsStore.basic.copyright"></el-input>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>
        <el-tab-pane label="功能设置" name="features">
          <div class="settings-form">
            <el-form :model="settingsStore.features" label-width="120px">
              <el-form-item label="用户注册">
                <el-switch v-model="settingsStore.features.userRegistration"></el-switch>
              </el-form-item>
              <el-form-item label="用户登录">
                <el-switch v-model="settingsStore.features.userLogin"></el-switch>
              </el-form-item>
              <el-form-item label="社区发帖">
                <el-switch v-model="settingsStore.features.communityPosting"></el-switch>
              </el-form-item>
              <el-form-item label="评论功能">
                <el-switch v-model="settingsStore.features.commentFunction"></el-switch>
              </el-form-item>
              <el-form-item label="收藏功能">
                <el-switch v-model="settingsStore.features.collectionFunction"></el-switch>
              </el-form-item>
              <el-form-item label="搜索功能">
                <el-switch v-model="settingsStore.features.searchFunction"></el-switch>
              </el-form-item>
              <el-form-item label="地图功能">
                <el-switch v-model="settingsStore.features.mapFunction"></el-switch>
              </el-form-item>
              <el-form-item label="口味测试">
                <el-switch v-model="settingsStore.features.tasteTest"></el-switch>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>
        <el-tab-pane label="安全设置" name="security">
          <div class="settings-form">
            <el-form :model="settingsStore.security" label-width="120px" :rules="securityRules" ref="securityFormRef">
              <el-form-item label="API密钥" prop="apiKey">
                <el-input v-model="settingsStore.security.apiKey" type="password"></el-input>
              </el-form-item>
              <el-form-item label="JWT密钥" prop="jwtSecret">
                <el-input v-model="settingsStore.security.jwtSecret" type="password"></el-input>
              </el-form-item>
              <el-form-item label="登录超时(分钟)" prop="loginTimeout">
                <el-input v-model.number="settingsStore.security.loginTimeout" type="number"></el-input>
              </el-form-item>
              <el-form-item label="密码复杂度" prop="passwordComplexity">
                <el-select v-model="settingsStore.security.passwordComplexity">
                  <el-option label="低" value="low"></el-option>
                  <el-option label="中" value="medium"></el-option>
                  <el-option label="高" value="high"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="IP限制">
                <el-switch v-model="settingsStore.security.ipRestriction"></el-switch>
              </el-form-item>
              <el-form-item label="验证码">
                <el-switch v-model="settingsStore.security.captcha"></el-switch>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>
        <el-tab-pane label="存储设置" name="storage">
          <div class="settings-form">
            <el-form :model="settingsStore.storage" label-width="120px" :rules="storageRules" ref="storageFormRef">
              <el-form-item label="存储方式" prop="storageType">
                <el-select v-model="settingsStore.storage.storageType">
                  <el-option label="本地存储" value="local"></el-option>
                  <el-option label="云存储" value="cloud"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="本地存储路径" prop="localPath">
                <el-input v-model="settingsStore.storage.localPath"></el-input>
              </el-form-item>
              <el-form-item label="云存储服务" prop="cloudService">
                <el-select v-model="settingsStore.storage.cloudService">
                  <el-option label="阿里云OSS" value="aliyun"></el-option>
                  <el-option label="腾讯云COS" value="tencent"></el-option>
                  <el-option label="七牛云" value="qiniu"></el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="云存储访问密钥" prop="accessKey">
                <el-input v-model="settingsStore.storage.accessKey" type="password"></el-input>
              </el-form-item>
              <el-form-item label="云存储密钥" prop="secretKey">
                <el-input v-model="settingsStore.storage.secretKey" type="password"></el-input>
              </el-form-item>
              <el-form-item label="云存储桶名" prop="bucketName">
                <el-input v-model="settingsStore.storage.bucketName"></el-input>
              </el-form-item>
              <el-form-item label="文件大小限制(MB)" prop="fileSizeLimit">
                <el-input v-model.number="settingsStore.storage.fileSizeLimit" type="number"></el-input>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useSettingsStore } from '../../../stores/admin/settingsStore'
import { ElMessage } from 'element-plus'

const settingsStore = useSettingsStore()
const activeTab = ref('basic')
const basicFormRef = ref()
const securityFormRef = ref()
const storageFormRef = ref()

const basicRules = {
  siteName: [
    { required: true, message: '请输入网站名称', trigger: 'blur' },
    { min: 2, max: 50, message: '网站名称长度在 2 到 50 个字符', trigger: 'blur' }
  ],
  siteDomain: [
    { required: true, message: '请输入网站域名', trigger: 'blur' },
    { type: 'url', message: '请输入正确的网站域名', trigger: 'blur' }
  ],
  siteDescription: [
    { required: true, message: '请输入网站描述', trigger: 'blur' }
  ],
  contactEmail: [
    { required: true, message: '请输入联系邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ],
  contactPhone: [
    { required: true, message: '请输入联系电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ]
}

const securityRules = {
  apiKey: [
    { required: true, message: '请输入API密钥', trigger: 'blur' }
  ],
  jwtSecret: [
    { required: true, message: '请输入JWT密钥', trigger: 'blur' }
  ],
  loginTimeout: [
    { required: true, message: '请输入登录超时时间', trigger: 'blur' },
    { type: 'number', min: 1, max: 1440, message: '登录超时时间在 1 到 1440 分钟之间', trigger: 'blur' }
  ],
  passwordComplexity: [
    { required: true, message: '请选择密码复杂度', trigger: 'change' }
  ]
}

const storageRules = {
  storageType: [
    { required: true, message: '请选择存储方式', trigger: 'change' }
  ],
  localPath: [
    { required: true, message: '请输入本地存储路径', trigger: 'blur' }
  ],
  cloudService: [
    { required: true, message: '请选择云存储服务', trigger: 'change' }
  ],
  fileSizeLimit: [
    { required: true, message: '请输入文件大小限制', trigger: 'blur' },
    { type: 'number', min: 1, max: 100, message: '文件大小限制在 1 到 100 MB 之间', trigger: 'blur' }
  ]
}

const saveSettings = async () => {
  try {
    // 验证表单
    if (basicFormRef.value) {
      await basicFormRef.value.validate()
    }
    if (securityFormRef.value) {
      await securityFormRef.value.validate()
    }
    if (storageFormRef.value) {
      await storageFormRef.value.validate()
    }
    
    const success = await settingsStore.saveSettings()
    if (success) {
      ElMessage.success('设置保存成功')
    } else {
      ElMessage.error('设置保存失败')
    }
  } catch (error) {
    console.error('表单验证失败:', error)
    ElMessage.error('表单验证失败')
  }
}

onMounted(async () => {
  try {
    await settingsStore.fetchSettings()
  } catch (error) {
    ElMessage.error('获取设置失败')
  }
})
</script>

<style scoped>
.settings {
  padding: 8px 0;
}

.admin-page-header :deep(.el-button) {
  border-radius: 24px;
  padding: 10px 24px;
  font-weight: 600;
  letter-spacing: 1px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.admin-page-header :deep(.el-button:hover) {
  transform: translateY(-2px);
  box-shadow: var(--shadow-primary);
}

.settings-form {
  padding: var(--spacing-xl) var(--spacing-md);
}

.settings-tabs :deep(.el-tabs__header) {
  background: linear-gradient(135deg, rgba(200,22,29,0.03), rgba(212,175,55,0.03));
  margin: 0;
  padding: 16px 24px;
  border-bottom: 1px solid var(--border-gold);
}

.settings-tabs :deep(.el-tabs__item) {
  font-weight: 600;
  letter-spacing: 1px;
  transition: all 0.3s ease;
}

.settings-tabs :deep(.el-tabs__item.is-active) {
  color: var(--primary-color);
}

.settings-tabs :deep(.el-tabs__active-bar) {
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  height: 3px;
  border-radius: 2px;
}

@media (max-width: 768px) {
  .admin-page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--spacing-md);
    padding: var(--spacing-md);
  }

  .admin-page-header :deep(.el-button) {
    width: 100%;
  }

  .settings-form {
    padding: var(--spacing-lg) var(--spacing-sm);
  }
}
</style>