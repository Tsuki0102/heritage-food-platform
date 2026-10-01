<template>
  <div class="admin-dashboard heritage-cloud-pattern">
    <div class="dashboard-header heritage-meander-border">
      <div class="header-left-section">
        <div class="header-icon-wrapper">
          <span class="heritage-seal header-seal">📊</span>
        </div>
        <div class="header-text-content">
          <h1 class="dashboard-title">
            <span class="title-heritage">龍</span>
            数据总览
          </h1>
          <p class="dashboard-subtitle">实时监控 · 数据洞察 · 智能分析</p>
        </div>
      </div>
      <div class="header-right-section">
        <div class="refresh-indicator" :class="{ refreshing: isRefreshing }">
          <span class="refresh-icon">🔄</span>
          <span class="refresh-text">{{ isRefreshing ? '刷新中...' : '自动刷新' }}</span>
        </div>
        <button class="manual-refresh-btn" @click="handleRefresh" title="手动刷新数据">
          <span>⟳</span>
        </button>
      </div>
    </div>

    <div class="dashboard-cards">
      <div class="stats-card-wrapper" v-for="(card, index) in statsCards" :key="card.key"
           :style="{ '--delay': index * 0.1 + 's', '--card-color': card.color, '--card-bg': card.bgColor }">
        <div class="admin-stats-card heritage-card">
          <div class="card-heritage-decoration"></div>
          <div class="card-top-row">
            <div class="admin-card-icon card-icon-enhanced" :style="{ background: card.iconBg, color: card.color }">
              {{ card.icon }}
              <span class="icon-glow"></span>
            </div>
            <div class="card-trend-badge" :class="card.trend > 0 ? 'trend-up' : 'trend-down'">
              <span>{{ card.trend > 0 ? '↑' : '↓' }}</span>
              <span>{{ Math.abs(card.trend) }}%</span>
            </div>
          </div>
          <div class="admin-card-content">
            <h3 class="card-label">{{ card.label }}</h3>
            <p class="admin-card-number card-value">
              <span v-if="card.key !== 'userCount'" class="value-prefix">¥</span>
              {{ statisticsStore.overview[card.key] || 0 }}
              <span v-if="card.suffix" class="value-suffix">{{ card.suffix }}</span>
            </p>
            <div class="card-progress-bar">
              <div class="progress-fill" :style="{ width: card.progress + '%' }"></div>
            </div>
          </div>
          <div class="card-footer-info">
            <span class="info-label">较上月</span>
            <span class="info-value" :class="card.trend > 0 ? 'positive' : 'negative'">
              {{ card.trend > 0 ? '+' : '' }}{{ card.change }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <div class="dashboard-charts">
      <div class="chart-section-header">
        <h2 class="charts-main-title">
          <span class="title-decorator">❋</span>
          数据可视化分析
        </h2>
        <p class="charts-subtitle">多维度展示平台运营状况</p>
      </div>

      <div class="charts-grid">
        <div class="admin-chart-container chart-card gold-shimmer-border">
          <div class="chart-header-enhanced">
            <div class="chart-title-group">
              <span class="chart-icon-badge user-chart-icon">📈</span>
              <h3>用户增长趋势</h3>
            </div>
            <div class="chart-actions">
              <span class="chart-period-badge">近7天</span>
            </div>
          </div>
          <div class="chart-wrapper chart-wrapper-enhanced">
            <canvas id="userTrendChart"></canvas>
          </div>
          <div class="chart-footer-stats">
            <div class="stat-item">
              <span class="stat-value-small">+12.5%</span>
              <span class="stat-label-small">周增长率</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <span class="stat-value-small">2,847</span>
              <span class="stat-label-small">本周新增</span>
            </div>
          </div>
        </div>

        <div class="admin-chart-container chart-card gold-shimmer-border">
          <div class="chart-header-enhanced">
            <div class="chart-title-group">
              <span class="chart-icon-badge food-chart-icon">🍜</span>
              <h3>美食分类分布</h3>
            </div>
            <div class="chart-actions">
              <span class="chart-period-badge">实时</span>
            </div>
          </div>
          <div class="chart-wrapper chart-wrapper-enhanced">
            <canvas id="foodCategoryChart"></canvas>
          </div>
          <div class="chart-footer-stats">
            <div class="stat-item">
              <span class="stat-value-small">8</span>
              <span class="stat-label-small">分类总数</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <span class="stat-value-small">1,256</span>
              <span class="stat-label-small">热门菜品</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="activity-section heritage-corner-decoration">
      <div class="activity-header">
        <div class="activity-title-group">
          <span class="activity-badge-icon">🏮</span>
          <h2 class="activity-main-title">最近动态</h2>
        </div>
        <div class="activity-filter-tabs">
          <button class="filter-tab active">全部</button>
          <button class="filter-tab">用户</button>
          <button class="filter-tab">内容</button>
          <button class="filter-tab">系统</button>
        </div>
      </div>

      <div class="admin-activity-list activity-list-enhanced">
        <div class="activities-container">
          <div class="admin-activity-item activity-item-enhanced"
               v-for="(activity, index) in recentActivities"
               :key="activity.id"
               :style="{ '--item-delay': index * 0.08 + 's' }">
            <div class="activity-icon-enhanced" :class="'icon-type-' + (index % 4)">
              <span class="activity-emoji">{{ activity.icon }}</span>
              <span class="icon-pulse-ring"></span>
            </div>
            <div class="activity-content-enhanced">
              <p class="activity-description">{{ activity.description }}</p>
              <div class="activity-meta">
                <span class="activity-time-enhanced">
                  <span class="time-icon-mini">🕐</span>
                  {{ activity.time }}
                </span>
                <span class="activity-type-tag" :class="'tag-type-' + (index % 4)">
                  {{ getActivityType(index) }}
                </span>
              </div>
            </div>
            <div class="activity-arrow">→</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, nextTick, computed } from 'vue'
