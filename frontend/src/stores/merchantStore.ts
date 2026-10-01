import { defineStore } from 'pinia'
import {
  getMerchantWorkspace,
  updateMerchantProfile,
  saveMerchantProduct,
  saveMerchantContent,
  createMerchantWithdrawal
} from '../api/merchantApi'

type AuditStatus = 'pending' | 'approved' | 'rejected' | 'offline' | 'hidden' | 'paid'

interface MerchantProfile {
  storeName: string
  storeStatus: string
  commissionRate: number
  heritageCertified: boolean
  settlementAmount: number
  withdrawPending: number
  lastSettlementAt: string
  contactName: string
  contactPhone: string
  introduction: string
}

interface MerchantProduct {
  id: number
  productName: string
  category: string
  price: number
  heritageTag: string
  description: string
  status: AuditStatus
  submittedAt: string
}

interface MerchantContent {
  id: number
  title: string
  contentType: string
  riskPoint: string
  content: string
  status: AuditStatus
  submittedAt: string
}

interface MerchantSettlement {
  id: number
  period: string
  orderCount: number
  turnover: number
  commissionAmount: number
  payableAmount: number
  status: AuditStatus
}

interface MerchantWithdrawal {
  id: number
  amount: number
  accountName: string
  accountNo: string
  status: AuditStatus
  submittedAt: string
}

interface MerchantState {
  loading: boolean
  profile: MerchantProfile | null
  products: MerchantProduct[]
  contents: MerchantContent[]
  settlements: MerchantSettlement[]
  withdrawals: MerchantWithdrawal[]
}

export const useMerchantStore = defineStore('merchant', {
  state: (): MerchantState => ({
    loading: false,
    profile: null,
    products: [],
    contents: [],
    settlements: [],
    withdrawals: []
  }),

  getters: {
    isMerchant: (state) => !!state.profile,
    totalTurnover: (state) => 
      state.settlements.reduce((sum, s) => sum + s.turnover, 0),
    pendingProducts: (state) => 
      state.products.filter(p => p.status === 'pending'),
    approvedProducts: (state) => 
      state.products.filter(p => p.status === 'approved')
  },

  actions: {
    async loadWorkspace() {
      this.loading = true
      try {
        const data = await getMerchantWorkspace()
        if (data.profile) {
          this.profile = {
            storeName: data.profile.storeName || '',
            storeStatus: data.profile.storeStatus || 'active',
            commissionRate: data.profile.commissionRate || 12,
            heritageCertified: data.profile.heritageCertified || false,
            settlementAmount: data.profile.settlementAmount || 0,
            withdrawPending: data.profile.withdrawPending || 0,
            lastSettlementAt: data.profile.lastSettlementAt || '',
            contactName: data.profile.contactName || '',
            contactPhone: data.profile.contactPhone || '',
            introduction: data.profile.introduction || ''
          }
        }
        this.products = data.products || []
        this.contents = data.contents || []
        this.settlements = data.settlements || []
        this.withdrawals = data.withdrawals || []
      } catch (error) {
        console.error('加载商家工作台失败:', error)
      } finally {
        this.loading = false
      }
    },

    async updateProfile(profile: Partial<MerchantProfile>) {
      this.loading = true
      try {
        await updateMerchantProfile(profile)
        await this.loadWorkspace()
      } catch (error) {
        console.error('更新商家资料失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async addProduct(product: Partial<MerchantProduct>) {
      this.loading = true
      try {
        await saveMerchantProduct(product)
        await this.loadWorkspace()
      } catch (error) {
        console.error('添加商品失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async addContent(content: Partial<MerchantContent>) {
      this.loading = true
      try {
        await saveMerchantContent(content)
        await this.loadWorkspace()
      } catch (error) {
        console.error('添加内容失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async submitWithdrawal(amount: number, accountName: string, accountNo: string) {
      this.loading = true
      try {
        await createMerchantWithdrawal({ amount, accountName, accountNo })
        await this.loadWorkspace()
      } catch (error) {
        console.error('提交提现失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})
