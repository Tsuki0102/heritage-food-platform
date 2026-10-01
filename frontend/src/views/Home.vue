<template>
  <div class="home">
    <!-- 左侧非遗文化装饰带 -->
    <div class="heritage-decoration-left">
      <div class="deco-column deco-left-1">
        <span class="deco-symbol symbol-cloud">☁</span>
        <span class="deco-symbol symbol-bamboo">🎋</span>
        <span class="deco-symbol symbol-lantern">🏮</span>
        <span class="deco-symbol symbol-fan">🪭</span>
      </div>
      <div class="deco-column deco-left-2">
        <span class="deco-pattern pattern-spiral">❋</span>
        <span class="deco-pattern pattern-circle">◉</span>
        <span class="deco-symbol symbol-tea">🍵</span>
        <span class="deco-symbol symbol-rice">🌾</span>
      </div>
      <div class="deco-vertical-text">千年传承</div>
    </div>

    <!-- 右侧传统工艺装饰带 -->
    <div class="heritage-decoration-right">
      <div class="deco-column deco-right-1">
        <span class="deco-symbol symbol-pot">🫖</span>
        <span class="deco-symbol symbol-chopsticks">🥢</span>
        <span class="deco-symbol symbol-dumpling">🥟</span>
        <span class="deco-symbol symbol-noodle">🍜</span>
      </div>
      <div class="deco-column deco-right-2">
        <span class="deco-pattern pattern-diamond">◆</span>
        <span class="deco-symbol symbol-spice">🌶️</span>
        <span class="deco-symbol symbol-wine">🍶</span>
        <span class="deco-pattern pattern-star">✦</span>
      </div>
      <div class="deco-vertical-text">匠心独运</div>
    </div>

    <Header />

    <section class="banner banner-section">
      <div class="banner-bg-pattern"></div>
      <div class="chinese-patterns">
        <div class="pattern pattern-top-left">☯</div>
        <div class="pattern pattern-top-right">卍</div>
        <div class="pattern pattern-bottom-left">☰</div>
        <div class="pattern pattern-bottom-right">☱</div>
      </div>

      <div class="banner-images">
        <div class="banner-track" :key="bannerKey">
          <img v-for="(img, index) in getBannerImages()" :key="index" :src="img" :alt="`banner-${index}`" class="banner-img" />
        </div>
      </div>

      <div class="banner-decoration">
        <div class="decoration-item left">❋</div>
        <div class="decoration-item right">❋</div>
        <div class="lantern left-lantern">🏮</div>
        <div class="lantern right-lantern">🏮</div>
      </div>

      <div class="banner-content">
        <div class="banner-badge">
          <span class="badge-icon">🏛️</span>
          <span class="badge-text">非物质文化遗产</span>
        </div>
        <h1>探索非遗美食文化</h1>
        <p>传承中华传统美食，体验地道风味</p>

        <!-- 修复：搜索框 + 点击搜索 -->
        <div class="search-box">
          <input 
            type="text" 
            v-model="searchKeyword" 
            placeholder="搜索美食、店铺..." 
            @keyup.enter="handleSearch"
          />
          <button class="search-btn btn-primary" @click="handleSearch">
            <span class="btn-icon">🔎</span>
            搜索
          </button>
        </div>

        <div class="ornamental-divider">
          <span class="divider-line"></span>
          <span class="divider-symbol">✦</span>
          <span class="divider-line"></span>
        </div>
      </div>

      <div class="wave-decoration">
        <svg viewBox="0 0 1200 120" preserveAspectRatio="none">
          <path d="M0,60 C150,100 350,20 600,60 C850,100 1050,20 1200,60 L1200,120 L0,120 Z" fill="var(--bg-color)" opacity="0.3"/>
          <path d="M0,80 C200,110 400,50 600,80 C800,110 1000,50 1200,80 L1200,120 L0,120 Z" fill="var(--bg-color)"/>
        </svg>
      </div>
    </section>

    <section class="recommend">
      <div class="container">
        <div class="page-header">
          <div class="page-title-decoration left">
            <span class="page-title-line"></span>
            <span class="page-title-dot">◆</span>
          </div>
          <h2 class="page-title">
            <span class="title-icon">💝</span>
            猜你喜欢
            <span class="title-icon">🥢</span>
          </h2>
          <div class="page-title-decoration right">
            <span class="page-title-dot">◆</span>
            <span class="page-title-line right"></span>
          </div>
        </div>

        <div class="food-list grid grid-auto">
          <div class="card food-item" v-for="food in foodList" :key="food.id" @click="navigateToFoodDetail(food.id)">
            <div class="item-image-wrapper">
              <img :src="`/images/${food.coverImage ? (food.coverImage.includes('.') ? food.coverImage : food.coverImage.replace(/jpg$/, '.jpg')) : 'beijing-duck.jpg'}`" :alt="food.name" class="food-img" loading="lazy"/>

              <div class="image-overlay">
                <div class="overlay-content">
                  <span class="view-detail">查看详情 →</span>
                </div>
              </div>

              <button class="favorite-btn">
                <span class="heart-icon">♡</span>
              </button>
            </div>

            <div class="food-info">
              <div class="info-header">
                <h3>{{ food.name }}</h3>
                <div class="info-region">{{ food.region }}</div>
              </div>

              <div class="food-meta">
                <span class="food-taste tag">
                  <span class="taste-icon">🌶️</span>
                  {{ food.taste }}
                </span>
              </div>

              <div class="food-footer">
                <div class="food-rating">
                  <div class="rating-section">
                    <span class="rating-stars">★★★★★</span>
                    <span class="rating-value">{{ food.averageScore }}</span>
                  </div>
                  <div class="collection-info">
                    <span class="collection-icon">♥</span>
                    <span>{{ food.collectionCount }}</span>
                  </div>
                </div>
              </div>
            </div>

            <div class="card-decoration">
              <div class="deco-pattern"></div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="hot">
      <div class="container">
        <div class="page-header">
          <div class="page-title-decoration left">
            <span class="page-title-line"></span>
            <span class="page-title-dot">◆</span>
          </div>
          <h2 class="page-title">
            <span class="title-icon">🔥</span>
            热门美食
            <span class="title-icon">⭐</span>
          </h2>
          <div class="page-title-decoration right">
            <span class="page-title-dot">◆</span>
            <span class="page-title-line right"></span>
          </div>
        </div>

        <div class="food-list grid grid-auto">
          <div class="card food-item" v-for="food in hotFoodList" :key="food.id" @click="navigateToFoodDetail(food.id)">
            <div class="item-image-wrapper">
              <img :src="`/images/${food.coverImage ? (food.coverImage.includes('.') ? food.coverImage : food.coverImage.replace(/jpg$/, '.jpg')) : 'beijing-duck.jpg'}`" :alt="food.name" class="food-img" loading="lazy"/>

              <div class="image-overlay">
                <div class="overlay-content">
                  <span class="view-detail">查看详情 →</span>
                </div>
              </div>

              <button class="favorite-btn">
                <span class="heart-icon">♡</span>
              </button>
            </div>

            <div class="food-info">
              <div class="info-header">
                <h3>{{ food.name }}</h3>
                <div class="info-region">{{ food.region }}</div>
              </div>

              <div class="food-meta">
                <span class="food-taste tag">
                  <span class="taste-icon">🌶️</span>
                  {{ food.taste }}
                </span>
              </div>

              <div class="food-footer">
                <div class="food-rating">
                  <div class="rating-section">
                    <span class="rating-stars">★★★★★</span>
                    <span class="rating-value">{{ food.averageScore }}</span>
                  </div>
                  <div class="view-info">
                    <span class="view-icon">👁️</span>
                    <span>{{ food.viewCount }}</span>
                  </div>
                </div>
              </div>
            </div>

            <div class="card-decoration">
              <div class="deco-pattern"></div>
            </div>
          </div>
        </div>

        <div class="more-foods">
          <button class="more-btn btn btn-primary" @click="navigateToFoodList">
            查看更多美食
            <span style="margin-left: 6px;">→</span>
          </button>
        </div>
      </div>
    </section>

    <section class="nearby">
      <div class="container">
        <div class="page-header">
          <div class="page-title-decoration left">
            <span class="page-title-line"></span>
            <span class="page-title-dot">◆</span>
          </div>
          <h2 class="page-title">
            <span class="title-icon">🏪</span>
            知名老字号
            <span class="title-icon">📜</span>
          </h2>
          <div class="page-title-decoration right">
            <span class="page-title-dot">◆</span>
            <span class="page-title-line right"></span>
          </div>
        </div>

        <div class="store-list grid grid-cols-3">
          <div class="card store-item" v-for="store in storeList" :key="store.id" @click="navigateToStoreDetail(store.id)">
            <div class="store-content">
              <div class="store-header">
                <div class="store-icon">🏮</div>
                <h3>{{ store.name }}</h3>
              </div>

              <div class="store-details">
                <p class="store-address">
                  <span class="detail-icon">📍</span>
                  {{ store.address }}
                </p>
                <p class="store-hours">
                  <span class="detail-icon">⏰</span>
                  {{ store.openingHours }}
                </p>
              </div>

              <div class="store-footer">
                <div class="store-rating">
                  <span class="rating-stars">★★★★★</span>
                  <span class="rating-value">{{ store.score }}</span>
                </div>
              </div>
            </div>

            <div class="card-decoration">
              <div class="deco-pattern"></div>
            </div>
          </div>
        </div>

        <div class="more-stores">
          <button class="more-btn btn btn-primary" @click="navigateToStoreList">
            查看更多店铺
            <span style="margin-left: 6px;">→</span>
          </button>
        </div>
      </div>
    </section>

    <section class="food-talk">
      <div class="container">
        <div class="page-header">
          <div class="page-title-decoration left">
            <span class="page-title-line"></span>
            <span class="page-title-dot">◆</span>
          </div>
          <h2 class="page-title food-talk-title">
            <span class="title-icon">📖</span>
            食话食说
            <span class="title-icon">🍵</span>
          </h2>
          <div class="page-title-decoration right">
            <span class="page-title-dot">◆</span>
            <span class="page-title-line right"></span>
          </div>
        </div>

        <div class="food-talk-content">
          <!-- 左侧：美食养生知识 -->
          <div class="food-talk-left">
            <!-- 美食搭配卡片 -->
            <div class="talk-card talk-card-primary">
              <div class="talk-card-header">
                <span class="card-icon">🍽️</span>
                <h4>美食搭配</h4>
                <span class="card-badge">5篇</span>
              </div>
              <ul class="talk-list">
                <li><span class="list-num">01</span><span class="list-text">北京烤鸭搭配荷叶饼，解腻又健康</span></li>
                <li><span class="list-num">02</span><span class="list-text">广式早茶中的点心，营养均衡搭配</span></li>
                <li><span class="list-num">03</span><span class="list-text">苏州糕团的天然食材，养生又美味</span></li>
                <li><span class="list-num">04</span><span class="list-text">上海小笼包的汤汁，滋补又暖胃</span></li>
                <li><span class="list-num">05</span><span class="list-text">郑州烩面的骨汤，营养丰富</span></li>
              </ul>
            </div>

            <!-- 孕期饮食卡片 -->
            <div class="talk-card talk-card-success">
              <div class="talk-card-header">
                <span class="card-icon">🤰</span>
                <h4>孕期饮食</h4>
                <span class="card-badge success">5篇</span>
              </div>
              <ul class="talk-list">
                <li><span class="list-num">01</span><span class="list-text">关注孕期饮食 每周各有重点</span></li>
                <li><span class="list-num">02</span><span class="list-text">孕妇多吃海鱼，减少早产风险</span></li>
                <li><span class="list-num">03</span><span class="list-text">这4种南瓜辅食，宝宝很爱吃的</span></li>
                <li><span class="list-num">04</span><span class="list-text">小孩的肝脾不和，可以吃点麦芽糖</span></li>
                <li><span class="list-num">05</span><span class="list-text">孕期吃西兰花芽，胎儿更健康</span></li>
              </ul>
            </div>

            <!-- 减肥瘦身卡片 -->
            <div class="talk-card">
              <div class="talk-card-header">
                <span class="card-icon">⚖️</span>
                <h4>减脂塑形</h4>
                <span class="card-badge">5篇</span>
              </div>
              <ul class="talk-list">
                <li><span class="list-num">01</span><span class="list-text">喝红酒减肥？当心越减越肥</span></li>
                <li><span class="list-num">02</span><span class="list-text">早上要吃好 高蛋白早餐有助减重</span></li>
                <li><span class="list-num">03</span><span class="list-text">为减肥大口吃肉 这样做有风险</span></li>
                <li><span class="list-num">04</span><span class="list-text">腹部赘肉太多？这些习惯能让你越吃越瘦</span></li>
                <li><span class="list-num">05</span><span class="list-text">"过年肥"带来幸福的烦恼 如何科学减肥</span></li>
              </ul>
            </div>
          </div>

          <!-- 中间：文化核心展示区 -->
          <div class="food-talk-center">
            <div class="center-showcase">
              <div class="showcase-ring">
                <div class="ring-inner">
                  <span class="ring-title">非遗美食</span>
                  <span class="ring-subtitle">四字真言</span>
                </div>
              </div>

              <div class="character-grid">
                <div class="character-item" style="--char-color: var(--primary-color); --char-bg: rgba(200,22,29,0.06);">
                  <div class="character-box">
                    <span class="character-char">食</span>
                  </div>
                  <div class="character-info">
                    <span class="character-name">食疗</span>
                    <span class="character-tag">养生</span>
                  </div>
                </div>

                <div class="character-item" style="--char-color: #228b22; --char-bg: rgba(34,139,34,0.06);">
                  <div class="character-box">
                    <span class="character-char">禁</span>
                  </div>
                  <div class="character-info">
                    <span class="character-name">禁忌</span>
                    <span class="character-tag">常识</span>
                  </div>
                </div>

                <div class="character-item" style="--char-color: var(--secondary-color); --char-bg: rgba(212,175,55,0.08);">
                  <div class="character-box">
                    <span class="character-char">文</span>
                  </div>
                  <div class="character-info">
                    <span class="character-name">文化</span>
                    <span class="character-tag">美食</span>
                  </div>
                </div>

                <div class="character-item" style="--char-color: #e91e63; --char-bg: rgba(233,30,99,0.06);">
                  <div class="character-box">
                    <span class="character-char">美</span>
                  </div>
                  <div class="character-info">
                    <span class="character-name">美颜</span>
                    <span class="character-tag">养肤</span>
                  </div>
                </div>
              </div>

              <div class="center-quote">
                <span class="quote-icon">❝</span>
                <p>千年传承 · 匠心独运 · 味蕾传奇</p>
                <span class="quote-icon">❞</span>
              </div>
            </div>
          </div>

          <!-- 右侧：热门文章列表 -->
          <div class="talk-card food-talk-right">
            <div class="talk-card-header">
              <span class="card-icon">📰</span>
              <h4>热门文章</h4>
              <span class="card-badge hot">16篇</span>
            </div>
            <ul class="talk-list talk-list-compact">
              <li class="list-item-hot"><span class="list-dot"></span><span class="list-text">红豆和牛奶合体，不仅补钙还能护心</span></li>
              <li><span class="list-dot"></span><span class="list-text">哪些食物胆固醇含量高？</span></li>
              <li><span class="list-dot"></span><span class="list-text">西红柿炖豆腐 红色食物们各有养生特长</span></li>
              <li><span class="list-dot"></span><span class="list-text">讨论食品安全之前 先补上科学认知这堂课</span></li>
              <li><span class="list-dot"></span><span class="list-text">身体松软的海鲜不要买</span></li>
              <li><span class="list-dot"></span><span class="list-text">皮肤干，喝莲峰山长生汤</span></li>
              <li><span class="list-dot"></span><span class="list-text">哪些食物改善皮肤干燥</span></li>
              <li><span class="list-dot"></span><span class="list-text">吃的对 比护肤品靠谱！</span></li>
              <li><span class="list-dot"></span><span class="list-text">海底椰炖雪梨 滋阴养肺润肤养颜</span></li>
              <li><span class="list-dot"></span><span class="list-text">头发干燥可能缺啥！快对照症状补营养</span></li>
              <li><span class="list-dot"></span><span class="list-text">冬季养生：红枣枸杞茶的神奇功效</span></li>
              <li><span class="list-dot"></span><span class="list-text">黑芝麻的养生秘密：乌发养肾两相宜</span></li>
              <li><span class="list-dot"></span><span class="list-text">山药健脾益胃，这样吃效果翻倍</span></li>
              <li><span class="list-dot"></span><span class="list-text">蜂蜜水什么时候喝最好？专家告诉你答案</span></li>
              <li><span class="list-dot"></span><span class="list-text">核桃补脑又益智，每日几颗最合适？</span></li>
              <li><span class="list-dot"></span><span class="list-text">银耳莲子羹：平民燕窝的美容秘方</span></li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useFoodStore } from '../stores/foodStore'
