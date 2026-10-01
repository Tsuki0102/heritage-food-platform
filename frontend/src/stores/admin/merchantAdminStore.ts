import { defineStore } from 'pinia'
import {
  addSensitiveWord,
  getAdminMerchantWorkspace,
  removeSensitiveWord,
  reviewOnboardingApplication,
  reviewQualificationApplication,
  updateAdminMerchantProfile,
  updateAdminMerchantRole,
  updateArtisanStatus,
  updateContentAuditStatus,
  updateProductAuditStatus,
  updateReviewAuditStatus,
  updateSettlementStatus,
  updateWithdrawalStatus
} from '../../api/merchantApi'
import type { User } from '../../types'

type AuditStatus = 'pending' | 'approved' | 'rejected' | 'offline' | 'hidden' | 'paid'
type StoreStatus = 'active' | 'limited' | 'banned'

interface MerchantProfileUpdatePayload {
  storeName?: string
  storeStatus?: StoreStatus
  commissionRate?: number
  heritageCertified?: boolean
}

export interface MerchantAccount extends User {
  roleIds: number[]
  roleKeys: string[]
  roleNames: string[]
  isMerchant: boolean
  storeName: string
  storeStatus: StoreStatus
  commissionRate: number
  heritageCertified: boolean
  settlementAmount: number
  withdrawPending: number
  lastSettlementAt: string
  contactName?: string
  contactPhone?: string
  introduction?: string
}

export interface OnboardingApplication {
  id: number
  applicantName: string
  phone: string
  storeName: string
  category: string
  region: string
  submittedAt: string
  note: string
  attachmentUrls: string[]
  status: AuditStatus
}

export interface QualificationApplication {
  id: number
  merchantName: string
  projectName: string
  certificateNo: string
  issuer: string
  submittedAt: string
  note: string
  attachmentUrls: string[]
  status: AuditStatus
}

export interface SettlementRecord {
  id: number
  merchantName: string
  period: string
  orderCount: number
  turnover: number
  commissionAmount: number
  payableAmount: number
  status: AuditStatus
}

export interface WithdrawRequest {
  id: number
  merchantName: string
  amount: number
  accountName: string
  accountNo: string
  submittedAt: string
  status: AuditStatus
}

export interface ProductAuditRecord {
  id: number
  merchantName: string
  productName: string
  category: string
  price: number
  heritageTag: string
  submittedAt: string
  status: AuditStatus
}

export interface ContentAuditRecord {
  id: number
  merchantName: string
  title: string
  contentType: string
  riskPoint: string
  submittedAt: string
  status: AuditStatus
}

export interface ReviewAuditRecord {
  id: number
  userName: string
  merchantName: string
  content: string
  hitWords: string[]
  submittedAt: string
  status: AuditStatus
}

export interface ArtisanRecord {
  id: number
  merchantName: string
  artisanName: string
  heritageSkill: string
  level: string
  verified: boolean
  status: 'active' | 'disabled'
}

