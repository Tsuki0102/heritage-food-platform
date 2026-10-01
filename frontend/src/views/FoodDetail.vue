<template>
  <div class="food-detail">
    <Header />

    <template v-if="isLoading">
      <div class="skeleton-container">
        <div class="skeleton-banner">
          <div class="skeleton-badge"></div>
          <div class="skeleton-title"></div>
          <div class="skeleton-subtitle"></div>
        </div>
        
        <div class="container skeleton-content">
          <div class="food-header">
            <div class="food-cover skeleton-image">
              <div class="skeleton-shimmer"></div>
            </div>
            <div class="food-info">
              <h1 class="skeleton-text skeleton-title-lg"></h1>
              <p class="skeleton-text skeleton-desc"></p>
              <div class="food-stats">
                <div class="stat-item skeleton-stat">
                  <span class="skeleton-text skeleton-stat-value"></span>
                  <span class="skeleton-text skeleton-stat-label"></span>
                </div>
                <div class="stat-item skeleton-stat">
                  <span class="skeleton-text skeleton-stat-value"></span>
                  <span class="skeleton-text skeleton-stat-label"></span>
                </div>
                <div class="stat-item skeleton-stat">
                  <span class="skeleton-text skeleton-stat-value"></span>
                  <span class="skeleton-text skeleton-stat-label"></span>
                </div>
              </div>
              <div class="food-tags">
                <span class="skeleton-tag"></span>
                <span class="skeleton-tag"></span>
              </div>
              <div class="food-actions">
                <button class="action-btn skeleton-btn"></button>
                <button class="action-btn skeleton-btn"></button>
                <button class="action-btn skeleton-btn"></button>
              </div>
            </div>
          </div>

          <div class="food-tabs">
            <div class="tab-nav">
              <button class="tab-btn skeleton-tab"></button>
              <button class="tab-btn skeleton-tab"></button>
              <button class="tab-btn skeleton-tab"></button>
              <button class="tab-btn skeleton-tab"></button>
            </div>
            <div class="tab-content">
              <div class="skeleton-paragraph">
                <div class="skeleton-line"></div>
                <div class="skeleton-line"></div>
                <div class="skeleton-line"></div>
                <div class="skeleton-line skeleton-line-short"></div>
              </div>
            </div>
          </div>

          <div class="related-foods">
            <h3 class="skeleton-text skeleton-section-title"></h3>
            <div class="food-list">
              <div class="food-item skeleton-food-item">
                <div class="skeleton-food-image"></div>
                <div class="food-item-info">
                  <div class="skeleton-text skeleton-food-title"></div>
                  <div class="skeleton-text skeleton-food-desc"></div>
                </div>
              </div>
              <div class="food-item skeleton-food-item">
                <div class="skeleton-food-image"></div>
                <div class="food-item-info">
                  <div class="skeleton-text skeleton-food-title"></div>
                  <div class="skeleton-text skeleton-food-desc"></div>
                </div>
              </div>
              <div class="food-item skeleton-food-item">
                <div class="skeleton-food-image"></div>
                <div class="food-item-info">
                  <div class="skeleton-text skeleton-food-title"></div>
                  <div class="skeleton-text skeleton-food-desc"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>

    <template v-else>
      <BannerSection :title="food.name" :subtitle="`${food.region} · ${food.taste}`" badge-icon="🍽️" :badge="food.heritageLevel" />

      <div class="container">
      <div class="food-header">
          <div class="food-header-top">
            <BackButton :to="ROUTES.HOME" />
          </div>
          <img
              :src="`/images/${food.coverImage}`"
              :alt="food.name"
              class="food-cover"
              @error="handleImageError"
          />
          <div class="food-info">
            <h1>{{ food.name }}</h1>
            <div class="food-meta">
              <span class="region">{{ food.region }}</span>
              <span class="taste">{{ food.taste }}</span>
              <span class="level">{{ food.heritageLevel }}</span>
            </div>
            <div class="food-stats">
              <div class="stat-item">
                <span class="stat-value">{{ food.averageScore }}</span>
                <span class="stat-label">评分</span>
              </div>
              <div class="stat-item">
                <span class="stat-value">{{ food.collectionCount }}</span>
                <span class="stat-label">收藏</span>
              </div>
              <div class="stat-item">
                <span class="stat-value">{{ food.viewCount }}</span>
                <span class="stat-label">浏览</span>
              </div>
            </div>
            <div class="food-actions">
              <button class="action-btn collect-btn" :class="{ active: isCollected, disabled: !userStore.isLoggedIn }" @click="handleCollect">
                <span class="icon">{{ isCollected ? '❤️' : '🤍' }}</span>
                {{ isCollected ? '已收藏' : '收藏' }}
              </button>
              <button class="action-btn share-btn" :class="{ disabled: !userStore.isLoggedIn }" @click="handleShare">
                <span class="icon">📤</span>
                分享
              </button>
              <button class="action-btn ai-btn" @click="showAiExplain">
                <span class="icon">🤖</span>
                AI讲解
              </button>
            </div>
          </div>
        </div>

        <div class="food-tabs">
          <div class="tab-nav">
            <button 
              v-for="tab in tabs" 
              :key="tab.key" 
              :class="['tab-btn', { active: activeTab === tab.key }]"
              @click="activeTab = tab.key"
            >
              {{ tab.label }}
            </button>
          </div>
          <div class="tab-content">
            <div v-if="activeTab === 'history'" class="tab-pane">
              <h3>历史渊源</h3>
              <p>{{ food.history }}</p>
            </div>
            <div v-if="activeTab === 'ingredients'" class="tab-pane">
              <h3>原料配方</h3>
              <p>{{ food.ingredients }}</p>
            </div>
            <div v-if="activeTab === 'process'" class="tab-pane">
              <h3>制作工艺</h3>
              <p>{{ food.process }}</p>
            </div>
            <div v-if="activeTab === 'comments'" class="tab-pane">
              <h3>用户评价</h3>
              <div class="comment-list">
                <div class="comment-item" v-for="comment in comments" :key="comment.id">
                  <div class="comment-header">
                    <img :src="comment.avatar" :alt="comment.nickname" class="comment-avatar" @error="handleAvatarError" />
                    <div class="comment-user">
                      <span class="nickname">{{ comment.nickname }}</span>
                      <span class="time">{{ formatTime(comment.createTime) }}</span>
                    </div>
                    <div class="comment-rating">
                      <span class="stars" v-for="i in 5" :key="i">
                        {{ i <= (comment.score || 0) ? '★' : '☆' }}
                      </span>
                    </div>
                  </div>
                  <div class="comment-content">{{ comment.content }}</div>
                </div>
                <div v-if="comments.length === 0" class="no-comments">
                  暂无评价，快来发表第一条评价吧！
                </div>
              </div>
              <div class="comment-form">
                  <h4>发表评价</h4>
                  <div class="rating-input" :class="{ disabled: !userStore.isLoggedIn }">
                    <span class="label">评分：</span>
                    <span class="stars" v-for="i in 5" :key="i" @click="handleRatingClick(i)">
                      {{ i <= selectedScore ? '★' : '☆' }}
                    </span>
                  </div>
                  <textarea 
                    v-model="commentContent" 
                    :placeholder="userStore.isLoggedIn ? '请输入评价内容...' : '请先登录后再发表评价'"
                    :disabled="!userStore.isLoggedIn || isSubmitting"
                  ></textarea>
                  <button 
                    class="submit-btn" 
                    @click="handleSubmitComment"
                    :disabled="!userStore.isLoggedIn || isSubmitting"
                  >
                    {{ isSubmitting ? '提交中...' : '提交评价' }}
                  </button>
                </div>
            </div>
          </div>
        </div>

        <div class="related-foods">
          <h3>相关美食</h3>
          <div class="food-list">
            <div class="food-item" v-for="item in relatedFoods" :key="item.id" @click="navigateToFoodDetail(item.id)" style="cursor: pointer;">
              <img :src="`/images/${item.coverImage}`" :alt="item.name" class="food-img" @error="handleImageError" />
              <div class="food-info">
                <h4>{{ item.name }}</h4>
                <p class="food-region">{{ item.region }}</p>
                <div class="food-rating">
                  <span class="rating">{{ item.averageScore }}</span>
                </div>
              </div>
            </div>
            <div v-if="relatedFoods.length === 0" class="no-related">
              暂无相关美食
            </div>
          </div>
        </div>
      </div>
    </template>

    <Footer />

    <div v-if="showAiModal" class="ai-modal" @click.self="closeAiModal">
      <div class="ai-modal-content">
        <div class="ai-modal-header">
          <h3>🤖 AI美食讲解</h3>
          <div class="ai-modal-actions">
            <button class="ai-speech-btn" :class="{ active: isSpeaking }" @click="toggleSpeech">
              {{ isSpeaking ? '⏹️ 停止播报' : '🔊 语音播报' }}
            </button>
            <button class="ai-modal-close" @click="closeAiModal">×</button>
          </div>
        </div>
        <div class="ai-modal-body">
          <div v-if="aiLoading" class="ai-loading">加载中...</div>
          <div v-else class="ai-content" v-html="aiExplanation"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getFoodById, getFoodRatings, submitFoodRating } from '../api/foodApi'
