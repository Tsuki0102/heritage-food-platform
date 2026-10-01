import { defineStore } from 'pinia'
import { Storage, resolveAvatarUrl } from '../utils'
import { logger, LogCategory } from '../utils/logger'
import { STORAGE_KEYS, DEFAULT_AVATAR } from '../constants'
import type { User } from '../types'
import api from '../api'
import { useCommunityStore } from './communityStore'

export const useUserStore = defineStore('user', {
  state: () => ({
    user: Storage.get<User>(STORAGE_KEYS.USER),
    token: Storage.get<string>(STORAGE_KEYS.TOKEN, ''),
    isLoading: false,
    error: '',
    isLoaded: false
  }),

  getters: {
    isLoggedIn: (state) => !!state.token && !!state.user,
    userInfo: (state) => state.user,
    userId: (state) => state.user?.id,
    userAvatar: (state) => {
      // 如果有上传的头像，直接用；否则用默认头像
      return state.user?.avatar
        ? resolveAvatarUrl(state.user.avatar)
        : DEFAULT_AVATAR
    },
    hasMerchantRole: (state) => {
      // 通过手机号判断是否是商家
      const merchantPhones = ['13800138003', '13800138005']
      return merchantPhones.includes(state.user?.phone || '')
    }
  },

  actions: {
    async login(phone: string, code: string): Promise<boolean> {
      this.isLoading = true
      this.error = ''
      
      try {
        // 尝试通过手机号查询用户
        let userInfo: User | null = null
        
        try {
          // 调用后端API根据手机号查询用户
          const userData = await api.get(`/api/user/phone/${phone}`)
          userInfo = userData
        } catch (error) {
          // 用户不存在，需要注册
          logger.info(LogCategory.USER, 'User not found, need to register', { phone })
        }
        
        if (userInfo) {
          // 用户已存在，直接登录
          const token = 'test-token-' + Date.now()
          
          // 检查是否为管理员手机号
          const isAdminPhone = phone === '13800138000'
          
          // 确保用户信息中包含isAdmin字段
          const updatedUserInfo: any = {
            ...userInfo,
            isAdmin: isAdminPhone ? 1 : 0
          }
          
          this.user = updatedUserInfo
          this.token = token
          
          Storage.set(STORAGE_KEYS.USER, updatedUserInfo)
          Storage.set(STORAGE_KEYS.TOKEN, token)
          
          logger.info(LogCategory.USER, 'User logged in', { userId: updatedUserInfo.id, nickname: updatedUserInfo.nickname, isAdmin: updatedUserInfo.isAdmin })
        } else {
          // 生成随机用户ID和昵称
          const randomId = Math.floor(Math.random() * 10000) + 10
          const randomNickname = '用户' + randomId
          const randomAvatar = 'avatar' + ((randomId % 10) + 1) + '.jpg'
          
          // 检查是否为管理员手机号
          const isAdminPhone = phone === '13800138000'
          
          // 准备用户信息，包含所有必填字段
          const newUserInfo: any = {
            id: randomId,
            nickname: randomNickname,
            password: '123456', // 默认密码
            phone,
            gender: 1, // 默认性别
            region: '未知', // 默认地区
            tasteTags: '', // 默认口味标签
            avatar: randomAvatar,
            registerTime: new Date().toISOString(), // 当前时间
            status: 1, // 默认状态
            isAdmin: isAdminPhone ? 1 : 0 // 如果是管理员手机号则设置为1
          }
          
          // 调用后端API注册用户
          await api.post('/api/user', newUserInfo)
          
          // 存储必要的字段到前端，包括isAdmin字段
          const frontUserInfo: any = {
            id: randomId,
            nickname: randomNickname,
            phone,
            avatar: randomAvatar,
            isAdmin: newUserInfo.isAdmin // 存储isAdmin字段
          }
          
          const token = 'test-token-' + Date.now()
          
          this.user = frontUserInfo
          this.token = token
          
          Storage.set(STORAGE_KEYS.USER, frontUserInfo)
          Storage.set(STORAGE_KEYS.TOKEN, token)
          
          logger.info(LogCategory.USER, 'User registered and logged in', { userId: randomId, nickname: randomNickname, isAdmin: frontUserInfo.isAdmin })
        }
        
        this.isLoaded = true
        return true
      } catch (error) {
        this.error = '登录失败'
        logger.error(LogCategory.USER, 'Login failed', { phone, code }, error instanceof Error ? error.stack : undefined)
        this.isLoaded = true
        return false
      } finally {
        this.isLoading = false
      }
    },

    logout(): void {
      this.user = null
      this.token = ''
      Storage.remove(STORAGE_KEYS.USER)
      Storage.remove(STORAGE_KEYS.TOKEN)
      logger.info(LogCategory.USER, 'User logged out')
    },

    loadUser(): void {
      const token = Storage.get<string>(STORAGE_KEYS.TOKEN)
      const user = Storage.get<User>(STORAGE_KEYS.USER)
      
      if (token && user) {
        this.token = token
        this.user = user
        logger.info(LogCategory.USER, 'User loaded', user)
      }
      this.isLoaded = true
    },

    // 清除旧的用户信息，确保使用新的用户信息
    clearUserInfo(): void {
      this.user = null
      this.token = ''
      Storage.remove(STORAGE_KEYS.USER)
      Storage.remove(STORAGE_KEYS.TOKEN)
      logger.info(LogCategory.USER, 'User info cleared')
    },

    updateUserInfo(updates: Partial<User>): boolean {
      if (!this.user) {
        logger.warn(LogCategory.USER, 'Cannot update: No user logged in')
        return false
      }
      
      this.user = { ...this.user, ...updates }
      Storage.set(STORAGE_KEYS.USER, this.user)
      logger.info(LogCategory.USER, 'User info updated', updates)
      
      if (updates.nickname || updates.avatar) {
        try {
          const communityStore = useCommunityStore()
          if (communityStore && this.user?.id) {
            communityStore.posts = communityStore.posts.map(post => {
              if (post.userId === this.user!.id) {
                const updatedPost = { ...post }
                if (updates.nickname) {
                  updatedPost.nickname = updates.nickname
                }
                if (updates.avatar) {
                  updatedPost.avatar = updates.avatar
                }
                return updatedPost
              }
              
              if (post.comments) {
                post.comments = post.comments.map(comment => {
                  if (comment.userId === this.user!.id) {
                    const updatedComment = { ...comment }
                    if (updates.nickname) {
                      updatedComment.nickname = updates.nickname
                    }
                    if (updates.avatar) {
                      updatedComment.avatar = updates.avatar
                    }
                    return updatedComment
                  }
                  return comment
                })
              }
              
              return post
            })
            communityStore.saveData()
            logger.info(LogCategory.USER, 'Community posts updated with new user info')
          }
        } catch (error) {
          logger.warn(LogCategory.USER, 'Failed to update community posts', error)
        }
      }
      
      return true
    },

    uploadAvatar(avatarUrl: string): boolean {
      if (!avatarUrl || typeof avatarUrl !== 'string') {
        logger.warn(LogCategory.USER, 'Invalid avatar URL provided', { avatarUrl })
        return false
      }
      
      const timestamp = Date.now()
      const avatarWithTimestamp = avatarUrl.includes('?') 
        ? `${avatarUrl}&t=${timestamp}` 
        : `${avatarUrl}?t=${timestamp}`
      return this.updateUserInfo({ avatar: avatarWithTimestamp })
    },

    updateNickname(nickname: string): boolean {
      return this.updateUserInfo({ nickname })
    },

    clearError(): void {
      this.error = ''
    }
  }
})
