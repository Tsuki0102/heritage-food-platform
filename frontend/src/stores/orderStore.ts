import { defineStore } from 'pinia'
import {
  createOrder,
  getOrderList,
  getOrderById,
  getOrderByNo,
  cancelOrder,
  confirmReceive
} from '../api/orderApi'
import type { Order, OrderCreateRequest, OrderListParams, ORDER_STATUS } from '../types/order'

interface OrderState {
  orders: Order[]
  currentOrder: Order | null
  loading: boolean
  error: string | null
  pagination: {
    page: number
    pageSize: number
    total: number
    totalPages: number
  }
}

export const useOrderStore = defineStore('order', {
  state: (): OrderState => ({
    orders: [],
    currentOrder: null,
    loading: false,
    error: null,
    pagination: {
      page: 1,
      pageSize: 10,
      total: 0,
      totalPages: 0
    }
  }),

  getters: {
    pendingPaymentOrders: (state) => state.orders.filter(o => o.status === 0),
    paidOrders: (state) => state.orders.filter(o => o.status === 1),
    shippedOrders: (state) => state.orders.filter(o => o.status === 2),
    completedOrders: (state) => state.orders.filter(o => o.status === 3),
    cancelledOrders: (state) => state.orders.filter(o => o.status === 4)
  },

  actions: {
    async createOrder(data: OrderCreateRequest) {
      this.loading = true
      this.error = null
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        const userId = userInfo.id || 8637
        const order = await createOrder(userId, data)
        this.orders.unshift(order)
        return order
      } catch (error) {
        this.error = '创建订单失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchOrders(params: OrderListParams) {
      this.loading = true
      this.error = null
      try {
        const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
        const userId = userInfo.id || 8637
        const data = await getOrderList(userId, params)
        this.orders = data.records
        this.pagination = {
          page: data.page,
          pageSize: data.pageSize,
          total: data.total,
          totalPages: data.totalPages
        }
        return data
      } catch (error) {
        this.error = '获取订单列表失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchOrderById(id: number) {
      this.loading = true
      this.error = null
      try {
        const order = await getOrderById(id)
        this.currentOrder = order
        return order
      } catch (error) {
        this.error = '获取订单详情失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async fetchOrderByNo(orderNo: string) {
      this.loading = true
      this.error = null
      try {
        const order = await getOrderByNo(orderNo)
        this.currentOrder = order
        return order
      } catch (error) {
        this.error = '获取订单详情失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async cancelOrderById(id: number) {
      this.loading = true
      this.error = null
      try {
        const order = await cancelOrder(id)
        const index = this.orders.findIndex(o => o.id === id)
        if (index >= 0) {
          this.orders[index] = order
        }
        if (this.currentOrder?.id === id) {
          this.currentOrder = order
        }
        return order
      } catch (error) {
        this.error = '取消订单失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    async confirmReceiveById(id: number) {
      this.loading = true
      this.error = null
      try {
        const order = await confirmReceive(id)
        const index = this.orders.findIndex(o => o.id === id)
        if (index >= 0) {
          this.orders[index] = order
        }
        if (this.currentOrder?.id === id) {
          this.currentOrder = order
        }
        return order
      } catch (error) {
        this.error = '确认收货失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    updateOrderStatus(orderNo: string, status: number) {
      const order = this.orders.find(o => o.orderNo === orderNo)
      if (order) {
        order.status = status
      }
      if (this.currentOrder?.orderNo === orderNo) {
        this.currentOrder.status = status
      }
    },

    clearCurrentOrder() {
      this.currentOrder = null
    }
  }
})