import { useStoreStore } from '../stores/storeStore'
import { getFoodList } from '../api/foodApi'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'

const router = useRouter()
const foodStore = useFoodStore()
const storeStore = useStoreStore()

// 修复：搜索关键词
const searchKeyword = ref('')

const bannerImages = [
  '/images/banner-1.jpg',
  '/images/banner-2.jpg',
  '/images/banner-3.jpg',
  '/images/banner-4.jpg'
]

const currentStartIndex = ref(0)
const bannerKey = ref(0)

const getStoredIndex = () => {
  const stored = localStorage.getItem('bannerIndex')
  return stored ? parseInt(stored) : 0
}

const saveIndex = (index: number) => {
  localStorage.setItem('bannerIndex', index.toString())
}

onMounted(() => {
  const lastIndex = getStoredIndex()
  currentStartIndex.value = (lastIndex + 1) % 4
  saveIndex(currentStartIndex.value)
  bannerKey.value++
})

const getBannerImages = () => {
  const images = []
  for (let i = 0; i < 8; i++) {
    const index = (currentStartIndex.value + i) % 4
    images.push(bannerImages[index])
  }
  return images
}

const navigateToFoodDetail = (foodId: number) => {
  router.push(`/food/${foodId}`)
}

const navigateToStoreDetail = (storeId: number) => {
  router.push(`/store/${storeId}`)
}