import { useStatisticsStore } from '../../../stores/admin/statisticsStore'
import Chart from 'chart.js/auto'

const statisticsStore = useStatisticsStore()
const isRefreshing = ref(false)

const statsCards = computed(() => [
  {
    key: 'userCount',
    label: '用户总数',
    icon: '👥',
    color: '#c8161d',
    bgColor: 'rgba(200,22,29,0.06)',
    iconBg: 'linear-gradient(135deg, rgba(200,22,29,0.15), rgba(200,22,29,0.05))',
    trend: 12.5,
    change: '+156人',
    progress: 75,
    suffix: ''
  },
  {
    key: 'foodCount',
    label: '美食总数',
    icon: '🍜',
    color: '#d4af37',
    bgColor: 'rgba(212,175,55,0.08)',
    iconBg: 'linear-gradient(135deg, rgba(212,175,55,0.18), rgba(212,175,55,0.06))',
    trend: 8.3,
    change: '+42道',
    progress: 60,
    suffix: '道'
  },
  {
    key: 'storeCount',
    label: '店铺总数',
    icon: '🏪',
    color: '#52c41a',
    bgColor: 'rgba(82,196,26,0.06)',
    iconBg: 'linear-gradient(135deg, rgba(82,196,26,0.15), rgba(82,196,26,0.05))',
    trend: 15.7,
    change: '+18家',
    progress: 85,
    suffix: '家'
  },
  {
    key: 'postCount',
    label: '社区帖子',
    icon: '💬',
    color: '#1890ff',
    bgColor: 'rgba(24,144,255,0.06)',
    iconBg: 'linear-gradient(135deg, rgba(24,144,255,0.15), rgba(24,144,255,0.05))',
    trend: 23.1,
    change: '+289篇',
    progress: 92,
    suffix: '篇'
  }
])

const recentActivities = ref([
  { id: 1, icon: '👤', description: '新用户「张三」完成注册，来自北京', time: '刚刚' },
  { id: 2, icon: '🍜', description: '新增非遗美食：北京烤鸭（全聚德）', time: '5分钟前' },
  { id: 3, icon: '💬', description: '用户「李四」发布美食体验帖：老字号探店', time: '12分钟前' },
  { id: 4, icon: '🏪', description: '非遗店铺「全聚德」入驻平台审核通过', time: '25分钟前' },
  { id: 5, icon: '⭐', description: '用户「王五」对「狗不理包子」给出五星好评', time: '38分钟前' }
])

