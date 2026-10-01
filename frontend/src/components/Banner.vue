<template>
  <section class="banner">
    <div class="banner-images">
      <div class="banner-track">
        <img v-for="(img, index) in images" :key="index" :src="img" :alt="`banner-${index}`" class="banner-img" />
      </div>
    </div>
    <div class="banner-content">
      <h1>{{ title }}</h1>
      <p v-if="description">{{ description }}</p>
      <slot v-if="$slots.default"></slot>
    </div>
  </section>
</template>

<script setup lang="ts">
defineProps({
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    default: ''
  },
  images: {
    type: Array as () => string[],
    default: () => [
      '/images/banner-1.jpg',
      '/images/banner-2.jpg',
      '/images/banner-3.jpg',
      '/images/banner-4.jpg'
    ]
  }
})
</script>

<style scoped>
.banner {
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.1) 0%, rgba(255, 149, 0, 0.1) 100%);
  padding: 80px 0;
  text-align: center;
  position: relative;
  overflow: hidden;
  border-radius: 0 0 50px 50px;
  margin-bottom: 40px;
}

.banner-images {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow: hidden;
  z-index: 0;
}

.banner-track {
  display: flex;
  height: 100%;
  animation: slideRightToLeft 45s linear infinite;
}

.banner-img {
  height: 350px;
  width: auto;
  object-fit: cover;
  flex-shrink: 0;
  opacity: 0.4;
}

.banner-content {
  position: relative;
  z-index: 1;
  animation: fadeIn 1s ease-out;
}

.banner-content h1 {
  font-size: 48px;
  color: var(--text-color);
  margin-bottom: 16px;
  font-weight: 700;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
}

.banner-content p {
  font-size: 20px;
  color: var(--text-light);
  margin-bottom: 24px;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

@media (max-width: 768px) {
  .banner-content h1 {
    font-size: 36px;
  }
  
  .banner-content p {
    font-size: 18px;
  }
}

@media (max-width: 480px) {
  .banner-content h1 {
    font-size: 28px;
  }
  
  .banner-content p {
    font-size: 16px;
  }
}

/* 动画效果 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideRightToLeft {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(-50%);
  }
}
</style>