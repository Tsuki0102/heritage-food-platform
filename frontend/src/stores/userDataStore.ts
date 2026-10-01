import { defineStore } from 'pinia'
import { Storage, generateId } from '../utils'
import { logger, LogCategory } from '../utils/logger'
import { STORAGE_KEYS, DEFAULT_IMAGES } from '../constants'
import type { UserData, CollectionItem, HistoryRecord, HistoryDay } from '../types'

const DEFAULT_USER_DATA: UserData = {
  collections: {
    foods: [],
    stores: []
  },
  history: []
}

export const useUserDataStore = defineStore('userData', {
  state: () => ({
    ...Storage.get<UserData>(STORAGE_KEYS.USER_DATA, DEFAULT_USER_DATA)
  }),
  
  getters: {
    getFoodCollections: (state) => state.collections.foods,
    getStoreCollections: (state) => state.collections.stores,
    getAllCollections: (state) => [...state.collections.foods, ...state.collections.stores],
    getTodayHistory: (state) => {
      const today = new Date().toISOString().split('T')[0]
      const todayHistory = state.history.find(day => day.date === today)
      return todayHistory?.records || []
    }
  },
  
  actions: {
    saveData(): void {
      Storage.set(STORAGE_KEYS.USER_DATA, this)
    },

    getTodayDate(): string {
      return new Date().toISOString().split('T')[0]
    },

    getCurrentTime(): string {
      const now = new Date()
      return `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`
    },

    addCollection(type: 'foods' | 'stores', item: CollectionItem): boolean {
      const existingIndex = this.collections[type].findIndex(i => i.id === item.id)
      if (existingIndex !== -1) {
        logger.warn(LogCategory.USER_DATA, 'Item already collected', { itemId: item.id, type })
        return false
      }
      
      this.collections[type].push(item)
      this.saveData()
      logger.info(LogCategory.USER_DATA, 'Collection added', { itemId: item.id, type })
      return true
    },
    
    removeCollection(type: 'foods' | 'stores', id: number): boolean {
      const initialLength = this.collections[type].length
      this.collections[type] = this.collections[type].filter(item => item.id !== id)
      
      if (this.collections[type].length !== initialLength) {
        this.saveData()
        logger.info(LogCategory.USER_DATA, 'Collection removed', { itemId: id, type })
        return true
      }
      
      logger.warn(LogCategory.USER_DATA, 'Collection not found', { itemId: id, type })
      return false
    },
    
    isCollected(type: 'foods' | 'stores', id: number): boolean {
      return this.collections[type].some(item => item.id === id)
    },
    
    toggleCollection(type: 'foods' | 'stores', item: CollectionItem): boolean {
      if (this.isCollected(type, item.id)) {
        return this.removeCollection(type, item.id)
      } else {
        return this.addCollection(type, item)
      }
    },

    clearCollections(type?: 'foods' | 'stores'): boolean {
      if (type) {
        this.collections[type] = []
      } else {
        this.collections.foods = []
        this.collections.stores = []
      }
      this.saveData()
      logger.info(LogCategory.USER_DATA, 'Collections cleared', { type: type || 'all' })
      return true
    },
    
    addHistory(item: HistoryRecord, type: 'food' | 'store'): boolean {
      const today = this.getTodayDate()
      const currentTime = this.getCurrentTime()
      
      let todayHistory = this.history.find(day => day.date === today)
      
      if (!todayHistory) {
        todayHistory = {
          date: today,
          records: []
        }
        this.history.unshift(todayHistory)
      }
      
      const existingIndex = todayHistory.records.findIndex(
        record => record.id === item.id && record.type === type
      )
      
      if (existingIndex !== -1) {
        todayHistory.records[existingIndex].time = currentTime
        logger.info(LogCategory.USER_DATA, 'History updated', { itemId: item.id, type })
      } else {
        todayHistory.records.unshift({
          ...item,
          time: currentTime,
          type
        })
        logger.info(LogCategory.USER_DATA, 'History added', { itemId: item.id, type })
      }
      
      this.limitHistorySize()
      this.saveData()
      return true
    },
    
    clearHistory(): boolean {
      this.history = []
      this.saveData()
      logger.info(LogCategory.USER_DATA, 'History cleared')
      return true
    },

    limitHistorySize(maxDays: number = 30): void {
      if (this.history.length > maxDays) {
        this.history = this.history.slice(0, maxDays)
        logger.info(LogCategory.USER_DATA, 'History limited', { maxDays })
      }
    },

    getHistoryByDate(date: string): HistoryRecord[] {
      const dayHistory = this.history.find(day => day.date === date)
      return dayHistory?.records || []
    },

    exportData(): UserData {
      return JSON.parse(JSON.stringify(this.$state))
    },

    importData(data: UserData): boolean {
      try {
        Object.assign(this.$state, data)
        this.saveData()
        console.log('[UserDataStore] Data imported successfully')
        return true
      } catch (error) {
        console.error('[UserDataStore] Failed to import data:', error)
        return false
      }
    },

    resetData(): boolean {
      try {
        Object.assign(this.$state, DEFAULT_USER_DATA)
        this.saveData()
        console.log('[UserDataStore] Data reset successfully')
        return true
      } catch (error) {
        console.error('[UserDataStore] Failed to reset data:', error)
        return false
      }
    }
  }
})