import { useFoodStore } from '../stores/foodStore'
import BackButton from '../components/BackButton.vue'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
import BannerSection from '../components/BannerSection.vue'
import { useUserDataStore } from '../stores/userDataStore'
import { useUserStore } from '../stores/userStore'
import { ROUTES } from '../constants'
import { Validator, DateUtils } from '../utils'

const route = useRoute()
const router = useRouter()
const userDataStore = useUserDataStore()
const userStore = useUserStore()
const foodStore = useFoodStore()

const navigateToFoodDetail = (foodId: number) => {
  try {
    router.push({ name: 'foodDetail', params: { id: foodId } })
  } catch (error) {
    console.error('路由跳转失败:', error)
    router.push(`/food/${foodId}`)
  }
}

const foodId = Number(route.params.id)
const food = ref<any>(null)
const relatedFoods = ref<any[]>([])
const comments = ref<any[]>([])
const isLoading = ref(true)

watch(() => route.params.id, async (newId) => {
  if (newId) {
    const id = Number(newId)
    await fetchFoodData(id)
  }
}, { immediate: false })

const fetchFoodData = async (id: number) => {
  isLoading.value = true
  try {
    const foodData = await getFoodById(id)
    if (!foodData) {
      alert('该美食不存在')
      router.push(ROUTES.HOME)
      return
    }
    food.value = foodData

    try {
      const related = await foodStore.fetchRelatedFoods(id)
      relatedFoods.value = related
    } catch (error) {
      relatedFoods.value = []
    }

    try {
      const ratings = await getFoodRatings(id)
      comments.value = (ratings || []).map((rating: any) => ({
        id: rating.id,
        userId: rating.userId,
        nickname: '用户' + rating.userId,
        avatar: rating.avatar ? `/images/${rating.avatar}` : '/images/avatar1.jpg',
        score: rating.score,
        content: rating.content,
        createTime: rating.createTime
      }))
    } catch (error) {
      comments.value = []
    }
    
    try {
      if (food.value) {
        userDataStore.addHistory({
          id: food.value.id,
          name: food.value.name,
          desc: food.value.history.substring(0, 50) + '...',
          image: `/images/${food.value.coverImage}`
        }, 'food')
      }
    } catch (error) {}
  } catch (error) {
    console.error('获取美食详情失败:', error)
    alert('获取详情失败，请返回首页重试')
    router.push(ROUTES.HOME)
  } finally {
    isLoading.value = false
  }
}

