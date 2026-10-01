<template>
  <div class="heritage-timeline">
    <!-- 顶部导航 -->
    <div class="timeline-header">
      <!-- 返回按钮 -->
      <button class="back-btn" @click="goBack">
        <span class="back-icon">←</span>
        <span class="back-text">返回</span>
      </button>
      
      <!-- 标题栏 -->
      <div class="page-header">
        <h1 class="header-title">非遗美食 · 时光复刻</h1>
        <p class="header-subtitle">拖拽时间轴，探寻古法制作的传承与演变</p>
      </div>
    </div>

    <main class="timeline-main">
      <!-- 只保留这一组可用的按钮（就是你截图里的3个） -->
      <div class="food-switcher">
        <div class="switcher-scroll">
          <button
            v-for="food in foodList"
            :key="food.id"
            :class="['food-btn', { active: currentFoodId === food.id }]"
            @click="switchFood(food.id)"
          >
            {{ food.name }}
          </button>
        </div>
      </div>

      <!-- 时光轴主体（完全保留原有功能） -->
      <div class="timeline-content">
        <div class="step-display">
          <div class="step-card">
            <div class="step-number">{{ currentStepIndex + 1 }}</div>
            <div class="step-img-box">
              <img
                :src="currentStep.img"
                :alt="currentStep.title"
                class="step-img"
                loading="lazy"
              />
            </div>
            <div class="step-info">
              <h3 class="step-time">{{ currentStep.time }}</h3>
              <h2 class="step-title">{{ currentStep.title }}</h2>
              <p class="step-desc">{{ currentStep.desc }}</p>
            </div>
          </div>
        </div>

        <div class="timeline-control">
          <button
            class="ctrl-btn prev-btn"
            @click="prevStep"
            :disabled="currentStepIndex === 0"
          >
            <i class="icon">◀</i>
          </button>

          <div class="progress-container" ref="progressRef" @mousedown="startDrag">
            <div class="progress-bg"></div>
            <div
              class="progress-fill"
              :style="{ width: `${(currentStepIndex / (currentSteps.length - 1)) * 100}%` }"
            ></div>
            <div class="step-markers">
              <span
                v-for="(step, index) in currentSteps"
                :key="step.id"
                :class="['marker', { active: currentStepIndex === index }]"
                @click="goToStep(index)"
              ></span>
            </div>
            <div
              class="progress-thumb"
              :style="{ left: `${(currentStepIndex / (currentSteps.length - 1)) * 100}%` }"
            ></div>
          </div>

          <button
            class="ctrl-btn next-btn"
            @click="nextStep"
            :disabled="currentStepIndex === currentSteps.length - 1"
          >
            <i class="icon">▶</i>
          </button>

          <button class="play-btn" @click="toggleAutoPlay">
            {{ isAutoPlaying ? "暂停" : "播放" }}
          </button>

          <div class="step-count">
            {{ currentStepIndex + 1 }} / {{ currentSteps.length }}
          </div>
        </div>
      </div>
    </main>

    <footer class="timeline-footer">
      <p>© 2026 非遗美食文化传承平台 - 时光轴组件</p>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from "vue";
import { useRouter } from "vue-router";

const router = useRouter();

const goBack = () => {
  router.back();
};

