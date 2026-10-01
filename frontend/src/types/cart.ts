export interface CartItem {
  id: number
  userId: number
  productId: number
  quantity: number
  product?: {
    id: number
    name: string
    price: number
    coverImage: string
    stock: number
  }
  createdAt: string
  updatedAt: string
}

export interface CartItemRequest {
  productId: number
  quantity: number
}

export interface CartListResponse {
  records: CartItem[]
  total: number
}
