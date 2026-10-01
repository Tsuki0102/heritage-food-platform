export interface Payment {
  id: number
  paymentNo: string
  orderId: number
  userId: number
  amount: number
  paymentMethod: string
  paymentStatus: number
  paidAt?: string
  createdAt: string
  updatedAt: string
}

export interface PaymentRequest {
  orderId: number
  paymentMethod: string
}

export interface PaymentResponse {
  paymentNo: string
  qrCode?: string
  payUrl?: string
}

export const PAYMENT_METHOD = {
  ALIPAY: 'alipay',
  WECHAT: 'wechat',
  CARD: 'card'
}

export const PAYMENT_METHOD_TEXT = {
  [PAYMENT_METHOD.ALIPAY]: '支付宝',
  [PAYMENT_METHOD.WECHAT]: '微信支付',
  [PAYMENT_METHOD.CARD]: '银行卡'
}

export const PAYMENT_STATUS = {
  PENDING: 0,
  SUCCESS: 1,
  FAILED: 2
}

export const PAYMENT_STATUS_TEXT = {
  [PAYMENT_STATUS.PENDING]: '待支付',
  [PAYMENT_STATUS.SUCCESS]: '支付成功',
  [PAYMENT_STATUS.FAILED]: '支付失败'
}
