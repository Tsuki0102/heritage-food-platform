export { default as Storage } from './storage'
export { default as DateUtils } from './date'
export { default as Validator } from './validator'
export { logger, LogLevel, LogCategory } from './logger'

export function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeout: ReturnType<typeof setTimeout> | null = null

  return function executedFunction(...args: Parameters<T>) {
    const later = () => {
      timeout = null
      func(...args)
    }

    if (timeout) {
      clearTimeout(timeout)
    }
    timeout = setTimeout(later, wait)
  }
}

export function throttle<T extends (...args: any[]) => any>(
  func: T,
  limit: number
): (...args: Parameters<T>) => void {
  let inThrottle: boolean = false

  return function executedFunction(...args: Parameters<T>) {
    if (!inThrottle) {
      func(...args)
      inThrottle = true
      setTimeout(() => (inThrottle = false), limit)
    }
  }
}

export function deepClone<T>(obj: T): T {
  if (obj === null || typeof obj !== 'object') {
    return obj
  }

  if (obj instanceof Date) {
    return new Date(obj.getTime()) as T
  }

  if (obj instanceof Array) {
    const copy: any = []
    for (let i = 0; i < obj.length; i++) {
      copy[i] = deepClone(obj[i])
    }
    return copy as T
  }

  if (obj instanceof Object) {
    const copy: any = {}
    for (const key in obj) {
      if (obj.hasOwnProperty(key)) {
        copy[key] = deepClone(obj[key])
      }
    }
    return copy as T
  }

  throw new Error('Unable to clone object')
}

export function generateId(): number {
  return Date.now() + Math.random()
}

export function truncate(str: string, length: number, suffix: string = '...'): string {
  if (str.length <= length) {
    return str
  }
  return str.substring(0, length) + suffix
}

export function formatNumber(num: number, decimals: number = 2): string {
  return num.toFixed(decimals)
}

export function isEmpty(value: any): boolean {
  if (value === null || value === undefined) {
    return true
  }
  if (typeof value === 'string') {
    return value.trim().length === 0
  }
  if (Array.isArray(value)) {
    return value.length === 0
  }
  if (typeof value === 'object') {
    return Object.keys(value).length === 0
  }
  return false
}

/**
 * 解析头像/图片资源的可访问路径，兼容四种存储形态：
 * - 完整 URL（http/https）：原样返回
 * - 以 / 开头的路径（/uploads/...、/file/...、/images/...）：原样返回
 * - 裸文件名（如 avatar3.jpg）：指向前端 public/images 目录
 * - 空：返回默认头像
 */
export function resolveAvatarUrl(avatar?: string | null, fallback = '/images/avatar1.jpg'): string {
  if (!avatar) return fallback
  if (/^https?:\/\//.test(avatar)) return avatar
  if (avatar.startsWith('/')) return avatar
  return `/images/${avatar}`
}
