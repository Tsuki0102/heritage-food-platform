<template>
  <div class="statistics heritage-pattern">
    <div class="admin-page-header">
      <h2 class="admin-page-title">数据统计分析</h2>
      <div class="header-actions">
        <el-date-picker
          v-model="dateRange"
          type="daterange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          @change="handleDateChange"
        ></el-date-picker>
        <el-button type="primary" @click="exportData">
          <span>📊</span>
          导出数据
        </el-button>
      </div>
    </div>

    <div class="stats-overview admin-stats-grid" v-loading="statisticsStore.loading">
      <div class="stat-card">
        <h3>总用户数</h3>
        <p class="stat-number">{{ statisticsStore.overview.userCount }}</p>
        <p class="stat-change positive">+{{ statisticsStore.overview.userGrowthRate }}%</p>
      </div>
      <div class="stat-card">
        <h3>总美食数</h3>
        <p class="stat-number">{{ statisticsStore.overview.foodCount }}</p>
        <p class="stat-change positive">+{{ statisticsStore.overview.foodGrowthRate }}%</p>
      </div>
      <div class="stat-card">
        <h3>总店铺数</h3>
        <p class="stat-number">{{ statisticsStore.overview.storeCount }}</p>
        <p class="stat-change positive">+{{ statisticsStore.overview.storeGrowthRate }}%</p>
      </div>
      <div class="stat-card">
        <h3>总帖子数</h3>
        <p class="stat-number">{{ statisticsStore.overview.postCount }}</p>
        <p class="stat-change positive">+{{ statisticsStore.overview.postGrowthRate }}%</p>
      </div>
      <div class="stat-card">
        <h3>总评论数</h3>
        <p class="stat-number">{{ statisticsStore.overview.commentCount }}</p>
        <p class="stat-change positive">+{{ statisticsStore.overview.commentGrowthRate }}%</p>
      </div>
      <div class="stat-card">
        <h3>总收藏数</h3>
        <p class="stat-number">{{ statisticsStore.overview.collectionCount }}</p>
        <p class="stat-change positive">+{{ statisticsStore.overview.collectionGrowthRate }}%</p>
      </div>
    </div>
    
    <div class="stats-charts" v-loading="statisticsStore.loading">
      <div class="admin-chart-container chart-section">
        <h3>用户增长趋势</h3>
        <div class="chart-wrapper">
          <canvas id="userGrowthChart"></canvas>
        </div>
      </div>
      <div class="admin-chart-container chart-section">
        <h3>美食分类分布</h3>
        <div class="chart-wrapper">
          <canvas id="foodCategoryChart"></canvas>
        </div>
      </div>
      <div class="admin-chart-container chart-section">
        <h3>用户地域分布</h3>
        <div class="chart-wrapper">
          <canvas id="userRegionChart"></canvas>
        </div>
      </div>
      <div class="admin-chart-container chart-section">
        <h3>活跃度分析</h3>
        <div class="chart-wrapper">
          <canvas id="activityChart"></canvas>
        </div>
      </div>
    </div>

    <div class="admin-table-wrapper stats-table heritage-corner-decoration" v-loading="statisticsStore.loading">
      <h3>热门美食排行</h3>
      <el-table :data="statisticsStore.topFoods" style="width: 100%">
        <el-table-column prop="rank" label="排名" width="80"></el-table-column>
        <el-table-column prop="name" label="美食名称"></el-table-column>
        <el-table-column prop="category" label="分类" width="120"></el-table-column>
        <el-table-column prop="likes" label="点赞数" width="100"></el-table-column>
        <el-table-column prop="comments" label="评论数" width="100"></el-table-column>
        <el-table-column prop="collections" label="收藏数" width="100"></el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick, onUnmounted } from 'vue'
import { useStatisticsStore } from '../../../stores/admin/statisticsStore'
import { ElMessage } from 'element-plus'
import Chart from 'chart.js/auto'

const statisticsStore = useStatisticsStore()
const dateRange = ref<[Date, Date]>([new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), new Date()])

let userGrowthChart: Chart | null = null
let foodCategoryChart: Chart | null = null
let userRegionChart: Chart | null = null
let activityChart: Chart | null = null

