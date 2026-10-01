/**
 * 图片工具函数 - 统一图片路径处理逻辑
 * 解决数据库中 cover_image 字段缺少点号的问题（如 beijing-duckjpg -> beijing-duck.jpg）
 */

/**
 * 处理美食封面图片路径
 * @param coverImage - 数据库中的原始图片文件名
 * @param fallbackImage - 图片不存在时的默认图片
 * @returns 完整的图片 URL 路径
 */
export const getFoodImageUrl = (
  coverImage: string | undefined | null,
  fallbackImage = 'beijing-duck.jpg'
): string => {
  if (!coverImage) {
    return `/images/${fallbackImage}`
  }

  // 如果已经包含扩展名，直接使用
  if (coverImage.includes('.')) {
    return `/images/${coverImage}`
  }

  // 处理缺少点号的情况：beijing-duckjpg -> beijing-duck.jpg
  if (coverImage.endsWith('jpg') || coverImage.endsWith('jpeg') || coverImage.endsWith('png')) {
    const baseName = coverImage.replace(/(jpg|jpeg|png)$/, '')
    return `/images/${baseName}.${RegExp.$1 || 'jpg'}`
  }

  // 默认添加 .jpg 扩展名
  return `/images/${coverImage}.jpg`
}

/**
 * 处理用户头像路径
 * @param avatar - 原始头像路径或文件名
 * @returns 完整的头像 URL 路径
 */
export const getAvatarUrl = (avatar: string | undefined | null): string => {
  if (!avatar) {
    return '/images/avatar1.jpg'
  }

  if (avatar.startsWith('http://') || avatar.startsWith('https://')) {
    return avatar
  }

  return `/images/${avatar}`
}

/**
 * 处理 Banner 背景图片数组
 * @param images - 原始图片数组
 * @param repeatCount - 重复次数（用于无缝滚动）
 * @returns 扩展后的图片数组
 */
export const getBannerImages = (
  images: string[],
  repeatCount = 2
): string[] => {
  const result: string[] = []
  for (let i = 0; i < repeatCount; i++) {
    result.push(...images)
  }
  return result
}

// 预定义的 Banner 图片列表
export const DEFAULT_BANNER_IMAGES = [
  '/images/banner-1.jpg',
  '/images/banner-2.jpg',
  '/images/banner-3.jpg',
  '/images/banner-4.jpg'
]

// 默认的美食图片
export const DEFAULT_FOOD_IMAGE = 'beijing-duck.jpg'

// 默认的用户头像
export const DEFAULT_AVATAR_IMAGE = 'avatar1.jpg'

// 默认的占位图片
export const DEFAULT_PLACEHOLDER_IMAGE = 'default-food.jpg'
