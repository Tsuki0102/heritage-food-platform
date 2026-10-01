export interface Product {
  id: number
  name: string
  description: string
  price: number
  originalPrice?: number
  coverImage: string
  images?: string[]
  category: string
  stock: number
  salesCount: number
  rating: number
  status: number
  createdAt: string
  updatedAt: string
}

export interface ProductCategory {
  id: number
  name: string
  icon?: string
  productCount?: number
}

export interface ProductListParams {
  page: number
  pageSize: number
  category?: string
  keyword?: string
  sortBy?: 'price' | 'sales' | 'rating'
  sortOrder?: 'asc' | 'desc'
}

export interface ProductListResponse {
  records: Product[]
  total: number
  page: number
  pageSize: number
  totalPages: number
}