const navigateToFoodList = () => {
  router.push('/foods')
}

const navigateToStoreList = () => {
  router.push('/stores')
}

// 修复：搜索功能
const handleSearch = () => {
  const keyword = searchKeyword.value.trim()
  if (!keyword) {
    alert('请输入搜索内容')
    return
  }
  // 跳转到美食列表页并携带搜索关键词
  router.push({
    path: '/foods',
    query: { keyword }
  })
}

const foodList = ref<any[]>([])
const hotFoodList = ref<any[]>([])
const storeList = ref<any[]>([])

onMounted(async () => {
  try {
    const res = await getFoodList(1, 9)
    const allFoods = res.records.slice(0, 9)
    foodList.value = allFoods.slice(0, 6)
    hotFoodList.value = allFoods.slice(6)
  } catch (error) {
    console.error('获取美食数据失败:', error)
  }

  try {
    const stores = await storeStore.fetchStoreList(1, 6)
    storeList.value = stores.records.slice(0, 6)
  } catch (error) {
    console.error('获取店铺数据失败:', error)
  }
})
</script>

<style scoped>
.home {
  min-height: 100vh;
  background: var(--gradient-bg);
  position: relative;
  overflow-x: hidden;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 24px;
}

/* ====== 视差滚动层 - 与全局系统一致 ====== */
.parallax-layer,
.parallax-slow,
.parallax-fast {
  transition: transform 0.1s ease-out;
  will-change: transform;
}

/* ====== 横幅区域 - 非遗文化主题增强版 ====== */
.banner {
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.08) 0%, rgba(212, 175, 55, 0.08) 100%);
  padding: 90px 0 110px;
  border-radius: 0 0 var(--radius-xxl) var(--radius-xxl);
  box-shadow:
    0 8px 32px rgba(200, 22, 29, 0.12),
    0 2px 8px rgba(0, 0, 0, 0.06);
  position: relative;
  overflow: hidden;
  transform-style: preserve-3d;
}

.banner::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 6px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
  z-index: 10;
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
  animation: slideRightToLeft 120s linear infinite;
  will-change: transform;
}

.banner-img {
  height: 420px;
  width: auto;
  object-fit: cover;
  flex-shrink: 0;
  opacity: 0.22;
  filter: blur(1.5px) brightness(1.05);
  transition: opacity 0.5s ease;
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
  animation: fadeInUp 1.4s cubic-bezier(0.4, 0, 0.2, 1);
  text-align: center;
  max-width: 880px;
  margin: 0 auto;
  padding: 0 28px;
}

.banner-badge {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  background: linear-gradient(135deg, var(--primary-color), #c81e1e, #a8131a);
  color: white;
  padding: 14px 32px;
  border-radius: 32px;
  font-size: 13.5px;
  font-weight: 700;
  margin-bottom: 28px;
  box-shadow:
    0 8px 28px rgba(200, 22, 29, 0.38),
    inset 0 1px 0 rgba(255,255,255,0.25),
    0 0 0 1px rgba(255,255,255,0.1) inset;
  letter-spacing: 3.5px;
  text-transform: uppercase;
  position: relative;
  overflow: hidden;
  animation: badgePulse 3s ease-in-out infinite;
}

.banner-badge::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.25), transparent);
  animation: shimmerMove 3s ease-in-out infinite;
}

.badge-icon { 
  font-size: 18px; 
  position: relative;
  z-index: 1;
}

.banner-content h1 {
  font-size: clamp(36px, 5.5vw, 60px);
  color: var(--text-color);
  margin-bottom: 24px;
  font-weight: 900;
  letter-spacing: 10px;
  line-height: 1.12;
  text-shadow:
    2px 2px 12px rgba(0, 0, 0, 0.08),
    0 0 50px rgba(200, 22, 29, 0.06),
    0 4px 20px rgba(212, 175, 55, 0.04);
  background: linear-gradient(
    135deg,
    var(--text-color) 0%,
    var(--primary-color) 40%,
    var(--secondary-color) 70%,
    var(--primary-color) 100%
  );
  background-size: 200% auto;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: gradientShift 8s ease infinite;
}

.banner-content p {
  font-size: clamp(16px, 2.2vw, 20px);
  color: var(--text-light);
  margin-bottom: 44px;
  letter-spacing: 5px;
  line-height: 1.75;
  font-weight: 400;
  max-width: 680px;
  margin-left: auto;
  margin-right: auto;
}

.search-box {
  display: flex;
  max-width: 600px;
  margin: 0 auto;
  background: rgba(255, 255, 255, 0.96);
  border-radius: var(--radius-xxl);
  box-shadow:
    0 10px 48px rgba(200, 22, 29, 0.16),
    0 2px 12px rgba(0, 0, 0, 0.08),
    inset 0 1px 0 rgba(255, 255, 255, 0.95),
    0 0 0 1px rgba(212, 175, 55, 0.15) inset;
  overflow: hidden;
  border: 2px solid rgba(212, 175, 55, 0.25);
  backdrop-filter: blur(12px);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.search-box:hover {
  transform: translateY(-6px) scale(1.02);
  box-shadow:
    0 16px 56px rgba(200, 22, 29, 0.22),
    0 6px 20px rgba(212, 175, 55, 0.15),
    inset 0 1px 0 rgba(255, 255, 255, 1),
    0 0 40px rgba(212, 175, 55, 0.08);
  border-color: var(--secondary-color);
}

.search-box:focus-within {
  transform: translateY(-6px) scale(1.02);
  border-color: var(--primary-color);
  box-shadow:
    0 16px 56px rgba(200, 22, 29, 0.25),
    0 6px 24px rgba(200, 22, 29, 0.12),
    0 0 0 4px rgba(200, 22, 29, 0.08);
}

.search-box input {
  flex: 1;
  padding: 20px 32px;
  border: none;
  font-size: 16.5px;
  color: var(--text-color);
  background: transparent;
  letter-spacing: 0.8px;
  font-weight: 400;
}

.search-box input:focus {
  outline: none;
  background: transparent;
}

.search-box input::placeholder {
  color: var(--text-lighter);
  letter-spacing: 1.5px;
  font-weight: 300;
}

.search-btn {
  padding: 18px 36px;
  font-size: 15.5px;
  border-radius: 0 var(--radius-xxl) var(--radius-xxl) 0;
  font-weight: 700;
  letter-spacing: 1.5px;
  transition: all 0.4s cubic-bezier(0.68,-0.55,0.265,1.55);
  position: relative;
  overflow: hidden;
}

.search-btn::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255,255,255,0.25);
  border-radius: 50%;
  transition: all 0.4s ease;
  transform: translate(-50%, -50%);
}

.search-btn:hover::before {
  width: 200px;
  height: 200px;
}

.btn-icon { 
  font-size: 16px; 
  position: relative;
  z-index: 1;
}

.ornamental-divider {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
  margin-top: 12px;
  animation: fadeInUp 1.6s cubic-bezier(0.4, 0, 0.2, 1) 0.3s both;
}

.divider-line {
  width: 100px;
  height: 2.5px;
  background: linear-gradient(90deg, transparent, var(--secondary-color), transparent);
  border-radius: 2px;
  box-shadow: 0 2px 8px rgba(212, 175, 55, 0.15);
}

.divider-symbol {
  font-size: 20px;
  color: var(--secondary-color);
  animation: pulse 2.5s ease-in-out infinite;
  filter: drop-shadow(0 2px 4px rgba(212, 175, 55, 0.3));
}

.wave-decoration {
  position: absolute;
  bottom: -2px;
  left: 0;
  right: 0;
  height: 90px;
  z-index: 1;
  animation: waveFloat 6s ease-in-out infinite;
}

.wave-decoration svg {
  width: 100%;
  height: 100%;
  display: block;
}

/* ====== 页面标题 - 优化间距 ====== */
.page-header {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
  margin-bottom: 36px;
  padding: 22px 0 20px;
  position: relative;
}

.page-header::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 120px;
  height: 3px;
  background: var(--gradient-sunset);
  border-radius: 2px;
  box-shadow: 0 2px 10px rgba(212, 175, 55, 0.2);
}

.page-title {
  font-size: clamp(30px, 4.5vw, 40px);
  color: var(--text-color);
  margin: 0;
  padding: 0;
  border: none;
  text-align: center;
  letter-spacing: 10px;
  font-weight: 900;
  display: flex;
  align-items: center;
  gap: 18px;
  position: relative;
}

.title-icon {
  font-size: clamp(28px, 4vw, 42px);
  animation: iconPulse 3s ease-in-out infinite;
  color: #FF8C00;
  -webkit-text-fill-color: #FF8C00;
  filter: drop-shadow(0 2px 6px rgba(255, 140, 0, 0.35));
  position: relative;
  z-index: 5;
}

.title-icon:last-child {
  animation-delay: 1s;
}

/* 标题两侧装饰图案 - 增强可见性 */
.page-title-decoration {
  display: flex;
  align-items: center;
  gap: 14px;
  position: relative;
  z-index: 10;
}

.page-title-decoration.left {
  margin-right: 12px;
}

.page-title-decoration.right {
  margin-left: 12px;
}