const getActivityType = (index: number): string => {
  const types = ['用户动态', '内容更新', '商家入驻', '互动反馈']
  return types[index % types.length]
}

const handleRefresh = async () => {
  isRefreshing.value = true
  await new Promise(resolve => setTimeout(resolve, 1500))
  isRefreshing.value = false
}

let refreshInterval = null
let userTrendChart: Chart | null = null
let foodCategoryChart: Chart | null = null

onMounted(async () => {
  await statisticsStore.fetchOverview()
  await nextTick()
  initCharts()
  startAutoRefresh()
})

onUnmounted(() => {
  if (refreshInterval) clearInterval(refreshInterval)
  if (userTrendChart) userTrendChart.destroy()
  if (foodCategoryChart) foodCategoryChart.destroy()
})

const initCharts = () => {
  const userTrendCtx = document.getElementById('userTrendChart') as HTMLCanvasElement
  const foodCategoryCtx = document.getElementById('foodCategoryChart') as HTMLCanvasElement

  if (userTrendCtx) {
    userTrendChart = new Chart(userTrendCtx, {
      type: 'line',
      data: {
        labels: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
        datasets: [{
          label: '新增用户',
          data: [65, 78, 90, 81, 96, 115, 130],
          borderColor: '#c8161d',
          backgroundColor: 'rgba(200,22,29,0.1)',
          fill: true,
          tension: 0.4,
          pointRadius: 5,
          pointHoverRadius: 8,
          pointBackgroundColor: '#c8161d',
          pointBorderColor: '#fff',
          pointBorderWidth: 2
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
          y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' } },
          x: { grid: { display: false } }
        }
      }
    })
  }

  if (foodCategoryCtx) {
    foodCategoryChart = new Chart(foodCategoryCtx, {
      type: 'doughnut',
      data: {
        labels: ['面食', '糕点', '小吃', '汤品', '烧烤', '甜品', '凉菜', '其他'],
        datasets: [{
          data: [25, 18, 15, 12, 10, 9, 6, 5],
          backgroundColor: [
            '#c8161d', '#d4af37', '#52c41a', '#1890ff',
            '#722ed1', '#fa8c16', '#13c2c2', '#eb2f96'
          ],
          borderWidth: 0,
          hoverOffset: 8
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: 'right' }
        }
      }
    })
  }
}

const startAutoRefresh = () => {
  refreshInterval = setInterval(() => {
    statisticsStore.fetchOverview()
  }, 300000)
}
</script>

<style scoped>
.admin-dashboard {
  padding: 4px 0;
}

.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-xl);
  padding: var(--spacing-lg) var(--spacing-xl);
  background: linear-gradient(135deg, rgba(255,255,255,0.98), rgba(250,245,235,0.95));
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-heritage);
  animation: fadeInDown 0.6s ease-out;
}

.header-left-section {
  display: flex;
  align-items: center;
  gap: var(--spacing-lg);
}

.header-icon-wrapper {
  animation: iconPulse 3s ease-in-out infinite;
}

.header-seal {
  font-size: 36px !important;
  min-width: 64px;
  height: 64px;
  border-width: 3px !important;
}

