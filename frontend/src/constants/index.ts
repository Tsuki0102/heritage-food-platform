export const APP_CONFIG = {
  NAME: '中华美食文化',
  VERSION: '1.0.0',
  DESCRIPTION: '致力于传承和推广中国传统美食文化的平台',
  AUTHOR: 'Heritage Food Team',
  HOMEPAGE: 'www.heritagefood.com'
} as const

export const STORAGE_KEYS = {
  TOKEN: 'token',
  USER: 'user',
  COMMUNITY_DATA: 'communityData',
  USER_DATA: 'userData',
  USER_SETTINGS: 'userSettings'
} as const

export const ROUTES = {
  HOME: '/',
  LOGIN: '/login',
  COMMUNITY: '/community',
  MAP: '/map',
  USER: '/user',
  USER_PROFILE: '/user/profile',
  USER_COLLECTIONS: '/user/collections',
  USER_COMMENTS: '/user/comments',
  USER_HISTORY: '/user/history',
  USER_POSTS: '/user/posts',
  USER_SETTINGS: '/user/settings',
  USER_HELP: '/user/help',
  USER_ABOUT: '/user/about',
  FOOD_DETAIL: '/food/:id',
  STORE_DETAIL: '/store/:id'
} as const

export const COMMUNITY_TABS = {
  ALL: 'all',
  COOK: 'cook',
  EXPERIENCE: 'experience',
  SHOP: 'shop'
} as const

export const COMMUNITY_TAB_LABELS = {
  [COMMUNITY_TABS.ALL]: '全部',
  [COMMUNITY_TABS.COOK]: '美食复刻',
  [COMMUNITY_TABS.EXPERIENCE]: '烹饪心得',
  [COMMUNITY_TABS.SHOP]: '探店体验'
} as const

export const POST_TYPES = {
  COOK: 'cook',
  EXPERIENCE: 'experience',
  SHOP: 'shop'
} as const

export const POST_TYPE_LABELS = {
  [POST_TYPES.COOK]: '美食复刻',
  [POST_TYPES.EXPERIENCE]: '烹饪心得',
  [POST_TYPES.SHOP]: '探店体验'
} as const

export const COLLECTION_TYPES = {
  FOODS: 'foods',
  STORES: 'stores'
} as const

export const COLLECTION_TYPE_LABELS = {
  [COLLECTION_TYPES.FOODS]: '美食收藏',
  [COLLECTION_TYPES.STORES]: '店铺收藏'
} as const

export const HISTORY_TYPES = {
  FOOD: 'food',
  STORE: 'store'
} as const

export const HISTORY_TYPE_LABELS = {
  [HISTORY_TYPES.FOOD]: '美食',
  [HISTORY_TYPES.STORE]: '店铺'
} as const

export const FEEDBACK_TYPES = {
  BUG: 'bug',
  SUGGESTION: 'suggestion',
  CONTENT: 'content',
  OTHER: 'other'
} as const

export const FEEDBACK_TYPE_LABELS = {
  [FEEDBACK_TYPES.BUG]: '功能异常',
  [FEEDBACK_TYPES.SUGGESTION]: '功能建议',
  [FEEDBACK_TYPES.CONTENT]: '内容问题',
  [FEEDBACK_TYPES.OTHER]: '其他'
} as const

export const ACTIVITY_STATUS = {
  ACTIVE: 'active',
  ENDED: 'ended'
} as const

export const ACTIVITY_STATUS_LABELS = {
  [ACTIVITY_STATUS.ACTIVE]: '进行中',
  [ACTIVITY_STATUS.ENDED]: '已结束'
} as const

export const PAGINATION = {
  DEFAULT_PAGE_SIZE: 10,
  MAX_PAGE_SIZE: 100
} as const

export const VALIDATION = {
  PHONE_REGEX: /^1[3-9]\d{9}$/,
  EMAIL_REGEX: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
  MIN_NICKNAME_LENGTH: 2,
  MAX_NICKNAME_LENGTH: 20,
  MIN_CONTENT_LENGTH: 1,
  MAX_CONTENT_LENGTH: 1000,
  MAX_COMMENT_LENGTH: 500
} as const

export const ERROR_MESSAGES = {
  NETWORK_ERROR: '网络错误，请稍后重试',
  SERVER_ERROR: '服务器错误，请稍后重试',
  AUTH_ERROR: '登录已过期，请重新登录',
  VALIDATION_ERROR: '输入数据有误，请检查',
  UNKNOWN_ERROR: '未知错误，请稍后重试'
} as const

export const SUCCESS_MESSAGES = {
  LOGIN_SUCCESS: '登录成功',
  LOGOUT_SUCCESS: '退出成功',
  SAVE_SUCCESS: '保存成功',
  DELETE_SUCCESS: '删除成功',
  SUBMIT_SUCCESS: '提交成功',
  UPDATE_SUCCESS: '更新成功'
} as const

export const DEFAULT_AVATAR = '/images/avatar1.jpg'

export const DEFAULT_IMAGES = {
  FOOD: '/images/beijing-duck.jpg',
  STORE: '/images/beijing-duck.jpg'
} as const

export const CONTACT = {
  EMAIL: 'support@heritagefood.com',
  PHONE: '400-123-4567',
  HOURS: '周一至周五 9:00-18:00',
  ADDRESS: '北京市朝阳区美食大厦'
} as const

export const LEGAL = {
  USER_AGREEMENT: '用户协议',
  PRIVACY_POLICY: '隐私政策',
  COPYRIGHT_NOTICE: '版权声明',
  ICP_NUMBER: '京ICP备12345678号'
} as const