.page-title-line {
  width: 70px;
  height: 3.5px;
  background: linear-gradient(90deg,
    transparent 0%,
    #FF8C00 20%,
    #DAA520 40%,
    #FF6347 60%,
    #FF8C00 80%,
    transparent 100%
  );
  border-radius: 3px;
  box-shadow:
    0 0 10px rgba(255, 140, 0, 0.5),
    0 2px 6px rgba(218, 165, 32, 0.4),
    inset 0 1px 2px rgba(255, 255, 255, 0.5);
  position: relative;
  overflow: hidden;
  flex-shrink: 0;
}

.page-title-line::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 70%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.9), transparent);
  animation: lineShine 3s ease-in-out infinite;
}

@keyframes lineShine {
  0% { left: -100%; }
  50%, 100% { left: 150%; }
}

.page-title-decoration.right .page-title-line {
  background: linear-gradient(90deg,
    transparent 0%,
    #FF8C00 20%,
    #DAA520 40%,
    #FF6347 60%,
    #FF8C00 80%,
    transparent 100%
  );
}

.page-title-dot {
  font-size: 18px;
  color: #FF8C00;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  background: linear-gradient(145deg, #ffffff, #fff8e8);
  border-radius: 50%;
  border: 2.5px solid #FF8C00;
  box-shadow:
    0 0 12px rgba(255, 140, 0, 0.45),
    0 3px 10px rgba(255, 99, 71, 0.25),
    inset 0 1px 3px rgba(255, 255, 255, 0.9);
  animation: dotPulse 4s ease-in-out infinite;
  transition: all 0.4s cubic-bezier(0.68,-0.55,0.265,1.55);
  position: relative;
  z-index: 11;
  flex-shrink: 0;
}

.page-title-dot:hover {
  transform: scale(1.35) rotate(180deg);
  background: linear-gradient(135deg, #FF8C00, #FFA500);
  border-color: #FF6347;
  color: white;
  box-shadow:
    0 0 20px rgba(255, 140, 0, 0.65),
    0 5px 16px rgba(255, 99, 71, 0.4),
    inset 0 1px 3px rgba(255,255,255,0.9);
}

@keyframes dotPulse {
  0%, 100% {
    transform: scale(1);
    box-shadow:
      0 0 12px rgba(255, 140, 0, 0.45),
      0 3px 10px rgba(255, 99, 71, 0.25),
      inset 0 1px 3px rgba(255, 255, 255, 0.9);
  }
  50% {
    transform: scale(1.1);
    box-shadow:
      0 0 22px rgba(255, 140, 0, 0.65),
      0 5px 16px rgba(255, 99, 71, 0.38),
      inset 0 1px 3px rgba(255, 255, 255, 0.95),
      0 0 30px rgba(255, 165, 0, 0.25);
  }
}

.page-title::after {
  display: none;
}

.food-talk-title {
  background: linear-gradient(135deg, var(--text-color), var(--secondary-color));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* ====== 区域通用 - 优化间距减少空白 ====== */
.recommend {
  margin-bottom: 48px;
  padding: 38px 0;
  background: linear-gradient(180deg, rgba(255,255,255,0) 0%, rgba(212,175,55,0.015) 100%);
  border-radius: var(--radius-md);
}

.hot {
  margin-bottom: 48px;
  padding: 38px 0;
  background: linear-gradient(135deg, rgba(200,22,29,0.01), rgba(212,175,55,0.01));
  border-radius: var(--radius-md);
  position: relative;
}

.hot::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
  opacity: 0.3;
}

.nearby {
  margin-bottom: 40px;
  padding: 36px 0;
  background: linear-gradient(135deg, rgba(212,175,55,0.04) 0%, rgba(200,22,29,0.03) 50%, rgba(212,175,55,0.02) 100%);
  border-radius: var(--radius-lg);
  position: relative;
  overflow: hidden;
}

.nearby::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg,
    var(--secondary-color) 0%,
    var(--primary-color) 25%,
    var(--secondary-color) 50%,
    var(--primary-color) 75%,
    var(--secondary-color) 100%
  );
  background-size: 200% 100%;
  animation: gradientSlide 6s linear infinite;
}

.nearby::after {
  content: '百年传承';
  position: absolute;
  top: 20px;
  right: 30px;
  font-size: 80px;
  opacity: 0.03;
  color: var(--primary-color);
  font-weight: 900;
  letter-spacing: 8px;
  pointer-events: none;
  writing-mode: vertical-rl;
}

@keyframes gradientSlide {
  0% { background-position: 0% center; }
  100% { background-position: 200% center; }
}

/* ====== 网格系统 - 优化间距 ====== */
.grid {
  display: grid;
  gap: calc(var(--spacing-lg) + 4px);
}

.grid-auto {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: calc(var(--spacing-lg) + 4px);
}

.grid-cols-3 {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: calc(var(--spacing-lg) + 4px);
}

/* ====== 美食卡片 - 全新视觉设计 ====== */
.card {
  background: #ffffff;
  border-radius: var(--radius-xl);
  box-shadow:
    0 4px 20px rgba(200, 22, 29, 0.08),
    0 1px 4px rgba(0, 0, 0, 0.04),
    0 0 0 1px rgba(212, 175, 55, 0.08) inset;
  transition: all 0.45s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  cursor: pointer;
}

.card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  opacity: 0;
  transition: opacity 0.4s ease;
}

.card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow:
    0 16px 48px rgba(200, 22, 29, 0.18),
    0 6px 24px rgba(212, 175, 55, 0.12),
    0 0 0 1px rgba(212, 175, 55, 0.15) inset;
}

.card:hover::before {
  opacity: 1;
}

.food-list {
  margin-bottom: 36px;
}

.item-image-wrapper {
  position: relative;
  overflow: hidden;
  height: 260px;
  background: linear-gradient(135deg, rgba(200,22,29,0.06), rgba(212,175,55,0.08));
  border-radius: var(--radius-lg) var(--radius-lg) 0 0;
}

.food-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  transition: transform 0.7s cubic-bezier(0.4, 0, 0.2, 1);
  display: block;
}

.card:hover .food-img {
  transform: scale(1.1);
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    to bottom,
    rgba(200, 22, 29, 0.75) 0%,
    rgba(168, 19, 26, 0.88) 100%
  );
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.4s ease;
  z-index: 1;
}

.card:hover .image-overlay {
  opacity: 1;
}

.overlay-content {
  text-align: center;
}

.view-detail {
  color: white;
  font-size: 15px;
  font-weight: 700;
  letter-spacing: 2px;
  padding: 12px 28px;
  border: 2px solid rgba(255, 255, 255, 0.85);
  border-radius: 30px;
  display: inline-block;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  background: rgba(255, 255, 255, 0.12);
  backdrop-filter: blur(10px);
  text-decoration: none;
}

.view-detail:hover {
  background: white;
  color: var(--primary-color);
  transform: scale(1.05);
  box-shadow: 0 4px 16px rgba(255, 255, 255, 0.3);
}

.favorite-btn {
  position: absolute;
  top: 18px;
  left: 18px;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.97);
  border: 2px solid rgba(212, 175, 55, 0.2);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.4s cubic-bezier(0.68,-0.55,0.265,1.55);
  box-shadow:
    0 4px 16px rgba(0, 0, 0, 0.12),
    0 0 24px rgba(212, 175, 55, 0.15),
    inset 0 1px 0 rgba(255,255,255,0.9);
  z-index: 2;
  opacity: 0;
  transform: translateX(-14px) scale(0.8);
}

.card:hover .favorite-btn {
  opacity: 1;
  transform: translateX(0) scale(1);
}

.favorite-btn:hover {
  background: var(--gradient-primary);
  color: white;
  border-color: transparent;
  transform: scale(1.15) !important;
  box-shadow:
    0 8px 28px rgba(200, 22, 29, 0.4),
    0 0 36px rgba(212, 175, 55, 0.25),
    inset 0 1px 0 rgba(255,255,255,0.2);
}

.favorite-btn:hover .heart-icon {
  color: white;
  animation: iconPulse 0.5s ease-out;
  filter: drop-shadow(0 2px 4px rgba(255,255,255,0.3));
}

.heart-icon {
  font-size: 19px;
  color: var(--text-light);
  transition: all 0.35s ease;
}

.food-info {
  padding: 22px 24px;
  background: linear-gradient(180deg, rgba(255,255,255,0) 0%, rgba(212,175,55,0.03) 100%);
}

.info-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 14px;
  gap: 12px;
}

.info-header h3 {
  font-size: clamp(19px, 2.2vw, 23px);
  margin: 0;
  color: var(--text-color);
  transition: color 0.3s ease;
  font-weight: 850;
  letter-spacing: 1.8px;
  line-height: 1.28;
  flex: 1;
}

.card:hover .info-header h3 {
  color: var(--primary-color);
}

.info-region {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 11.5px;
  color: white;
  background: linear-gradient(135deg, var(--secondary-color), #b8860b);
  padding: 6px 15px;
  border-radius: 16px;
  font-weight: 700;
  white-space: nowrap;
  letter-spacing: 0.6px;
  box-shadow: 0 3px 12px rgba(212, 175, 55, 0.3);
  flex-shrink: 0;
}

.food-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 16px;
}

.taste-icon {
  font-size: 15px;
  opacity: 0.85;
}

