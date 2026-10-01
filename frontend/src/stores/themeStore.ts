import { defineStore } from 'pinia'

export type ThemeType = 'light' | 'dark' | 'eye-care'

interface ThemeState {
  theme: ThemeType
}

export const useThemeStore = defineStore('theme', {
  state: (): ThemeState => ({
    theme: 'light'
  }),
  actions: {
    setTheme(theme: ThemeType) {
      this.theme = theme
      this.saveThemeToLocalStorage()
      this.applyTheme()
    },
    saveThemeToLocalStorage() {
      localStorage.setItem('theme', this.theme)
    },
    loadThemeFromLocalStorage() {
      const savedTheme = localStorage.getItem('theme') as ThemeType | null
      if (savedTheme) {
        this.theme = savedTheme
      } else {
        this.detectSystemTheme()
      }
      this.applyTheme()
    },
    detectSystemTheme() {
      if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
        this.theme = 'dark'
      } else {
        this.theme = 'light'
      }
    },
    applyTheme() {
      document.documentElement.setAttribute('data-theme', this.theme)
    }
  }
})
