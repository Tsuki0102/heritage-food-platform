<template>
  <div class="community-page">
    <Header />

    <!-- 顶部横幅 - 使用公共组件 -->
    <BannerSection
      title="美食社区"
      subtitle="分享美食心得，交流烹饪技巧，记录探店体验"
      badge-icon="👥"
      badge="互动交流"
    />

    <!-- 发布内容按钮区域 -->
    <div class="publish-section">
      <div class="container">
        <button class="post-btn btn-primary" @click="handlePostClick">
          <span class="btn-icon">✍️</span>
          发布内容
        </button>
      </div>
    </div>

    <div class="container">
      <div class="community-content">

        <!-- 标签页导航 -->
        <div class="community-tabs">
          <div class="tab-nav">
            <button 
              v-for="tab in tabs" 
              :key="tab.key" 
              :class="['tab-btn', { active: activeTab === tab.key }]"
              @click="activeTab = tab.key"
            >
              <span class="tab-icon">{{ getTabIcon(tab.key) }}</span>
              {{ tab.label }}
            </button>
          </div>
        </div>

        <!-- 帖子列表 -->
        <div class="post-list">
          <div class="post-item" v-for="post in paginatedPosts" :key="post.id">
            <div class="post-header">
              <img
                :src="post.avatar"
                :alt="post.nickname"
                class="post-avatar"
                @error="(e) => (e.target as HTMLImageElement).src = '/images/avatar1.jpg'"
              />
              <div class="post-user">
                <span class="nickname">{{ post.nickname }}</span>
                <span class="time">{{ post.createTime }}</span>
              </div>
              <div class="post-type" :class="post.type">
                <span class="type-icon">{{ getTypeIcon(post.type) }}</span>
                {{ post.typeText }}
              </div>
            </div>

            <div class="post-content">
              <h3>{{ post.title }}</h3>
              <p class="post-text">{{ post.content }}</p>
              <img v-if="post.mediaPath" v-lazy="post.mediaPath" :alt="post.title" class="post-image" />
            </div>

            <div class="post-footer">
              <div class="post-actions">
                <button class="action-btn like-btn" :class="{ active: post.liked, disabled: !userStore.isLoggedIn }" @click="handleLikeClick(post.id)">
                  <span class="icon">{{ post.liked ? '❤️' : '🤍' }}</span>
                  <span class="count">{{ post.likeCount }}</span>
                  <span class="btn-text">喜欢</span>
                </button>
                <button class="action-btn comment-btn" @click="handleComment(post.id)">
                  <span class="icon">💬</span>
                  <span class="count">{{ post.commentCount }}</span>
                  <span class="btn-text">评论</span>
                </button>
                <button class="action-btn share-btn" :class="{ disabled: !userStore.isLoggedIn }" @click="handleShareClick(post.id)">
                  <span class="icon">📤</span>
                  <span class="btn-text">分享</span>
                </button>
                <button v-if="userStore.isLoggedIn && post.userId === userStore.userInfo?.id" class="action-btn delete-btn" @click="handleDeletePost(post.id)">
                  <span class="icon">🗑️</span>
                  <span class="btn-text">删除</span>
                </button>
              </div>
            </div>

            <!-- 评论区 -->
            <CommentSection 
              v-if="post.showComments" 
              :post="post"
              @like-comment="(commentId) => handleCommentLike(post.id, commentId)"
              @add-comment="(postId, content) => addComment(postId, content)"
              @delete-comment="(commentId) => deleteComment(post.id, commentId)"
            />

          </div>
        </div>

        <!-- 分页 -->
        <div class="pagination">
          <button class="page-btn prev-btn" @click="handlePrevPage" :disabled="currentPage === 1">
            <span>◀</span> 上一页
          </button>
          <div class="page-info-container">
            <span class="page-current">{{ currentPage }}</span>
            <span class="page-divider">/</span>
            <span class="page-total">{{ totalPages }}</span>
          </div>
          <button class="page-btn next-btn" @click="handleNextPage" :disabled="currentPage === totalPages">
            下一页 <span>▶</span>
          </button>
        </div>

        <!-- 发布内容弹窗 -->
        <div class="modal-overlay" v-if="showPostModal" @click.self="showPostModal = false">
          <div class="modal-content">
            <div class="modal-header">
              <h3>
                <span class="header-icon">✍️</span>
                发布内容
              </h3>
              <button class="close-btn" @click="showPostModal = false">&times;</button>
            </div>
            <div class="modal-body">
              <form @submit.prevent="submitPost">
                <div class="form-group">
                  <label>
                    <span class="label-icon">📝</span>
                    标题
                  </label>
                  <input type="text" v-model="newPost.title" placeholder="请输入标题" required />
                </div>
                <div class="form-group">
                  <label>
                    <span class="label-icon">📄</span>
                    内容
                  </label>
                  <textarea v-model="newPost.content" placeholder="请输入内容" required></textarea>
                </div>
                <div class="form-group">
                  <label>
                    <span class="label-icon">🏷️</span>
                    类型
                  </label>
                  <select v-model="newPost.type" required>
                    <option value="cook">🍳 美食复刻</option>
                    <option value="experience">💡 烹饪心得</option>
                    <option value="shop">🏪 探店体验</option>
                  </select>
                </div>
                <div class="form-group">
                  <label>
                    <span class="label-icon">📷</span>
                    图片
                  </label>
                  <input type="file" @change="handleImageUpload" accept="image/*" />
                </div>
                <div class="form-actions">
                  <button type="button" class="cancel-btn" @click="showPostModal = false">取消</button>
                  <button type="submit" class="submit-btn btn-primary">
                    <span class="btn-icon">🚀</span>
                    发布
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useCommunity } from '../composables/useCommunity'
import { useUserStore } from '../stores/userStore'
import { useCommunityStore } from '../stores/communityStore'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import CommentSection from '../components/CommentSection.vue'
import BannerSection from '../components/BannerSection.vue'

