import { defineStore } from 'pinia'
import { getFoodById, getFoodList, getHotFoodList } from '../api/foodApi'
import type { Food } from '../types/food'

export const useFoodStore = defineStore('food', {
  state: () => ({
    foods: [] as Food[],
    recommendedFoods: [] as Food[],
    hotFoods: [] as Food[],
    loading: false,
    error: null as string | null
  }),
  getters: {
    getRecommendedFoods: (state) => state.recommendedFoods,
    getHotFoods: (state) => state.hotFoods
  },
  actions: {
    async fetchFood(id: number) {
      this.loading = true
      try {
        const foodData = await getFoodById(id)
        return foodData
      } catch (error) {
        this.error = '获取美食信息失败'
        throw error
      } finally {
        this.loading = false
      }
    },
    async fetchRecommendedFoods() {
      this.loading = true
      try {
        console.log('开始获取推荐美食')
        const data = await getFoodList(1, 6)
        console.log('推荐美食数据:', data)
        this.recommendedFoods = data.records
        return this.recommendedFoods
      } catch (error) {
        this.error = '获取推荐美食失败'
        console.error('获取推荐美食失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },
    async fetchHotFoods() {
      this.loading = true
      try {
        const data = await getHotFoodList(1, 3)
        this.hotFoods = data.records
        return this.hotFoods
      } catch (error) {
        this.error = '获取热门美食失败'
        throw error
      } finally {
        this.loading = false
      }
    },
    async fetchRelatedFoods(id: number) {
      this.loading = true
      try {
        // 由于后端没有相关美食API，暂时从推荐美食中筛选
        if (this.recommendedFoods.length === 0) {
          await this.fetchRecommendedFoods()
        }
        return this.recommendedFoods.filter(food => food.id !== id).slice(0, 2)
      } catch (error) {
        this.error = '获取相关美食失败'
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})