const foodData = ref([
  {
    id: "duck",
    name: "北京烤鸭",
    steps: [
      {
        id: 1,
        time: "处理阶段",
        title: "填鸭处理与打气",
        desc: "选用正宗北京填鸭，清洗干净，打气使皮肉分离，为上色做准备。",
        img: "/images/duck/1.jpg",
      },
      {
        id: 2,
        time: "烫皮挂糖",
        title: "开水烫皮与挂糖",
        desc: "用沸水烫皮，刷上麦芽糖水，风干表皮使其紧绷。",
        img: "/images/duck/2.jpg",
      },
      {
        id: 3,
        time: "风干晾制",
        title: "通风晾干24小时",
        desc: "挂于通风处自然风干，使表皮干燥，为烤制脆皮做铺垫。",
        img: "/images/duck/3.jpg",
      },
      {
        id: 4,
        time: "果木烤制",
        title: "果木炭火精准烤制",
        desc: "使用枣木、梨木烤制，火候精准，外皮呈现枣红色且酥脆。",
        img: "/images/duck/4.jpg",
      },
      {
        id: 5,
        time: "片鸭上桌",
        title: "手工片鸭与搭配",
        desc: "将烤鸭片成薄片，搭配甜面酱、葱丝、黄瓜丝及荷叶饼食用。",
        img: "/images/duck/5.jpg",
      },
    ],
  },
  {
    id: "dimsum",
    name: "广式早茶",
    steps: [
      {
        id: 1,
        time: "备料阶段",
        title: "精选鲜虾、猪肉、面粉",
        desc: "选用新鲜虾仁、猪肉丁，搭配精细面粉，严格按传统配比。",
        img: "/images/dimsum/1.jpg",
      },
      {
        id: 2,
        time: "揉面阶段",
        title: "古法揉制面皮",
        desc: "手工揉制面团，控制水温与力道，保证面皮薄韧不易破。",
        img: "/images/dimsum/2.jpg",
      },
      {
        id: 3,
        time: "包制阶段",
        title: "手工包制点心",
        desc: "捏出精致褶子，包成虾饺、烧卖、凤爪等经典造型。",
        img: "/images/dimsum/3.jpg",
      },
      {
        id: 4,
        time: "蒸制阶段",
        title: "竹蒸笼旺火蒸制",
        desc: "使用竹蒸笼高温蒸制，确保点心鲜嫩多汁，热气腾腾。",
        img: "/images/dimsum/4.jpg",
      },
    ],
  },
  {
    id: "cake",
    name: "苏州园林糕团",
    steps: [
      {
        id: 1,
        time: "泡米磨粉",
        title: "糯米浸泡，水磨成粉",
        desc: "选用优质糯米，长时间浸泡后磨成细腻米粉，保证糕团软糯口感。",
        img: "/images/cake/1.jpg",
      },
      {
        id: 2,
        time: "天然调色",
        title: "艾草、南瓜、紫薯调色",
        desc: "使用天然植物食材给米粉调色，健康无添加，呈现雅致色彩。",
        img: "/images/cake/2.jpg",
      },
      {
        id: 3,
        time: "手工造型",
        title: "手工捏制园林造型",
        desc: "手工雕刻成荷花、梅花、亭台楼阁等园林元素，造型精美。",
        img: "/images/cake/3.jpg",
      },
      {
        id: 4,
        time: "文火蒸制",
        title: "慢火蒸制，香甜成型",
        desc: "使用蒸笼文火蒸制，把控火候，保证糕团软糯香甜且造型完整。",
        img: "/images/cake/4.jpg",
      },
    ],
  },
  {
    id: "xiaolongbao",
    name: "上海小笼包",
    steps: [
      {
        id: 1,
        time: "制皮阶段",
        title: "和面揉面，擀制薄皮",
        desc: "选用高筋面粉，温水和面，揉至光滑，醒发后擀成薄如蝉翼的圆形面皮。",
        img: "/images/xiaolongbao/1.jpg",
      },
      {
        id: 2,
        time: "调馅阶段",
        title: "猪皮冻与肉馅调配",
        desc: "选用新鲜猪前腿肉，加入熬制的猪皮冻，调味后顺时针搅拌至上劲。",
        img: "/images/xiaolongbao/2.jpg",
      },
      {
        id: 3,
        time: "包制阶段",
        title: "手工包制18褶",
        desc: "每张面皮包入适量馅料，捏出18个以上的褶子，确保汤汁不流失。",
        img: "/images/xiaolongbao/3.jpg",
      },
      {
        id: 4,
        time: "蒸制阶段",
        title: "竹蒸笼旺火蒸制",
        desc: "放入竹蒸笼，用旺火蒸制5-6分钟，至小笼包饱满透亮即可。",
        img: "/images/xiaolongbao/4.jpg",
      },
      {
        id: 5,
        time: "上桌享用",
        title: "蘸醋品汤，趁热食用",
        desc: "搭配姜丝和香醋，先咬一小口吸出汤汁，再品尝肉馅的鲜美。",
        img: "/images/xiaolongbao/5.jpg",
      },
    ],
  },
  {
    id: "huimian",
    name: "郑州烩面",
    steps: [
      {
        id: 1,
        time: "和面阶段",
        title: "高筋面粉加盐和面",
        desc: "选用高筋面粉，加入适量盐和水，反复揉至面团光滑，醒发30分钟。",
        img: "/images/huimian/1.jpg",
      },
      {
        id: 2,
        time: "抻面阶段",
        title: "手工抻制宽面",
        desc: "将面团分成小剂，用手拉抻成宽薄均匀的面条，技艺精湛。",
        img: "/images/huimian/2.jpg",
      },
      {
        id: 3,
        time: "熬汤阶段",
        title: "骨汤熬制8小时",
        desc: "选用牛骨、羊骨等食材，慢火熬制8小时以上，汤头浓郁鲜美。",
        img: "/images/huimian/3.jpg",
      },
      {
        id: 4,
        time: "煮面阶段",
        title: "沸水下面，快速煮熟",
        desc: "将抻好的面条放入沸水锅中，快速煮熟后捞出，保持面条劲道。",
        img: "/images/huimian/4.jpg",
      },
      {
        id: 5,
        time: "配料阶段",
        title: "添加配菜与调料",
        desc: "浇上熬好的骨汤，加入羊肉片、海带丝、豆腐丝等配菜，撒上香菜即可。",
        img: "/images/huimian/5.jpg",
      },
    ],
  },
]);