const userStore = useUserStore()
const communityStore = useCommunityStore()

// 使用社区组合式函数
const {
  tabs,
  activeTab,
  showPostModal,
  newPost,
  currentPage,
  paginatedPosts,
  totalPages,
  handleImageUpload,
  submitPost,
  handleLike,
  handleComment,
  addComment,
  handleCommentLike,
  handleShare,
  handlePrevPage,
  handleNextPage,
  handleDeletePost,
  deleteComment
} = useCommunity()

// 未登录时的操作处理
const handlePostClick = () => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再发布内容')
    return
  }
  showPostModal.value = true
}

const handleLikeClick = (postId: number) => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再点赞')
    return
  }
  handleLike(postId)
}

const handleShareClick = (postId: number) => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再分享')
    return
  }
  handleShare(postId)
}

// 辅助函数：获取标签页图标
const getTabIcon = (key: string) => {
  const iconMap: Record<string, string> = {
    all: '📋',
    cook: '🍳',
    experience: '💡',
    shop: '🏪'
  }
  return iconMap[key] || '📋'
}

// 辅助函数：获取帖子类型图标
const getTypeIcon = (type: string) => {
  const iconMap: Record<string, string> = {
    cook: '🍳',
    experience: '💡',
    shop: '🏪'
  }
  return iconMap[type] || '📝'
}



onMounted(async () => {
  // 从后端API获取社区帖子数据
  try {
    await communityStore.fetchPosts()
  } catch (error) {
    console.error('获取社区帖子失败:', error)
  }
})
</script>

<style scoped>
.community-page {
  min-height: 100vh;
  background: var(--gradient-bg);
  position: relative;
  overflow-x: hidden;
}

.container {
  max-width: 960px;
  margin: 0 auto;
  padding: 0 24px;
}

.community-content {
  margin: 40px 0 60px;
}

/* ====== 发布内容区域 ====== */
.publish-section {
  margin: -30px auto 0;
  padding: 0 24px;
  position: relative;
  z-index: 10;
}

.publish-section .container {
  max-width: 960px;
  display: flex;
  justify-content: center;
  padding: 0;
}

.post-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 14px 32px;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 1px;
  border-radius: var(--radius-sm);
  box-shadow: var(--shadow-lg);
  position: relative;
  overflow: hidden;
}

.post-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
  transition: left 0.6s ease;
}

.post-btn:hover::before {
  left: 100%;
}

.btn-icon { font-size: 16px; }

/* ====== 标签页导航 ====== */
.community-tabs {
  background: var(--gradient-card);
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  margin-bottom: 32px;
  position: relative;
}

.community-tabs::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

.tab-nav {
  display: flex;
  border-bottom: 2px solid rgba(212, 175, 55, 0.15);
  overflow-x: auto;
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
}

.tab-btn {
  padding: 18px 32px;
  border: none;
  background: transparent;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 15px;
  white-space: nowrap;
  font-weight: 600;
  color: var(--text-light);
  position: relative;
  letter-spacing: 1px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.tab-btn::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 0;
  height: 3px;
  background: var(--gradient-primary);
  border-radius: 2px;
  transition: width 0.3s ease;
}