const initCharts = async () => {
  await nextTick()
  
  // 初始化用户增长趋势图表
  const userGrowthCtx = document.getElementById('userGrowthChart') as HTMLCanvasElement
  if (userGrowthCtx) {
    if (userGrowthChart) {
      userGrowthChart.destroy()
    }
    
    // 准备用户增长趋势数据
    const userTrendLabels = statisticsStore.userTrend.map(item => item.date)
    const userTrendData = statisticsStore.userTrend.map(item => item.count)
    
    userGrowthChart = new Chart(userGrowthCtx, {
      type: 'line',
      data: {
        labels: userTrendLabels,
        datasets: [{
          label: '用户增长',
          data: userTrendData,
          borderColor: '#409EFF',
          backgroundColor: 'rgba(64, 158, 255, 0.1)',
          tension: 0.4,
          fill: true,
          pointRadius: 4,
          pointHoverRadius: 6
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'top' as const
          },
          tooltip: {
            mode: 'index' as const,
            intersect: false,
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleFont: {
              size: 14
            },
            bodyFont: {
              size: 13
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: '用户数量'
            }
          },
          x: {
            title: {
              display: true,
              text: '月份'
            }
          }
        }
      }
    })
  }
  
  // 初始化美食分类分布图表
  const foodCategoryCtx = document.getElementById('foodCategoryChart') as HTMLCanvasElement
  if (foodCategoryCtx) {
    if (foodCategoryChart) {
      foodCategoryChart.destroy()
    }
    
    // 准备美食分类数据
    const foodCategoryLabels = statisticsStore.foodCategory.map(item => item.category)
    const foodCategoryData = statisticsStore.foodCategory.map(item => item.count)
    
    foodCategoryChart = new Chart(foodCategoryCtx, {
      type: 'pie',
      data: {
        labels: foodCategoryLabels,
        datasets: [{
          data: foodCategoryData,
          backgroundColor: [
            '#409EFF', '#67C23A', '#E6A23C', '#F56C6C',
            '#909399', '#722ED1', '#13C2C2', '#FAAD14'
          ],
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'right' as const
          },
          tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleFont: {
              size: 14
            },
            bodyFont: {
              size: 13
            },
            callbacks: {
              label: function(context) {
                const label = context.label || ''
                const value = context.raw as number
                const total = context.dataset.data.reduce((acc: number, val: number) => acc + val, 0)
                const percentage = Math.round((value / total) * 100)
                return `${label}: ${value} (${percentage}%)`
              }
            }
          }
        }
      }
    })
  }
  
  // 初始化用户地域分布图表
  const userRegionCtx = document.getElementById('userRegionChart') as HTMLCanvasElement
  if (userRegionCtx) {
    if (userRegionChart) {
      userRegionChart.destroy()
    }
    
    // 准备用户地域数据
    const userRegionLabels = statisticsStore.userRegion.map(item => item.region)
    const userRegionData = statisticsStore.userRegion.map(item => item.count)
    
    userRegionChart = new Chart(userRegionCtx, {
      type: 'bar',
      data: {
        labels: userRegionLabels,
        datasets: [{
          label: '用户数量',
          data: userRegionData,
          backgroundColor: '#409EFF',
          borderRadius: 4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        indexAxis: 'y' as const,
        plugins: {
          legend: {
            position: 'top' as const
          },
          tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleFont: {
              size: 14
            },
            bodyFont: {
              size: 13
            }
          }
        },
        scales: {
          x: {
            beginAtZero: true,
            title: {
              display: true,
              text: '用户数量'
            }
          }
        }
      }
    })
  }
  
  // 初始化活跃度分析图表
  const activityCtx = document.getElementById('activityChart') as HTMLCanvasElement
  if (activityCtx) {
    if (activityChart) {
      activityChart.destroy()
    }
    
    // 准备活跃度数据
    const activityLabels = statisticsStore.activityData.map(item => `${item.hour}:00`)
    const activityData = statisticsStore.activityData.map(item => item.count)
    
    activityChart = new Chart(activityCtx, {
      type: 'line',
      data: {
        labels: activityLabels,
        datasets: [{
          label: '活跃用户数',
          data: activityData,
          borderColor: '#67C23A',
          backgroundColor: 'rgba(103, 194, 58, 0.1)',
          tension: 0.4,
          fill: true,
          pointRadius: 3,
          pointHoverRadius: 5
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'top' as const
          },
          tooltip: {
            mode: 'index' as const,
            intersect: false,
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleFont: {
              size: 14
            },
            bodyFont: {
              size: 13
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: '活跃用户数'
            }
          },
          x: {
            title: {
              display: true,
              text: '时间'
            }
          }
        }
      }
    })
  }
}

