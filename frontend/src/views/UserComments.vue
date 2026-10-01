<template>
  <div class="user-comments-page">
    <Header />

    <!-- 页面横幅 -->
    <BannerSection
      title="我的评价"
      subtitle="查看您的评价记录"
      badge-icon="💬"
      badge="评价中心"
    />

    <div class="container">
      <!-- 评价列表 -->
      <div class="comments-content">
        <template v-if="userComments.length > 0">
          <div v-for="comment in userComments" :key="comment.id" class="comment-card">
            <!-- 卡片顶部装饰条 -->
            <div class="card-decoration"></div>

            <!-- 评论头部 -->
            <div class="card-header">
              <div class="user-avatar">
                <img :src="comment.avatar" :alt="comment.nickname" />
                <span class="online-dot"></span>
              </div>
              <div class="header-info">
                <h4 class="target-name">{{ comment.targetName }}</h4>
                <div class="meta-info">
                  <span class="time-icon">🕐</span>
                  <span class="time-text">{{ formatTime(comment.createTime) }}</span>
                </div>
              </div>
            </div>

            <!-- 评论内容 -->
            <div class="card-body">
              <p class="comment-text">{{ comment.content }}</p>

              <!-- 媒体图片（如有） -->
              <div v-if="comment.mediaPath" class="media-container">
                <img :src="comment.mediaPath" :alt="comment.targetName" />
              </div>
            </div>

            <!-- 评论底部操作栏 -->
            <div class="card-footer">
              <div class="stats-section">
                <span class="stat-item likes-stat">
                  <span class="stat-icon">❤️</span>
                  <span class="stat-value">{{ comment.likeCount }} 赞</span>
                </span>
              </div>

              <button class="delete-btn" @click="deleteComment(comment.postId, comment.commentId)">
                <span class="btn-icon">🗑️</span>
                删除评价
              </button>
            </div>
          </div>
        </template>

        <!-- 空状态 -->
        <div class="empty-state" v-else>
          <div class="empty-content">
            <div class="empty-icon">💬</div>
            <h3 class="empty-title">暂无评价记录</h3>
            <p class="empty-desc">您还没有发表过任何评价</p>
            <router-link to="/community" class="go-community-btn btn-primary">
              <span class="btn-icon">✍️</span>
              去社区发表评价
            </router-link>
          </div>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'
import { useCommunityStore } from '../stores/communityStore'
import { useUserStore } from '../stores/userStore'

interface Comment {
  id: number
  targetName: string
  content: string
  mediaPath?: string
  createTime: string
  likeCount: number
  avatar: string
  nickname: string
  postId: number
  commentId: number
}

const communityStore = useCommunityStore()
const userStore = useUserStore()

// 从社区帖子中提取当前用户的评论
const userComments = computed(() => {
  const currentUserId = userStore.user?.id || 1
  const comments: Comment[] = []

  communityStore.posts.forEach(post => {
    if (post.comments) {
      post.comments.forEach(comment => {
        if (comment.userId === currentUserId) {
          comments.push({
            id: comment.id,
            targetName: post.title,
            content: comment.content,
            mediaPath: post.mediaPath,
            createTime: comment.createTime,
            likeCount: comment.likeCount,
            avatar: comment.avatar,
            nickname: comment.nickname,
            postId: post.id,
            commentId: comment.id
          })
        }
      })
    }
  })

  // 按时间倒序排序
  return comments.sort((a, b) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime())
})

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

const deleteComment = (postId: number, commentId: number) => {
  if (confirm('确定要删除这个评价吗？')) {
    communityStore.deleteComment(postId, commentId, userStore.user?.id || 1)
    alert('删除成功')
  }
}

onMounted(() => {
  userStore.loadUser()
})
</script>

<style scoped>
.user-comments-page {
  min-height: 100vh;
  background: var(--gradient-bg);
}

.container {
  max-width: 900px;
  margin: 0 auto;
  padding: 40px 24px 60px;
}

/* ====== 评论内容 ====== */
.comments-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* 评论卡片 */
.comment-card {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.comment-card::before {
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

.comment-card:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-lg);
}

.comment-card:hover::before {
  opacity: 1;
}

.card-decoration {
  position: absolute;
  top: 20px;
  right: 20px;
  width: 50px;
  height: 50px;
  border: 2px solid rgba(212, 175, 55, 0.15);
  border-radius: 50%;
  z-index: 0;
}

/* 头部区域 */
.card-header {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 24px 28px 20px;
  position: relative;
  z-index: 1;
}

.user-avatar {
  width: 52px;
  height: 52px;
  border-radius: 50%;
  overflow: hidden;
  border: 3px solid var(--secondary-color);
  position: relative;
  flex-shrink: 0;
  transition: all 0.3s ease;
}

.comment-card:hover .user-avatar {
  transform: scale(1.08) rotate(5deg);
  box-shadow: 0 6px 16px rgba(212, 175, 55, 0.35);
}

.user-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.online-dot {
  position: absolute;
  bottom: 3px;
  right: 3px;
  width: 12px;
  height: 12px;
  background: #52c41a;
  border: 2px solid white;
  border-radius: 50%;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.7; transform: scale(1.15); }
}

.header-info {
  flex: 1;
}

.target-name {
  font-size: 17px;
  color: var(--text-color);
  margin-bottom: 6px;
  font-weight: 700;
  letter-spacing: 0.5px;
}

.meta-info {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  color: var(--text-light);
  font-weight: 500;
}

.time-icon { font-size: 14px; }

/* 内容区域 */
.card-body {
  padding: 0 28px 20px;
  position: relative;
  z-index: 1;
}

.comment-text {
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
  max-height: 280px;
  object-fit: cover;
  display: block;
}

/* 底部操作栏 */
.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 28px;
  border-top: 1.5px dashed rgba(212, 175, 55, 0.25);
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
  position: relative;
  z-index: 1;
}

.stats-section {
  display: flex;
  align-items: center;
  gap: 12px;
}

.stat-item {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
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

.delete-btn {
  padding: 9px 20px;
  background: white;
  color: #e74c3c;
  border: 2px solid #e74c3c;
  border-radius: var(--radius-sm);
  cursor: pointer;
  font-size: 13px;
  font-weight: 600;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
  gap: 6px;
  letter-spacing: 0.5px;
}

.btn-icon { font-size: 15px; }

.delete-btn:hover {
  background: #e74c3c;
  color: white;
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 6px 16px rgba(231, 76, 60, 0.3);
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

.go-community-btn {
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

.go-community-btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 12px 28px rgba(200, 22, 29, 0.4);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .container {
    padding: 30px 16px 50px;
  }

  .card-header,
  .card-body,
  .card-footer {
    padding-left: 20px;
    padding-right: 20px;
  }

  .user-avatar {
    width: 44px;
    height: 44px;
  }

  .target-name {
    font-size: 15px;
  }

  .comment-text {
    font-size: 14px;
  }

  .card-footer {
    flex-direction: column;
    gap: 14px;
  }

  .stats-section {
    justify-content: center;
  }

  .delete-btn {
    width: 100%;
    justify-content: center;
  }

  .media-container img {
    max-height: 220px;
  }

  .empty-icon {
    font-size: 60px;
  }

  .empty-title {
    font-size: 22px;
  }
}
</style>