.tab-icon { font-size: 18px; }

.tab-btn:hover {
  background: rgba(200, 22, 29, 0.04);
  color: var(--primary-color);
}

.tab-btn.active {
  color: var(--primary-color);
  font-weight: 700;
}

.tab-btn.active::after {
  width: 60%;
}

/* ====== 帖子列表 ====== */
.post-list {
  display: flex;
  flex-direction: column;
  gap: 24px;
  margin-bottom: 36px;
}

.post-item {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  padding: 28px;
  box-shadow: var(--shadow-md);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid var(--border-gold);
  position: relative;
  overflow: hidden;
}

.post-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.post-item:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-lg);
  border-color: var(--border-gold-hover);
}

.post-item:hover::before {
  opacity: 1;
}

.post-header {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  gap: 16px;
}

.post-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid var(--border-gold);
  transition: all 0.3s ease;
  flex-shrink: 0;
}

.post-item:hover .post-avatar {
  border-color: var(--secondary-color);
  transform: scale(1.08) rotate(3deg);
}

.post-user {
  flex: 1;
  min-width: 0;
}

.nickname {
  font-size: 15px;
  font-weight: 700;
  color: var(--text-color);
  margin-right: 10px;
  letter-spacing: 0.5px;
}

.time {
  font-size: 12px;
  color: var(--text-lighter);
}

.post-type {
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 12px;
  color: white;
  font-weight: 600;
  letter-spacing: 0.5px;
  display: flex;
  align-items: center;
  gap: 6px;
  flex-shrink: 0;
  box-shadow: var(--shadow-sm);
}

.type-icon { font-size: 14px; }

.post-type.cook {
  background: linear-gradient(135deg, #228b22, #2e8b57);
}

.post-type.experience {
  background: linear-gradient(135deg, #2196f3, #1976d2);
}

.post-type.shop {
  background: linear-gradient(135deg, #ff9800, #f57c00);
}

.post-content {
  margin-bottom: 20px;
}

.post-content h3 {
  font-size: 20px;
  margin-bottom: 12px;
  color: var(--text-color);
  font-weight: 700;
  letter-spacing: 1px;
  line-height: 1.4;
  transition: color 0.3s ease;
}

.post-item:hover .post-content h3 {
  color: var(--primary-color);
}

.post-text {
  line-height: 1.75;
  color: var(--text-light);
  margin-bottom: 16px;
  font-size: 15px;
  text-align: justify;
}

.post-image {
  width: 100%;
  max-height: 320px;
  object-fit: cover;
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
  transition: transform 0.4s ease;
}

.post-image:hover {
  transform: scale(1.02);
}

.post-footer {
  border-top: 1.5px dashed rgba(212, 175, 55, 0.25);
  padding-top: 18px;
}

.post-actions {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 10px 20px;
  border: 2px solid var(--border-gold);
  background: white;
  color: var(--text-light);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-size: 13px;
  font-weight: 500;
  letter-spacing: 0.5px;
}

.action-btn:hover:not(:disabled) {
  background: linear-gradient(135deg, rgba(200,22,29,0.04), rgba(212,175,55,0.04));
  color: var(--primary-color);
  border-color: var(--primary-color);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(200, 22, 29, 0.12);
}

.action-btn.disabled {
  cursor: not-allowed;
  opacity: 0.45;
  border-color: var(--border-gold);
}

.action-btn.disabled:hover {
  background: white;
  color: var(--text-light);
  transform: none;
  box-shadow: none;
}

.like-btn.active {
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.08), rgba(168, 19, 26, 0.06)) !important;
  color: var(--primary-color) !important;
  border-color: var(--primary-color) !important;
  font-weight: 600;
}

.delete-btn:hover {
  background: linear-gradient(135deg, rgba(244, 67, 54, 0.08), rgba(211, 47, 47, 0.06)) !important;
  color: #f44336 !important;
  border-color: #f44336 !important;
}

.icon { font-size: 16px; }
.count { font-weight: 600; }
.btn-text { font-size: 13px; }

/* ====== 分页 ====== */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 24px;
  margin-bottom: 48px;
  padding: 28px;
  background: linear-gradient(135deg, rgba(255,255,255,0.95), rgba(250,250,250,0.95));
  border-radius: var(--radius-lg);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  border: 1px solid var(--border-gold);
}

.page-btn {
  padding: 12px 24px;
  border: 2px solid var(--border-gold);
  background: white;
  border-radius: var(--radius-sm);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  color: var(--text-color);
  display: flex;
  align-items: center;
  gap: 6px;
  letter-spacing: 1px;
}

