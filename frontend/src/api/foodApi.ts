import api from './index';

// 定义通用类型
interface ApiResponse<T = any> {
  code: number;
  message: string;
  data: T;
}

// 根据ID获取美食
export const getFoodById = (id: number): Promise<any> => {
  return api.get(`/api/food/${id}`);
};

// 获取美食列表
export const getFoodList = (page: number, size: number, filters?: any): Promise<any> => {
  return api.get('/api/food/list', {
    params: { page, size, ...filters }
  });
};

// 获取热门美食列表
export const getHotFoodList = (page: number, size: number): Promise<any> => {
  return api.get('/api/food/hot/list', {
    params: { page, size }
  });
};

// 根据地区获取美食
export const getFoodByRegion = (region: string): Promise<any> => {
  return api.get(`/api/food/region/${region}`);
};

// 根据口味获取美食
export const getFoodByTaste = (taste: string): Promise<any> => {
  return api.get(`/api/food/taste/${taste}`);
};

// 获取美食评价
export const getFoodRatings = (foodId: number): Promise<any[]> => {
  return api.get(`/api/food/${foodId}/ratings`);
};

// 提交美食评价
export const submitFoodRating = (foodId: number, score: number, content: string, userId: number): Promise<any> => {
  return api.post(`/api/food/rating/${foodId}`, {
    userId,
    score,
    content
  });
};

// 删除美食
export const deleteFood = (id: number): Promise<any> => {
  return api.delete(`/api/food/${id}`);
};

// 更新美食
export const updateFood = (data: any): Promise<any> => {
  return api.put('/api/food', data);
};
