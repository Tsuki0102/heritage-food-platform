<template>
  <div class="taste-test">
    <div class="decorative-bg">
      <div class="bg-circle circle-1"></div>
      <div class="bg-circle circle-2"></div>
      <div class="bg-circle circle-3"></div>
    </div>
    <div class="container">
      <!-- 返回按钮 -->
      <button class="back-btn" @click="goBack">
        <span class="back-icon">←</span>
        <span class="back-text">返回</span>
      </button>
      
      <!-- 测试标题 -->
      <div class="test-header">
        <div class="header-icon">🍜</div>
        <h1 class="test-title">非遗美食口味DNA测试</h1>
        <p class="test-subtitle">只需10秒，发现你的专属美食画像</p>
      </div>

      <!-- 测试过程 -->
      <div v-if="!store.isCompleted" class="test-process">
        <div class="progress-container">
          <div class="progress-bar">
            <div 
              class="progress-fill" 
              :style="{ width: `${((store.currentQuestion + 1) / store.questions.length) * 100}%` }"
            ></div>
          </div>
          <div class="progress-text">{{ store.currentQuestion + 1 }} / {{ store.questions.length }}</div>
        </div>
        <div class="question-card">
          <div class="question-number">问题 {{ store.currentQuestion + 1 }}</div>
          <h2 class="question-text">{{ currentQuestion?.text }}</h2>
          <div class="options">
            <div 
              v-for="option in currentQuestion?.options" 
              :key="option.id"
              class="option-card"
              @click="store.selectAnswer(currentQuestion.id, option.value)"
            >
              <div class="option-icon">{{ getOptionIcon(option.value) }}</div>
              <div class="option-content">{{ option.text }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- 测试结果 -->
      <div v-else class="test-result">
        <div class="result-card">
          <div class="result-icon">🎉</div>
          <h2 class="result-title">你的美食口味画像</h2>
          <div class="portrait-box">
            <div class="portrait-decoration"></div>
            <div class="portrait-text">{{ store.result.portrait }}</div>
          </div>
          
          <div class="recommendations">
            <h3 class="recommend-title">✨ 为你推荐的非遗美食</h3>
            <div class="food-list">
              <div 
                v-for="(food, index) in store.result.recommendedFoods" 
                :key="index"
                class="food-item"
              >
                <div class="food-icon">{{ getFoodIcon(index) }}</div>
                <div class="food-name">{{ food }}</div>
              </div>
            </div>
          </div>
          
          <div class="result-actions">
            <button class="poster-btn" @click="generatePoster">
              <span>📸</span> 生成海报
            </button>
            <button class="reset-btn" @click="store.resetTest">
              <span>🔄</span> 重新测试
            </button>
          </div>
          
          <!-- 海报弹窗 -->
          <div v-if="showPoster" class="poster-modal" @click.self="showPoster = false">
            <div class="poster-content" ref="posterRef">
              <div class="poster-header">
                <div class="poster-logo">🍜</div>
                <h2 class="poster-title">非遗美食口味DNA测试</h2>
              </div>
              <div class="poster-divider"></div>
              <div class="poster-body">
                <div class="poster-portrait-box">
                  <div class="poster-portrait-text">{{ store.result.portrait }}</div>
                </div>
                <div class="poster-recommendations">
                  <h3 class="poster-recommend-title">✨ 推荐美食</h3>
                  <div class="poster-food-list">
                    <div 
                      v-for="(food, index) in store.result.recommendedFoods" 
                      :key="index"
                      class="poster-food-item"
                    >
                      <span class="poster-food-icon">{{ getFoodIcon(index) }}</span>
                      <span class="poster-food-name">{{ food }}</span>
                    </div>
                  </div>
                </div>
              </div>
              <div class="poster-footer">
                <p class="poster-quote">"美食是一种文化，品味是一种生活"</p>
                <p class="poster-date">{{ currentDate }}</p>
              </div>
            </div>
            <div class="poster-modal-actions">
              <button class="download-btn" @click="downloadPoster">
                <span>💾</span> 下载海报
              </button>
              <button class="close-btn" @click="showPoster = false">
                关闭
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useTasteTestStore } from '../stores/tasteTestStore'

const router = useRouter()

const goBack = () => {
  router.back()
}

const store = useTasteTestStore()
const showPoster = ref(false)
const posterRef = ref<HTMLElement>()

// 获取当前问题
const currentQuestion = computed(() => store.getCurrentQuestion())

