import { defineStore } from 'pinia'
import { getStoreById, getStoreList, getAllStores } from '../api/storeApi'
import type { Store } from '../types/store'

export const useStoreStore = defineStore('store', {
  state: () => ({
    stores: [] as Store[],
    total: 0,
    loading: false,
    error: null as string | null
  }),
  actions: {
    async fetchStore(id: number) {
      this.loading = true
      try {
        const storeData = await getStoreById(id)
        return storeData
      } catch (error) {
        this.error = '获取店铺信息失败'
        throw error
      } finally {
        this.loading = false
      }
    },
    async fetchStoreList(page: number, size: number, filters?: any) {
      this.loading = true
      try {
        const data = await getStoreList(page, size, filters)
        this.stores = data.records
        this.total = data.total
        return { records: this.stores, total: this.total }
      } catch (error) {
        this.error = '获取店铺列表失败'
        throw error
      } finally {
        this.loading = false
      }
    },
    async fetchAllStores() {
      this.loading = true
      try {
        const data = await getAllStores()
        this.stores = data
        return this.stores
      } catch (error) {
        this.error = '获取所有店铺失败'
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})