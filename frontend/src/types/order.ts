export interface Order {
  id: number
  orderNo: string
  userId: number
  totalAmount: number
  status: number
  statusText: string
  receiverName: string
  receiverPhone: string
  receiverAddress: string
  remark?: string
  items?: OrderItem[]
  createdAt: string
  updatedAt: string
}

export interface OrderItem {
  id: number
  orderId: number
  productId: number
  productName: string
  coverImage: string
  price: number
  quantity: number
  subtotal: number
  createdAt: string
}

export interface OrderCreateRequest {
  receiverName: string
  receiverPhone: string
  receiverAddress: string
  remark?: string
  paymentMethod: string
}

export interface OrderListParams {
  page: number
  pageSize: number
  status?: number
}

export interface OrderListResponse {
  records: Order[]
  total: number
  page: number
  pageSize: number
  totalPages: number
}

export const ORDER_STATUS = {
  PENDING_PAYMENT: 0,
  PAID: 1,
  SHIPPED: 2,
  COMPLETED: 3,
  CANCELLED: 4
}

export const ORDER_STATUS_TEXT = {
  [ORDER_STATUS.PENDING_PAYMENT]: '待支付',
  [ORDER_STATUS.PAID]: '已支付',
  [ORDER_STATUS.SHIPPED]: '已发货',
  [ORDER_STATUS.COMPLETED]: '已完成',
  [ORDER_STATUS.CANCELLED]: '已取消'
}