.food-footer {
  padding-top: 14px;
  border-top: 1.5px dashed rgba(212, 175, 55, 0.25);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.food-rating {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  gap: 16px;
}

.rating-section {
  display: flex;
  align-items: center;
  gap: 8px;
}

.rating-stars {
  color: var(--secondary-color);
  font-size: 15px;
  letter-spacing: 2.5px;
}

.rating-value {
  font-size: 19px;
  font-weight: 900;
  color: var(--secondary-color);
  text-shadow: 0 1px 4px rgba(212, 175, 55, 0.2);
}

.collection-info,
.view-info {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  color: var(--text-lighter);
  font-weight: 500;
  letter-spacing: 0.3px;
}

.collection-icon {
  color: var(--primary-color);
  font-size: 16px;
  transition: transform 0.3s ease;
}

.card:hover .collection-icon {
  transform: scale(1.15) rotate(-10deg);
}

.view-icon { 
  font-size: 14px; 
  opacity: 0.7;
}

.card-decoration {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, transparent, var(--secondary-color), var(--primary-color), var(--secondary-color), transparent);
  opacity: 0;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 0 0 var(--radius-md) var(--radius-md);
}

.card:hover .card-decoration {
  opacity: 1;
  height: 5px;
}

.deco-pattern {
  height: 100%;
  background: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 4px,
    rgba(212, 175, 55, 0.35) 4px,
    rgba(212, 175, 55, 0.35) 8px
  );
  animation: decoSlide 3s linear infinite;
}

/* ====== 更多按钮 - 优化间距 ====== */
.more-foods,
.more-stores {
  text-align: center;
  margin-bottom: 40px;
}

.more-btn {
  padding: 18px 44px;
  font-size: 16.5px;
  border-radius: var(--radius-xxl);
  box-shadow:
    var(--shadow-primary),
    0 0 24px rgba(200, 22, 29, 0.12),
    0 4px 12px rgba(212, 175, 55, 0.08);
  font-weight: 700;
  letter-spacing: 2.5px;
  transition: all 0.4s cubic-bezier(0.68,-0.55,0.265,1.55);
  position: relative;
  overflow: hidden;
}

.more-btn::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255,255,255,0.28);
  border-radius: 50%;
  transition: all 0.5s ease;
  transform: translate(-50%, -50%);
  z-index: 1;
}

.more-btn:hover {
  transform: translateY(-6px) scale(1.05);
  box-shadow:
    0 14px 42px rgba(200, 22, 29, 0.45),
    0 0 36px rgba(212, 175, 55, 0.18),
    0 8px 20px rgba(0, 0, 0, 0.08);
}

.more-btn:hover::before {
  width: 280px;
  height: 280px;
}

/* ====== 店铺列表 - 现代化UI设计 ====== */
.store-list {
  margin-bottom: 24px;
}

.store-content {
  padding: 22px 24px;
  background: linear-gradient(145deg, #ffffff 0%, #fefefe 50%, rgba(255,252,245,0.95) 100%);
  position: relative;
}

.store-content::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(212,175,55,0.3), transparent);
}

.store-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 14px;
  padding-bottom: 12px;
  border-bottom: 2px solid transparent;
  background-image: linear-gradient(to right, var(--secondary-color), var(--secondary-color));
  background-size: 80px 2px;
  background-position: left bottom;
  background-repeat: no-repeat;
  position: relative;
}

.store-icon {
  font-size: 38px;
  width: 62px;
  height: 62px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(145deg, rgba(200, 22, 29, 0.06), rgba(212, 175, 55, 0.1));
  border-radius: var(--radius-xl);
  animation: iconPulse 3s ease-in-out infinite;
  flex-shrink: 0;
  box-shadow:
    0 4px 16px rgba(200, 22, 29, 0.08),
    0 0 0 1px rgba(212, 175, 55, 0.15) inset,
    inset 0 2px 4px rgba(255,255,255,0.9);
  position: relative;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.card:hover .store-icon {
  transform: scale(1.08) rotate(-3deg);
  box-shadow:
    0 8px 24px rgba(200, 22, 29, 0.15),
    0 0 20px rgba(212, 175, 55, 0.12);
}

.store-icon::before {
  content: '';
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  border-radius: calc(var(--radius-xl) + 2px);
  background: conic-gradient(
    from 0deg,
    transparent 0%,
    var(--secondary-color) 10%,
    transparent 20%,
    transparent 80%,
    var(--primary-color) 90%,
    transparent 100%
  );
  opacity: 0;
  transition: opacity 0.5s ease;
  z-index: -1;
  animation: rotateBorder 8s linear infinite;
}

.card:hover .store-icon::before {
  opacity: 0.6;
}

@keyframes rotateBorder {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.store-header h3 {
  font-size: clamp(18px, 2.1vw, 22px);
  margin: 0;
  color: var(--text-color);
  transition: all 0.35s ease;
  font-weight: 850;
  letter-spacing: 1.6px;
  line-height: 1.3;
  flex: 1;
}

.card:hover .store-header h3 {
  color: var(--primary-color);
  text-shadow: 0 2px 8px rgba(200, 22, 29, 0.15);
}

.store-details {
  margin-bottom: 16px;
  padding-left: 2px;
}

.store-address,
.store-hours {
  font-size: 13px;
  color: var(--text-light);
  margin-bottom: 8px;
  display: flex;
  align-items: flex-start;
  gap: 9px;
  line-height: 1.6;
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  padding-left: 4px;
}

.card:hover .store-address,
.card:hover .store-hours {
  color: var(--text-color);
  transform: translateX(3px);
  padding-left: 7px;
}

.detail-icon {
  font-size: 15px;
  opacity: 0.85;
  flex-shrink: 0;
  margin-top: 1px;
  transition: transform 0.3s ease;
}

.card:hover .detail-icon {
  transform: scale(1.15) rotate(-5deg);
}

.store-footer {
  padding-top: 12px;
  border-top: 1.5px dashed rgba(212, 175, 55, 0.25);
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: linear-gradient(to right, transparent, rgba(212,175,55,0.03), transparent);
  margin: 0 -24px;
  padding-left: 24px;
  padding-right: 24px;
}

.store-footer .rating-value {
  font-size: 18px;
  font-weight: 900;
}

.store-rating {
  display: flex;
  align-items: center;
  gap: 10px;
}

.store-rating .rating-stars {
  color: var(--secondary-color);
  font-size: 14.5px;
  letter-spacing: 2.5px;
  filter: drop-shadow(0 1px 2px rgba(212, 175, 55, 0.2));
  transition: all 0.3s ease;
}

.card:hover .store-rating .rating-stars {
  transform: scale(1.05);
  filter: drop-shadow(0 2px 4px rgba(212, 175, 55, 0.35));
}

.store-rating .rating-value {
  font-size: 18px;
  font-weight: 900;
  color: var(--secondary-color);
  text-shadow: 0 1px 4px rgba(212, 175, 55, 0.25);
  background: linear-gradient(135deg, var(--secondary-color), #b8860b);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  transition: all 0.35s ease;
}

.card:hover .store-rating .rating-value {
  transform: scale(1.08);
  filter: drop-shadow(0 2px 6px rgba(212, 175, 55, 0.4));
}

/* ====== 食话食说 - 非遗文化主题增强 ====== */
.food-talk {
  background: linear-gradient(135deg, rgba(200, 22, 29, 0.02), rgba(212, 175, 55, 0.02));
  padding: 72px 0;
  margin-bottom: 56px;
  border-radius: var(--radius-xl);
  position: relative;
  overflow: hidden;
}

.food-talk::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: var(--gradient-sunset);
  background-size: 200% 100%;
  animation: gradientMove 4s ease infinite;
}

.food-talk::after {
  content: '❋';
  position: absolute;
  top: 20px;
  right: 30px;
  font-size: 80px;
  opacity: 0.03;
  color: var(--secondary-color);
  pointer-events: none;
}

/* ====== 食话食说 - 现代美食主题设计 ====== */
.food-talk {
  background: linear-gradient(135deg,
    rgba(255, 140, 0, 0.04) 0%,
    rgba(255, 165, 0, 0.03) 25%,
    rgba(34, 139, 34, 0.025) 50%,
    rgba(220, 20, 60, 0.02) 75%,
    rgba(212, 175, 55, 0.035) 100%
  );
  padding: 48px 0;
  margin-bottom: 40px;
  border-radius: var(--radius-lg);
  position: relative;
  overflow: hidden;
}

.food-talk::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg,
    #FF8C00 0%,
    #FFA500 20%,
    #228B22 40%,
    #DC143C 60%,
    #DAA520 80%,
    #FF8C00 100%
  );
  background-size: 300% 100%;
  animation: foodGradientMove 8s linear infinite;
}

@keyframes foodGradientMove {
  0% { background-position: 0% center; }
  100% { background-position: 300% center; }
}

.food-talk::after {
  content: '🍽️';
  position: absolute;
  top: 15px;
  right: 25px;
  font-size: 70px;
  opacity: 0.04;
  color: #FF8C00;
  pointer-events: none;
  filter: blur(1px);
}

.food-talk-content {
  display: grid;
  grid-template-columns: 1fr 280px 1fr;
  gap: 24px;
  margin-top: 32px;
  max-width: 1320px;
  margin-left: auto;
  margin-right: auto;
}