const handleDateChange = async (val: [Date, Date] | null) => {
  if (!val) return
  
  try {
    const startDate = val[0].toISOString()
    const endDate = val[1].toISOString()
    await statisticsStore.fetchStatisticsByDateRange(startDate, endDate)
    initCharts()
  } catch (error) {
    ElMessage.error('获取统计数据失败')
  }
}

const exportData = async () => {
  try {
    const startDate = dateRange.value[0].toISOString()
    const endDate = dateRange.value[1].toISOString()
    const success = await statisticsStore.exportData(startDate, endDate)
    if (success) {
      ElMessage.success('数据导出成功')
    } else {
      ElMessage.error('数据导出失败')
    }
  } catch (error) {
    ElMessage.error('数据导出失败')
  }
}

onMounted(async () => {
  try {
    const startDate = dateRange.value[0].toISOString()
    const endDate = dateRange.value[1].toISOString()
    await statisticsStore.fetchStatisticsByDateRange(startDate, endDate)
    initCharts()
  } catch (error) {
    ElMessage.error('获取统计数据失败')
  }
})

onUnmounted(() => {
  // 清理Chart实例，避免内存泄漏
  if (userGrowthChart) {
    userGrowthChart.destroy()
  }
  if (foodCategoryChart) {
    foodCategoryChart.destroy()
  }
  if (userRegionChart) {
    userRegionChart.destroy()
  }
  if (activityChart) {
    activityChart.destroy()
  }
})
</script>

<style scoped>
.statistics {
  padding: 8px 0;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
}

.header-actions :deep(.el-button) {
  border-radius: 24px;
  padding: 10px 20px;
  font-weight: 600;
  letter-spacing: 1px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.header-actions :deep(.el-button:hover) {
  transform: translateY(-2px);
  box-shadow: var(--shadow-primary);
}

.admin-stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: var(--spacing-lg);
  margin-bottom: var(--spacing-xl);
}

.admin-stats-grid .stat-card {
  background: var(--gradient-card);
  border-radius: var(--radius-md);
  padding: var(--spacing-lg) var(--spacing-md);
  box-shadow: var(--shadow-admin);
  text-align: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid transparent;
  position: relative;
  overflow: hidden;
}

.admin-stats-grid .stat-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.admin-stats-grid .stat-card:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-admin-hover);
  border-color: var(--border-gold);
}

.admin-stats-grid .stat-card:hover::before {
  opacity: 1;
}

.admin-stats-grid .stat-card h3 {
  font-size: 14px;
  color: var(--admin-text-secondary);
  margin: 0 0 var(--spacing-sm) 0;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.admin-stats-grid .stat-number {
  font-size: 26px;
  font-weight: 800;
  color: var(--primary-color);
  margin: 0 0 var(--spacing-xs) 0;
  letter-spacing: -0.5px;
}

.admin-stats-grid .stat-change {
  font-size: 13px;
  margin: 0;
  font-weight: 600;
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

.admin-stats-grid .stat-change.positive {
  color: #52c41a;
  background: rgba(82, 196, 26, 0.08);
  padding: 2px 10px;
  border-radius: 12px;
}

.admin-stats-grid .stat-change.negative {
  color: #ff4d4f;
  background: rgba(255, 77, 79, 0.08);
  padding: 2px 10px;
  border-radius: 12px;
}

.stats-charts {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(420px, 1fr));
  gap: var(--spacing-lg);
  margin-bottom: var(--spacing-xl);
}

.stats-table {
  padding: var(--spacing-xl);
}

.stats-table h3 {
  font-size: 18px;
  color: var(--admin-text-primary);
  margin: 0 0 var(--spacing-lg) 0;
  position: relative;
  padding-left: 16px;
}

.stats-table h3::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 20px;
  background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
  border-radius: 2px;
}

@media (max-width: 1024px) {
  .stats-charts {
    grid-template-columns: 1fr;
  }

  .chart-wrapper {
    height: 280px;
  }
}

@media (max-width: 768px) {
  .admin-page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--spacing-md);
    padding: var(--spacing-md);
  }

  .header-actions {
    width: 100%;
    flex-direction: column;
    align-items: stretch;
    gap: var(--spacing-sm);
  }

  .admin-stats-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: var(--spacing-md);
    margin-bottom: var(--spacing-lg);
  }

  .stats-charts {
    margin-bottom: var(--spacing-lg);
  }

  .chart-wrapper {
    height: 240px;
  }

  .stats-table {
    padding: var(--spacing-lg) var(--spacing-md);
  }
}

@media (max-width: 480px) {
  .admin-stats-grid {
    grid-template-columns: 1fr;
  }

  .chart-wrapper {
    height: 200px;
  }
}
</style>