.header-text-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.dashboard-title {
  font-size: 26px;
  color: var(--admin-text-primary);
  margin: 0;
  font-weight: 800;
  letter-spacing: 2px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.title-heritage {
  font-size: 28px;
  color: var(--secondary-color);
  text-shadow: 0 0 15px rgba(212,175,55,0.4);
  animation: iconPulse 4s ease-in-out infinite;
}

.dashboard-subtitle {
  font-size: 13px;
  color: var(--admin-text-muted);
  letter-spacing: 3px;
  margin-left: 44px;
}

.header-right-section {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
}

.refresh-indicator {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  background: linear-gradient(135deg, rgba(82,196,26,0.08), rgba(82,196,26,0.04));
  border-radius: 20px;
  border: 1px solid rgba(82,196,26,0.15);
}

.refresh-indicator.refreshing .refresh-icon {
  animation: spin 1s linear infinite;
}

.refresh-icon {
  font-size: 14px;
}

.refresh-text {
  font-size: 12px;
  color: #52c41a;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.manual-refresh-btn {
  width: 40px;
  height: 40px;
  border: none;
  background: linear-gradient(135deg, var(--primary-color), #a8131a);
  border-radius: 50%;
  cursor: pointer;
  color: white;
  font-size: 18px;
  transition: all 0.35s cubic-bezier(0.68,-0.55,0.265,1.55);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: var(--shadow-primary);
}

.manual-refresh-btn:hover {
  transform: rotate(180deg) scale(1.1);
  box-shadow: var(--shadow-golden);
}

.stats-card-wrapper {
  animation: fadeInUp 0.6s ease-out both;
  animation-delay: var(--delay);
}

.heritage-card {
  position: relative;
  overflow: hidden;
}

.card-heritage-decoration {
  position: absolute;
  top: -20px;
  right: -20px;
  width: 80px;
  height: 80px;
  background: radial-gradient(circle, var(--card-color) 0%, transparent 70%);
  opacity: 0.06;
  border-radius: 50%;
  pointer-events: none;
}

.card-top-row {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: var(--spacing-md);
}

.card-icon-enhanced {
  position: relative;
  overflow: visible;
}

.icon-glow {
  position: absolute;
  inset: -4px;
  background: inherit;
  filter: blur(8px);
  opacity: 0.3;
  border-radius: inherit;
  z-index: -1;
  transition: all 0.3s ease;
}

.heritage-card:hover .icon-glow {
  opacity: 0.5;
  filter: blur(12px);
}

.card-trend-badge {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.5px;
}

.trend-up {
  background: rgba(82,196,26,0.1);
  color: #52c41a;
  border: 1px solid rgba(82,196,26,0.2);
}

.trend-down {
  background: rgba(255,77,79,0.1);
  color: #ff4d4f;
  border: 1px solid rgba(255,77,79,0.15);
}

.card-label {
  font-size: 13px;
  color: var(--admin-text-secondary);
  margin-bottom: 8px;
  font-weight: 600;
  letter-spacing: 1px;
  text-transform: uppercase;
}

.card-value {
  display: flex;
  align-items: baseline;
  gap: 4px;
}

.value-prefix {
  font-size: 18px;
  font-weight: 700;
  color: var(--card-color);
  opacity: 0.7;
}

.value-suffix {
  font-size: 14px;
  font-weight: 600;
  color: var(--admin-text-muted);
  margin-left: 4px;
}

.card-progress-bar {
  height: 4px;
  background: rgba(0,0,0,0.05);
  border-radius: 2px;
  margin-top: var(--spacing-sm);
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--card-color), var(--secondary-color));
  border-radius: 2px;
  transition: width 1s cubic-bezier(0.4,0,0.2,1);
  position: relative;
}

.progress-fill::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(90deg, transparent 0%, rgba(255,255,255,0.4) 50%, transparent 100%);
  animation: shimmerMove 2s ease-in-out infinite;
}

.card-footer-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: var(--spacing-sm);
  padding-top: var(--spacing-sm);
  border-top: 1px solid rgba(0,0,0,0.04);
}

.info-label {
  font-size: 11px;
  color: var(--admin-text-muted);
  letter-spacing: 0.5px;
}

.info-value {
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.5px;
}

