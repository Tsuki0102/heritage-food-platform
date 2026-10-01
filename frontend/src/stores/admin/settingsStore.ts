import { defineStore } from 'pinia'
import { logger, LogCategory } from '../../utils/logger'
import api from '../../api'

interface BasicSettings {
  siteName: string
  siteDomain: string
  siteDescription: string
  siteKeywords: string
  contactEmail: string
  contactPhone: string
  icpNumber: string
  copyright: string
}

interface FeatureSettings {
  userRegistration: boolean
  userLogin: boolean
  communityPosting: boolean
  commentFunction: boolean
  collectionFunction: boolean
  searchFunction: boolean
  mapFunction: boolean
  tasteTest: boolean
}

interface SecuritySettings {
  apiKey: string
  jwtSecret: string
  loginTimeout: number
  passwordComplexity: 'low' | 'medium' | 'high'
  ipRestriction: boolean
  captcha: boolean
}

interface StorageSettings {
  storageType: 'local' | 'cloud'
  localPath: string
  cloudService: 'aliyun' | 'tencent' | 'qiniu'
  accessKey: string
  secretKey: string
  bucketName: string
  fileSizeLimit: number
}

interface SettingsState {
  basic: BasicSettings
  features: FeatureSettings
  security: SecuritySettings
  storage: StorageSettings
  loading: boolean
  error: string
}

export const useSettingsStore = defineStore('settings', {
  state: (): SettingsState => ({
    basic: {
      siteName: 'heritage-food-frontend',
      siteDomain: 'http://localhost:3000',
      siteDescription: '美食传承与分享平台',
      siteKeywords: '美食,传承,文化,分享',
      contactEmail: 'contact@example.com',
      contactPhone: '13800138000',
      icpNumber: '京ICP备12345678号',
      copyright: '© 2026 heritage-food-frontend. All rights reserved.'
    },
    features: {
      userRegistration: true,
      userLogin: true,
      communityPosting: true,
      commentFunction: true,
      collectionFunction: true,
      searchFunction: true,
      mapFunction: true,
      tasteTest: true
    },
    security: {
      apiKey: 'test-api-key',
      jwtSecret: 'test-jwt-secret',
      loginTimeout: 30,
      passwordComplexity: 'medium',
      ipRestriction: false,
      captcha: true
    },
    storage: {
      storageType: 'local',
      localPath: './uploads',
      cloudService: 'aliyun',
      accessKey: '',
      secretKey: '',
      bucketName: '',
      fileSizeLimit: 10
    },
    loading: false,
    error: ''
  }),

  actions: {
    async fetchSettings() {
      this.loading = true
      this.error = ''
      
      try {
        // 调用真实的API
        const response = await api.get('/api/admin/settings')
        this.basic = response.basic
        this.features = response.features
        this.security = response.security
        this.storage = response.storage
        
        logger.info(LogCategory.ADMIN, 'Settings fetched')
      } catch (error) {
        this.error = '获取系统设置失败'
        logger.error(LogCategory.ADMIN, 'Failed to fetch settings', error instanceof Error ? error.stack : undefined)
        // 发生错误时使用默认数据
        this.basic = {
          siteName: 'heritage-food-frontend',
          siteDomain: 'http://localhost:3000',
          siteDescription: '美食传承与分享平台',
          siteKeywords: '美食,传承,文化,分享',
          contactEmail: 'contact@example.com',
          contactPhone: '13800138000',
          icpNumber: '京ICP备12345678号',
          copyright: '© 2026 heritage-food-frontend. All rights reserved.'
        }
        this.features = {
          userRegistration: true,
          userLogin: true,
          communityPosting: true,
          commentFunction: true,
          collectionFunction: true,
          searchFunction: true,
          mapFunction: true,
          tasteTest: true
        }
        this.security = {
          apiKey: 'test-api-key',
          jwtSecret: 'test-jwt-secret',
          loginTimeout: 30,
          passwordComplexity: 'medium',
          ipRestriction: false,
          captcha: true
        }
        this.storage = {
          storageType: 'local',
          localPath: './uploads',
          cloudService: 'aliyun',
          accessKey: '',
          secretKey: '',
          bucketName: '',
          fileSizeLimit: 10
        }
      } finally {
        this.loading = false
      }
    },

    async saveSettings() {
      this.loading = true
      this.error = ''
      
      try {
        // 调用真实的API
        await api.put('/api/admin/settings', {
          basic: this.basic,
          features: this.features,
          security: this.security,
          storage: this.storage
        })
        
        logger.info(LogCategory.ADMIN, 'Settings saved')
        return true
      } catch (error) {
        this.error = '保存系统设置失败'
        logger.error(LogCategory.ADMIN, 'Failed to save settings', error instanceof Error ? error.stack : undefined)
        return false
      } finally {
        this.loading = false
      }
    },

    updateBasicSettings(settings: Partial<BasicSettings>) {
      this.basic = { ...this.basic, ...settings }
    },

    updateFeatureSettings(settings: Partial<FeatureSettings>) {
      this.features = { ...this.features, ...settings }
    },

    updateSecuritySettings(settings: Partial<SecuritySettings>) {
      this.security = { ...this.security, ...settings }
    },

    updateStorageSettings(settings: Partial<StorageSettings>) {
      this.storage = { ...this.storage, ...settings }
    },

    clearError() {
      this.error = ''
    }
  }
})