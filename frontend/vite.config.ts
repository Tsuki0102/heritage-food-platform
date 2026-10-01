import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0',      // 允许手机访问
    port: 3000,           // 强制固定端口 3000（不再乱跳）
    strictPort: true,     // 强制只用 3000，不自动+1
    proxy: {
      '/api': {
        target: 'http://localhost:8088',
        changeOrigin: true
        // 不再rewrite路径，保持/api前缀原样转发给后端
      },
      '/file': {
        target: 'http://localhost:8088',
        changeOrigin: true,
        rewrite: (path) => path
      }
    }
  }
})