const foodList = ref(foodData.value);
const currentFoodId = ref("duck");
const currentStepIndex = ref(0);
const isAutoPlaying = ref(false);
const autoPlayTimer = ref<number | null>(null);
const progressRef = ref<HTMLElement | null>(null);
const isDragging = ref(false);

const currentFood = computed(() => {
  return foodList.value.find((f) => f.id === currentFoodId.value) || foodList.value[0];
});

const currentSteps = computed(() => currentFood.value.steps);
const currentStep = computed(() => currentSteps.value[currentStepIndex.value]);

const switchFood = (foodId: string) => {
  currentFoodId.value = foodId;
  currentStepIndex.value = 0;
  stopAutoPlay();
};

const prevStep = () => {
  if (currentStepIndex.value > 0) currentStepIndex.value--;
};

const nextStep = () => {
  if (currentStepIndex.value < currentSteps.value.length - 1) {
    currentStepIndex.value++;
  } else {
    stopAutoPlay();
  }
};

const goToStep = (index: number) => {
  currentStepIndex.value = index;
};

const toggleAutoPlay = () => {
  isAutoPlaying.value ? stopAutoPlay() : startAutoPlay();
};

const startAutoPlay = () => {
  isAutoPlaying.value = true;
  autoPlayTimer.value = window.setInterval(() => nextStep(), 4000);
};

const stopAutoPlay = () => {
  isAutoPlaying.value = false;
  if (autoPlayTimer.value) clearInterval(autoPlayTimer.value);
};

const startDrag = (e: MouseEvent) => {
  isDragging.value = true;
  document.addEventListener("mousemove", handleDrag);
  document.addEventListener("mouseup", stopDrag);
};

const handleDrag = (e: MouseEvent) => {
  if (!isDragging.value || !progressRef.value) return;
  const rect = progressRef.value.getBoundingClientRect();
  const percent = Math.min(Math.max((e.clientX - rect.left) / rect.width, 0), 1);
  const stepIndex = Math.round(percent * (currentSteps.value.length - 1));
  currentStepIndex.value = stepIndex;
};

const stopDrag = () => {
  isDragging.value = false;
  document.removeEventListener("mousemove", handleDrag);
  document.removeEventListener("mouseup", stopDrag);
};

const handleTouchStart = (e: TouchEvent) => {
  isDragging.value = true;
  document.addEventListener("touchmove", handleTouchMove);
  document.addEventListener("touchend", stopDrag);
};

