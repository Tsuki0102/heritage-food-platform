import api from './index'

export const getMerchantApplicationOverview = () => api.get('/api/merchant/applications/overview')

export const submitMerchantOnboardingApplication = (payload: Record<string, unknown>) => {
  return api.post('/api/merchant/onboarding-applications', payload)
}

export const getMerchantWorkspace = () => api.get('/api/merchant/workspace')

export const updateMerchantProfile = (payload: Record<string, unknown>) => {
  return api.put('/api/merchant/profile', payload)
}

export const saveMerchantProduct = (payload: Record<string, unknown>) => {
  return api.post('/api/merchant/products', payload)
}

export const updateMerchantProductStatus = (id: number, status: string) => {
  return api.put(`/api/merchant/products/${id}/status`, null, {
    params: { status }
  })
}

export const saveMerchantContent = (payload: Record<string, unknown>) => {
  return api.post('/api/merchant/contents', payload)
}

export const submitMerchantQualificationApplication = (payload: Record<string, unknown>) => {
  return api.post('/api/merchant/qualification-applications', payload)
}

export const createMerchantWithdrawal = (payload: Record<string, unknown>) => {
  return api.post('/api/merchant/withdrawals', payload)
}

export const getAdminMerchantWorkspace = () => api.get('/api/admin/merchants/workspace')

export const updateAdminMerchantRole = (userId: number, enabled: boolean) => {
  return api.put(`/api/admin/merchants/accounts/${userId}/merchant-role`, null, {
    params: { enabled }
  })
}

export const updateAdminMerchantProfile = (userId: number, payload: Record<string, unknown>) => {
  return api.put(`/api/admin/merchants/accounts/${userId}/profile`, payload)
}

export const reviewOnboardingApplication = (id: number, approved: boolean) => {
  return api.put(`/api/admin/merchants/onboarding/${id}/review`, null, {
    params: { approved }
  })
}

export const reviewQualificationApplication = (id: number, approved: boolean) => {
  return api.put(`/api/admin/merchants/qualifications/${id}/review`, null, {
    params: { approved }
  })
}

export const updateSettlementStatus = (id: number, status: string) => {
  return api.put(`/api/admin/merchants/settlements/${id}/status`, null, {
    params: { status }
  })
}

export const updateWithdrawalStatus = (id: number, status: string) => {
  return api.put(`/api/admin/merchants/withdrawals/${id}/status`, null, {
    params: { status }
  })
}

export const updateProductAuditStatus = (id: number, status: string) => {
  return api.put(`/api/admin/merchants/products/${id}/status`, null, {
    params: { status }
  })
}

export const updateContentAuditStatus = (id: number, status: string) => {
  return api.put(`/api/admin/merchants/contents/${id}/status`, null, {
    params: { status }
  })
}

export const updateReviewAuditStatus = (id: number, status: string) => {
  return api.put(`/api/admin/merchants/reviews/${id}/status`, null, {
    params: { status }
  })
}

export const updateArtisanStatus = (id: number, status: string) => {
  return api.put(`/api/admin/merchants/artisans/${id}/status`, null, {
    params: { status }
  })
}

export const addSensitiveWord = (word: string) => {
  return api.post('/api/admin/merchants/sensitive-words', { word })
}

export const removeSensitiveWord = (word: string) => {
  return api.delete('/api/admin/merchants/sensitive-words', {
    params: { word }
  })
}