/* ====== 左侧：知识卡片区域 - 现代化设计 ====== */
.food-talk-left {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.talk-card {
  background: linear-gradient(145deg, #ffffff 0%, #fffcf8 100%);
  border-radius: var(--radius-lg);
  border: 1.5px solid rgba(255, 140, 0, 0.12);
  overflow: hidden;
  transition: all 0.45s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  box-shadow:
    0 2px 12px rgba(255, 140, 0, 0.06),
    0 1px 4px rgba(0, 0, 0, 0.03);
}

.talk-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3.5px;
  background: linear-gradient(90deg,
    transparent 0%,
    #FF8C00 30%,
    #FFA500 50%,
    #FFD700 70%,
    transparent 100%
  );
  opacity: 0;
  transition: opacity 0.4s ease;
}

.talk-card:hover {
  transform: translateY(-6px) scale(1.01);
  box-shadow:
    0 14px 36px rgba(255, 140, 0, 0.15),
    0 6px 18px rgba(212, 175, 55, 0.08);
  border-color: rgba(255, 140, 0, 0.25);
}

.talk-card:hover::before {
  opacity: 1;
}

.talk-card-primary:hover::before {
  background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
}

.talk-card-success {
  background: linear-gradient(145deg, #f0fff0 0%, #f5faf5 100%);
  border-color: rgba(34, 139, 34, 0.18);
}

.talk-card-success:hover {
  border-color: rgba(34, 139, 34, 0.35);
  box-shadow:
    0 14px 36px rgba(34, 139, 34, 0.12),
    0 6px 18px rgba(34, 139, 34, 0.06);
}

.talk-card-success::before {
  background: linear-gradient(90deg,
    transparent 0%,
    #228b22 40%,
    #32CD32 50%,
    #228b22 60%,
    transparent 100%
  );
}

.talk-card-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 18px;
  background: linear-gradient(135deg, rgba(255,250,245,0.98), rgba(255,255,255,1));
  border-bottom: 1.5px solid rgba(255, 140, 0, 0.08);
}

.card-icon {
  font-size: 28px;
  animation: iconBounce 2s ease-in-out infinite;
  filter: drop-shadow(0 2px 4px rgba(255, 140, 0, 0.15));
}

.talk-card-header h4 {
  font-size: 19px;
  color: var(--text-color);
  margin: 0;
  font-weight: 750;
  letter-spacing: 1px;
  flex: 1;
}

.card-badge {
  padding: 7px 16px;
  background: linear-gradient(135deg, #FF8C00, #FFA500);
  color: white;
  border-radius: 14px;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.8px;
  box-shadow: 0 3px 10px rgba(255, 140, 0, 0.25);
}

.card-badge.success {
  background: linear-gradient(135deg, #228b22, #32CD32);
  box-shadow: 0 3px 10px rgba(34, 139, 34, 0.25);
}

.card-badge.hot {
  background: linear-gradient(135deg, #FF6B35, #F7931E);
  box-shadow: 0 3px 10px rgba(255, 107, 53, 0.25);
}

/* 列表样式 - 现代化设计 */
.talk-list {
  list-style: none;
  padding: 14px 18px;
  margin: 0;
}

.talk-list li {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 15px;
  color: var(--text-light);
  line-height: 1.65;
  cursor: pointer;
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  padding: 9px 12px;
  border-radius: var(--radius-sm);
  margin-bottom: 3px;
  position: relative;
}

.talk-list li:last-child {
  margin-bottom: 0;
}

.talk-list li:hover {
  background: linear-gradient(135deg,
    rgba(255, 140, 0, 0.06),
    rgba(255, 165, 0, 0.04)
  );
  color: #FF8C00;
  transform: translateX(5px);
  box-shadow: 0 2px 8px rgba(255, 140, 0, 0.08);
}

.list-num {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 30px;
  height: 28px;
  background: linear-gradient(145deg, rgba(255, 140, 0, 0.1), rgba(255, 165, 0, 0.06));
  border: 1.5px solid rgba(255, 140, 0, 0.2);
  border-radius: 8px;
  font-size: 13.5px;
  font-weight: 750;
  color: #FF8C00;
  letter-spacing: 0.7px;
  flex-shrink: 0;
  transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
}

.talk-list li:hover .list-num {
  background: linear-gradient(135deg, #FF8C00, #FFA500);
  color: white;
  border-color: transparent;
  transform: scale(1.08) rotate(-3deg);
  box-shadow: 0 3px 10px rgba(255, 140, 0, 0.35);
}

.list-text {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.list-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: linear-gradient(135deg, #FFD700, #FFA500);
  flex-shrink: 0;
  opacity: 0.55;
  transition: all 0.35s ease;
  box-shadow: 0 1px 4px rgba(255, 165, 0, 0.25);
}

.talk-list li:hover .list-dot {
  opacity: 1;
  transform: scale(1.6) rotate(180deg);
  box-shadow:
    0 0 12px rgba(255, 215, 0, 0.6),
    0 2px 6px rgba(255, 140, 0, 0.3);
}

.list-item-hot .list-dot {
  background: linear-gradient(135deg, #FF6347, #FF4500);
  opacity: 1;
  box-shadow:
    0 0 8px rgba(255, 99, 71, 0.5),
    0 2px 4px rgba(255, 69, 0, 0.3);
  animation: hotPulse 2s ease-in-out infinite;
}

@keyframes hotPulse {
  0%, 100% {
    transform: scale(1);
    box-shadow:
      0 0 8px rgba(255, 99, 71, 0.5),
      0 2px 4px rgba(255, 69, 0, 0.3);
  }
  50% {
    transform: scale(1.15);
    box-shadow:
      0 0 14px rgba(255, 99, 71, 0.7),
      0 3px 6px rgba(255, 69, 0, 0.4);
  }
}

.talk-list-compact li {
  padding: 9px 12px;
  font-size: 14.5px;
  margin-bottom: 2.5px;
}

/* ====== 中间：文化核心展示区 - 现代化设计 ====== */
.food-talk-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

.center-showcase {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 18px;
  padding: 26px 18px;
  background: linear-gradient(145deg,
    #ffffff 0%,
    #fffcf8 40%,
    #fffaf0 70%,
    #fff8e8 100%
  );
  border-radius: var(--radius-xl);
  border: 2px solid rgba(255, 140, 0, 0.15);
  box-shadow:
    0 8px 28px rgba(255, 140, 0, 0.08),
    0 4px 14px rgba(212, 175, 55, 0.06),
    inset 0 1px 0 rgba(255, 255, 255, 0.95);
  position: relative;
  overflow: hidden;
}

.center-showcase::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  background:
    radial-gradient(circle at 30% 20%, rgba(255, 165, 0, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 70% 80%, rgba(34, 139, 34, 0.07) 0%, transparent 50%);
  pointer-events: none;
}

.showcase-ring {
  width: 115px;
  height: 115px;
  border-radius: 50%;
  background: conic-gradient(
    from 0deg,
    #FF8C00 0%,
    #FFA500 25%,
    #228B22 50%,
    #DC143C 60%,
    #FF8C00 100%
  );
  padding: 3.5px;
  animation: ringRotate 10s linear infinite;
  position: relative;
  box-shadow:
    0 4px 16px rgba(255, 140, 0, 0.2),
    0 2px 8px rgba(212, 175, 55, 0.15);
}

@keyframes ringRotate {
  to { transform: rotate(360deg); }
}

.ring-inner {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: linear-gradient(145deg, #ffffff, #fffcf8);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 2px;
  box-shadow:
    inset 0 2px 6px rgba(255, 140, 0, 0.08),
    inset 0 -1px 3px rgba(212, 175, 55, 0.05);
}

.ring-title {
  font-size: 17px;
  font-weight: 850;
  color: #FF8C00;
  letter-spacing: 2.5px;
  background: linear-gradient(135deg, #FF8C00, #FFA500, #DAA520);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.ring-subtitle {
  font-size: 13.5px;
  the: var(--text-lighter);
  letter-spacing: 1.6px;
}

.character-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  width: 100%;
}

.character-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  transition: all 0.45s cubic-bezier(0.4, 0, input, 0.2, 1);
  cursor: pointer;
  padding: 10px 8px;
  border-radius: var(--radius-sm);
}

.character-item:hover {
  background: linear-gradient(135deg,
    rgba(255, 140, 0, 0.06),
    rgba(255, 165, 0, 0.04)
  );
  transform: translateY(-5px) scale(1.04);
}

.character-box {
  width: 68px;
  height: 68px;
  border-radius: 50%;
  background: linear-gradient(145deg, #ffffff, #fffcf8);
  border: 2.5px solid rgba(255, 140, 0, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow:
    0 4px 16px rgba(255, 140, 0, 0.1),
    0 2px 6px rgba(212, 175, 55, 0.08),
    inset 0 1px 3px rgba(255, 255, 255, 0.9);
  transition: all 0.45s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.character-box::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  border-radius: 50%;
  background: radial-gradient(circle,
    var(--char-color) 0%,
    transparent 70%
  );
  opacity: 0.15;
  transform: translate(-50%, -50%);
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.character-item:hover .character-box {
  border-color: var(--char-color);
  box-shadow:
    0 10px 28px rgba(255, 140, 0, 0.18),
    0 4px 12px rgba(212, 175, 55, 0.1),
    0 0 0 4px var(--char-bg);
  transform: scale(1.1) rotate(8deg);
}

.character-item:hover .character-box::after {
  width: 140%;
  height: 140%;
}

.character-char {
  font-size: 34px;
  font-weight: 900;
  color: var(--char-color);
  position: relative;
  z-index: 1;
  transition: all 0.4s cubic-bezier(0.68,-0.55,0.265,1.55);
  text-shadow:
    2px 2px 6px rgba(0,0,0,0.08),
    0 0 12px rgba(255, 140, 0, 0.12);
}

.character-item:hover .character-char {
  transform: scale(1.15) rotate(-5deg);
  text-shadow:
    3px 3px 10px rgba(0,0,0,0.12),
    0 0 20px var(--char-color),
    0 0 30px rgba(255, 140, 0, 0.15);
}

.character-info {
  margin-top: 7px;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.character-name {
  font-size: 16px;
  font-weight: 750;
  color: var(--char-color);
  letter-spacing: 2.6px;
}

.character-tag {
  font-size: 13px;
  color: var(--text-lighter);
  padding: 5px 14px;
  background: linear-gradient(135deg,
    rgba(255, 255, 255, 0.9),
    rgba(255, 250, 245, 0.95)
  );
  border-radius: 10px;
  border: 1px solid rgba(255, 140, 0, 0.12);
  display: inline-block;
}

.center-quote {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  background: linear-gradient(135deg, rgba(212,175,55,0.06), rgba(200,22,29,0.04));
  border-radius: 25px;
  border: 1px solid var(--border-gold);
}

.quote-icon {
  font-size: 18px;
  color: var(--secondary-color);
  opacity: 0.6;
  animation: quotePulse 3s ease-in-out infinite;
}

.quote-icon:last-child {
  animation-delay: 1.5s;
}

@keyframes quotePulse {
  0%, 100% { opacity: 0.4; transform: scale(1); }
  50% { opacity: 0.8; transform: scale(1.1); }
}

/* ====== Banner区域专用动画 ====== */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(40px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes badgePulse {
  0%, 100% {
    box-shadow:
      0 8px 28px rgba(200, 22, 29, 0.38),
      inset 0 1px 0 rgba(255,255,255,0.25);
  }
  50% {
    box-shadow:
      0 12px 40px rgba(200, 22, 29, 0.48),
      inset 0 1px 0 rgba(255,255,255,0.3),
      0 0 30px rgba(212, 175, 55, 0.15);
  }
}

@keyframes gradientShift {
  0% { background-position: 0% center; }
  50% { background-position: 100% center; }
  100% { background-position: 0% center; }
}

@keyframes slideRightToLeft {
  0% { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}

@keyframes shimmerMove {
  0% { left: -100%; }
  50%, 100% { left: 100%; }
}

@keyframes waveFloat {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-8px);
  }
}

@keyframes pulse {
  0%, 100% {
    opacity: 0.6;
    transform: scale(1);
  }
  50% {
    opacity: 1;
    transform: scale(1.2);
  }
}

@keyframes decoSlide {
  0% {
    background-position: 0 0;
  }
  100% {
    background-position: 16px 0;
  }
}

.center-quote p {
  font-size: 15px;
  color: var(--text-light);
  letter-spacing: 4px;
  margin: 0;
  font-weight: 650;
}

/* ====== 右侧：热门文章 ====== */
.food-talk-right {
  padding: 0 !important;
  height: auto !important;
}

/* ====== 响应式设计 - 优化间距 ====== */
@media (max-width: 1024px) {
  .grid-auto { grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); }
  .grid-cols-3 { grid-template-columns: repeat(2, 1fr); }

  /* 装饰带响应式 - 平板端 */
  .heritage-decoration-left,
  .heritage-decoration-right {
    width: 50px;
    padding: 60px 0;
  }

  .deco-symbol {
    font-size: 22px;
  }

  .deco-pattern {
    font-size: 15px;
  }

  .deco-vertical-text {
    font-size: 11px;
    letter-spacing: 6px;
  }

  .deco-column {
    gap: 22px;
  }

  .recommend,
  .hot,
  .nearby {
    margin-bottom: 44px;
    padding: 36px 0;
  }

  .page-header {
    margin-bottom: 36px;
    padding: 22px 0 20px;
  }

  .food-talk-content {
    grid-template-columns: 1fr;
    gap: 24px;
  }

  .character-grid {
    grid-template-columns: repeat(4, 1fr);
    gap: 14px;
  }

  .character-box {
    width: 68px;
    height: 68px;
  }

  .character-char {
    font-size: 32px;
  }

  .showcase-ring {
    width: 108px;
    height: 108px;
  }

  .talk-card {
    height: auto !important;
  }

  .banner {
    padding: 80px 0 100px;
  }

  .banner-img {
    height: 360px;
  }

  .banner-content h1 {
    font-size: clamp(32px, 5vw, 48px);
    letter-spacing: 6px;
  }

  .banner-content p {
    font-size: clamp(15px, 2vw, 18px);
    letter-spacing: 3px;
    margin-bottom: 38px;
  }

  .search-box {
    max-width: 520px;
  }

  .page-header {
    margin-bottom: 42px;
    padding: 28px 0 24px;
  }
}

@media (max-width: 768px) {
  /* 装饰带响应式 - 移动端隐藏 */
  .heritage-decoration-left,
  .heritage-decoration-right {
    display: none;
  }

  /* 确保内容区域有足够padding */
  .home {
    padding-left: 0;
    padding-right: 0;
  }

  .banner {
    padding: 65px 0 85px;
    border-radius: 0 0 36px 36px;
  }

  .banner-img {
    height: 300px;
  }

  .banner-content {
    max-width: 100%;
    padding: 0 20px;
  }

  .banner-badge {
    padding: 12px 26px;
    font-size: 12.5px;
    margin-bottom: 22px;
    letter-spacing: 2.5px;
  }

  .banner-content h1 {
    font-size: clamp(28px, 6.5vw, 40px);
    letter-spacing: 5px;
    margin-bottom: 20px;
  }

  .banner-content p {
    font-size: clamp(14px, 2.5vw, 17px);
    letter-spacing: 2.5px;
    margin-bottom: 32px;
    max-width: 100%;
  }

  .search-box {
    max-width: 100%;
    flex-direction: column;
    border-radius: var(--radius-lg);
  }

  .search-box input {
    padding: 16px 20px;
    font-size: 15px;
    border-radius: var(--radius-lg) var(--radius-lg) 0 0;
  }

  .search-btn {
    padding: 16px 28px;
    border-radius: 0 0 var(--radius-lg) var(--radius-lg);
    justify-content: center;
  }

  .pattern { font-size: 32px; }
  .decoration-item { display: none; }
  .lantern { display: none; }

  .page-header {
    flex-direction: column;
    gap: 12px;
    margin-bottom: 32px;
    padding: 18px 0;
  }

  .page-header::after {
    width: 80px;
  }

  .page-title-decoration {
    display: none;
  }

  .page-title {
    font-size: clamp(24px, 5vw, 30px);
    letter-spacing: 4px;
  }

  .title-icon { font-size: 24px; }

  .recommend,
  .hot,
  .nearby {
    margin-bottom: 36px;
    padding: 30px 0;
  }

  .grid-auto,
  .grid-cols-3 {
    grid-template-columns: 1fr;
  }

  .food-talk-characters {
    grid-template-columns: 1fr 1fr;
  }

  .food-talk-title {
    font-size: 24px;
  }

  .search-box {
    max-width: calc(100% - 48px);
    flex-direction: column;
    border-radius: var(--radius-lg);
  }

  .search-box input {
    border-radius: var(--radius-lg) var(--radius-lg) 0 0;
    padding: 16px 20px;
  }

  .search-btn {
    border-radius: 0 0 var(--radius-lg) var(--radius-lg);
    padding: 14px 28px;
    justify-content: center;
  }

  .item-image-wrapper {
    height: 200px;
  }

  .info-header {
    flex-direction: column;
    gap: 8px;
  }

  .info-region {
    align-self: flex-start;
  }
}

@media (max-width: 480px) {
  .container {
    padding: 0 16px;
  }

  .banner {
    padding: 52px 0 68px;
    border-radius: 0 0 28px 28px;
  }

  .banner-img {
    height: 250px;
    opacity: 0.18;
  }

  .banner-content {
    max-width: 100%;
    padding: 0 16px;
  }

  .banner-badge {
    padding: 10px 22px;
    font-size: 11.5px;
    letter-spacing: 2.2px;
    margin-bottom: 18px;
  }

  .banner-content h1 {
    font-size: clamp(24px, 7.5vw, 32px);
    letter-spacing: 3px;
    margin-bottom: 18px;
    line-height: 1.2;
  }

  .banner-content p {
    font-size: clamp(13px, 2.8vw, 15px);
    letter-spacing: 2px;
    margin-bottom: 28px;
    line-height: 1.6;
    max-width: 100%;
  }

  .search-box {
    max-width: 100%;
    border-radius: var(--radius-md);
  }

  .search-box input {
    padding: 14px 18px;
    font-size: 14px;
    border-radius: var(--radius-md) var(--radius-md) 0 0;
  }

  .search-btn {
    padding: 14px 24px;
    font-size: 14px;
    border-radius: 0 0 var(--radius-md) var(--radius-md);
  }

  .ornamental-divider {
    gap: 14px;
    margin-top: 8px;
  }

  .divider-line {
    width: 70px;
    height: 2px;
  }

  .divider-symbol {
    font-size: 17px;
  }

  .wave-decoration {
    height: 60px;
  }

  .page-title {
    font-size: clamp(20px, 6vw, 26px);
    letter-spacing: 2px;
  }

  .food-talk {
    padding: 48px 0;
    border-radius: var(--radius-lg);
  }

  .showcase-ring {
    width: 96px;
    height: 96px;
  }

  .ring-title {
    font-size: 12px;
  }

  .character-grid {
    grid-template-columns: 1fr 1fr;
    gap: 12px;
  }

  .character-box {
    width: 60px;
    height: 60px;
  }

  .character-char {
    font-size: 26px;
  }

  .center-quote {
    flex-direction: column;
    gap: 6px;
    padding: 10px 16px;
  }

  .center-quote p {
    font-size: 11px;
    letter-spacing: 2px;
  }

  .talk-card-header {
    padding: 14px 18px;
  }

  .talk-list {
    padding: 14px 18px;
  }

  .list-num {
    min-width: 20px;
    height: 18px;
    font-size: 10px;
  }

  .item-image-wrapper {
    height: 180px;
  }

  .food-info {
    padding: 18px 20px;
  }

  .info-header h3 {
    font-size: 17px;
  }

  .more-btn {
    padding: 14px 32px;
    font-size: 15px;
    width: calc(100% - 48px);
    max-width: 320px;
  }
}

/* ====== 两侧非遗美食文化装饰带 ====== */
.home {
  position: relative;
  overflow-x: hidden;
}

/* 左侧装饰区 - 非遗文化符号 */
.heritage-decoration-left {
  position: fixed;
  left: 0;
  top: 0;
  width: 65px;
  height: 100vh;
  background: linear-gradient(180deg,
    rgba(212, 175, 55, 0.04) 0%,
    rgba(200, 22, 29, 0.03) 25%,
    rgba(212, 175, 55, 0.05) 50%,
    rgba(200, 22, 29, 0.02) 75%,
    rgba(212, 175, 55, 0.06) 100%
  );
  border-right: 1.5px solid rgba(212, 175, 55, 0.12);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-around;
  padding: 80px 0;
  z-index: 1;
  pointer-events: none;
  opacity: 0.85;
  transition: opacity 0.4s ease;
}

.home:hover .heritage-decoration-left,
.home:hover .heritage-decoration-right {
  opacity: 1;
}

/* 右侧装饰区 - 传统工艺元素 */
.heritage-decoration-right {
  position: fixed;
  right: 0;
  top: 0;
  width: 65px;
  height: 100vh;
  background: linear-gradient(180deg,
    rgba(200, 22, 29, 0.04) 0%,
    rgba(212, 175, 55, 0.03) 25%,
    rgba(200, 22, 29, 0.05) 50%,
    rgba(212, 175, 55, 0.02) 75%,
    rgba(200, 22, 29, 0.06) 100%
  );
  border-left: 1.5px solid rgba(212, 175, 55, 0.12);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-around;
  padding: 80px 0;
  z-index: 1;
  pointer-events: none;
  opacity: 0.85;
}

/* 装饰列容器 */
.deco-column {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 28px;
}

.deco-left-1 { animation: floatUp 6s ease-in-out infinite; }
.deco-left-2 { animation: floatDown 7s ease-in-out infinite 1s; }
.deco-right-1 { animation: floatDown 6.5s ease-in-out infinite 0.5s; }
.deco-right-2 { animation: floatUp 7.5s ease-in-out infinite 1.5s; }

@keyframes floatUp {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-12px); }
}

@keyframes floatDown {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(12px); }
}

/* 装饰符号基础样式 */
.deco-symbol {
  font-size: 26px;
  opacity: 0.5;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  filter: grayscale(20%);
  cursor: default;
  position: relative;
}

.deco-symbol:hover {
  opacity: 1;
  transform: scale(1.3) rotate(-8deg);
  filter: grayscale(0%) drop-shadow(0 4px 12px rgba(212, 175, 55, 0.35));
}

/* 左侧特定符号样式 */
.symbol-cloud { animation: cloudFloat 4s ease-in-out infinite; color: #87CEEB; }
.symbol-bamboo { animation: bambooSway 5s ease-in-out infinite 0.5s; color: #228B22; }
.symbol-lantern { animation: lanternGlow 3s ease-in-out infinite; color: #FF4500; }
.symbol-fan { animation: fanWave 6s ease-in-out infinite 1s; color: #DAA520; }
.symbol-tea { animation: teaSteam 4s ease-in-out infinite 2s; color: #8B4513; }
.symbol-rice { animation: riceSway 5s ease-in-out infinite 1.5s; color: #DAA520; }

@keyframes cloudFloat {
  0%, 100% { transform: translateX(0); }
  50% { transform: translateX(4px); }
}

@keyframes bambooSway {
  0%, 100% { transform: rotate(0deg); }
  25% { transform: rotate(3deg); }
  75% { transform: rotate(-3deg); }
}

@keyframes lanternGlow {
  0%, 100% { 
    opacity: 0.5; 
    filter: drop-shadow(0 0 8px rgba(255,69,0,0.3));
  }
  50% { 
    opacity: 0.9; 
    filter: drop-shadow(0 0 16px rgba(255,69,0,0.6));
  }
}

@keyframes fanWave {
  0%, 100% { transform: rotateY(0deg); }
  50% { transform: rotateY(15deg); }
}

@keyframes teaSteam {
  0%, 100% { transform: translateY(0) scale(1); opacity: 0.5; }
  50% { transform: translateY(-6px) scale(1.08); opacity: 0.8; }
}

@keyframes riceSway {
  0%, 100% { transform: rotate(0deg); }
  33% { transform: rotate(5deg); }
  66% { transform: rotate(-5deg); }
}

/* 右侧特定符号样式 */
.symbol-pot { animation: potSteam 4s ease-in-out infinite; color: #8B4513; }
.symbol-chopsticks { animation: chopstickTap 3s ease-in-out infinite 0.8s; color: #8B4513; }
.symbol-dumpling { animation: dumplingFloat 5s ease-in-out infinite 1.2s; color: #F5DEB3; }
.symbol-noodle { animation: noodleWave 4.5s ease-in-out infinite 0.6s; color: #DEB887; }
.symbol-spice { animation: spiceSparkle 2.5s ease-in-out infinite; color: #DC143C; }
.symbol-wine { animation: wineShimmer 5s ease-in-out infinite 1.8s; color: #800020; }

@keyframes potSteam {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-5px); }
}

@keyframes chopstickTap {
  0%, 90%, 100% { transform: rotate(0deg); }
  95% { transform: rotate(10deg); }
}

@keyframes dumplingFloat {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-8px) rotate(5deg); }
}

@keyframes noodleWave {
  0%, 100% { transform: skewX(0deg); }
  25% { transform: skewX(3deg); }
  75% { transform: skewX(-3deg); }
}

@keyframes spiceSparkle {
  0%, 100% { opacity: 0.5; transform: scale(1); }
  50% { opacity: 1; transform: scale(1.2); filter: drop-shadow(0 0 8px rgba(220,20,60,0.5)); }
}

@keyframes wineShimmer {
  0%, 100% { filter: brightness(1) hue-rotate(0deg); }
  50% { filter: brightness(1.2) hue-rotate(10deg); }
}

/* 装饰图案样式 */
.deco-pattern {
  font-size: 18px;
  opacity: 0.25;
  color: var(--secondary-color);
}

.pattern-spiral { animation: spiralRotate 12s linear infinite; }
.pattern-circle { animation: circlePulse 4s ease-in-out infinite 0.7s; }
.pattern-diamond { animation: diamondSpin 8s linear infinite 1s; }
.pattern-star { animation: starTwinkle 3s ease-in-out infinite 2.2s; color: var(--primary-color); }

@keyframes spiralRotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@keyframes circlePulse {
  0%, 100% { transform: scale(1); opacity: 0.25; }
  50% { transform: scale(1.3); opacity: 0.45; }
}

@keyframes diamondSpin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@keyframes starTwinkle {
  0%, 100% { opacity: 0.25; transform: scale(1) rotate(0deg); }
  50% { opacity: 0.6; transform: scale(1.2) rotate(180deg); }
}

/* 垂直文字 */
.deco-vertical-text {
  writing-mode: vertical-rl;
  text-orientation: upright;
  font-size: 13px;
  letter-spacing: 8px;
  color: var(--secondary-color);
  opacity: 0.3;
  font-weight: 700;
  white-space: nowrap;
  text-shadow: 0 0 10px rgba(212, 175, 55, 0.2);
  animation: textFade 6s ease-in-out infinite;
}

.heritage-decoration-right .deco-vertical-text {
  color: var(--primary-color);
  text-shadow: 0 0 10px rgba(200, 22, 29, 0.2);
}

@keyframes textFade {
  0%, 100% { opacity: 0.25; }
  50% { opacity: 0.45; }
}
</style>