interface MerchantAdminState {
  loading: boolean
  error: string
  accounts: MerchantAccount[]
  onboardingApplications: OnboardingApplication[]
  qualificationApplications: QualificationApplication[]
  settlementRecords: SettlementRecord[]
  withdrawRequests: WithdrawRequest[]
  productAudits: ProductAuditRecord[]
  contentAudits: ContentAuditRecord[]
  reviewAudits: ReviewAuditRecord[]
  artisanRecords: ArtisanRecord[]
  sensitiveWords: string[]
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

const parseAttachmentUrls = (value: unknown) => {
  if (Array.isArray(value)) {
    return value.filter(Boolean).map(item => String(item))
  }
  if (typeof value !== 'string' || !value.trim()) {
    return []
  }
  return value
    .split(',')
    .map(item => item.trim())
    .filter(Boolean)
}

export const useMerchantAdminStore = defineStore('merchantAdmin', {
  state: (): MerchantAdminState => ({
    loading: false,
    error: '',
    accounts: [],
    onboardingApplications: [],
    qualificationApplications: [],
    settlementRecords: [],
    withdrawRequests: [],
    productAudits: [],
    contentAudits: [],
    reviewAudits: [],
    artisanRecords: [],
    sensitiveWords: []
  }),

  getters: {
    merchantAccounts: state => state.accounts.filter(account => account.isMerchant),
    pendingOnboardingCount: state => state.onboardingApplications.filter(item => item.status === 'pending').length,
    pendingQualificationCount: state => state.qualificationApplications.filter(item => item.status === 'pending').length,
    pendingProductCount: state => state.productAudits.filter(item => item.status === 'pending').length,
    pendingContentCount: state => state.contentAudits.filter(item => item.status === 'pending').length,
    pendingWithdrawCount: state => state.withdrawRequests.filter(item => item.status === 'pending').length
  },

  actions: {
    applyWorkspace(workspace: any) {
      this.accounts = (workspace?.accounts || []).map((account: any) => ({
        ...account,
        isMerchant: Boolean(account.isMerchant),
        commissionRate: Number(account.commissionRate || 0),
        heritageCertified: Boolean(account.heritageCertified),
        settlementAmount: Number(account.settlementAmount || 0),
        withdrawPending: Number(account.withdrawPending || 0),
        lastSettlementAt: normalizeDateTime(account.lastSettlementAt)
      }))

      this.onboardingApplications = (workspace?.onboardingApplications || []).map((item: any) => ({
        ...item,
        attachmentUrls: parseAttachmentUrls(item.attachmentUrls),
        submittedAt: normalizeDateTime(item.submittedAt)
      }))

      this.qualificationApplications = (workspace?.qualificationApplications || []).map((item: any) => ({
        ...item,
        attachmentUrls: parseAttachmentUrls(item.attachmentUrls),
        submittedAt: normalizeDateTime(item.submittedAt)
      }))

      this.settlementRecords = (workspace?.settlementRecords || []).map((item: any) => ({
        ...item,
        orderCount: Number(item.orderCount || 0),
        turnover: Number(item.turnover || 0),
        commissionAmount: Number(item.commissionAmount || 0),
        payableAmount: Number(item.payableAmount || 0)
      }))

      this.withdrawRequests = (workspace?.withdrawRequests || []).map((item: any) => ({
        ...item,
        amount: Number(item.amount || 0),
        submittedAt: normalizeDateTime(item.submittedAt)
      }))

      this.productAudits = (workspace?.productAudits || []).map((item: any) => ({
        ...item,
        price: Number(item.price || 0),
        submittedAt: normalizeDateTime(item.submittedAt)
      }))

      this.contentAudits = (workspace?.contentAudits || []).map((item: any) => ({
        ...item,
        submittedAt: normalizeDateTime(item.submittedAt)
      }))

      this.reviewAudits = (workspace?.reviewAudits || []).map((item: any) => ({
        ...item,
        hitWords: Array.isArray(item.hitWords) ? item.hitWords : [],
        submittedAt: normalizeDateTime(item.submittedAt)
      }))

      this.artisanRecords = (workspace?.artisanRecords || []).map((item: any) => ({
        ...item,
        verified: Boolean(item.verified)
      }))

      this.sensitiveWords = workspace?.sensitiveWords || []
    },

    async fetchMerchantAdminData() {
      this.loading = true
      this.error = ''

      try {
        const workspace = await getAdminMerchantWorkspace()
        this.applyWorkspace(workspace)
      } catch (error) {
        this.error = '加载商家管理数据失败'
        console.error('加载商家管理数据失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },

    async setMerchantRole(userId: number, enabled: boolean) {
      this.loading = true
      this.error = ''

      try {
        await updateAdminMerchantRole(userId, enabled)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '更新商家角色失败'
        console.error('更新商家角色失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async updateAccountProfile(userId: number, updates: MerchantProfileUpdatePayload) {
      this.loading = true
      this.error = ''

      try {
        await updateAdminMerchantProfile(userId, updates)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '更新商家账号信息失败'
        console.error('更新商家账号信息失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async approveOnboarding(id: number) {
      this.loading = true
      this.error = ''

      try {
        await reviewOnboardingApplication(id, true)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '处理入驻审核失败'
        console.error('处理入驻审核失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async rejectOnboarding(id: number) {
      this.loading = true
      this.error = ''

      try {
        await reviewOnboardingApplication(id, false)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '驳回入驻申请失败'
        console.error('驳回入驻申请失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async approveQualification(id: number) {
      this.loading = true
      this.error = ''

      try {
        await reviewQualificationApplication(id, true)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '处理资质审核失败'
        console.error('处理资质审核失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async rejectQualification(id: number) {
      this.loading = true
      this.error = ''

      try {
        await reviewQualificationApplication(id, false)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '驳回资质申请失败'
        console.error('驳回资质申请失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async markSettlementPaid(id: number) {
      this.loading = true
      this.error = ''

      try {
        await updateSettlementStatus(id, 'paid')
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '更新结算状态失败'
        console.error('更新结算状态失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async reviewWithdraw(id: number, status: 'approved' | 'rejected') {
      this.loading = true
      this.error = ''

      try {
        await updateWithdrawalStatus(id, status)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '处理提现审核失败'
        console.error('处理提现审核失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async reviewProduct(id: number, status: 'approved' | 'rejected' | 'offline') {
      this.loading = true
      this.error = ''

      try {
        await updateProductAuditStatus(id, status)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '处理商品审核失败'
        console.error('处理商品审核失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async reviewContent(id: number, status: 'approved' | 'rejected') {
      this.loading = true
      this.error = ''

      try {
        await updateContentAuditStatus(id, status)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '处理内容审核失败'
        console.error('处理内容审核失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async reviewComment(id: number, status: 'approved' | 'hidden' | 'rejected') {
      this.loading = true
      this.error = ''

      try {
        await updateReviewAuditStatus(id, status)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '处理评价审核失败'
        console.error('处理评价审核失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async toggleArtisanStatus(id: number, status: 'active' | 'disabled') {
      this.loading = true
      this.error = ''

      try {
        await updateArtisanStatus(id, status)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '更新匠人状态失败'
        console.error('更新匠人状态失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async addSensitiveWord(word: string) {
      const normalized = word.trim()
      if (!normalized) {
        return false
      }

      this.loading = true
      this.error = ''

      try {
        await addSensitiveWord(normalized)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '新增敏感词失败'
        console.error('新增敏感词失败:', error)
        return false
      } finally {
        this.loading = false
      }
    },

    async removeSensitiveWord(word: string) {
      this.loading = true
      this.error = ''

      try {
        await removeSensitiveWord(word)
        await this.fetchMerchantAdminData()
        return true
      } catch (error) {
        this.error = '删除敏感词失败'
        console.error('删除敏感词失败:', error)
        return false
      } finally {
        this.loading = false
      }
    }
  }
})
