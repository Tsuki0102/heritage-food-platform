package com.heritage.food.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.CommunityPost;

import java.util.List;

public interface CommunityService {
    CommunityPost getPostById(Long id);
    Page<CommunityPost> getPostList(int page, int size);
    List<CommunityPost> getAllPosts();
    void savePost(CommunityPost post);
    void updatePost(CommunityPost post);
    void deletePost(Long id);
}