const handleTouchMove = (e: TouchEvent) => {
  if (!isDragging.value || !progressRef.value) return;
  const rect = progressRef.value.getBoundingClientRect();
  const touch = e.touches[0];
  const percent = Math.min(Math.max((touch.clientX - rect.left) / rect.width, 0), 1);
  const stepIndex = Math.round(percent * (currentSteps.value.length - 1));
  currentStepIndex.value = stepIndex;
};

onMounted(() => {
  progressRef.value?.addEventListener("touchstart", handleTouchStart);
});

onUnmounted(() => {
  stopAutoPlay();
  progressRef.value?.removeEventListener("touchstart", handleTouchStart);
  document.removeEventListener("mousemove", handleDrag);
  document.removeEventListener("mouseup", stopDrag);
  document.removeEventListener("touchmove", handleTouchMove);
  document.removeEventListener("touchend", stopDrag);
});
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: "微软雅黑", "PingFang SC", sans-serif;
}
.heritage-timeline {
  min-height: 100vh;
  background: linear-gradient(135deg, #fdf9f5 0%, #fef5e7 50%, #fdf3e0 100%);
  color: #333;
  overflow-x: hidden;
  position: relative;
}
.heritage-timeline::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    radial-gradient(circle at 10% 20%, rgba(200, 22, 29, 0.05) 0%, transparent 40%),
    radial-gradient(circle at 90% 80%, rgba(185, 136, 82, 0.05) 0%, transparent 40%);
  pointer-events: none;
  z-index: 0;
}

.timeline-header {
  position: relative;
  z-index: 1;
}

.back-btn {
  position: absolute;
  top: 1rem;
  left: 1rem;
  display: flex;
  align-items: center;
  gap: 6px;
  background: rgba(255, 255, 255, 0.9);
  border: 2px solid rgba(200, 22, 29, 0.1);
  border-radius: 50px;
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 600;
  color: #c8161d;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  z-index: 10;
}

.back-btn:hover {
  background: #c8161d;
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(200, 22, 29, 0.3);
  border-color: #c8161d;
}

.back-icon {
  font-size: 16px;
  font-weight: bold;
}

