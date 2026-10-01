import { defineStore } from 'pinia'
import {
  getProductList,
  getProductById,
  getProductCategories,
  searchProducts,
  getProductsByCategory,
  getHotProducts,
  getRecommendProducts
} from '../api/productApi'
import type { Product, ProductCategory, ProductListParams } from '../types/product'

interface ProductState {
  products: Product[]
  currentProduct: Product | null
  categories: ProductCategory[]
  hotProducts: Product[]
  recommendProducts: Product[]
  loading: boolean
  error: string | null
  pagination: {
    page: number
    pageSize: number
    total: number
    totalPages: number
  }
}

export const useProductStore = defineStore('product', {
  state: (): ProductState => ({
    products: [],
    currentProduct: null,
    categories: [],
    hotProducts: [],
    recommendProducts: [],
    loading: false,
    error: null,
    pagination: {
      page: 1,
      pageSize: 10,
      total: 0,
      totalPages: 0
    }
  }),

  getters: {
    hasMore: (state) => state.pagination.page < state.pagination.totalPages
  },

  actions: {
    async fetchProducts(params: ProductListParams) {
      this.loading = true
      this.error = null
      try {
        const data = await getProductList(params)
        this.products = data.records
        this.pagination = {
          page: data.page,
          pageSize: data.pageSize,
          total: data.total,
          totalPages: data.totalPages
        }
        return data
      } catch (error) {
        this.error = '获取商品列表失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchProductById(id: number) {
      this.loading = true
      this.error = null
      try {
        const data = await getProductById(id)
        this.currentProduct = data
        return data
      } catch (error) {
        this.error = '获取商品详情失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchCategories() {
      try {
        const data = await getProductCategories()
        this.categories = data
        return data
      } catch (error) {
        this.error = '获取商品分类失败'
        throw error
      }
    },

    async searchProducts(keyword: string, page: number = 1, pageSize: number = 10) {
      this.loading = true
      try {
        const data = await searchProducts(keyword, page, pageSize)
        if (page === 1) {
          this.products = data.records
        } else {
          this.products = [...this.products, ...data.records]
        }
        this.pagination = {
          page: data.page,
          pageSize: data.pageSize,
          total: data.total,
          totalPages: data.totalPages
        }
        return data
      } catch (error) {
        this.error = '搜索商品失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchProductsByCategory(category: string, page: number = 1, pageSize: number = 10) {
      this.loading = true
      try {
        const data = await getProductsByCategory(category, page, pageSize)
        if (page === 1) {
          this.products = data.records
        } else {
          this.products = [...this.products, ...data.records]
        }
        this.pagination = {
          page: data.page,
          pageSize: data.pageSize,
          total: data.total,
          totalPages: data.totalPages
        }
        return data
      } catch (error) {
        this.error = '获取分类商品失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchHotProducts(limit: number = 10) {
      try {
        const data = await getHotProducts(limit)
        this.hotProducts = data
        return data
      } catch (error) {
        this.error = '获取热门商品失败'
        throw error
      }
    },

    async fetchRecommendProducts(limit: number = 10) {
      try {
        const data = await getRecommendProducts(limit)
        this.recommendProducts = data
        return data
      } catch (error) {
        this.error = '获取推荐商品失败'
        throw error
      }
    },

    clearCurrentProduct() {
      this.currentProduct = null
    }
  }
})
