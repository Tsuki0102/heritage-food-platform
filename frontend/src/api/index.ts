import axios from 'axios';

// 创建Axios实例
const api = axios.create({
  baseURL: '',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json'
  }
});

// 请求拦截器
api.interceptors.request.use(
  config => {
    console.log(`[API请求] ${config.method?.toUpperCase()} ${config.baseURL}${config.url}`, config.params || '');
    return config;
  },
  error => {
    console.error('[API请求错误]:', error);
    return Promise.reject(error);
  }
);

// 响应拦截器
api.interceptors.response.use(
  response => {
    console.log(`[API响应] ${response.config.url}:`, response.status);
    return response.data;
  },
  error => {
    if (error.code === 'ECONNABORTED') {
      console.error('[API超时] 请求超时，请检查网络连接或后端服务是否正常运行');
      console.error('[API超时] 目标地址:', error.config?.baseURL + error.config?.url);
    } else if (error.response) {
      console.error(`[API错误] ${error.response.status}:`, error.response.data);
    } else if (error.request) {
      console.error('[API无响应] 服务器无响应，请确认后端服务已启动');
      console.error('[API无响应] 代理目标: http://localhost:8088');
    } else {
      console.error('[API异常]:', error.message);
    }
    return Promise.reject(error);
  }
);

export default api;