// 获取当前日期
const currentDate = computed(() => {
  const now = new Date()
  return now.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
})

// 生成海报
const generatePoster = () => {
  showPoster.value = true
}

// 下载海报（使用简单的截图方式）
const downloadPoster = () => {
  alert('提示：请使用浏览器的截图功能保存海报\n\n快捷键：\nWindows: Win + Shift + S\nMac: Cmd + Shift + 4')
}

// 获取选项图标
const getOptionIcon = (value: string) => {
  const icons: Record<string, string> = {
    sweet: '🍬',
    spicy: '🌶️',
    light: '🥗',
    sour: '🍋',
    none: '🙅',
    mild: '🌶️',
    medium: '🌶️🌶️',
    hot: '🌶️🌶️🌶️',
    sichuan: '🐼',
    guangdong: '🥢',
    shandong: '🥟',
    jiangsu: '🦐',
    steamed: '🥟',
    braised: '🍖',
    'stir-fried': '🔥',
    stewed: '🍲',
    taste: '👅',
    health: '💪',
    appearance: '✨',
    price: '💰'
  }
  return icons[value] || '🍽️'
}

// 获取美食图标
const getFoodIcon = (index: number) => {
  const icons = ['🍜', '🥘', '🍲', '🥗', '🍱', '🥠']
  return icons[index] || '🍽️'
}

// 组件挂载时加载结果
onMounted(() => {
  store.loadResult()
})
</script>

<style scoped>
.taste-test {
  min-height: 100vh;
  padding: var(--spacing-xl) 0;
  background: linear-gradient(135deg, #fef5e7 0%, #fff5e6 50%, #ffeaa7 100%);
  position: relative;
  overflow: hidden;
}

.decorative-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  overflow: hidden;
}

.bg-circle {
  position: absolute;
  border-radius: 50%;
  opacity: 0.1;
}

.circle-1 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
  top: -100px;
  left: -100px;
  animation: float 8s ease-in-out infinite;
}

.circle-2 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
  bottom: -50px;
  right: -50px;
  animation: float 6s ease-in-out infinite reverse;
}

.circle-3 {
  width: 200px;
  height: 200px;
  background: linear-gradient(135deg, #ffb347, #ffcc33);
  top: 50%;
  right: 10%;
  animation: float 10s ease-in-out infinite;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0) rotate(0deg);
  }
  50% {
    transform: translateY(-30px) rotate(5deg);
  }
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 var(--spacing-md);
  position: relative;
  z-index: 1;
}

.back-btn {
  position: absolute;
  top: var(--spacing-md);
  left: var(--spacing-md);
  display: flex;
  align-items: center;
  gap: 6px;
  background: rgba(255, 255, 255, 0.9);
  border: 2px solid rgba(200, 22, 29, 0.1);
  border-radius: 50px;
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 600;
  color: var(--primary-color);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  z-index: 10;
}

.back-btn:hover {
  background: var(--primary-color);
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(200, 22, 29, 0.3);
  border-color: var(--primary-color);
}

.back-icon {
  font-size: 16px;
  font-weight: bold;
}

.back-text {
  font-size: 14px;
}

.test-header {
  text-align: center;
  margin-bottom: var(--spacing-xxl);
}

.header-icon {
  font-size: 64px;
  margin-bottom: var(--spacing-md);
  animation: bounce 2s ease-in-out infinite;
}

@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.test-title {
  font-size: 36px;
  font-weight: bold;
  background: linear-gradient(135deg, var(--primary-color), #ff6b6b);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: var(--spacing-md);
  text-shadow: none;
}

.test-subtitle {
  font-size: 18px;
  color: var(--text-light);
  font-weight: 500;
}

.test-process {
  max-width: 600px;
  margin: 0 auto;
}

.progress-container {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-xl);
}

.progress-bar {
  flex: 1;
  height: 12px;
  background: rgba(200, 22, 29, 0.1);
  border-radius: 6px;
  overflow: hidden;
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--primary-color), #ff6b6b, var(--secondary-color));
  background-size: 200% 100%;
  animation: shimmer 2s linear infinite;
  transition: width 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 6px;
}

@keyframes shimmer {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}

.progress-text {
  font-size: 14px;
  font-weight: 600;
  color: var(--primary-color);
  min-width: 50px;
}

.question-card {
  background: var(--bg-white);
  border-radius: 24px;
  padding: var(--spacing-xl);
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1), 0 2px 10px rgba(0, 0, 0, 0.05);
  border: 1px solid rgba(200, 22, 29, 0.1);
  backdrop-filter: blur(10px);
}

