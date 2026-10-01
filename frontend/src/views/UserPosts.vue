<template>
  <div class="user-posts-page">
    <Header />

    <!-- 页面横幅 -->
    <BannerSection
      title="我的发布"
      subtitle="管理您发布的内容"
      badge-icon="✍️"
      badge="发布中心"
    />

    <div class="container">
      <!-- 已登录状态 -->
      <template v-if="userStore.isLoggedIn">
        <!-- 工具栏 -->
        <div class="toolbar">
          <div class="toolbar-left">
            <span class="total-count">共 {{ userPosts.length }} 篇帖子</span>
          </div>
          <router-link to="/community" class="publish-btn btn-primary">
            <span class="btn-icon">✍️</span>
            发布新内容
          </router-link>
        </div>

        <!-- 帖子列表 -->
        <div class="posts-content">
          <template v-if="userPosts.length > 0">
            <div v-for="post in userPosts" :key="post.id" class="post-card">
              <!-- 卡片顶部装饰条 -->
              <div class="card-decoration"></div>

              <!-- 帖子头部 -->
              <div class="card-header">
                <span :class="['type-badge', post.type]">
                  <span class="type-icon">{{ getTypeIcon(post.type) }}</span>
                  {{ getTypeText(post.type) }}
                </span>
                <div class="header-meta">
                  <span class="time-badge">
                    <span class="meta-icon">🕐</span>
                    {{ formatTime(post.createTime) }}
                  </span>
                </div>
              </div>

              <!-- 帖子内容 -->
              <div class="card-body">
                <h3 class="post-title">{{ post.title }}</h3>
                <p class="post-text">{{ post.content }}</p>

                <!-- 媒体图片（如有） -->
                <div v-if="post.mediaPath" class="media-container">
                  <img :src="post.mediaPath" :alt="post.title" />
                </div>
              </div>

              <!-- 统计信息 -->
              <div class="card-stats">
                <div class="stat-item likes-stat">
                  <span class="stat-icon">❤️</span>
                  <span class="stat-value">{{ post.likeCount }} 赞</span>
                </div>
                <div class="stat-item comments-stat">
                  <span class="stat-icon">💬</span>
                  <span class="stat-value">{{ post.commentCount }} 评论</span>
                </div>
              </div>

              <!-- 操作按钮 -->
              <div class="card-actions">
                <router-link :to="`/community`" class="action-btn btn-edit">
                  <span class="btn-icon">✏️</span>
                  编辑帖子
                </router-link>
                <button class="action-btn btn-delete" @click="deletePost(post.id)">
                  <span class="btn-icon">🗑️</span>
                  删除帖子
                </button>
              </div>
            </div>
          </template>

          <!-- 空状态 -->
          <div class="empty-state" v-else>
            <div class="empty-content">
              <div class="empty-icon">📝</div>
              <h3 class="empty-title">暂无发布内容</h3>
              <p class="empty-desc">您还没有发布过任何帖子</p>
              <router-link to="/community" class="go-publish-btn btn-primary">
                <span class="btn-icon">✍️</span>
                发布第一篇帖子
              </router-link>
            </div>
          </div>
        </div>
      </template>

      <!-- 未登录状态 -->
      <template v-else>
        <div class="login-required">
          <div class="login-card">
            <div class="login-icon">🔒</div>
            <h3 class="login-title">请先登录</h3>
            <p class="login-desc">登录后可以查看和管理您的发布内容</p>
            <router-link to="/login" class="login-btn btn-primary">
              <span class="btn-icon">🚀</span>
              立即登录
            </router-link>
          </div>
        </div>
      </template>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useCommunityStore } from '../stores/communityStore'
import { useUserStore } from '../stores/userStore'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'

interface Post {
  id: number
  title: string
  content: string
  type: string
  mediaPath?: string
  userId: number
  nickname: string
  avatar: string
  createTime: string
  likeCount: number
  commentCount: number
  liked?: boolean
  showComments?: boolean
}

const communityStore = useCommunityStore()
const userStore = useUserStore()
const currentUserId = userStore.isLoggedIn ? userStore.userInfo?.id : null
const userPosts = ref<Post[]>(userStore.isLoggedIn ? communityStore.posts.filter((post: Post) => post.userId === currentUserId) : [])

