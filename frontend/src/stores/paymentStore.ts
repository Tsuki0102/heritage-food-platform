import { defineStore } from 'pinia'
import {
  createPayment,
  getPaymentStatus,
  getPaymentByOrderId,
  cancelPayment
} from '../api/paymentApi'
import type { Payment, PaymentRequest, PaymentResponse } from '../types/payment'

interface PaymentState {
  currentPayment: Payment | null
  paymentResponse: PaymentResponse | null
  loading: boolean
  error: string | null
}

export const usePaymentStore = defineStore('payment', {
  state: (): PaymentState => ({
    currentPayment: null,
    paymentResponse: null,
    loading: false,
    error: null
  }),

  getters: {
    isPaid: (state) => state.currentPayment?.paymentStatus === 1
  },

  actions: {
    async createPayment(data: PaymentRequest) {
      this.loading = true
      this.error = null
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        const userId = userInfo.id || 8637
        const response = await createPayment(userId, data)
        this.paymentResponse = response
        return response
      } catch (error) {
        this.error = '创建支付失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchPaymentStatus(paymentNo: string) {
      this.loading = true
      this.error = null
      try {
        const payment = await getPaymentStatus(paymentNo)
        this.currentPayment = payment
        return payment
      } catch (error) {
        this.error = '获取支付状态失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchPaymentByOrderId(orderId: number) {
      this.loading = true
      this.error = null
      try {
        const payment = await getPaymentByOrderId(orderId)
        this.currentPayment = payment
        return payment
      } catch (error) {
        this.error = '获取支付信息失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async cancelPaymentByNo(paymentNo: string) {
      this.loading = true
      this.error = null
      try {
        await cancelPayment(paymentNo)
        this.currentPayment = null
        this.paymentResponse = null
      } catch (error) {
        this.error = '取消支付失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    clearPayment() {
      this.currentPayment = null
      this.paymentResponse = null
    }
  }
})