onMounted(async () => {
  await fetchFoodData(foodId)
})

const isCollected = computed(() => userDataStore.isCollected('foods', foodId))

const tabs = [
  { key: 'history', label: '历史渊源' },
  { key: 'ingredients', label: '原料配方' },
  { key: 'process', label: '制作工艺' },
  { key: 'comments', label: '用户评价' }
]

const activeTab = ref('history')
const selectedScore = ref(5)
const commentContent = ref('')
const isSubmitting = ref(false)

const showAiModal = ref(false)
const aiExplanation = ref('')
const aiLoading = ref(false)
const isSpeaking = ref(false)
let speechUtterance: SpeechSynthesisUtterance | null = null

const formatTime = (time: string) => {
  return DateUtils.relativeTime(time)
}

const handleRatingClick = (score: number) => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再评分')
    return
  }
  selectedScore.value = score
}

const handleImageError = (event: Event) => {
  const target = event.target as HTMLImageElement
  target.src = '/images/beijing-duck.jpg'
}

const handleAvatarError = (event: Event) => {
  const target = event.target as HTMLImageElement
  target.src = '/images/avatar1.jpg'
}

const handleCollect = () => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再收藏')
    return
  }
  
  try {
    if (!food.value) return
    if (isCollected.value) {
      userDataStore.removeCollection('foods', foodId)
    } else {
      userDataStore.addCollection('foods', {
        id: food.value.id,
        name: food.value.name,
        desc: food.value.history.substring(0, 50) + '...',
        image: `/images/${food.value.coverImage}`
      })
    }
  } catch (error) {
    alert('操作失败，请重试')
  }
}

const handleShare = () => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再分享')
    return
  }
  alert('分享功能开发中')
}

const validateComment = () => {
  if (!userStore.isLoggedIn) {
    alert('请先登录后再发表评价')
    return false
  }
  if (!Validator.required(commentContent.value)) {
    alert('请输入评价内容')
    return false
  }
  if (!Validator.minLength(commentContent.value, 5)) {
    alert('评价内容至少需要5个字符')
    return false
  }
  if (!Validator.maxLength(commentContent.value, 500)) {
    alert('评价内容不能超过500个字符')
    return false
  }
  return true
}

