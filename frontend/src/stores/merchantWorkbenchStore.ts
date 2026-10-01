import { defineStore } from 'pinia'
import {
  createMerchantWithdrawal,
  getMerchantWorkspace,
  saveMerchantContent,
  saveMerchantProduct,
  updateMerchantProductStatus,
  updateMerchantProfile
} from '../api/merchantApi'
import { useUserStore } from './userStore'

type AuditStatus = 'pending' | 'approved' | 'rejected' | 'offline' | 'hidden' | 'paid'
type StoreStatus = 'active' | 'limited' | 'banned'

export interface MerchantStoreProfile {
  storeName: string
  storeStatus: StoreStatus
  commissionRate: number
  heritageCertified: boolean
  settlementAmount: number
  withdrawPending: number
  lastSettlementAt: string
}

export interface MerchantWorkspaceMeta {
  contactName: string
  contactPhone: string
  introduction: string
}

export interface MerchantWorkbenchProduct {
  id: number
  merchantName: string
  productName: string
  category: string
  price: number
  heritageTag: string
  description: string
  submittedAt: string
  status: AuditStatus
}

export interface MerchantWorkbenchContent {
  id: number
  merchantName: string
  title: string
  contentType: string
  riskPoint: string
  content: string
  submittedAt: string
  status: AuditStatus
}

export interface MerchantWorkbenchSettlement {
  id: number
  merchantName: string
  period: string
  orderCount: number
  turnover: number
  commissionAmount: number
  payableAmount: number
  status: AuditStatus
}

export interface MerchantWorkbenchWithdraw {
  id: number
  merchantName: string
  amount: number
  accountName: string
  accountNo: string
  submittedAt: string
  status: AuditStatus
}

interface MerchantWorkbenchState {
  loading: boolean
  error: string
  initializedUserId: number | null
  profile: MerchantStoreProfile
  meta: MerchantWorkspaceMeta
  allProducts: MerchantWorkbenchProduct[]
  allContents: MerchantWorkbenchContent[]
  allSettlements: MerchantWorkbenchSettlement[]
  allWithdraws: MerchantWorkbenchWithdraw[]
}

const normalizeDateTime = (value: string | null | undefined) => {
  if (!value) {
    return '--'
  }

  const date = new Date(value)
  if (Number.isNaN(date.getTime())) {
    return value
  }

  return date.toLocaleString('zh-CN', { hour12: false })
}

const createDefaultProfile = (nickname: string): MerchantStoreProfile => ({
  storeName: `${nickname}的非遗小店`,
  storeStatus: 'active',
  commissionRate: 12,
  heritageCertified: false,
  settlementAmount: 0,
  withdrawPending: 0,
  lastSettlementAt: '--'
})

const createDefaultMeta = (nickname: string, phone: string): MerchantWorkspaceMeta => ({
  contactName: nickname,
  contactPhone: phone,
  introduction: '这里可以展示商家的品牌故事、非遗技艺和店铺特色。'
})