.question-number {
  font-size: 13px;
  color: var(--text-lighter);
  margin-bottom: var(--spacing-md);
  text-transform: uppercase;
  letter-spacing: 2px;
  font-weight: 600;
}

.question-text {
  font-size: 24px;
  font-weight: 700;
  color: var(--text-color);
  margin-bottom: var(--spacing-xl);
  text-align: center;
  line-height: 1.4;
}

.options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: var(--spacing-md);
}

.option-card {
  background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
  border: 2px solid #e9ecef;
  border-radius: 16px;
  padding: var(--spacing-lg) var(--spacing-md);
  text-align: center;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.option-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
  z-index: 1;
}

.option-card:hover {
  transform: translateY(-4px) scale(1.02);
  box-shadow: 0 12px 24px rgba(200, 22, 29, 0.15);
  border-color: var(--primary-color);
}

.option-card:hover::before {
  opacity: 0.08;
}

.option-card:active {
  transform: translateY(-2px) scale(0.98);
}

.option-icon {
  font-size: 36px;
  margin-bottom: var(--spacing-sm);
  position: relative;
  z-index: 2;
}

.option-content {
  position: relative;
  z-index: 2;
  font-size: 16px;
  font-weight: 600;
  color: var(--text-color);
}

.test-result {
  max-width: 600px;
  margin: 0 auto;
}

.result-card {
  background: var(--bg-white);
  border-radius: 24px;
  padding: var(--spacing-xl);
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1), 0 2px 10px rgba(0, 0, 0, 0.05);
  border: 1px solid rgba(200, 22, 29, 0.1);
  text-align: center;
  position: relative;
  overflow: hidden;
}

.result-icon {
  font-size: 56px;
  margin-bottom: var(--spacing-md);
  animation: celebrate 0.6s ease-out;
}

@keyframes celebrate {
  0% {
    transform: scale(0) rotate(-180deg);
  }
  50% {
    transform: scale(1.2) rotate(10deg);
  }
  100% {
    transform: scale(1) rotate(0deg);
  }
}

.result-title {
  font-size: 28px;
  font-weight: bold;
  background: linear-gradient(135deg, var(--primary-color), #ff6b6b);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: var(--spacing-lg);
}

.portrait-box {
  background: linear-gradient(135deg, var(--primary-color) 0%, #ff6b6b 50%, var(--secondary-color) 100%);
  border-radius: 20px;
  padding: var(--spacing-xl);
  margin-bottom: var(--spacing-xl);
  box-shadow: 0 8px 24px rgba(200, 22, 29, 0.3);
  position: relative;
  overflow: hidden;
}

.portrait-decoration {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    radial-gradient(circle at 20% 80%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
  pointer-events: none;
}

.portrait-text {
  font-size: 32px;
  font-weight: bold;
  color: white;
  text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.2);
  position: relative;
  z-index: 1;
}

.recommendations {
  margin-bottom: var(--spacing-xl);
}

.recommend-title {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-color);
  margin-bottom: var(--spacing-lg);
}

.food-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: var(--spacing-md);
}

.food-item {
  background: linear-gradient(135deg, #fff 0%, #fef5e7 100%);
  border: 2px solid #ffeaa7;
  border-radius: 16px;
  padding: var(--spacing-md);
  display: flex;
  flex-direction: column;
  align-items: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.food-item:hover {
  transform: translateY(-4px) scale(1.05);
  box-shadow: 0 8px 20px rgba(255, 179, 71, 0.3);
  border-color: var(--primary-color);
}

.food-icon {
  font-size: 32px;
  margin-bottom: var(--spacing-sm);
}

.food-name {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-color);
}

.result-actions {
  margin-top: var(--spacing-lg);
  display: flex;
  gap: var(--spacing-md);
  justify-content: center;
  flex-wrap: wrap;
}

.poster-btn {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border: none;
  color: white;
  padding: var(--spacing-md) var(--spacing-xl);
  border-radius: 50px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.poster-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.5);
}