const handleSubmitComment = async () => {
  if (!validateComment()) return
  if (!food.value) return
  if (!userStore.userId) {
    alert('请先登录')
    return
  }

  isSubmitting.value = true
  try {
    await submitFoodRating(foodId, selectedScore.value, commentContent.value, userStore.userId)
    const ratings = await getFoodRatings(foodId)
    comments.value = (ratings || []).map((rating: any) => ({
      id: rating.id,
      userId: rating.userId,
      nickname: '用户' + rating.userId,
      avatar: rating.avatar ? `/images/${rating.avatar}` : '/images/avatar1.jpg',
      score: rating.score,
      content: rating.content,
      createTime: rating.createTime
    }))
    alert('评价提交成功！')
    commentContent.value = ''
    selectedScore.value = 5
  } catch (error) {
    alert('提交失败，请重试')
  } finally {
    isSubmitting.value = false
  }
}

const showAiExplain = async () => {
  if (!food.value) return;
  
  showAiModal.value = true;
  aiLoading.value = true;
  aiExplanation.value = '';

  try {
    const url = `/api/ai/food/explain?foodName=${encodeURIComponent(food.value.name)}`;
    const response = await fetch(url, {
      method: "GET",
      mode: "cors",
      headers: {
        "Content-Type": "text/plain;charset=UTF-8"
      }
    });

    if (!response.ok) throw new Error("请求失败");
    const text = await response.text();
    aiExplanation.value = formatAiResponse(text);
  } catch (err) {
    aiExplanation.value = "<p>获取AI讲解失败，请确保后端已启动并配置跨域</p>";
  } finally {
    aiLoading.value = false;
  }
};

const formatAiResponse = (text: string): string => {
  if (!text || text.trim() === '') {
    return "<p>暂无讲解内容</p>";
  }

  const lines: string[] = text.split(/[\r\n]+/);
  const cleanedLines: string[] = lines.filter((line: string) => line.trim() !== '');
  const formattedParagraphs: string[] = [];

  cleanedLines.forEach((line: string, index: number) => {
    let processedLine: string = line.trim();
    
    if (processedLine.length === 0) return;

    const isStartWithNumber: boolean = /^[①②③④⑤⑥⑦⑧⑨⑩]/.test(processedLine);
    const isShortParagraph: boolean = processedLine.length < 50;
    const isFirstParagraph: boolean = index === 0;

    if (isStartWithNumber || (isShortParagraph && isFirstParagraph)) {
      const match: RegExpMatchArray | null = processedLine.match(/^([①②③④⑤⑥⑦⑧⑨⑩])\s*(.+)/);
      if (match) {
        processedLine = `<strong>${match[1]} ${match[2]}</strong>`;
      } else {
        processedLine = `<strong>${processedLine}</strong>`;
      }
    }

    formattedParagraphs.push(`<p>${processedLine}</p>`);
  });

  return formattedParagraphs.join('\n');
};

const toggleSpeech = () => {
  if (isSpeaking.value) {
    window.speechSynthesis.cancel();
    isSpeaking.value = false;
    return;
  }

  const text = aiExplanation.value.replace(/<[^>]*>/g, '');
  
  if (!text || text.trim() === '') {
    return;
  }

  speechUtterance = new SpeechSynthesisUtterance(text);
  speechUtterance.lang = 'zh-CN';
  speechUtterance.rate = 0.9;
  speechUtterance.pitch = 1;

  speechUtterance.onend = () => {
    isSpeaking.value = false;
  };

  speechUtterance.onerror = () => {
    isSpeaking.value = false;
  };

  window.speechSynthesis.speak(speechUtterance);
  isSpeaking.value = true;
};

const closeAiModal = () => {
  window.speechSynthesis.cancel();
  isSpeaking.value = false;
  showAiModal.value = false
}
</script>

<style scoped>
.food-detail {
  min-height: 100vh;
  background: var(--gradient-bg);
  position: relative;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 24px;
}

.food-header {
  position: relative;
  display: grid;
  grid-template-columns: 420px 1fr;
  gap: 40px;
  margin-bottom: 48px;
  background: var(--gradient-card);
  border-radius: var(--radius-xl);
  overflow: hidden;
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
}

.food-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 5px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

.food-header-top {
  position: absolute;
  top: 20px;
  left: 20px;
  z-index: 10;
}

