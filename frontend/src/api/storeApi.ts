import api from './index';

// 根据ID获取店铺
export const getStoreById = (id: number) => {
  return api.get(`/api/store/${id}`);
};

// 获取店铺列表
export const getStoreList = (page: number, size: number, filters?: any) => {
  return api.get('/api/store/list', {
    params: { page, size, ...filters }
  });
};

// 获取所有店铺
export const getAllStores = () => {
  return api.get('/api/store/all');
};

// 创建店铺
export const createStore = (data: any) => {
  return api.post('/api/store', data);
};

// 更新店铺
export const updateStore = (data: any) => {
  return api.put('/api/store', data);
};

// 删除店铺
export const deleteStore = (id: number) => {
  return api.delete(`/api/store/${id}`);
};
