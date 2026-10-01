import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import 'leaflet/dist/leaflet.css'
import VueLazyload from 'vue-lazyload'
import './assets/styles/global.css'
import App from './App.vue'
import router from './router'
import { useUserStore } from './stores/userStore'
import { useThemeStore } from './stores/themeStore'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)
app.use(ElementPlus)
app.use(VueLazyload, {
  preLoad: 1.3,
  error: '/src/assets/images/error.png',
  loading: '/src/assets/images/loading.png',
  attempt: 1
})

// 清除旧的用户信息，确保使用新的用户信息
const userStore = useUserStore()
userStore.clearUserInfo()

// 初始化主题
const themeStore = useThemeStore()
themeStore.loadThemeFromLocalStorage()

app.mount('#app')