.food-cover {
  width: 100%;
  height: 450px;
  object-fit: cover;
  transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

.food-header:hover .food-cover {
  transform: scale(1.03);
}

.food-info {
  padding: 40px;
  display: flex;
  flex-direction: column;
}

.food-info h1 {
  font-size: 36px;
  margin-bottom: 20px;
  color: var(--text-color);
  font-weight: 800;
  letter-spacing: 2px;
  background: linear-gradient(135deg, var(--text-color), var(--primary-color));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.food-meta {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}

.region {
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.08), rgba(212, 175, 55, 0.08));
  border: 1px solid var(--border-gold);
  padding: 8px 18px;
  border-radius: 25px;
  font-size: 14px;
  color: var(--primary-color);
  font-weight: 600;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.region::before { content: '📍'; }

.taste {
  background: linear-gradient(135deg, rgba(255, 149, 0, 0.08), rgba(212, 175, 55, 0.08));
  border: 1px solid var(--border-gold);
  padding: 8px 18px;
  border-radius: 25px;
  font-size: 14px;
  color: #ff9500;
  font-weight: 600;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.taste::before { content: '🌶️'; }

.level {
  background: var(--gradient-primary);
  padding: 8px 18px;
  border-radius: 25px;
  font-size: 13px;
  color: white;
  font-weight: 700;
  letter-spacing: 1px;
  box-shadow: var(--shadow-primary);
}

.food-stats {
  display: flex;
  gap: 32px;
  margin-bottom: 28px;
  padding: 20px 0;
  border-top: 1.5px dashed var(--border-gold);
  border-bottom: 1.5px dashed var(--border-gold);
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16px 24px;
  background: linear-gradient(135deg, rgba(212, 175, 55, 0.05), rgba(200, 22, 29, 0.03));
  border-radius: var(--radius-sm);
  transition: var(--transition);
  border: 1px solid transparent;
}

.stat-item:hover {
  border-color: var(--border-gold-hover);
  transform: translateY(-3px);
}

.stat-value {
  font-size: 28px;
  font-weight: 800;
  color: var(--secondary-color);
  letter-spacing: 1px;
}

.stat-label {
  font-size: 13px;
  color: var(--text-lighter);
  margin-top: 4px;
  font-weight: 500;
}

.food-actions {
  display: flex;
  gap: 16px;
  margin-top: auto;
}

.action-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 26px;
  border: 2px solid var(--primary-color);
  background: white;
  color: var(--primary-color);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 1px;
  flex: 1;
}

.action-btn:hover:not(:disabled) {
  background: var(--gradient-primary);
  color: white;
  transform: translateY(-2px);
  box-shadow: var(--shadow-primary);
  border-color: transparent;
}

.action-btn:disabled {
  opacity: 0.45;
  cursor: not-allowed;
}

.collect-btn.active {
  background: var(--gradient-primary) !important;
  color: white !important;
  border-color: transparent !important;
}

.icon { font-size: 18px; }

.food-tabs {
  background: var(--gradient-card);
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-gold);
  margin-bottom: 48px;
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

.tab-content {
  padding: 40px;
}

.tab-pane h3 {
  font-size: 22px;
  margin-bottom: 20px;
  color: var(--text-color);
  font-weight: 700;
  letter-spacing: 2px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.tab-pane h3::before {
  content: '✦';
  color: var(--secondary-color);
  font-size: 18px;
}

.tab-pane p {
  line-height: 1.85;
  color: var(--text-light);
  margin-bottom: 20px;
  font-size: 15px;
  text-align: justify;
}

.comment-list {
  margin-bottom: 36px;
}

.comment-item {
  padding: 24px 0;
  border-bottom: 1px dashed var(--border-gold);
  transition: var(--transition);
}

.comment-item:hover {
  background: rgba(212, 175, 55, 0.03);
  margin: 0 -20px;
  padding-left: 20px;
  padding-right: 20px;
  border-radius: var(--radius-xs);
}

.comment-header {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
}

.comment-avatar {
  width: 46px;
  height: 46px;
  border-radius: 50%;
  margin-right: 14px;
  object-fit: cover;
  border: 3px solid var(--border-gold);
  transition: var(--transition);
}

.comment-item:hover .comment-avatar {
  border-color: var(--secondary-color);
  transform: scale(1.08);
}

.comment-user {
  flex: 1;
}

.nickname {
  font-size: 15px;
  font-weight: 700;
  color: var(--text-color);
  margin-right: 10px;
}

.time {
  font-size: 12px;
  color: var(--text-lighter);
}

.comment-rating {
  color: var(--secondary-color);
  font-size: 14px;
  letter-spacing: 2px;
}

.comment-content {
  font-size: 15px;
  line-height: 1.7;
  color: var(--text-light);
  padding-left: 60px;
}

.no-comments {
  text-align: center;
  padding: 48px;
  color: var(--text-lighter);
  font-size: 15px;
  background: linear-gradient(135deg, rgba(212, 175, 55, 0.03), rgba(200, 22, 29, 0.02));
  border-radius: var(--radius-md);
  border: 1px dashed var(--border-gold);
}

.comment-form {
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
  padding: 28px;
  border-radius: var(--radius-md);
  border: 1px solid var(--border-gold);
  box-shadow: var(--shadow-sm);
}

.comment-form h4 {
  font-size: 17px;
  margin-bottom: 18px;
  color: var(--text-color);
  font-weight: 700;
  letter-spacing: 1px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.comment-form h4::before { content: '💬'; }

.rating-input {
  display: flex;
  align-items: center;
  margin-bottom: 18px;
  padding: 12px 16px;
  background: white;
  border-radius: var(--radius-xs);
  border: 1px solid var(--border-gold);
}

.rating-input .label {
  font-size: 14px;
  color: var(--text-light);
  margin-right: 12px;
  font-weight: 600;
}

.rating-input .stars {
  font-size: 24px;
  color: var(--secondary-color);
  cursor: pointer;
  transition: transform 0.2s ease;
  filter: drop-shadow(0 2px 4px rgba(212, 175, 55, 0.3));
}

.rating-input .stars:hover {
  transform: scale(1.25) rotate(-5deg);
}

.rating-input.disabled {
  opacity: 0.5;
}

.comment-form textarea {
  width: 100%;
  height: 120px;
  padding: 16px;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-sm);
  resize: vertical;
  margin-bottom: 18px;
  font-size: 15px;
  font-family: inherit;
  transition: var(--transition);
  background: white;
  color: var(--text-color);
}

.comment-form textarea:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.08);
}