.info-value.positive { color: #52c41a; }
.info-value.negative { color: #ff4d4f; }

.dashboard-charts {
  margin-bottom: var(--spacing-xl);
}

.chart-section-header {
  margin-bottom: var(--spacing-lg);
  padding: 0 var(--spacing-xs);
}

.charts-main-title {
  font-size: 20px;
  color: var(--admin-text-primary);
  margin: 0 0 6px 0;
  font-weight: 800;
  letter-spacing: 1.5px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.title-decorator {
  font-size: 24px;
  animation: iconPulse 3s ease-in-out infinite;
}

.charts-subtitle {
  font-size: 13px;
  color: var(--admin-text-muted);
  margin: 0 0 0 34px;
  letter-spacing: 1px;
}

.charts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
  gap: var(--spacing-lg);
}

.chart-card {
  padding: var(--spacing-xl);
  position: relative;
  overflow: hidden;
}

.chart-header-enhanced {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-md);
}

.chart-title-group {
  display: flex;
  align-items: center;
  gap: 10px;
}

.chart-icon-badge {
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
}

.user-chart-icon {
  background: linear-gradient(135deg, rgba(200,22,29,0.12), rgba(200,22,29,0.04));
}

.food-chart-icon {
  background: linear-gradient(135deg, rgba(212,175,55,0.15), rgba(212,175,55,0.05));
}

.chart-title-group h3 {
  font-size: 16px;
  font-weight: 700;
  color: var(--admin-text-primary);
  margin: 0;
  letter-spacing: 0.5px;
}

.chart-period-badge {
  font-size: 11px;
  color: var(--secondary-color);
  background: rgba(212,175,55,0.1);
  padding: 4px 12px;
  border-radius: 12px;
  font-weight: 600;
  letter-spacing: 0.5px;
  border: 1px solid rgba(212,175,55,0.15);
}

.chart-wrapper-enhanced {
  height: 280px;
  background: linear-gradient(135deg, rgba(200,22,29,0.02), rgba(212,175,55,0.02));
  border-radius: var(--radius-sm);
  padding: var(--spacing-md);
  position: relative;
}

.chart-footer-stats {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--spacing-lg);
  margin-top: var(--spacing-md);
  padding-top: var(--spacing-md);
  border-top: 1px dashed var(--border-gold);
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.stat-value-small {
  font-size: 16px;
  font-weight: 800;
  color: var(--primary-color);
  letter-spacing: -0.5px;
}

.stat-label-small {
  font-size: 11px;
  color: var(--admin-text-muted);
  letter-spacing: 0.5px;
}

.stat-divider {
  width: 1px;
  height: 30px;
  background: linear-gradient(180deg, transparent, var(--border-gold), transparent);
}

.activity-section {
  background: var(--gradient-card);
  border-radius: var(--radius-lg);
  padding: var(--spacing-xl);
  box-shadow: var(--shadow-admin);
  border: 1px solid var(--border-gold);
  animation: fadeInUp 0.6s ease-out 0.4s both;
}

.activity-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-lg);
  padding-bottom: var(--spacing-md);
  border-bottom: 2px solid var(--border-gold);
}

.activity-title-group {
  display: flex;
  align-items: center;
  gap: 12px;
}

.activity-badge-icon {
  font-size: 28px;
  animation: iconPulse 3s ease-in-out infinite;
}

.activity-main-title {
  font-size: 19px;
  color: var(--admin-text-primary);
  margin: 0;
  font-weight: 800;
  letter-spacing: 1.5px;
}

.activity-filter-tabs {
  display: flex;
  gap: 6px;
  background: var(--bg-cream);
  padding: 5px;
  border-radius: 20px;
  border: 1px solid var(--border-gold);
}

.filter-tab {
  padding: 8px 18px;
  border: none;
  background: transparent;
  cursor: pointer;
  font-size: 13px;
  font-weight: 500;
  color: var(--admin-text-secondary);
  border-radius: 16px;
  transition: all 0.3s ease;
  letter-spacing: 0.5px;
}

.filter-tab:hover {
  color: var(--primary-color);
  background: rgba(200,22,29,0.05);
}

.filter-tab.active {
  background: var(--gradient-primary);
  color: white;
  font-weight: 600;
  box-shadow: var(--shadow-primary);
}

.activity-list-enhanced {
  background: transparent;
  box-shadow: none;
  padding: 0;
}

.activities-container {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-sm);
}

.activity-item-enhanced {
  padding: var(--spacing-md) var(--spacing-lg);
  border: 1px solid var(--border-gold);
  border-radius: var(--radius-md);
  transition: all 0.4s cubic-bezier(0.4,0,0.2,1);
  animation: fadeInUp 0.5s ease-out both;
  animation-delay: var(--item-delay);
  background: var(--bg-white);
}

