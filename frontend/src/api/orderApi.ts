import api from './index'
import type { Order, OrderCreateRequest, OrderListParams, OrderListResponse } from '../types/order'

export const createOrder = (userId: number, data: OrderCreateRequest) => {
  return api.post<Order>(`/api/order?userId=${userId}`, data)
}

export const getOrderList = (userId: number, params: OrderListParams) => {
  return api.get<OrderListResponse>('/api/order/list', { params: { ...params, userId } })
}

export const getOrderById = (id: number) => {
  return api.get<Order>(`/api/order/${id}`)
}

export const getOrderByNo = (orderNo: string) => {
  return api.get<Order>(`/api/order/no/${orderNo}`)
}

export const cancelOrder = (id: number) => {
  return api.put<Order>(`/api/order/${id}/cancel`)
}

export const confirmReceive = (id: number) => {
  return api.put<Order>(`/api/order/${id}/receive`)
}