.submit-btn {
  background: var(--gradient-primary);
  color: #fff;
  border: none;
  padding: 13px 32px;
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 2px;
  box-shadow: var(--shadow-primary);
}

.submit-btn:hover:not(:disabled) {
  background: var(--gradient-primary-reverse);
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(200, 22, 29, 0.35);
}

.submit-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.related-foods {
  margin-bottom: 56px;
}

.related-foods h3 {
  font-size: 26px;
  margin-bottom: 28px;
  color: var(--text-color);
  font-weight: 700;
  letter-spacing: 3px;
  text-align: center;
  position: relative;
  padding-bottom: 16px;
}

.related-foods h3::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 80px;
  height: 3px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  border-radius: 2px;
}

.food-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 24px;
}

.food-item {
  background: var(--gradient-card);
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  border: 1px solid var(--border-gold);
  position: relative;
}

.food-item::before {
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

.food-item:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: var(--shadow-lg);
  border-color: var(--border-gold-hover);
}

.food-item:hover::before {
  opacity: 1;
}

.food-item .food-info {
  pointer-events: none;
  padding: 16px;
  display: block;
}

.food-img {
  width: 100%;
  height: 180px;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.food-item:hover .food-img {
  transform: scale(1.08);
}

.food-info h4 {
  font-size: 17px;
  margin: 0 0 8px 0;
  color: var(--text-color);
  font-weight: 700;
  letter-spacing: 1px;
  transition: color 0.3s ease;
}

.food-item:hover .food-info h4 {
  color: var(--primary-color);
}

.food-region {
  font-size: 13px;
  color: var(--text-light);
  margin: 0 0 10px 0;
  display: inline-block;
  background: linear-gradient(135deg, rgba(212, 175, 55, 0.1), rgba(200, 22, 29, 0.06));
  padding: 3px 10px;
  border-radius: 12px;
  font-weight: 500;
}

.food-rating {
  margin: 0;
  display: flex;
  align-items: center;
  gap: 6px;
}

.rating {
  font-size: 16px;
  font-weight: 800;
  color: var(--secondary-color);
  letter-spacing: 1px;
}

.no-related {
  grid-column: 1 / -1;
  text-align: center;
  padding: 48px;
  color: var(--text-lighter);
  font-size: 15px;
  background: var(--gradient-card);
  border-radius: var(--radius-lg);
  border: 1px dashed var(--border-gold);
}

@media (max-width: 1024px) {
  .food-header {
    grid-template-columns: 350px 1fr;
    gap: 30px;
  }
  .food-cover {
    height: 380px;
  }
  .food-info h1 {
    font-size: 30px;
  }
  .food-tags {
    flex-wrap: wrap;
  }
  .stat-item {
    padding: 12px 16px;
  }
}

@media (max-width: 768px) {
  .food-header {
    grid-template-columns: 1fr;
    gap: 0;
  }
  .food-cover {
    height: 300px;
    border-radius: 0;
  }
  .food-info {
    padding: 24px;
    border-radius: 24px 24px 0 0;
    margin-top: -20px;
    position: relative;
    z-index: 10;
  }
  .food-info h1 {
    font-size: 26px;
  }
  .food-desc {
    font-size: 14px;
    line-height: 1.7;
  }
  .food-stats {
    gap: 12px;
    flex-wrap: wrap;
  }
  .stat-item {
    padding: 10px 14px;
    font-size: 13px;
  }
  .stat-value {
    font-size: 20px;
  }
  .food-tags {
    gap: 8px;
  }
  .region, .taste {
    padding: 6px 14px;
    font-size: 13px;
  }
  .tab-btn {
    padding: 12px 16px;
    font-size: 13px;
  }
  .tab-content {
    padding: 20px;
  }
  .food-list {
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 16px;
  }
  .comment-content {
    padding-left: 0;
  }
  .comment-item {
    padding: 16px;
  }
  .related-foods h3 {
    font-size: 20px;
  }
}

@media (max-width: 480px) {
  .food-detail {
    padding-bottom: 80px;
  }
  .food-header {
    grid-template-columns: 1fr;
  }
  .food-cover {
    height: 240px;
  }
  .food-info {
    padding: 20px;
    margin-top: -16px;
  }
  .food-info h1 {
    font-size: 22px;
    margin-bottom: 12px;
  }
  .food-desc {
    font-size: 13px;
    margin-bottom: 16px;
  }
  .food-stats {
    gap: 8px;
    margin-bottom: 16px;
  }
  .stat-item {
    padding: 8px 12px;
    font-size: 12px;
    min-width: 80px;
  }
  .stat-value {
    font-size: 18px;
  }
  .food-tags {
    gap: 6px;
    margin-bottom: 16px;
  }
  .region, .taste {
    padding: 5px 12px;
    font-size: 12px;
  }
  .food-actions {
    flex-direction: column;
    gap: 10px;
  }
  .action-btn {
    width: 100%;
    padding: 14px 20px;
    font-size: 14px;
  }
  .tabs {
    overflow-x: auto;
    white-space: nowrap;
    padding: 0 16px;
    margin: 0 -20px;
  }
  .tab-btn {
    padding: 12px 20px;
    font-size: 14px;
    flex-shrink: 0;
  }
  .tab-content {
    padding: 16px;
  }
  .tab-content h3 {
    font-size: 18px;
    margin-bottom: 12px;
  }
  .food-list {
    grid-template-columns: 1fr;
    gap: 12px;
  }
  .food-item {
    padding: 12px;
  }
  .food-item img {
    height: 120px;
  }
  .food-item-info h4 {
    font-size: 15px;
  }
  .comment-item {
    padding: 12px;
  }
  .comment-user {
    margin-bottom: 8px;
  }
  .comment-score {
    margin-bottom: 8px;
  }
  .comment-text {
    font-size: 13px;
    line-height: 1.6;
  }
  .comment-time {
    font-size: 12px;
  }
  .comment-form textarea {
    height: 80px;
    font-size: 13px;
  }
  .related-foods {
    padding: 16px;
  }
  .related-foods h3 {
    font-size: 18px;
  }
  
  .ai-modal {
    background: rgba(0, 0, 0, 0.8);
  }
  
  .ai-modal-content {
    width: 100%;
    max-width: 100%;
    max-height: 100vh;
    height: 100%;
    border-radius: 0;
    border: none;
    display: flex;
    flex-direction: column;
  }
  
  .ai-modal-header {
    padding: 16px 20px;
    position: sticky;
    top: 0;
    z-index: 10;
  }
  
  .ai-modal-header h3 {
    font-size: 16px;
  }
  
  .ai-speech-btn {
    padding: 6px 12px;
    font-size: 12px;
  }
  
  .ai-modal-body {
    padding: 16px 20px;
    flex: 1;
    max-height: none;
    overflow-y: auto;
  }
  
  .ai-content {
    font-size: 14px;
    line-height: 1.7;
  }
}

@media (max-width: 360px) {
  .food-info {
    padding: 16px;
  }
  .food-info h1 {
    font-size: 20px;
  }
  .food-cover {
    height: 200px;
  }
  .action-btn {
    padding: 12px 16px;
    font-size: 13px;
  }
  .ai-modal-body {
    padding: 12px 16px;
  }
}

.ai-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.ai-modal-content {
  background: var(--gradient-card);
  border-radius: var(--radius-lg);
  width: 90%;
  max-width: 600px;
  max-height: 80vh;
  overflow: hidden;
  border: 2px solid var(--border-gold);
  box-shadow: var(--shadow-lg);
}

.ai-modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  background: var(--gradient-primary);
  color: white;
}

