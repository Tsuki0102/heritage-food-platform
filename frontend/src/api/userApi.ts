import api from './index';

// 根据ID获取用户
export const getUserById = (id: number) => {
  return api.get(`/api/user/${id}`);
};

// 保存用户
export const saveUser = (userData: any) => {
  return api.post('/api/user', userData);
};