.activity-item-enhanced:hover {
  transform: translateX(8px);
  box-shadow: var(--shadow-heritage);
  border-color: var(--primary-color);
  background: linear-gradient(135deg, rgba(200,22,29,0.02), rgba(212,175,55,0.03));
}

.activity-icon-enhanced {
  width: 48px;
  height: 48px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  position: relative;
  flex-shrink: 0;
  transition: all 0.4s cubic-bezier(0.68,-0.55,0.265,1.55);
}

.icon-type-0 { background: linear-gradient(135deg, rgba(200,22,29,0.12), rgba(200,22,29,0.04)); }
.icon-type-1 { background: linear-gradient(135deg, rgba(212,175,55,0.15), rgba(212,175,55,0.05)); }
.icon-type-2 { background: linear-gradient(135deg, rgba(82,196,26,0.12), rgba(82,196,26,0.04)); }
.icon-type-3 { background: linear-gradient(135deg, rgba(24,144,255,0.12), rgba(24,144,255,0.04)); }

.icon-pulse-ring {
  position: absolute;
  inset: -3px;
  border-radius: inherit;
  border: 2px solid currentColor;
  opacity: 0;
  animation: iconPulse 2s ease-out infinite;
}

.activity-item-enhanced:hover .activity-icon-enhanced {
  transform: scale(1.15) rotate(-8deg);
}

.activity-item-enhanced:hover .icon-pulse-ring {
  opacity: 0.3;
}

.activity-emoji {
  position: relative;
  z-index: 1;
}

.activity-content-enhanced {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.activity-description {
  font-size: 14px;
  color: var(--admin-text-primary);
  font-weight: 500;
  line-height: 1.5;
  margin: 0;
}

.activity-meta {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
}

.activity-time-enhanced {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: var(--admin-text-muted);
}

.time-icon-mini {
  font-size: 12px;
}

.activity-type-tag {
  font-size: 11px;
  padding: 2px 10px;
  border-radius: 10px;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.tag-type-0 { background: rgba(200,22,29,0.1); color: #c8161d; }
.tag-type-1 { background: rgba(212,175,55,0.12); color: #b8860b; }
.tag-type-2 { background: rgba(82,196,26,0.1); color: #389e0d; }
.tag-type-3 { background: rgba(24,144,255,0.1); color: #096dd9; }

.activity-arrow {
  font-size: 18px;
  color: var(--admin-text-muted);
  opacity: 0;
  transform: translateX(-10px);
  transition: all 0.3s ease;
}

.activity-item-enhanced:hover .activity-arrow {
  opacity: 1;
  transform: translateX(0);
  color: var(--primary-color);
}

@media (max-width: 1024px) {
  .charts-grid { grid-template-columns: 1fr; }
  .chart-wrapper-enhanced { height: 260px; }
}

.dashboard-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: var(--spacing-lg);
  margin-bottom: var(--spacing-xl);
}

@media (max-width: 1024px) {
  .charts-grid { grid-template-columns: 1fr; }
  .chart-wrapper-enhanced { height: 260px; }
}

@media (max-width: 768px) {
  .dashboard-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--spacing-md);
    padding: var(--spacing-lg) var(--spacing-md);
  }

  .header-right-section {
    width: 100%;
    justify-content: flex-start;
  }

  .dashboard-cards {
    grid-template-columns: repeat(2, 1fr);
    gap: var(--spacing-md);
    margin-bottom: var(--spacing-lg);
  }

  .charts-grid { margin-bottom: var(--spacing-lg); }
  .chart-wrapper-enhanced { height: 240px; }

  .activity-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--spacing-md);
  }

  .activity-filter-tabs {
    width: 100%;
    overflow-x: auto;
  }

  .activity-section {
    padding: var(--spacing-lg) var(--spacing-md);
  }
}

@media (max-width: 480px) {
  .dashboard-cards { grid-template-columns: 1fr; }
  .chart-wrapper-enhanced { height: 200px; }

  .dashboard-title { font-size: 22px; }
  .header-seal { min-width: 52px; height: 52px; font-size: 28px !important; }
}
</style>