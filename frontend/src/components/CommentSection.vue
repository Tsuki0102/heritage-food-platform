<template>
  <div class="comment-section">
    <div class="comment-header">
      <h3>
        <span class="header-icon">💬</span>
        评论 ({{ post.commentCount }})
      </h3>
    </div>

    <div class="comment-list">
      <div
        v-for="comment in post.comments"
        :key="comment.id"
        class="comment-item"
      >
        <img
          :src="comment.avatar"
          alt="用户头像"
          class="comment-avatar"
          @error="(e) => e.target.src = '/images/avatar1.jpg'"
        />
        <div class="comment-content">
          <div class="comment-top">
            <div class="user-info">
              <span class="comment-nickname">{{ comment.nickname }}</span>
              <span class="comment-time">{{ comment.createTime }}</span>
            </div>
          </div>
          <p class="comment-text">{{ comment.content }}</p>
          <div class="comment-bottom">
            <button
              class="action-btn like-btn"
              :class="{ liked: comment.liked, disabled: !userStore.isLoggedIn }"
              @click="handleLikeComment(comment.id)"
            >
              <span class="icon">{{ comment.liked ? '❤️' : '🤍' }}</span>
              <span>{{ comment.likeCount }}</span>
            </button>
            <button
              v-if="canDeleteComment(comment)"
              class="action-btn delete-btn"
              @click="handleDeleteComment(comment.id)"
            >
              <span class="icon">🗑️</span>
              <span>删除</span>
            </button>
          </div>
        </div>
      </div>
    </div>

    <div class="comment-input-section">
      <div v-if="userStore.isLoggedIn" class="input-avatar">
        {{ userStore.userInfo?.nickname?.charAt(0) || '我' }}
      </div>
      <div v-else class="input-avatar guest-avatar">
        <span>👤</span>
      </div>
      <div class="input-container">
        <input
          v-model="newComment"
          type="text"
          :placeholder="userStore.isLoggedIn ? '写下你的评论...' : '请先登录后再评论'"
          class="comment-input"
          :disabled="!userStore.isLoggedIn"
          @keyup.enter="handleSubmitComment"
        />
        <button
          class="submit-btn btn-primary"
          :disabled="!userStore.isLoggedIn || !newComment.trim()"
          @click="handleSubmitComment"
        >
          <span class="btn-icon">✨</span>
          发布
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useUserStore } from '../stores/userStore'
import type { Post, Comment } from '../types'

const props = defineProps<{
  post: Post
}>()

const emit = defineEmits<{
  (e: 'like-comment', commentId: number): void
  (e: 'add-comment', postId: number, content: string): void
  (e: 'delete-comment', commentId: number): void
}>()

const userStore = useUserStore()
const newComment = ref('')

const userAvatar = computed(() => {
  return userStore.userAvatar
})

const handleLikeComment = (commentId: number) => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再点赞')
    return
  }
  emit('like-comment', commentId)
}

const handleSubmitComment = () => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再评论')
    return
  }
  
  if (newComment.value.trim()) {
    emit('add-comment', props.post.id, newComment.value.trim())
    newComment.value = ''
  }
}

const canDeleteComment = (comment: Comment) => {
  return userStore.isLoggedIn && userStore.userInfo?.id === comment.userId
}

const handleDeleteComment = (commentId: number) => {
  if (confirm('确定要删除这条评论吗？')) {
    emit('delete-comment', commentId)
  }
}
</script>

<style scoped>
.comment-section {
  margin-top: 28px;
  padding: 24px;
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.comment-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

.comment-section:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-3px);
}

/* ====== 评论头部 ====== */
.comment-header {
  margin-bottom: 20px;
  padding-bottom: 16px;
  border-bottom: 2px dashed rgba(212, 175, 55, 0.25);
}

.comment-header h3 {
  font-size: 17px;
  font-weight: 700;
  color: var(--text-color);
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
  letter-spacing: 1px;
}

.header-icon { font-size: 20px; animation: iconPulse 3s ease-in-out infinite; }

@keyframes iconPulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.15) rotate(5deg); }
}

/* ====== 评论列表 ====== */
.comment-list {
  margin-bottom: 20px;
  max-height: 400px;
  overflow-y: auto;
  padding-right: 8px;
}

.comment-list::-webkit-scrollbar {
  width: 6px;
}

.comment-list::-webkit-scrollbar-track {
  background: rgba(212, 175, 55, 0.08);
  border-radius: 10px;
}

.comment-list::-webkit-scrollbar-thumb {
  background: linear-gradient(180deg, var(--secondary-color), var(--primary-color));
  border-radius: 10px;
}