export const useMerchantWorkbenchStore = defineStore('merchantWorkbench', {
  state: (): MerchantWorkbenchState => ({
    loading: false,
    error: '',
    initializedUserId: null,
    profile: createDefaultProfile('商家'),
    meta: createDefaultMeta('商家', ''),
    allProducts: [],
    allContents: [],
    allSettlements: [],
    allWithdraws: []
  }),

  getters: {
    currentStoreName: state => state.profile.storeName,
    products: state => state.allProducts,
    contents: state => state.allContents,
    settlements: state => state.allSettlements,
    withdraws: state => state.allWithdraws,
    pendingProductCount(): number {
      return this.products.filter(item => item.status === 'pending').length
    },
    approvedProductCount(): number {
      return this.products.filter(item => item.status === 'approved').length
    },
    pendingContentCount(): number {
      return this.contents.filter(item => item.status === 'pending').length
    },
    latestSettlement(): MerchantWorkbenchSettlement | null {
      return this.settlements[0] || null
    },
    totalTurnover(): number {
      return this.settlements.reduce((total, item) => total + Number(item.turnover || 0), 0)
    }
  },

  actions: {
    applyWorkspace(workspace: any) {
      const userStore = useUserStore()
      const currentUser = userStore.user
      const defaultProfile = createDefaultProfile(currentUser?.nickname || '商家')
      const defaultMeta = createDefaultMeta(currentUser?.nickname || '商家', currentUser?.phone || '')

      this.profile = {
        storeName: workspace?.profile?.storeName || defaultProfile.storeName,
        storeStatus: workspace?.profile?.storeStatus || defaultProfile.storeStatus,
        commissionRate: Number(workspace?.profile?.commissionRate ?? defaultProfile.commissionRate),
        heritageCertified: Boolean(workspace?.profile?.heritageCertified),
        settlementAmount: Number(workspace?.profile?.settlementAmount || 0),
        withdrawPending: Number(workspace?.profile?.withdrawPending || 0),
        lastSettlementAt: normalizeDateTime(workspace?.profile?.lastSettlementAt)
      }

      this.meta = {
        contactName: workspace?.profile?.contactName || defaultMeta.contactName,
        contactPhone: workspace?.profile?.contactPhone || defaultMeta.contactPhone,
        introduction: workspace?.profile?.introduction || defaultMeta.introduction
      }

      this.allProducts = (workspace?.products || []).map((item: any) => ({
        ...item,
        price: Number(item.price || 0),
        submittedAt: normalizeDateTime(item.submittedAt)
      }))

      this.allContents = (workspace?.contents || []).map((item: any) => ({
        ...item,
        submittedAt: normalizeDateTime(item.submittedAt)
      }))

      this.allSettlements = (workspace?.settlements || []).map((item: any) => ({
        ...item,
        orderCount: Number(item.orderCount || 0),
        turnover: Number(item.turnover || 0),
        commissionAmount: Number(item.commissionAmount || 0),
        payableAmount: Number(item.payableAmount || 0)
      }))

      this.allWithdraws = (workspace?.withdrawals || []).map((item: any) => ({
        ...item,
        amount: Number(item.amount || 0),
        submittedAt: normalizeDateTime(item.submittedAt)
      }))
    },

    async initialize(force = false) {
      const userStore = useUserStore()
      const currentUser = userStore.user

      if (!currentUser) {
        return
      }

      if (this.initializedUserId === currentUser.id && !force) {
        return
      }

      this.loading = true
      this.error = ''

      try {
        const workspace = await getMerchantWorkspace(currentUser.id, false)
        this.applyWorkspace(workspace)
        this.initializedUserId = currentUser.id
      } catch (error) {
        this.error = '加载商家工作台数据失败'
        console.error('加载商家工作台数据失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async refresh() {
      await this.initialize(true)
    },

    async saveProfile(payload: {
      storeName: string
      contactName: string
      contactPhone: string
      introduction: string
    }) {
      const userStore = useUserStore()
      const currentUser = userStore.user
      
      this.loading = true
      this.error = ''

      try {
        await updateMerchantProfile(payload, currentUser?.id || 3, false)
        await this.refresh()
      } catch (error) {
        this.error = '保存商家资料失败'
        console.error('保存商家资料失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async saveProduct(
      product: Omit<MerchantWorkbenchProduct, 'id' | 'merchantName' | 'submittedAt' | 'status'> & {
        id?: number
      }
    ) {
      const userStore = useUserStore()
      const currentUser = userStore.user
      
      this.loading = true
      this.error = ''

      try {
        await saveMerchantProduct({
          id: product.id,
          productName: product.productName,
          category: product.category,
          price: product.price,
          heritageTag: product.heritageTag,
          description: product.description
        }, currentUser?.id || 3, false)
        await this.refresh()
      } catch (error) {
        this.error = '保存商品失败'
        console.error('保存商品失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async setProductStatus(id: number, status: AuditStatus) {
      const userStore = useUserStore()
      const currentUser = userStore.user
      
      this.loading = true
      this.error = ''

      try {
        await updateMerchantProductStatus(id, status, currentUser?.id || 3, false)
        await this.refresh()
      } catch (error) {
        this.error = '更新商品状态失败'
        console.error('更新商品状态失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async saveContent(
      content: Omit<MerchantWorkbenchContent, 'id' | 'merchantName' | 'submittedAt' | 'status'> & {
        id?: number
      }
    ) {
      const userStore = useUserStore()
      const currentUser = userStore.user
      
      this.loading = true
      this.error = ''

      try {
        await saveMerchantContent({
          id: content.id,
          title: content.title,
          contentType: content.contentType,
          riskPoint: content.riskPoint,
          content: content.content
        }, currentUser?.id || 3, false)
        await this.refresh()
      } catch (error) {
        this.error = '保存内容失败'
        console.error('保存内容失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async submitWithdraw(amount: number, accountName: string, accountNo: string) {
      const userStore = useUserStore()
      const currentUser = userStore.user
      
      this.loading = true
      this.error = ''

      try {
        await createMerchantWithdrawal({
          amount,
          accountName,
          accountNo
        }, currentUser?.id || 3, false)
        await this.refresh()
      } catch (error) {
        this.error = '提交提现申请失败'
        console.error('提交提现申请失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})
