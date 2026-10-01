import { defineStore } from 'pinia'
import { logger, LogCategory } from '../../utils/logger'
import api from '../../api'
import type { Permission } from '../../types'

interface PermissionAdminState {
  permissions: Permission[]
  permissionTree: Permission[]
  loading: boolean
  error: string
  userPermissions: string[]
}

export const usePermissionAdminStore = defineStore('permissionAdmin', {
  state: (): PermissionAdminState => ({
    permissions: [],
    permissionTree: [],
    loading: false,
    error: '',
    userPermissions: []
  }),

  getters: {
    getPermissionById: (state) => (id: number) => {
      return state.permissions.find(permission => permission.id === id)
    },
    getPermissionTree: (state) => {
      return state.permissionTree
    },
    hasPermission: (state) => (permissionKey: string) => {
      return state.userPermissions.includes(permissionKey)
    }
  },

  actions: {
    async fetchPermissions() {
      this.loading = true
      this.error = ''
      
      try {
        const response = await api.get('/api/admin/permissions')
        this.permissions = response.data || []
        
        logger.info(LogCategory.ADMIN, 'Permissions fetched', { count: this.permissions.length })
      } catch (error) {
        this.error = '获取权限列表失败'
        logger.error(LogCategory.ADMIN, 'Failed to fetch permissions', error instanceof Error ? error.stack : undefined)
        this.permissions = []
      } finally {
        this.loading = false
      }
    },

    async fetchPermissionTree() {
      this.loading = true
      this.error = ''
      
      try {
        const response = await api.get('/api/admin/permissions/tree')
        this.permissionTree = response || []
        
        logger.info(LogCategory.ADMIN, 'Permission tree fetched', { count: this.permissionTree.length })
      } catch (error) {
        this.error = '获取权限树失败'
        logger.error(LogCategory.ADMIN, 'Failed to fetch permission tree', error instanceof Error ? error.stack : undefined)
        this.permissionTree = []
      } finally {
        this.loading = false
      }
    },

    async fetchUserPermissions(userId: number) {
      this.loading = true
      this.error = ''
      
      try {
        const response = await api.get(`/api/admin/permissions/user/${userId}/keys`)
        this.userPermissions = response || []
        
        logger.info(LogCategory.ADMIN, 'User permissions fetched', { count: this.userPermissions.length })
      } catch (error) {
        this.error = '获取用户权限失败'
        logger.error(LogCategory.ADMIN, 'Failed to fetch user permissions', error instanceof Error ? error.stack : undefined)
        this.userPermissions = []
      } finally {
        this.loading = false
      }
    },

    async addPermission(permission: Omit<Permission, 'id' | 'createTime' | 'updateTime'>) {
      this.loading = true
      this.error = ''
      
      try {
        await api.post('/api/admin/permissions', permission)
        await this.fetchPermissions()
        await this.fetchPermissionTree()
        
        logger.info(LogCategory.ADMIN, 'Permission added')
        return true
      } catch (error) {
        this.error = '添加权限失败'
        logger.error(LogCategory.ADMIN, 'Failed to add permission', error instanceof Error ? error.stack : undefined)
        return false
      } finally {
        this.loading = false
      }
    },

    async updatePermission(permission: Permission) {
      this.loading = true
      this.error = ''
      
      try {
        await api.put('/api/admin/permissions', permission)
        await this.fetchPermissions()
        await this.fetchPermissionTree()
        
        logger.info(LogCategory.ADMIN, 'Permission updated', { permissionId: permission.id })
        return true
      } catch (error) {
        this.error = '更新权限失败'
        logger.error(LogCategory.ADMIN, 'Failed to update permission', { permissionId: permission.id }, error instanceof Error ? error.stack : undefined)
        return false
      } finally {
        this.loading = false
      }
    },

    async deletePermission(id: number) {
      this.loading = true
      this.error = ''
      
      try {
        await api.delete(`/api/admin/permissions/${id}`)
        await this.fetchPermissions()
        await this.fetchPermissionTree()
        
        logger.info(LogCategory.ADMIN, 'Permission deleted', { permissionId: id })
        return true
      } catch (error) {
        this.error = '删除权限失败'
        logger.error(LogCategory.ADMIN, 'Failed to delete permission', { permissionId: id }, error instanceof Error ? error.stack : undefined)
        return false
      } finally {
        this.loading = false
      }
    },

    async checkPermission(userId: number, permissionKey: string) {
      try {
        const response = await api.get(`/api/admin/permissions/user/${userId}/check/${permissionKey}`)
        return response.hasPermission
      } catch (error) {
        logger.error(LogCategory.ADMIN, 'Failed to check permission', error instanceof Error ? error.stack : undefined)
        return false
      }
    },

    clearError() {
      this.error = ''
    }
  }
})