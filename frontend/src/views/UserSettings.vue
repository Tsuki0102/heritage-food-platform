<template>
  <div class="user-settings">
    <Header />
    
    <div class="container">
      <div class="page-header">
        <BackButton to="/user" />
        <h1>设置</h1>
      </div>
      
      <div class="settings-list">
        <div class="settings-section">
          <h3>账号设置</h3>
          <div class="settings-item">
            <span class="label">手机号</span>
            <span class="value">{{ userStore.user?.phone || '未设置' }}</span>
          </div>
          <div class="settings-item">
            <span class="label">昵称</span>
            <span class="value">{{ userStore.user?.nickname || '未设置' }}</span>
          </div>
        </div>
        
        <div class="settings-section">
          <h3>通知设置</h3>
          <div class="settings-item">
            <span class="label">推送通知</span>
            <label class="switch">
              <input type="checkbox" v-model="settings.pushNotification" />
              <span class="slider"></span>
            </label>
          </div>
          <div class="settings-item">
            <span class="label">消息提醒</span>
            <label class="switch">
              <input type="checkbox" v-model="settings.messageNotification" />
              <span class="slider"></span>
            </label>
          </div>
        </div>
        
        <div class="settings-section">
          <h3>隐私设置</h3>
          <div class="settings-item">
            <span class="label">公开我的收藏</span>
            <label class="switch">
              <input type="checkbox" v-model="settings.publicCollections" />
              <span class="slider"></span>
            </label>
          </div>
          <div class="settings-item">
            <span class="label">公开我的足迹</span>
            <label class="switch">
              <input type="checkbox" v-model="settings.publicHistory" />
              <span class="slider"></span>
            </label>
          </div>
        </div>
        
        <div class="settings-section">
          <h3>其他</h3>
          <div class="settings-item">
            <span class="label">清除缓存</span>
            <button class="action-btn" @click="clearCache">清除</button>
          </div>
          <div class="settings-item">
            <span class="label">版本信息</span>
            <span class="value">v1.0.0</span>
          </div>
        </div>
      </div>
      
      <button class="save-btn" @click="saveSettings">保存设置</button>
    </div>
    
    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useUserStore } from '../stores/userStore'
import BackButton from '../components/BackButton.vue'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'

const userStore = useUserStore()

const settings = ref({
  pushNotification: true,
  messageNotification: true,
  publicCollections: false,
  publicHistory: false
})

onMounted(() => {
  loadSettings()
})

const loadSettings = () => {
  try {
    const savedSettings = localStorage.getItem('userSettings')
    if (savedSettings) {
      settings.value = JSON.parse(savedSettings)
    }
  } catch (error) {
    console.error('加载设置失败:', error)
  }
}

const saveSettings = () => {
  try {
    localStorage.setItem('userSettings', JSON.stringify(settings.value))
    alert('设置已保存')
  } catch (error) {
    console.error('保存设置失败:', error)
    alert('保存设置失败')
  }
}

const clearCache = () => {
  if (confirm('确定要清除缓存吗？')) {
    localStorage.removeItem('userData')
    localStorage.removeItem('communityData')
    alert('缓存已清除')
  }
}
</script>

<style scoped>
.user-settings {
  min-height: 100vh;
  background: var(--bg-color);
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.page-header {
  background: var(--bg-white);
  padding: 20px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 20px;
  box-shadow: var(--shadow);
}

.page-header h1 {
  font-size: 20px;
  margin: 0;
  color: var(--text-color);
}

.settings-list {
  background: var(--bg-white);
  border-radius: 8px;
  overflow: hidden;
  box-shadow: var(--shadow);
  margin-bottom: 20px;
}

.settings-section {
  padding: 20px;
  border-bottom: 1px solid var(--border-color);
}

.settings-section:last-child {
  border-bottom: none;
}

.settings-section h3 {
  font-size: 16px;
  color: var(--text-light);
  margin: 0 0 15px 0;
}

.settings-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 0;
}

.settings-item .label {
  font-size: 14px;
  color: var(--text-color);
}

.settings-item .value {
  font-size: 14px;
  color: var(--text-lighter);
}

.action-btn {
  background: var(--bg-color);
  color: var(--text-light);
  border: 1px solid var(--border-color);
  padding: 6px 16px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s;
}

.action-btn:hover {
  background: var(--border-color);
}

.switch {
  position: relative;
  display: inline-block;
  width: 50px;
  height: 26px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: var(--border-color);
  transition: 0.3s;
  border-radius: 26px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 20px;
  width: 20px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: 0.3s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: var(--primary-color);
}

input:checked + .slider:before {
  transform: translateX(24px);
}

.save-btn {
  background: var(--primary-color);
  color: #fff;
  border: none;
  padding: 15px;
  border-radius: 8px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.3s;
  width: 100%;
  box-shadow: var(--shadow);
}

.save-btn:hover {
  background: #a8131a;
}

@media (max-width: 768px) {
  .container {
    padding: 15px;
  }
  
  .page-header {
    padding: 15px;
  }
  
  .settings-section {
    padding: 15px;
  }
}
</style>