// 获取类型图标
const getTypeIcon = (type: string) => {
  const iconMap: Record<string, string> = {
    cook: '🍳',
    experience: '💡',
    shop: '🏪'
  }
  return iconMap[type] || '📝'
}

// 获取类型文本
const getTypeText = (type: string) => {
  const textMap: Record<string, string> = {
    cook: '美食复刻',
    experience: '心得体会',
    shop: '探店分享'
  }
  return textMap[type] || '其他'
}

// 格式化时间
const formatTime = (dateStr: string) => {
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const deletePost = (postId: number) => {
  if (!userStore.isLoggedIn || !currentUserId) {
    alert('请先登录')
    return
  }

  if (confirm('确定要删除这个帖子吗？')) {
    communityStore.deletePost(postId)
    userPosts.value = communityStore.posts.filter((post: Post) => post.userId === currentUserId)
    alert('删除成功')
  }
}

onMounted(() => {
  // 初始化数据
})
</script>

<style scoped>
.user-posts-page {
  min-height: 100vh;
  background: var(--gradient-bg);
}

.container {
  max-width: 900px;
  margin: 0 auto;
  padding: 40px 24px 60px;
}

/* ====== 工具栏 ====== */
.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 24px;
  background: var(--gradient-card);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  margin-bottom: 32px;
}

.toolbar-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.total-count {
  font-size: 15px;
  color: var(--text-light);
  font-weight: 600;
}

.publish-btn {
  padding: 11px 24px;
  font-size: 14px;
  font-weight: 700;
  letter-spacing: 0.5px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  text-decoration: none;
}

.btn-icon { font-size: 16px; }

.publish-btn:hover:not(:disabled) {
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.35);
}

/* ====== 帖子内容 ====== */
.posts-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* 帖子卡片 */
.post-card {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.post-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.post-card:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-lg);
}

.post-card:hover::before {
  opacity: 1;
}

.card-decoration {
  position: absolute;
  top: 16px;
  right: 16px;
  width: 60px;
  height: 60px;
  border: 2px solid rgba(212, 175, 55, 0.12);
  border-radius: 50%;
  z-index: 0;
}

/* 头部区域 */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 22px 28px 18px;
  position: relative;
  z-index: 1;
}

.type-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 7px 16px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 700;
  color: white;
  letter-spacing: 0.5px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.type-icon { font-size: 15px; }

.type-badge.cook {
  background: linear-gradient(135deg, #4caf50, #388e3c);
}

.type-badge.experience {
  background: linear-gradient(135deg, #2196f3, #1976d2);
}

.type-badge.shop {
  background: linear-gradient(135deg, #ff9800, #f57c00);
}

.header-meta {
  display: flex;
  align-items: center;
  gap: 10px;
}

.time-badge {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 13px;
  color: var(--text-lighter);
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
  padding: 5px 12px;
  border-radius: 14px;
  border: 1px solid var(--border-gold);
  font-weight: 500;
}

.meta-icon { font-size: 14px; }

/* 内容区域 */
.card-body {
  padding: 0 28px 20px;
  position: relative;
  z-index: 1;
}

.post-title {
  font-size: 20px;
  color: var(--text-color);
  margin-bottom: 12px;
  font-weight: 800;
  line-height: 1.4;
  letter-spacing: 0.5px;
}

.post-card:hover .post-title {
  color: var(--primary-color);
}

.post-text {
  font-size: 15px;
  color: var(--text-light);
  line-height: 1.8;
  margin-bottom: 16px;
  font-weight: 500;
}

.media-container {
  max-width: 100%;
  border-radius: var(--radius-md);
  overflow: hidden;
  border: 2px solid var(--border-gold);
  transition: all 0.3s ease;
}

.media-container:hover {
  border-color: var(--primary-color);
  transform: scale(1.02);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.15);
}

.media-container img {
  width: 100%;
  max-height: 320px;
  object-fit: cover;
  display: block;
}

/* 统计信息 */
.card-stats {
  display: flex;
  gap: 16px;
  padding: 18px 28px;
  border-top: 1.5px dashed rgba(212, 175, 55, 0.25);
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
  position: relative;
  z-index: 1;
}

.stat-item {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 7px 16px;
  background: linear-gradient(135deg, rgba(200,22,29,0.06), rgba(212,175,55,0.06));
  border-radius: 20px;
  font-size: 13px;
  font-weight: 600;
  color: var(--text-light);
  transition: all 0.3s ease;
}

.stat-item:hover {
  background: linear-gradient(135deg, rgba(200,22,29,0.1), rgba(212,175,55,0.1));
  transform: translateY(-2px);
}

.stat-icon { font-size: 16px; }

.stat-value { letter-spacing: 0.5px; }

/* 操作按钮 */
.card-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 18px 28px;
  border-top: 1.5px dashed rgba(212, 175, 55, 0.25);
  position: relative;
  z-index: 1;
}

.action-btn {
  padding: 10px 20px;
  border-radius: var(--radius-sm);
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  text-decoration: none;
  border: none;
  letter-spacing: 0.5px;
}

.btn-edit {
  background: white;
  color: var(--text-color);
  border: 2px solid var(--border-gold);
}

.btn-edit:hover {
  border-color: var(--secondary-color);
  color: var(--secondary-color);
  background: linear-gradient(135deg, rgba(212,175,55,0.04), rgba(212,175,55,0.02));
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 6px 16px rgba(212, 175, 55, 0.25);
}

.btn-delete {
  background: white;
  color: #e74c3c;
  border: 2px solid #e74c3c;
}

.btn-delete:hover {
  background: #e74c3c;
  color: white;
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 6px 16px rgba(231, 76, 60, 0.3);
}

.btn-delete:hover .btn-icon {
  animation: shake 0.5s ease-in-out;
}

@keyframes shake {
  0%, 100% { transform: rotate(0deg); }
  25% { transform: rotate(-10deg); }
  75% { transform: rotate(10deg); }
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 80px 20px;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
}

.empty-content {
  max-width: 400px;
  margin: 0 auto;
}

.empty-icon {
  font-size: 80px;
  margin-bottom: 24px;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-20px); }
}

