import api from './index'
import type { Product, ProductListParams, ProductListResponse, ProductCategory } from '../types/product'

export const getProductList = (params: ProductListParams) => {
  return api.get<ProductListResponse>('/api/product/list', { params })
}

export const getProductById = (id: number) => {
  return api.get<Product>(`/api/product/${id}`)
}

export const getProductCategories = () => {
  return api.get<ProductCategory[]>('/api/product/categories')
}

export const searchProducts = (keyword: string, page: number = 1, pageSize: number = 10) => {
  return api.get<ProductListResponse>('/api/product/search', {
    params: { keyword, page, pageSize }
  })
}

export const getProductsByCategory = (category: string, page: number = 1, pageSize: number = 10) => {
  return api.get<ProductListResponse>('/api/product/category', {
    params: { category, page, pageSize }
  })
}

export const getHotProducts = (limit: number = 10) => {
  return api.get<Product[]>('/api/product/hot', {
    params: { limit }
  })
}

export const getRecommendProducts = (limit: number = 10) => {
  return api.get<Product[]>('/api/product/recommend', {
    params: { limit }
  })
}

export const createProduct = (data: any) => {
  return api.post('/api/product', data)
}

export const updateProduct = (data: any) => {
  return api.put('/api/product', data)
}

export const deleteProduct = (id: number) => {
  return api.delete(`/api/product/${id}`)
}
