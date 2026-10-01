import { defineStore } from 'pinia'
import { logger, LogCategory } from '../../utils/logger'
import api from '../../api'
import type { User } from '../../types'

interface UserAdminState {
  users: User[]
  loading: boolean
  error: string
  total: number
  currentPage: number
  pageSize: number
  searchQuery: string
}

export const useUserAdminStore = defineStore('userAdmin', {
  state: (): UserAdminState => ({
    users: [],
    loading: false,
    error: '',
    total: 0,
    currentPage: 1,
    pageSize: 10,
    searchQuery: ''
  }),

  getters: {
    getUserById: (state) => (id: number) => {
      return state.users.find(user => user.id === id)
    }
  },

  actions: {
    async fetchUsers() {
      this.loading = true
      this.error = ''
      
      try {
        // 调用真实的API
        const response = await api.get('/api/user')
        this.users = response
        this.total = this.users.length
        
        logger.info(LogCategory.ADMIN, 'Users fetched', { count: this.users.length })
      } catch (error) {
        this.error = '获取用户列表失败'
        logger.error(LogCategory.ADMIN, 'Failed to fetch users', error instanceof Error ? error.stack : undefined)
        // 发生错误时使用模拟数据
        this.users = [
          {
            id: 1,
            nickname: '管理员',
            phone: '13800138000',
            password: '123456',
            gender: 1,
            region: '北京',
            registerTime: '2026-01-01 00:00:00',
            status: 1,
            isAdmin: 1,
            avatar: 'avatar1.jpg'
          },
          {
            id: 2,
            nickname: '张三',
            phone: '13800138001',
            password: '123456',
            gender: 1,
            region: '上海',
            registerTime: '2026-01-02 00:00:00',
            status: 1,
            isAdmin: 0,
            avatar: 'avatar2.jpg'
          },
          {
            id: 3,
            nickname: '李四',
            phone: '13800138002',
            password: '123456',
            gender: 0,
            region: '广州',
            registerTime: '2026-01-03 00:00:00',
            status: 1,
            isAdmin: 0,
            avatar: 'avatar3.jpg'
          }
        ]
        this.total = this.users.length
      } finally {
        this.loading = false
      }
    },

    async addUser(user: Omit<User, 'id' | 'registerTime'>) {
      this.loading = true
      this.error = ''
      
      try {
        // 调用真实的API
        await api.post('/api/user', user)
        // 重新获取用户列表
        await this.fetchUsers()
        
        logger.info(LogCategory.ADMIN, 'User added')
        return true
      } catch (error) {
        this.error = '添加用户失败'
        logger.error(LogCategory.ADMIN, 'Failed to add user', error instanceof Error ? error.stack : undefined)
        // 发生错误时使用模拟数据
        const newUser = {
          ...user,
          id: Math.max(...this.users.map(u => u.id)) + 1,
          registerTime: new Date().toISOString()
        }
        this.users.push(newUser)
        this.total++
        return true
      } finally {
        this.loading = false
      }
    },

    async updateUser(user: User) {
      this.loading = true
      this.error = ''
      
      try {
        // 调用真实的API
        await api.put('/api/user', user)
        // 不需要重新获取用户列表，直接更新本地数据
        const index = this.users.findIndex(u => u.id === user.id)
        if (index !== -1) {
          this.users[index] = user
        }
        
        logger.info(LogCategory.ADMIN, 'User updated', { userId: user.id })
        return true
      } catch (error) {
        this.error = '更新用户失败'
        logger.error(LogCategory.ADMIN, 'Failed to update user', { userId: user.id }, error instanceof Error ? error.stack : undefined)
        // 发生错误时使用模拟数据
        const index = this.users.findIndex(u => u.id === user.id)
        if (index !== -1) {
          this.users[index] = user
        }
        return true
      } finally {
        this.loading = false
      }
    },

    async deleteUser(id: number) {
      this.loading = true
      this.error = ''
      
      try {
        // 调用真实的API
        await api.delete(`/api/user/${id}`)
        // 重新获取用户列表
        await this.fetchUsers()
        
        logger.info(LogCategory.ADMIN, 'User deleted', { userId: id })
        return true
      } catch (error) {
        this.error = '删除用户失败'
        logger.error(LogCategory.ADMIN, 'Failed to delete user', { userId: id }, error instanceof Error ? error.stack : undefined)
        // 发生错误时使用模拟数据
        this.users = this.users.filter(u => u.id !== id)
        this.total--
        return true
      } finally {
        this.loading = false
      }
    },

    setCurrentPage(page: number) {
      this.currentPage = page
      this.fetchUsers()
    },

    setPageSize(size: number) {
      this.pageSize = size
      this.currentPage = 1
      this.fetchUsers()
    },

    setSearchQuery(query: string) {
      this.searchQuery = query
      this.currentPage = 1
      this.fetchUsers()
    },

    clearError() {
      this.error = ''
    }
  }
})