.reset-btn {
  background: linear-gradient(135deg, var(--primary-color), #ff6b6b);
  border: none;
  color: white;
  padding: var(--spacing-md) var(--spacing-xl);
  border-radius: 50px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 12px rgba(200, 22, 29, 0.3);
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.reset-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(200, 22, 29, 0.4);
}

.reset-btn:active {
  transform: translateY(0);
}

/* 海报弹窗 */
.poster-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: var(--spacing-lg);
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.poster-content {
  background: linear-gradient(135deg, #fef5e7 0%, #fff5e6 50%, #ffeaa7 100%);
  border-radius: 24px;
  padding: var(--spacing-xl);
  max-width: 500px;
  width: 100%;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  position: relative;
  overflow: hidden;
}

.poster-content::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: 
    radial-gradient(circle at 20% 30%, rgba(200, 22, 29, 0.08) 0%, transparent 40%),
    radial-gradient(circle at 80% 70%, rgba(212, 175, 55, 0.08) 0%, transparent 40%);
  pointer-events: none;
}

.poster-header {
  text-align: center;
  margin-bottom: var(--spacing-lg);
  position: relative;
  z-index: 1;
}

.poster-logo {
  font-size: 48px;
  margin-bottom: var(--spacing-sm);
}

.poster-title {
  font-size: 24px;
  font-weight: bold;
  background: linear-gradient(135deg, var(--primary-color), #ff6b6b);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 0;
}

.poster-divider {
  height: 3px;
  background: linear-gradient(90deg, transparent, var(--primary-color), var(--secondary-color), transparent);
  margin: var(--spacing-lg) 0;
  border-radius: 2px;
}

.poster-body {
  position: relative;
  z-index: 1;
}

.poster-portrait-box {
  background: linear-gradient(135deg, var(--primary-color) 0%, #ff6b6b 50%, var(--secondary-color) 100%);
  border-radius: 20px;
  padding: var(--spacing-xl);
  margin-bottom: var(--spacing-xl);
  text-align: center;
  box-shadow: 0 8px 24px rgba(200, 22, 29, 0.3);
  position: relative;
  overflow: hidden;
}

.poster-portrait-box::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    radial-gradient(circle at 20% 80%, rgba(255, 255, 255, 0.15) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.15) 0%, transparent 50%);
  pointer-events: none;
}

.poster-portrait-text {
  font-size: 28px;
  font-weight: bold;
  color: white;
  text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.3);
  position: relative;
  z-index: 1;
}

.poster-recommendations {
  margin-bottom: var(--spacing-lg);
}

.poster-recommend-title {
  font-size: 18px;
  font-weight: 700;
  color: var(--text-color);
  margin-bottom: var(--spacing-md);
  text-align: center;
}

.poster-food-list {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.poster-food-item {
  background: rgba(255, 255, 255, 0.9);
  border: 2px solid #ffeaa7;
  border-radius: 12px;
  padding: var(--spacing-md);
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  transition: all 0.3s ease;
}

.poster-food-icon {
  font-size: 24px;
}

.poster-food-name {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-color);
}

.poster-footer {
  text-align: center;
  margin-top: var(--spacing-lg);
  padding-top: var(--spacing-lg);
  border-top: 1px dashed rgba(200, 22, 29, 0.2);
  position: relative;
  z-index: 1;
}

.poster-quote {
  font-size: 14px;
  color: var(--text-light);
  font-style: italic;
  margin: 0 0 var(--spacing-sm) 0;
}

.poster-date {
  font-size: 13px;
  color: var(--text-lighter);
  margin: 0;
}

.poster-modal-actions {
  margin-top: var(--spacing-lg);
  display: flex;
  gap: var(--spacing-md);
  justify-content: center;
}

.download-btn {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border: none;
  color: white;
  padding: var(--spacing-sm) var(--spacing-xl);
  border-radius: 50px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.download-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.5);
}

.close-btn {
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  padding: var(--spacing-sm) var(--spacing-lg);
  border-radius: 50px;
  font-size: 15px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.close-btn:hover {
  background: rgba(255, 255, 255, 0.3);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .back-btn {
    top: var(--spacing-sm);
    left: var(--spacing-sm);
    padding: 6px 12px;
    font-size: 12px;
  }
  
  .test-title {
    font-size: 28px;
  }
  
  .test-subtitle {
    font-size: 16px;
  }
  
  .header-icon {
    font-size: 48px;
  }
  
  .question-card {
    padding: var(--spacing-lg);
    border-radius: 20px;
  }
  
  .question-text {
    font-size: 20px;
  }
  
  .options {
    grid-template-columns: 1fr;
  }
  
  .portrait-text {
    font-size: 24px;
  }
  
  .food-list {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .result-card {
    padding: var(--spacing-lg);
  }
}
</style>
