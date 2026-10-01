import api from './index'
import type { CartItem, CartItemRequest, CartListResponse } from '../types/cart'

export const getCartList = (userId: number) => {
  return api.get<CartListResponse>(`/api/cart?userId=${userId}`)
}

export const addToCart = (userId: number, data: CartItemRequest) => {
  return api.post<CartItem>(`/api/cart?userId=${userId}`, data)
}

export const updateCartItem = (id: number, quantity: number) => {
  return api.put<CartItem>(`/api/cart/${id}`, { quantity })
}

export const removeFromCart = (id: number) => {
  return api.delete(`/api/cart/${id}`)
}

export const clearCart = (userId: number) => {
  return api.delete(`/api/cart/clear?userId=${userId}`)
}

export const getCartCount = (userId: number) => {
  return api.get<{ count: number }>(`/api/cart/count?userId=${userId}`)
}
