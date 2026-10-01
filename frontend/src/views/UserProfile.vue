<template>
  <div class="user-profile">
    <Header />
    
    <div class="container">
      <div class="profile-header">
        <h1>个人资料</h1>
      </div>
      
      <div class="profile-content">
        <div class="avatar-section">
          <div class="avatar-container">
            <img :src="userStore.userAvatar" :alt="user.nickname" class="avatar" />
            <input type="file" id="avatar-upload" class="avatar-upload" @change="handleAvatarUpload" />
            <label for="avatar-upload" class="avatar-upload-btn">
              <span>更换头像</span>
            </label>
          </div>
        </div>
        
        <div class="form-section">
          <form @submit.prevent="updateProfile">
            <div class="form-group">
              <label>昵称</label>
              <input type="text" v-model="formData.nickname" placeholder="请输入昵称" />
            </div>
            <div class="form-group">
              <label>手机号</label>
              <input type="tel" v-model="formData.phone" disabled placeholder="手机号" />
            </div>
            <div class="form-actions">
              <button type="submit" class="submit-btn">保存修改</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    
    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/userStore'
import { useCommunityStore } from '../stores/communityStore'
import api from '../api'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'

const router = useRouter()
const userStore = useUserStore()
const communityStore = useCommunityStore()
const user = ref(userStore.userInfo || {})
const formData = ref({
  nickname: '',
  phone: ''
})

onMounted(() => {
  if (userStore.user) {
    formData.value = {
      nickname: userStore.user.nickname,
      phone: userStore.user.phone
    }
  }
})

const handleAvatarUpload = async (event: Event) => {
  const target = event.target as HTMLInputElement
  if (!target.files || !target.files[0]) return

  const file = target.files[0]
  const formData = new FormData()
  formData.append('file', file)

  try {
    // 检查文件是否正确选择
    console.log('选择的文件:', file)
    console.log('文件信息:', {
      name: file.name,
      size: file.size,
      fileType: file.type
    })
    
    // 1. 上传文件
    // 响应拦截器已剥壳，uploadRes 即后端返回的文件路径（如 /file/xxx.jpg）
    const uploadRes = await api.post('/file/upload', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })

    console.log('上传文件返回数据:', uploadRes)
    console.log('返回数据类型:', typeof uploadRes)

    // 构造完整的头像URL
    let avatarUrl = typeof uploadRes === 'string' ? uploadRes : String((uploadRes as any)?.data ?? '')

    if (avatarUrl) {
      // 如果返回的字符串包含错误信息
      if (avatarUrl.includes('上传失败') || avatarUrl.includes('文件异常') || avatarUrl.includes('无效')) {
        console.error('上传失败:', avatarUrl)
        alert('头像上传失败: ' + avatarUrl)
        return
      }

      // 兼容裸文件名返回；以 / 开头的路径可直接访问
      avatarUrl = avatarUrl.startsWith('/') ? avatarUrl : `/uploads/${avatarUrl}`
      console.log('构造的头像URL:', avatarUrl)
    }
    
    // 2. 构造完整 User 对象（必须包含 id，否则后端更新会失败）
    const updateUser = {
      ...userStore.userInfo, // 保留原有字段（id、nickname、phone 等）
      avatar: avatarUrl      // 只更新头像
    }

    // 3. 调用 PUT /api/user 更新用户
    await api.put('/api/user', updateUser)

    // 4. 更新本地状态
    userStore.$patch({
      user: updateUser
    })

    // 5. 使用改进的 uploadAvatar 方法（包含缓存破坏）
    const uploadSuccess = userStore.uploadAvatar(avatarUrl)
    if (!uploadSuccess) {
      console.error('头像URL更新失败')
    }

    alert('✅ 头像上传并更新成功！')
    console.log('新头像地址:', avatarUrl)
  } catch (err) {
    console.error('❌ 上传或更新失败:', err)
    alert('操作失败，请检查后端服务')
  }
}
const updateProfile = async () => {
  const updateUser = {
    ...userStore.userInfo,
    nickname: formData.value.nickname
  }
  
  try {
    await api.put('/api/user', updateUser)
    userStore.updateUserInfo({
      nickname: formData.value.nickname
    })
    await communityStore.fetchPosts()
    alert('资料更新成功')
    router.push('/user')
  } catch (error) {
    console.error('更新资料失败:', error)
    alert('更新失败，请重试')
  }
}
</script>

<style scoped>
.user-profile {
  min-height: 100vh;
  background: var(--bg-color);
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.profile-header {
  text-align: center;
  margin: 40px 0;
}

.profile-header h1 {
  font-size: 28px;
  color: var(--text-color);
}

.profile-content {
  background: var(--bg-white);
  border-radius: 8px;
  padding: 40px;
  box-shadow: var(--shadow);
}

.avatar-section {
  text-align: center;
  margin-bottom: 40px;
}

.avatar-container {
  position: relative;
  display: inline-block;
}

.avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid var(--border-color);
}

.avatar-upload {
  display: none;
}

.avatar-upload-btn {
  position: absolute;
  bottom: 0;
  right: 0;
  background: var(--primary-color);
  color: #fff;
  border: none;
  border-radius: 50%;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 12px;
  transition: background 0.3s;
}

.avatar-upload-btn:hover {
  background: #a8131a;
}

.form-section {
  max-width: 400px;
  margin: 0 auto;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-size: 16px;
  color: var(--text-color);
  font-weight: 500;
}

.form-group input {
  width: 100%;
  padding: 12px;
  border: 1px solid var(--border-color);
  border-radius: 4px;
  font-size: 16px;
  outline: none;
  transition: border-color 0.3s;
  background: var(--bg-white);
  color: var(--text-color);
}

.form-group input:focus {
  border-color: var(--primary-color);
}

.form-group input:disabled {
  background: var(--bg-color);
  color: var(--text-lighter);
}

.form-actions {
  margin-top: 30px;
  text-align: center;
}

.submit-btn {
  background: var(--primary-color);
  color: #fff;
  border: none;
  padding: 12px 30px;
  border-radius: 4px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.3s;
}

.submit-btn:hover {
  background: #a8131a;
}

@media (max-width: 768px) {
  .container {
    padding: 15px;
  }
  
  .profile-content {
    padding: 20px;
  }
  
  .avatar {
    width: 100px;
    height: 100px;
  }
}
</style>