export interface User {
  id: number
  nickname: string
  phone: string
  avatar?: string
}

export interface Comment {
  id: number
  userId: number
  nickname: string
  avatar: string
  score?: number
  content: string
  createTime: string
  liked?: boolean
  likeCount?: number
}

export interface Food {
  id: number
  name: string
  region: string
  taste: string
  heritageLevel: string
  history: string
  ingredients: string
  process: string
  coverImage: string
  averageScore: number
  collectionCount: number
  viewCount: number
  comments: Comment[]
}

export interface StoreFood {
  id: number
  name: string
  description: string
  price: number
  coverImage: string
}

export interface Activity {
  id: number
  activityType: string
  activityRule: string
  startTime: string
  endTime: string
  status: string
  statusText: string
}

export interface Store {
  id: number
  name: string
  address: string
  contact: string
  openingHours: string
  introduction: string
  score: number
  longitude: number
  latitude: number
  foods: StoreFood[]
  activities: Activity[]
  comments: Comment[]
  images?: string[]
}

export interface Post {
  id: number
  userId: number
  nickname: string
  avatar: string
  title: string
  content: string
  mediaPath: string
  type: string
  typeText: string
  likeCount: number
  commentCount: number
  createTime: string
  liked?: boolean
  comments?: Comment[]
  showComments?: boolean
}

export interface CollectionItem {
  id: number
  name: string
  desc: string
  image: string
}

export interface HistoryRecord {
  id: number
  name: string
  desc: string
  image: string
  time: string
  type: 'food' | 'store'
}

export interface HistoryDay {
  date: string
  records: HistoryRecord[]
}

export interface FAQ {
  id: number
  question: string
  answer: string
  expanded?: boolean
}

export interface Feedback {
  type: 'bug' | 'suggestion' | 'content' | 'other'
  content: string
  contact?: string
}

export interface UserSettings {
  pushNotification: boolean
  messageNotification: boolean
  publicCollections: boolean
  publicHistory: boolean
}

export interface UserData {
  collections: {
    foods: CollectionItem[]
    stores: CollectionItem[]
  }
  history: HistoryDay[]
}

export interface PaginationParams {
  page: number
  pageSize: number
}

export interface PaginationMeta {
  total: number
  page: number
  pageSize: number
  totalPages: number
}

export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
}

export interface ApiError {
  code: number
  message: string
  details?: any
}

export interface Tab {
  key: string
  label: string
}

export interface MenuItem {
  icon: string
  label: string
  path?: string
  action?: () => void
}

export interface FormField {
  name: string
  label: string
  type: 'text' | 'password' | 'email' | 'tel' | 'textarea' | 'select' | 'checkbox' | 'radio'
  placeholder?: string
  required?: boolean
  options?: { label: string; value: any }[]
  validation?: {
    required?: boolean
    minLength?: number
    maxLength?: number
    pattern?: RegExp
  }
}

export interface FormState {
  values: Record<string, any>
  errors: Record<string, string>
  touched: Record<string, boolean>
}

export interface Notification {
  id: number
  type: 'success' | 'error' | 'warning' | 'info'
  title: string
  message: string
  duration?: number
}

export interface ModalProps {
  title: string
  content: string
  confirmText?: string
  cancelText?: string
  onConfirm?: () => void
  onCancel?: () => void
}

export interface Role {
  id: number
  roleName: string
  roleKey: string
  description: string
  status: number
  createTime: string
  updateTime: string
  permissions?: Permission[]
}

export interface Permission {
  id: number
  permissionName: string
  permissionKey: string
  resourceType: string
  resourceUrl: string
  parentId: number
  description: string
  status: number
  createTime: string
  updateTime: string
  children?: Permission[]
}

export interface UserRole {
  id: number
  userId: number
  roleId: number
  createTime: string
}

export interface RolePermission {
  id: number
  roleId: number
  permissionId: number
  createTime: string
}

export * from './product'
export * from './cart'
export * from './order'
export * from './payment'