.comment-item {
  display: flex;
  gap: 14px;
  margin-bottom: 18px;
  padding: 16px;
  border: 1.5px solid transparent;
  border-radius: var(--radius-md);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  animation: fadeInUp 0.5s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(15px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.comment-item:hover {
  background: linear-gradient(135deg, rgba(200,22,29,0.02), rgba(212,175,55,0.02));
  border-color: var(--border-gold);
  transform: translateX(6px);
  box-shadow: 0 6px 20px rgba(200, 22, 29, 0.08);
}

.comment-item:last-child { margin-bottom: 0; }

/* ====== 用户头像 ====== */
.comment-avatar {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  object-fit: cover;
  flex-shrink: 0;
  border: 2.5px solid var(--border-gold);
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.comment-item:hover .comment-avatar {
  border-color: var(--secondary-color);
  transform: scale(1.12) rotate(3deg);
  box-shadow: 0 4px 12px rgba(212, 175, 55, 0.25);
}

/* ====== 评论内容 ====== */
.comment-content {
  flex: 1;
  min-width: 0;
}

.comment-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.user-info {
  display: flex;
  align-items: baseline;
  gap: 10px;
}

.comment-nickname {
  font-weight: 700;
  color: var(--text-color);
  font-size: 15px;
  letter-spacing: 0.5px;
  transition: all 0.3s ease;
}

.comment-item:hover .comment-nickname {
  color: var(--primary-color);
}

.comment-time {
  font-size: 12px;
  color: var(--text-lighter);
  font-weight: 500;
}

.comment-text {
  font-size: 14px;
  color: var(--text-light);
  line-height: 1.7;
  margin: 0 0 12px 0;
  padding: 12px 16px;
  background: linear-gradient(135deg, rgba(250,250,250,0.9), rgba(255,255,255,0.95));
  border-radius: var(--radius-sm);
  border-left: 3px solid transparent;
  transition: all 0.3s ease;
}

.comment-item:hover .comment-text {
  background: white;
  border-left-color: var(--secondary-color);
  box-shadow: 0 2px 8px rgba(212, 175, 55, 0.1);
}

/* ====== 操作按钮 ====== */
.comment-bottom {
  display: flex;
  align-items: center;
  gap: 12px;
}

.action-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 7px 16px;
  border: 1.5px solid var(--border-gold);
  background: white;
  color: var(--text-light);
  font-size: 13px;
  cursor: pointer;
  border-radius: 20px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-weight: 500;
}

.action-btn:hover:not(:disabled) {
  background: linear-gradient(135deg, rgba(200,22,29,0.04), rgba(212,175,55,0.04));
  color: var(--primary-color);
  border-color: var(--primary-color);
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 4px 12px rgba(200, 22, 29, 0.12);
}

.icon { font-size: 15px; }

.like-btn.liked {
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

/* ====== 输入区域 ====== */
.comment-input-section {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 18px;
  background: linear-gradient(135deg, rgba(250,250,250,0.95), rgba(255,255,255,0.99));
  border-radius: var(--radius-md);
  border: 2px solid var(--border-gold);
  transition: all 0.3s ease;
  box-shadow: inset 0 2px 6px rgba(0, 0, 0, 0.03);
}

.comment-input-section:focus-within {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.08), inset 0 2px 6px rgba(0, 0, 0, 0.02);
  transform: translateY(-2px);
}

.input-avatar {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  background: var(--gradient-primary);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 17px;
  font-weight: 800;
  flex-shrink: 0;
  border: 2.5px solid var(--border-gold);
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(200, 22, 29, 0.2);
}

.input-avatar:hover {
  transform: scale(1.08) rotate(5deg);
  box-shadow: 0 4px 16px rgba(200, 22, 29, 0.3);
}

.guest-avatar {
  background: linear-gradient(135deg, #e0e0e0, #bdbdbd);
  font-size: 18px;
}

.input-container {
  flex: 1;
  display: flex;
  background-color: white;
  border: 2px solid var(--border-gold);
  border-radius: 26px;
  padding: 4px 6px 4px 18px;
  align-items: center;
  transition: all 0.3s ease;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.04);
}

.input-container:focus-within {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(200, 22, 29, 0.06);
}

.comment-input {
  flex: 1;
  border: none;
  outline: none;
  padding: 10px 0;
  font-size: 14px;
  resize: none;
  background: transparent;
  color: var(--text-color);
  line-height: 1.5;
}

.comment-input::placeholder {
  color: var(--text-lighter);
  font-style: italic;
}

.submit-btn {
  padding: 10px 22px;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 1px;
  display: flex;
  align-items: center;
  gap: 6px;
  border-radius: 20px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.submit-btn:hover:not(:disabled) {
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 6px 16px rgba(200, 22, 29, 0.35);
}

.submit-btn:disabled {
  opacity: 0.45;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.btn-icon { font-size: 14px; }

/* 响应式设计 */
@media (max-width: 768px) {
  .comment-section {
    padding: 18px;
  }

  .comment-item {
    flex-direction: column;
    gap: 12px;
    padding: 14px;
  }

  .comment-avatar {
    width: 38px;
    height: 38px;
  }

  .comment-input-section {
    flex-direction: column;
    align-items: stretch;
    gap: 10px;
  }

  .input-avatar {
    align-self: flex-start;
  }

  .input-container {
    padding: 4px 6px 4px 14px;
  }

  .comment-list {
    max-height: 300px;
  }
}
</style>