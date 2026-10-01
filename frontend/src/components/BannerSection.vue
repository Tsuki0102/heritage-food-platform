<template>
  <section class="banner-section">
    <!-- 背景纹理 -->
    <div class="banner-bg-pattern"></div>

    <!-- 传统纹样装饰 -->
    <div class="chinese-patterns">
      <div class="pattern pattern-top-left">☯</div>
      <div class="pattern pattern-top-right">卍</div>
      <div class="pattern pattern-bottom-left">☰</div>
      <div class="pattern pattern-bottom-right">☱</div>
    </div>

    <!-- 滚动背景图 -->
    <div class="banner-images">
      <div class="banner-track" :style="{ animationDuration: `${duration}s` }">
        <img
          v-for="(img, index) in displayImages"
          :key="index"
          :src="img"
          :alt="`banner-${index}`"
          class="banner-img"
        />
      </div>
    </div>

    <!-- 装饰元素 -->
    <div class="banner-decoration">
      <div class="decoration-item left">❋</div>
      <div class="decoration-item right">❋</div>
      <div class="lantern left-lantern">🏮</div>
      <div class="lantern right-lantern">🏮</div>
    </div>

    <!-- 内容区域 -->
    <div class="banner-content">
      <!-- 徽章 -->
      <div v-if="badge" class="content-badge">
        <span class="badge-icon">{{ badgeIcon }}</span>
        <span class="badge-text">{{ badge }}</span>
      </div>

      <!-- 标题 -->
      <h1>{{ title }}</h1>

      <!-- 副标题/描述 -->
      <p v-if="subtitle">{{ subtitle }}</p>

      <!-- 自定义插槽内容 -->
      <slot name="extra"></slot>

      <!-- 装饰性分隔线 -->
      <div v-if="showDivider" class="ornamental-divider">
        <span class="divider-line"></span>
        <span class="divider-symbol">✦</span>
        <span class="divider-line"></span>
      </div>
    </div>

    <!-- 底部波浪装饰 -->
    <div class="wave-decoration">
      <svg viewBox="0 0 1200 120" preserveAspectRatio="none">
        <path d="M0,60 C150,100 350,20 600,60 C850,100 1050,20 1200,60 L1200,120 L0,120 Z"
              fill="var(--bg-color)" opacity="0.3"/>
        <path d="M0,80 C200,110 400,50 600,80 C800,110 1000,50 1200,80 L1200,120 L0,120 Z"
              fill="var(--bg-color)"/>
      </svg>
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { DEFAULT_BANNER_IMAGES, getBannerImages } from '../utils/imageHelper'

interface Props {
  title: string
  subtitle?: string
  badge?: string
  badgeIcon?: string
  images?: string[]
  duration?: number
  showDivider?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  subtitle: '',
  badge: '',
  badgeIcon: '🏛️',
  images: () => DEFAULT_BANNER_IMAGES,
  duration: 120,
  showDivider: true
})

const displayImages = computed(() => getBannerImages(props.images))
</script>

<style scoped>
.banner-section {
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.08) 0%, rgba(212, 175, 55, 0.08) 100%);
  padding: 80px 0 100px;
  text-align: center;
  position: relative;
  overflow: hidden;
  border-radius: 0 0 var(--radius-xxl, 60px) var(--radius-xxl, 60px);
  margin-bottom: 40px;
  box-shadow: 0 8px 32px rgba(200, 22, 29, 0.1);
}

.banner-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 6px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

.banner-bg-pattern {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image:
    radial-gradient(circle at 20% 30%, rgba(212, 175, 55, 0.15) 0%, transparent 50%),
    radial-gradient(circle at 80% 70%, rgba(200, 22, 29, 0.1) 0%, transparent 50%),
    repeating-linear-gradient(45deg, transparent, transparent 10px, rgba(212, 175, 55, 0.03) 10px, rgba(212, 175, 55, 0.03) 20px);
  z-index: 0;
}

.chinese-patterns {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
  z-index: 1;
}

.pattern {
  position: absolute;
  font-size: 48px;
  opacity: 0.06;
  color: var(--secondary-color);
  animation: patternFloat 6s ease-in-out infinite;
}

.pattern-top-left { top: 10%; left: 5%; }
.pattern-top-right { top: 10%; right: 5%; animation-delay: 1.5s; }
.pattern-bottom-left { bottom: 15%; left: 8%; animation-delay: 3s; }
.pattern-bottom-right { bottom: 15%; right: 8%; animation-delay: 4.5s; }

.banner-images {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow: hidden;
  z-index: 0;
  pointer-events: none;
}

.banner-track {
  display: flex;
  height: 100%;
  width: max-content;
  animation: slideRightToLeft linear infinite;
  will-change: transform;
}

.banner-img {
  height: 380px;
  width: auto;
  object-fit: cover;
  flex-shrink: 0;
  opacity: 0.25;
  filter: blur(1px);
}

.banner-decoration {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
  z-index: 1;
}

.decoration-item {
  position: absolute;
  font-size: 28px;
  color: var(--secondary-color);
  opacity: 0.35;
  animation: float 3s ease-in-out infinite;
}

.decoration-item.left { left: 8%; top: 28%; }
.decoration-item.right { right: 8%; bottom: 32%; animation-delay: 1.5s; }

.lantern {
  position: absolute;
  font-size: 36px;
  opacity: 0.2;
  animation: lanternSwing 4s ease-in-out infinite;
}

.left-lantern { left: 15%; top: 12%; }
.right-lantern { right: 15%; top: 12%; animation-delay: 2s; }

.banner-content {
  position: relative;
  z-index: 2;
  animation: fadeIn 1.2s ease-out;
}

.content-badge {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  background: linear-gradient(135deg, var(--primary-color), #c81e1e, #a8131a);
  color: white;
  padding: 10px 24px;
  border-radius: 25px;
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 20px;
  box-shadow: 0 6px 20px rgba(200, 22, 29, 0.35), inset 0 1px 0 rgba(255,255,255,0.2);
  letter-spacing: 2px;
}

.badge-icon { font-size: 20px; }

.banner-content h1 {
  font-size: 48px;
  color: var(--text-color);
  margin-bottom: 16px;
  font-weight: 800;
  letter-spacing: 6px;
  text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.08);
  background: linear-gradient(135deg, var(--text-color), var(--primary-color));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.banner-content p {
  font-size: 18px;
  color: var(--text-light);
  max-width: 650px;
  margin: 0 auto 24px;
  line-height: 1.6;
}

.ornamental-divider {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
  margin-top: 8px;
}

.divider-line {
  width: 80px;
  height: 2px;
  background: linear-gradient(90deg, transparent, var(--secondary-color), transparent);
}

.divider-symbol {
  font-size: 18px;
  color: var(--secondary-color);
  animation: pulse 2s ease-in-out infinite;
}

.wave-decoration {
  position: absolute;
  bottom: -2px;
  left: 0;
  right: 0;
  height: 80px;
  z-index: 1;
}

.wave-decoration svg {
  width: 100%;
  height: 100%;
  display: block;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes slideRightToLeft {
  0% { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-12px); }
}

@keyframes pulse {
  0%, 100% { opacity: 0.6; transform: scale(1); }
  50% { opacity: 1; transform: scale(1.15); }
}

@keyframes patternFloat {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-15px) rotate(10deg); }
}

@keyframes lanternSwing {
  0%, 100% { transform: rotate(-5deg); }
  50% { transform: rotate(5deg); }
}
</style>