.back-text {
  font-size: 14px;
}
/* 匹配你截图的标题栏样式 */
.page-header {
  text-align: center;
  padding: 2.5rem 1rem;
  background: linear-gradient(180deg, rgba(253, 249, 245, 0.95), rgba(248, 237, 224, 0.9));
  position: relative;
  z-index: 1;
}
.page-header::before {
  content: '🍜';
  position: absolute;
  top: 1rem;
  left: 50%;
  transform: translateX(-50%);
  font-size: 3rem;
  opacity: 0.3;
}
.header-title {
  font-size: 2.5rem;
  color: #c8161d;
  margin-bottom: 0.8rem;
  font-weight: 700;
  position: relative;
  z-index: 1;
}
.header-subtitle {
  font-size: 1.1rem;
  color: #8b7355;
  font-weight: 500;
}
.timeline-main {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
  position: relative;
  z-index: 1;
}
.food-switcher {
  margin: 1rem 0 2rem;
  overflow-x: auto;
}
.switcher-scroll {
  display: flex;
  gap: 1rem;
  padding-bottom: 0.5rem;
  justify-content: center;
}
.food-btn {
  padding: 0.9rem 2rem;
  border: 2px solid #d4b891;
  background: linear-gradient(135deg, #fff 0%, #fdf9f5 100%);
  color: #8b4513;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 50px;
  box-shadow: 0 2px 8px rgba(139, 69, 19, 0.1);
}
.food-btn.active {
  background: #c8161d;
  color: #fff;
  border-color: #c8161d;
}
.food-btn:hover:not(.active) {
  background: linear-gradient(135deg, #f8ede0 0%, #fdf3e0 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(139, 69, 19, 0.15);
}
.timeline-content {
  margin-bottom: 3rem;
}
.step-display {
  margin-bottom: 2rem;
}
.step-card {
  background: #fff;
  border-radius: 20px;
  box-shadow: 0 8px 30px rgba(139, 69, 19, 0.12), 0 2px 10px rgba(139, 69, 19, 0.06);
  overflow: hidden;
  position: relative;
  border: 1px solid rgba(185, 136, 82, 0.1);
  animation: cardFadeIn 0.5s ease-out;
}
@keyframes cardFadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
.step-number {
  position: absolute;
  top: 1rem;
  right: 1rem;
  font-size: 3rem;
  color: rgba(139, 69, 19, 0.1);
  font-weight: bold;
  z-index: 1;
}
.step-img-box {
  width: 100%;
  height: 350px;
  overflow: hidden;
}
.step-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}
.step-img-box:hover .step-img {
  transform: scale(1.05);
}
.step-info {
  padding: 1.2rem;
}
.step-time {
  font-size: 0.9rem;
  color: #b98852;
  margin-bottom: 0.4rem;
}
.step-title {
  font-size: 1.4rem;
  color: #8b4513;
  margin-bottom: 0.7rem;
}
.step-desc {
  font-size: 1rem;
  line-height: 1.6;
  color: #666;
}
.timeline-control {
  display: flex;
  align-items: center;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}
.ctrl-btn {
  width: 52px;
  height: 52px;
  border-radius: 50%;
  border: 2px solid #d4b891;
  background: linear-gradient(135deg, #fff 0%, #fdf9f5 100%);
  color: #8b4513;
  font-size: 1.3rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 12px rgba(139, 69, 19, 0.1);
}
.ctrl-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}
.ctrl-btn:hover:not(:disabled) {
  background: linear-gradient(135deg, #f8ede0 0%, #fdf3e0 100%);
  transform: scale(1.1);
  box-shadow: 0 6px 16px rgba(139, 69, 19, 0.2);
  border-color: #c8161d;
}
.progress-container {
  flex: 1;
  max-width: 600px;
  height: 10px;
  background: linear-gradient(90deg, #f0e6dc, #f8ede0);
  border-radius: 5px;
  position: relative;
  cursor: pointer;
  box-shadow: inset 0 2px 4px rgba(139, 69, 19, 0.1);
}
.progress-bg {
  width: 100%;
  height: 100%;
  border-radius: 5px;
}
.progress-fill {
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  background: #c8161d;
  border-radius: 5px;
  transition: width 0.3s ease;
}
.step-markers {
  position: absolute;
  top: 50%;
  left: 0;
  right: 0;
  transform: translateY(-50%);
  display: flex;
  justify-content: space-between;
  padding: 0 4px;
}
.marker {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: #fff;
  border: 2px solid #d4b891;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 4px rgba(139, 69, 19, 0.1);
}
.marker.active {
  background: #c8161d;
  border-color: #c8161d;
  transform: scale(1.3);
}
.progress-thumb {
  position: absolute;
  top: 50%;
  transform: translate(-50%, -50%);
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #c8161d;
  box-shadow: 0 2px 8px rgba(200, 22, 29, 0.3);
  cursor: grab;
  transition: left 0.3s ease;
}
.progress-thumb:hover {
  box-shadow: 0 2px 8px rgba(200, 22, 29, 0.3);
}
.play-btn {
  padding: 0.6rem 1.2rem;
  border-radius: 50px;
  border: none;
  background: #c8161d;
  color: #fff;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
}
.play-btn:hover {
  background: #a8131a;
}
.step-count {
  font-size: 1rem;
  color: #666;
  min-width: 60px;
  text-align: center;
}
.timeline-footer {
  text-align: center;
  padding: 2rem 1rem;
  font-size: 0.9rem;
  color: #999;
  border-top: 1px solid #f0e6dc;
}
@media (max-width: 768px) {
  .back-btn {
    top: 0.5rem;
    left: 0.5rem;
    padding: 6px 12px;
    font-size: 12px;
  }
  
  .header-title {
    font-size: 1.8rem;
  }
  
  .step-img-box {
    height: 280px;
  }
  
  .step-info {
    padding: 1.5rem;
  }
  
  .step-title {
    font-size: 1.5rem;
  }
}
</style>