.page-btn:hover:not(:disabled) {
  border-color: var(--primary-color);
  color: var(--primary-color);
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.15);
}

.page-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.page-info-container {
  display: flex;
  align-items: baseline;
  gap: 8px;
  font-size: 15px;
  color: var(--text-light);
  padding: 8px 20px;
  background: linear-gradient(135deg, rgba(212, 175, 55, 0.08), rgba(200, 22, 29, 0.08));
  border-radius: var(--radius-sm);
  font-weight: 500;
}

.page-current {
  font-size: 24px;
  font-weight: 800;
  color: var(--primary-color);
}

.page-divider {
  color: var(--secondary-color);
  font-weight: 300;
}

.page-total {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-color);
}

/* ====== 发布内容弹窗 ====== */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(4px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.modal-content {
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  width: 90%;
  max-width: 640px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  border: 1px solid var(--border-gold);
  animation: slideUp 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}

.modal-content::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

@keyframes slideUp {
  from {
    transform: translateY(40px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px 28px;
  border-bottom: 2px dashed var(--border-gold);
  background: linear-gradient(135deg, rgba(250,245,240,0.98), rgba(255,255,255,0.99));
}

.modal-header h3 {
  margin: 0;
  color: var(--text-color);
  font-size: 20px;
  font-weight: 700;
  letter-spacing: 2px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-icon { font-size: 24px; }

.close-btn {
  background: none;
  border: none;
  font-size: 28px;
  cursor: pointer;
  color: var(--text-light);
  padding: 0;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.close-btn:hover {
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.08), rgba(212, 175, 55, 0.08));
  color: var(--primary-color);
  transform: rotate(90deg);
}

.modal-body {
  padding: 28px;
}

.form-group {
  margin-bottom: 24px;
}

.form-group label {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
  font-size: 15px;
  color: var(--text-color);
  font-weight: 600;
  letter-spacing: 1px;
}

.label-icon { font-size: 17px; }

.form-group input,
.form-group textarea,
.form-group select {
  width: 100%;
  padding: 14px 18px;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-sm);
  font-size: 15px;
  outline: none;
  transition: all 0.3s ease;
  background: white;
  color: var(--text-color);
  font-family: inherit;
}

.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.1);
}

.form-group textarea {
  resize: vertical;
  min-height: 140px;
  line-height: 1.6;
}

.form-group input[type="file"] {
  padding: 12px;
  border: 2px dashed var(--border-gold);
  background: linear-gradient(135deg, rgba(250,245,240,0.5), rgba(255,255,255,0.5));
  cursor: pointer;
}

.form-group input[type="file"]:hover {
  border-color: var(--secondary-color);
  background: linear-gradient(135deg, rgba(212,175,55,0.04), rgba(200,22,29,0.02));
}

.form-actions {
  display: flex;
  gap: 16px;
  justify-content: flex-end;
  margin-top: 32px;
  padding-top: 24px;
  border-top: 1.5px dashed var(--border-gold);
}

.cancel-btn {
  padding: 13px 28px;
  border: 2px solid var(--border-gold);
  background: white;
  color: var(--text-light);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 1px;
}

.cancel-btn:hover {
  background: linear-gradient(135deg, rgba(200,22,29,0.03), rgba(212,175,55,0.03));
  border-color: var(--primary-color);
  color: var(--primary-color);
  transform: translateY(-2px);
}

.submit-btn {
  padding: 13px 32px;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 2px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.submit-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(200, 22, 29, 0.35);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .container {
    padding: 0 16px;
  }

  .publish-section {
    margin: -20px auto 0;
    padding: 0 16px;
  }

  .publish-section .container {
    justify-content: center;
  }

  .post-btn {
    padding: 12px 24px;
    font-size: 14px;
  }
  
  .tab-btn {
    padding: 14px 20px;
    font-size: 14px;
  }
  
  .post-item {
    padding: 20px;
  }
  
  .post-header {
    flex-wrap: wrap;
  }
  
  .post-type {
    order: -1;
    margin-left: auto;
  }
  
  .post-actions {
    flex-wrap: wrap;
    gap: 8px;
  }
  
  .action-btn {
    padding: 8px 16px;
    font-size: 12px;
  }
  
  .btn-text {
    display: none;
  }
  
  .modal-content {
    width: 95%;
    margin: 20px;
  }
  
  .modal-body {
    padding: 20px;
  }
  
  .pagination {
    flex-direction: column;
    gap: 16px;
    padding: 20px;
  }
}
</style>