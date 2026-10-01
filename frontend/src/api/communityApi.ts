import api from './index';

// 根据ID获取社区帖子
export const getPostById = (id: number) => {
  return api.get(`/api/community/${id}`);
};

// 获取社区帖子列表
export const getPostList = (page: number, size: number) => {
  return api.get('/api/community/list', {
    params: { page, size }
  });
};

// 获取所有社区帖子
export const getAllPosts = () => {
  return api.get('/api/community/all');
};

// 创建社区帖子
export const createPost = (post: any) => {
  console.log('Creating post with data:', post);
  return api.post('/api/community', post);
};

// 更新社区帖子
export const updatePost = (post: any) => {
  return api.put('/api/community', post);
};

// 删除社区帖子
export const deletePost = (id: number) => {
  return api.delete(`/api/community/${id}`);
};