.ai-modal-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.ai-speech-btn {
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.4);
  color: white;
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 6px;
}

.ai-speech-btn:hover {
  background: rgba(255, 255, 255, 0.3);
}

.ai-speech-btn.active {
  background: #ff4757;
  border-color: #ff4757;
}

.ai-modal-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  letter-spacing: 1px;
}

.ai-modal-close {
  background: none;
  border: none;
  color: white;
  font-size: 28px;
  cursor: pointer;
  line-height: 1;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background 0.2s;
}

.ai-modal-close:hover {
  background: rgba(255, 255, 255, 0.2);
}

.ai-modal-body {
  padding: 24px;
  max-height: 60vh;
  overflow-y: auto;
}

.ai-loading {
  text-align: center;
  padding: 40px;
  color: var(--text-lighter);
  font-size: 15px;
}

.ai-content {
  font-size: 15px;
  line-height: 1.8;
  color: var(--text-light);
  white-space: pre-wrap;
  word-break: break-word;
}

.ai-btn {
  background: white;
  border-color: var(--primary-color);
  color: var(--primary-color);
}

.ai-btn:hover:not(:disabled) {
  background: var(--gradient-primary);
  color: white;
}

/* 金色流光骨架屏动画 */
.skeleton-container {
  min-height: 100vh;
  background: var(--bg-primary);
}
.skeleton-banner {
  padding: 40px 24px;
  background: var(--gradient-primary);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}
