import { defineStore } from 'pinia'
import { defineStore as _defineStore } from 'pinia'
import {
  getCartList,
  addToCart,
  updateCartItem,
  removeFromCart,
  clearCart,
  getCartCount
} from '../api/cartApi'
import type { CartItem } from '../types/cart'

interface CartState {
  items: CartItem[]
  loading: boolean
  error: string | null
}

export const useCartStore = defineStore('cart', {
  state: (): CartState => ({
    items: [],
    loading: false,
    error: null
  }),

  getters: {
    totalAmount(): number {
      return this.items.reduce((sum, item) => {
        return sum + (item.product?.price || 0) * item.quantity
      }, 0)
    },

    totalCount(): number {
      return this.items.reduce((sum, item) => sum + item.quantity, 0)
    },

    isEmpty(): boolean {
      return this.items.length === 0
    }
  },

  actions: {
    async fetchCartList() {
      this.loading = true
      this.error = null
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        const userId = userInfo.id || 8637
        const data = await getCartList(userId)
        this.items = data.records
        return data
      } catch (error) {
        this.error = '获取购物车列表失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async addItem(productId: number, quantity: number = 1) {
      this.loading = true
      this.error = null
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        const userId = userInfo.id || 8637
        const item = await addToCart(userId, { productId, quantity })
        const existingIndex = this.items.findIndex(i => i.productId === productId)
        if (existingIndex >= 0) {
          this.items[existingIndex] = item
        } else {
          this.items.push(item)
        }
        return item
      } catch (error) {
        this.error = '添加购物车失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async updateItem(id: number, quantity: number) {
      this.loading = true
      this.error = null
      try {
        const item = await updateCartItem(id, quantity)
        const index = this.items.findIndex(i => i.id === id)
        if (index >= 0) {
          this.items[index] = item
        }
        return item
      } catch (error) {
        this.error = '更新购物车失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async removeItem(id: number) {
      this.loading = true
      this.error = null
      try {
        await removeFromCart(id)
        this.items = this.items.filter(item => item.id !== id)
      } catch (error) {
        this.error = '删除购物车商品失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async clearAll() {
      this.loading = true
      this.error = null
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        const userId = userInfo.id || 8637
        await clearCart(userId)
        this.items = []
      } catch (error) {
        this.error = '清空购物车失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchCartCount() {
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        const userId = userInfo.id || 8637
        const data = await getCartCount(userId)
        return data.count
      } catch (error) {
        throw error
      }
    },

    incrementQuantity(id: number) {
      const item = this.items.find(i => i.id === id)
      if (item && item.product && item.quantity < item.product.stock) {
        this.updateItem(id, item.quantity + 1)
      }
    },

    decrementQuantity(id: number) {
      const item = this.items.find(i => i.id === id)
      if (item && item.quantity > 1) {
        this.updateItem(id, item.quantity - 1)
      }
    }
  }
})
