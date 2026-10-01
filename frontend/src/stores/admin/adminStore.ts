import { defineStore } from 'pinia'
import { logger, LogCategory } from '../../utils/logger'

interface AdminState {
  sidebarCollapsed: boolean
  currentRoute: string
  breadcrumbs: Array<{ name: string; path: string }>
}

export const useAdminStore = defineStore('admin', {
  state: (): AdminState => ({
    sidebarCollapsed: false,
    currentRoute: '',
    breadcrumbs: []
  }),

  getters: {
    isSidebarCollapsed: (state) => state.sidebarCollapsed
  },

  actions: {
    toggleSidebar() {
      this.sidebarCollapsed = !this.sidebarCollapsed
      logger.info(LogCategory.ADMIN, 'Sidebar toggled', { collapsed: this.sidebarCollapsed })
    },

    setCurrentRoute(route: string) {
      this.currentRoute = route
    },

    setBreadcrumbs(breadcrumbs: Array<{ name: string; path: string }>) {
      this.breadcrumbs = breadcrumbs
    },

    clearAdminState() {
      this.sidebarCollapsed = false
      this.currentRoute = ''
      this.breadcrumbs = []
      logger.info(LogCategory.ADMIN, 'Admin state cleared')
    }
  }
})