.skeleton-badge {
  width: 48px;
  height: 48px;
  background: rgba(255,255,255,0.2);
  border-radius: 50%;
  animation: goldShimmer 1.8s infinite;
}
.skeleton-title {
  width: 200px;
  height: 32px;
  background: rgba(255,255,255,0.2);
  border-radius: 8px;
  animation: goldShimmer 1.8s infinite;
}
.skeleton-subtitle {
  width: 150px;
  height: 20px;
  background: rgba(255,255,255,0.15);
  border-radius: 6px;
  animation: goldShimmer 1.8s infinite;
}
.skeleton-content { padding: 0; }
.skeleton-image {
  position: relative;
  overflow: hidden;
  background: #f5e3c0;
  height: 450px;
}
.skeleton-shimmer {
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,215,0,0.3), transparent);
  animation: goldShimmer 1.8s infinite;
}
.skeleton-text {
  background: linear-gradient(90deg, #f5e3c0 25%, #f9d598 50%, #f5e3c0 75%);
  background-size: 200% 100%;
  animation: goldShimmer 1.8s infinite;
  border-radius: 4px;
}
.skeleton-title-lg { width: 70%; height: 40px; margin-bottom: 16px; }
.skeleton-desc { width: 90%; height: 16px; margin-bottom: 20px; }
.skeleton-stat {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}
.skeleton-stat-value { width: 50px; height: 28px; background: #f5e3c0; animation: goldShimmer 1.8s infinite; }
.skeleton-stat-label { width: 40px; height: 14px; background: #f5e3c0; animation: goldShimmer 1.8s infinite; }
.skeleton-tag {
  width: 80px;
  height: 32px;
  background: #f5e3c0;
  animation: goldShimmer 1.8s infinite;
  border-radius: 20px;
}
.skeleton-btn {
  background: #f5e3c0;
  animation: goldShimmer 1.8s infinite;
  border: 1px solid #f9d598;
}
.skeleton-tab {
  background: #f8f0e0;
  animation: goldShimmer 1.8s infinite;
  border: none;
}
.skeleton-paragraph {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.skeleton-line {
  height: 16px;
  background: #f5e3c0;
  animation: goldShimmer 1.8s infinite;
  border-radius: 4px;
}
.skeleton-line-short { width: 60%; }
.skeleton-section-title { width: 150px; height: 24px; margin-bottom: 20px; }
.skeleton-food-item {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}
.skeleton-food-image {
  width: 100%;
  height: 180px;
  background: #f5e3c0;
  animation: goldShimmer 1.8s infinite;
}
.skeleton-food-title { width: 70%; height: 20px; margin-bottom: 8px; }
.skeleton-food-desc { width: 90%; height: 14px; }

@keyframes goldShimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

@media (max-width: 768px) {
  .skeleton-banner { padding: 30px 16px; }
  .skeleton-title { width: 160px; height: 28px; }
  .skeleton-subtitle { width: 120px; height: 16px; }
  .skeleton-image { height: 380px; }
}
@media (max-width: 480px) {
  .skeleton-banner { padding: 24px 12px; }
  .skeleton-title { width: 140px; height: 24px; }
  .skeleton-subtitle { width: 100px; height: 14px; }
  .skeleton-food-image { height: 120px; }
  .skeleton-image { height: 300px; }
}
</style>