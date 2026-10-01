<template>
  <div class="food-card" @click="handleClick">
    <div class="card-image-wrapper">
      <img
        :src="imageUrl"
        :alt="name"
        class="food-img"
        loading="lazy"
      />

      <!-- 图片遮罩层 -->
      <div class="image-overlay">
        <div class="overlay-content">
          <span class="view-detail">查看详情 →</span>
        </div>
      </div>

      <!-- 非遗级别徽章 -->
      <div v-if="heritageLevel" class="item-badge badge-heritage">
        <span class="badge-icon">🏆</span>
        <span class="badge-level">{{ heritageLevel }}</span>
      </div>

      <!-- 收藏按钮 -->
      <button
        v-if="showFavorite"
        class="favorite-btn"
        @click.stop="$emit('favorite', id)"
      >
        <span class="heart-icon">{{ isFavorited ? '❤️' : '♡' }}</span>
      </button>

      <!-- 自定义插槽（额外覆盖层） -->
      <slot name="overlay"></slot>
    </div>

    <div class="food-info">
      <div class="info-header">
        <h3>{{ name }}</h3>
        <div v-if="region" class="info-region">{{ region }}</div>
      </div>

      <div class="food-meta" v-if="taste || $slots.meta">
        <slot name="meta">
          <span v-if="taste" class="food-taste tag">
            <span class="taste-icon">🌶️</span>
            {{ taste }}
          </span>
        </slot>
      </div>

      <div class="food-footer">
        <div class="food-rating">
          <div class="rating-section">
            <span class="rating-stars">★★★★★</span>
            <span class="rating-value">{{ averageScore || '5.0' }}</span>
          </div>
          <div class="extra-info" v-if="collectionCount || viewCount || $slots.extraInfo">
            <slot name="extraInfo">
              <span v-if="collectionCount" class="collection-info">
                <span class="collection-icon">♥</span>
                {{ collectionCount }}
              </span>
              <span v-if="viewCount" class="view-info">
                <span class="view-icon">👁️</span>
                {{ viewCount }}
              </span>
            </slot>
          </div>
        </div>
      </div>
    </div>

    <!-- 卡片底部装饰 -->
    <div class="card-decoration">
      <div class="deco-pattern"></div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { getFoodImageUrl, DEFAULT_FOOD_IMAGE } from '../utils/imageHelper'

interface Props {
  id: number | string
  name: string
  coverImage?: string | null
  region?: string
  taste?: string
  heritageLevel?: string
  averageScore?: number | null
  collectionCount?: number | null
  viewCount?: number | null
  showFavorite?: boolean
  isFavorited?: boolean
  routePath?: string
}

const props = withDefaults(defineProps<Props>(), {
  coverImage: null,
  region: '',
  taste: '',
  heritageLevel: '',
  averageScore: null,
  collectionCount: null,
  viewCount: null,
  showFavorite: false,
  isFavorited: false,
  routePath: ''
})

const emit = defineEmits<{
  (e: 'click', id: number | string): void
  (e: 'favorite', id: number | string): void
}>()

const router = useRouter()

const imageUrl = computed(() =>
  getFoodImageUrl(props.coverImage, DEFAULT_FOOD_IMAGE)
)

const handleClick = () => {
  emit('click', props.id)

  if (props.routePath) {
    router.push(props.routePath)
  }
}
</script>

<style scoped>
.food-card {
  background: linear-gradient(145deg, #ffffff, #fafafa);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
  border: 1px solid var(--border-gold);
  position: relative;
  cursor: pointer;
}

.food-card::before {
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

.food-card:hover::before {
  opacity: 1;
}

.food-card:hover {
  transform: translateY(-8px) scale(1.01);
  box-shadow: var(--shadow-lg);
  border-color: var(--border-gold-hover);
}

.card-image-wrapper {
  position: relative;
  overflow: hidden;
  height: 220px;
}

.food-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

.food-card:hover .food-img {
  transform: scale(1.12);
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, rgba(200, 22, 29, 0.7), rgba(168, 19, 26, 0.85));
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.4s ease;
  z-index: 1;
}

.food-card:hover .image-overlay {
  opacity: 1;
}

.overlay-content {
  text-align: center;
}

.view-detail {
  color: white;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 2px;
  padding: 12px 28px;
  border: 2px solid rgba(255, 255, 255, 0.8);
  border-radius: 30px;
  display: inline-block;
  transition: all 0.3s ease;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
}

.view-detail:hover {
  background: white;
  color: var(--primary-color);
  transform: scale(1.05);
}

.item-badge {
  position: absolute;
  top: 14px;
  right: 14px;
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 5px;
  z-index: 2;
  letter-spacing: 1px;
}

.badge-heritage {
  background: linear-gradient(135deg, var(--primary-color), #a8131a);
  color: white;
  box-shadow: 0 4px 16px rgba(200, 22, 29, 0.4);
}

.badge-icon { font-size: 14px; }

.favorite-btn {
  position: absolute;
  top: 14px;
  left: 14px;
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.95);
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  z-index: 2;
  opacity: 0;
  transform: translateX(-10px);
}

.food-card:hover .favorite-btn {
  opacity: 1;
  transform: translateX(0);
}

.favorite-btn:hover {
  background: var(--primary-color);
  transform: scale(1.1) !important;
}

.favorite-btn:hover .heart-icon {
  color: white;
}

.heart-icon {
  font-size: 18px;
  color: var(--text-light);
  transition: color 0.3s ease;
}

.food-info {
  padding: 20px;
}

.info-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 12px;
}

.info-header h3 {
  font-size: 20px;
  margin: 0;
  color: var(--text-color);
  transition: color 0.3s ease;
  font-weight: 700;
  letter-spacing: 1px;
  flex: 1;
}

.food-card:hover .info-header h3 {
  color: var(--primary-color);
}

.info-region {
  font-size: 12px;
  color: white;
  background: linear-gradient(135deg, var(--secondary-color), #b8860b);
  padding: 4px 12px;
  border-radius: 12px;
  font-weight: 600;
  white-space: nowrap;
  margin-left: 10px;
}

.food-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 16px;
}

.tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.06), rgba(212, 175, 55, 0.06));
  border: 1px solid var(--border-gold);
  border-radius: 12px;
  font-size: 13px;
  color: var(--text-light);
  font-weight: 500;
  transition: all 0.3s ease;
}

.taste-icon { font-size: 14px; }

.food-footer {
  padding-top: 14px;
  border-top: 1.5px dashed rgba(212, 175, 55, 0.2);
}

.food-rating {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.rating-section {
  display: flex;
  align-items: center;
  gap: 8px;
}

.rating-stars {
  color: var(--secondary-color);
  font-size: 14px;
  letter-spacing: 2px;
}

.rating-value {
  font-size: 18px;
  font-weight: 800;
  color: var(--secondary-color);
}

.extra-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.collection-info,
.view-info {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 14px;
  color: var(--text-lighter);
  font-weight: 500;
}

.collection-icon {
  color: var(--primary-color);
  font-size: 16px;
}

.view-icon { font-size: 14px; }

.card-decoration {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, transparent, var(--secondary-color), transparent);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.food-card:hover .card-decoration {
  opacity: 1;
}

.deco-pattern {
  height: 100%;
  background: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 4px,
    rgba(212, 175, 55, 0.3) 4px,
    rgba(212, 175, 55, 0.3) 8px
  );
}
</style>
