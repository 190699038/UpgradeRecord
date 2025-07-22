
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueJsx from '@vitejs/plugin-vue-jsx'
import path from 'path'

// https://vite.dev/config/
export default defineConfig({
  base: './', // 添加这行确保资源使用相对路径
  publicPath: './',
  plugins: [vue(), vueJsx()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src')
    }
  },
  build: {
    sourcemap: true, // 生成 Sourcemap
  },
  server: {
    host: '0.0.0.0',

    proxy: {
      '/DailyReview/server': {
        changeOrigin: true,
      },
      '/api': {
        target: 'https://api.dingtalk.com',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''),
        secure: false, // 开发环境可以忽略HTTPS证书验证
        ws: true // 如果需要代理WebSocket
      }
    }
  }
})