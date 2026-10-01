import { defineStore } from 'pinia'
import { logger, LogCategory } from '../../utils/logger'
import api from '../../api'
import type { Role, Permission } from '../../types'

interface RoleAdminState {
  roles: Role[]
  loading: boolean
  error: string
  total: number
  currentPage: number
  pageSize: number
  searchQuery: string
}

export const useRoleAdminStore = defineStore('roleAdmin', {
  state: (): RoleAdminState => ({
    roles: [],
    loading: false,
    error: '',
    total: 0,
    currentPage: 1,
    pageSize: 10,
    searchQuery: ''
  }),

  getters: {
    getRoleById: (state) => (id: number) => {
      return state.roles.find(role => role.id === id)
    }
  },

  actions: {
    async fetchRoles() {
      this.loading = true
      this.error = ''
      
      try {
        const response = await api.get('/api/admin/roles')
        this.roles = response.data || []
        this.total = this.roles.length
        
        logger.info(LogCategory.ADMIN, 'Roles fetched', { count: this.roles.length })
      } catch (error) {
        this.error = '获取角色列表失败'
        logger.error(LogCategory.ADMIN, 'Failed to fetch roles', error instanceof Error ? error.stack : undefined)
        this.roles = []
        this.total = 0
      } finally {
        this.loading = false
      }
    },

    async addRole(role: Omit<Role, 'id' | 'createTime' | 'updateTime'>) {
      this.loading = true
      this.error = ''
      
      try {
        await api.post('/api/admin/roles', role)
        await this.fetchRoles()
        
        logger.info(LogCategory.ADMIN, 'Role added')
        return true
      } catch (error) {
        this.error = '添加角色失败'
        logger.error(LogCategory.ADMIN, 'Failed to add role', error instanceof Error ? error.stack : undefined)
        return false
      } finally {
        this.loading = false
      }
    },

    async updateRole(role: Role) {
      this.loading = true
      this.error = ''
      
      try {
        await api.put('/api/admin/roles', role)
        await this.fetchRoles()
        
        logger.info(LogCategory.ADMIN, 'Role updated', { roleId: role.id })
        return true
      } catch (error) {
        this.error = '更新角色失败'
        logger.error(LogCategory.ADMIN, 'Failed to update role', { roleId: role.id }, error instanceof Error ? error.stack : undefined)
        return false
      } finally {
        this.loading = false
      }
    },

    async deleteRole(id: number) {
      this.loading = true
      this.error = ''
      
      try {
        await api.delete(`/api/admin/roles/${id}`)
        await this.fetchRoles()
        
        logger.info(LogCategory.ADMIN, 'Role deleted', { roleId: id })
        return true
      } catch (error) {
        this.error = '删除角色失败'
        logger.error(LogCategory.ADMIN, 'Failed to delete role', { roleId: id }, error instanceof Error ? error.stack : undefined)
        return false
      } finally {
        this.loading = false
      }
    },

    async assignPermissionsToRole(roleId: number, permissionIds: number[]) {
      this.loading = true
      this.error = ''
      
      try {
        await api.post(`/api/admin/roles/${roleId}/permissions`, permissionIds)
        await this.fetchRoles()
        
        logger.info(LogCategory.ADMIN, 'Permissions assigned to role', { roleId })
        return true
      } catch (error) {
        this.error = '分配权限失败'
        logger.error(LogCategory.ADMIN, 'Failed to assign permissions', { roleId }, error instanceof Error ? error.stack : undefined)
        return false
      } finally {
        this.loading = false
      }
    },

    async removePermissionsFromRole(roleId: number, permissionIds: number[]) {
      this.loading = true
      this.error = ''
      
      try {
        await api.delete(`/api/admin/roles/${roleId}/permissions`, { data: permissionIds })
        await this.fetchRoles()
        
        logger.info(LogCategory.ADMIN, 'Permissions removed from role', { roleId })
        return true
      } catch (error) {
        this.error = '移除权限失败'
        logger.error(LogCategory.ADMIN, 'Failed to remove permissions', { roleId }, error instanceof Error ? error.stack : undefined)
        return false
      } finally {
        this.loading = false
      }
    },

    setCurrentPage(page: number) {
      this.currentPage = page
      this.fetchRoles()
    },

    setPageSize(size: number) {
      this.pageSize = size
      this.currentPage = 1
      this.fetchRoles()
    },

    setSearchQuery(query: string) {
      this.searchQuery = query
      this.currentPage = 1
      this.fetchRoles()
    },

    clearError() {
      this.error = ''
    }
  }
})