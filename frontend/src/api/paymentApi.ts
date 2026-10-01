import api from './index'
import type { Payment, PaymentRequest, PaymentResponse } from '../types/payment'

export const createPayment = (userId: number, data: PaymentRequest) => {
  return api.post<PaymentResponse>(`/api/payment?userId=${userId}`, data)
}

export const getPaymentStatus = (paymentNo: string) => {
  return api.get<Payment>(`/api/payment/${paymentNo}`)
}

export const getPaymentByOrderId = (orderId: number) => {
  return api.get<Payment>(`/api/payment/order/${orderId}`)
}

export const cancelPayment = (paymentNo: string) => {
  return api.delete(`/api/payment/${paymentNo}`)
}