.empty-title {
  font-size: 26px;
  color: var(--text-color);
  margin-bottom: 12px;
  font-weight: 700;
  letter-spacing: 2px;
}

.empty-desc {
  font-size: 16px;
  color: var(--text-light);
  margin-bottom: 32px;
  line-height: 1.6;
}

.go-publish-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 16px 36px;
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 1px;
  border-radius: var(--radius-sm);
  text-decoration: none;
}

.go-publish-btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 12px 28px rgba(200, 22, 29, 0.4);
}

/* 登录提示 */
.login-required {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 500px;
}

.login-card {
  text-align: center;
  padding: 60px 48px;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  max-width: 500px;
}

.login-icon {
  font-size: 80px;
  margin-bottom: 24px;
  animation: lockPulse 2s ease-in-out infinite;
}

@keyframes lockPulse {
  0%, 100% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.1); opacity: 0.8; }
}

.login-title {
  font-size: 26px;
  color: var(--text-color);
  margin-bottom: 12px;
  font-weight: 700;
  letter-spacing: 2px;
}

.login-desc {
  font-size: 16px;
  color: var(--text-light);
  margin-bottom: 36px;
  line-height: 1.6;
}

.login-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 16px 40px;
  font-size: 17px;
  font-weight: 700;
  letter-spacing: 1px;
  border-radius: var(--radius-sm);
  text-decoration: none;
}

.login-btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 12px 28px rgba(200, 22, 29, 0.4);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .container {
    padding: 30px 16px 50px;
  }

  .toolbar {
    flex-direction: column;
    gap: 14px;
    padding: 16px 20px;
  }

  .toolbar-left {
    width: 100%;
    justify-content: center;
  }

  .publish-btn {
    width: 100%;
    justify-content: center;
  }

  .card-header,
  .card-body,
  .card-stats,
  .card-actions {
    padding-left: 20px;
    padding-right: 20px;
  }

  .post-title {
    font-size: 18px;
  }

  .post-text {
    font-size: 14px;
  }

  .media-container img {
    max-height: 260px;
  }

  .card-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }

  .card-stats {
    flex-wrap: wrap;
  }

  .card-actions {
    flex-direction: column;
  }

  .btn-edit,
  .btn-delete {
    width: 100%;
    justify-content: center;
  }

  .login-card {
    padding: 40px 28px;
  }

  .login-icon {
    font-size: 60px;
  }

  .empty-icon {
    font-size: 60px;
  }

  .empty-title {
    font-size: 22px;
  }
}
</style>
