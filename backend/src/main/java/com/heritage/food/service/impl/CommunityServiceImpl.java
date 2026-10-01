package com.heritage.food.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.dao.CommunityCommentMapper;
import com.heritage.food.dao.CommunityPostMapper;
import com.heritage.food.dao.UserMapper;
import com.heritage.food.model.CommunityComment;
import com.heritage.food.model.CommunityPost;
import com.heritage.food.model.User;
import com.heritage.food.service.CommunityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommunityServiceImpl implements CommunityService {

    @Autowired
    private CommunityPostMapper communityPostMapper;
    @Autowired
    private CommunityCommentMapper communityCommentMapper;
    @Autowired
    private UserMapper userMapper;

    @Override
    public CommunityPost getPostById(Long id) {
        CommunityPost post = communityPostMapper.selectById(id);
        
        if (post != null) {
            // 关联查询用户信息
            User user = userMapper.selectById(post.getUserId());
            if (user != null) {
                post.setNickname(user.getNickname());
                post.setAvatar(user.getAvatar() != null ? user.getAvatar() : "avatar" + (post.getUserId() % 10 + 1) + ".jpg");
            } else {
                // 如果用户不存在，设置默认值
                post.setNickname("用户" + post.getUserId());
                post.setAvatar("avatar" + (post.getUserId() % 10 + 1) + ".jpg");
            }
            
            // 查询评论数
            QueryWrapper<CommunityComment> commentWrapper = new QueryWrapper<>();
            commentWrapper.eq("post_id", post.getId());
            Long commentCountLong = communityCommentMapper.selectCount(commentWrapper);
            Integer commentCount = commentCountLong != null ? commentCountLong.intValue() : 0;
            post.setCommentCount(commentCount);
            
            // 查询评论列表
            List<CommunityComment> comments = communityCommentMapper.selectList(commentWrapper);
            // 为每个评论添加用户信息
            for (CommunityComment comment : comments) {
                User commentUser = userMapper.selectById(comment.getUserId());
                if (commentUser != null) {
                    comment.setNickname(commentUser.getNickname());
                    comment.setAvatar(commentUser.getAvatar() != null ? commentUser.getAvatar() : "avatar" + (comment.getUserId() % 10 + 1) + ".jpg");
                }
            }
            post.setComments(comments);
        }
        
        return post;
    }

    @Override
    public Page<CommunityPost> getPostList(int page, int size) {
        Page<CommunityPost> postPage = new Page<>(page, size);
        QueryWrapper<CommunityPost> wrapper = new QueryWrapper<>();
        wrapper.orderByDesc("create_time");
        Page<CommunityPost> result = communityPostMapper.selectPage(postPage, wrapper);
        
        // 关联查询用户信息和评论数
        for (CommunityPost post : result.getRecords()) {
            // 关联查询用户信息
            User user = userMapper.selectById(post.getUserId());
            if (user != null) {
                post.setNickname(user.getNickname());
                post.setAvatar(user.getAvatar() != null ? user.getAvatar() : "avatar" + (post.getUserId() % 10 + 1) + ".jpg");
            } else {
                // 如果用户不存在，设置默认值
                post.setNickname("用户" + post.getUserId());
                post.setAvatar("avatar" + (post.getUserId() % 10 + 1) + ".jpg");
            }
            
            // 查询评论数
            QueryWrapper<CommunityComment> commentWrapper = new QueryWrapper<>();
            commentWrapper.eq("post_id", post.getId());
            Long commentCountLong = communityCommentMapper.selectCount(commentWrapper);
            Integer commentCount = commentCountLong != null ? commentCountLong.intValue() : 0;
            post.setCommentCount(commentCount);
            
            // 查询评论列表
            List<CommunityComment> comments = communityCommentMapper.selectList(commentWrapper);
            // 为每个评论添加用户信息
            for (CommunityComment comment : comments) {
                User commentUser = userMapper.selectById(comment.getUserId());
                if (commentUser != null) {
                    comment.setNickname(commentUser.getNickname());
                    comment.setAvatar(commentUser.getAvatar() != null ? commentUser.getAvatar() : "avatar" + (comment.getUserId() % 10 + 1) + ".jpg");
                }
            }
            post.setComments(comments);
        }
        
        return result;
    }

    @Override
    public List<CommunityPost> getAllPosts() {
        List<CommunityPost> posts = communityPostMapper.selectList(null);
        
        for (CommunityPost post : posts) {
            // 关联查询用户信息
            User user = userMapper.selectById(post.getUserId());
            if (user != null) {
                post.setNickname(user.getNickname());
                post.setAvatar(user.getAvatar() != null ? user.getAvatar() : "avatar" + (post.getUserId() % 10 + 1) + ".jpg");
            } else {
                // 如果用户不存在，设置默认值
                post.setNickname("用户" + post.getUserId());
                post.setAvatar("avatar" + (post.getUserId() % 10 + 1) + ".jpg");
            }
            
            // 查询评论数
            QueryWrapper<CommunityComment> commentWrapper = new QueryWrapper<>();
            commentWrapper.eq("post_id", post.getId());
            Long commentCountLong = communityCommentMapper.selectCount(commentWrapper);
            Integer commentCount = commentCountLong != null ? commentCountLong.intValue() : 0;
            post.setCommentCount(commentCount);
            
            // 查询评论列表
            List<CommunityComment> comments = communityCommentMapper.selectList(commentWrapper);
            // 为每个评论添加用户信息
            for (CommunityComment comment : comments) {
                User commentUser = userMapper.selectById(comment.getUserId());
                if (commentUser != null) {
                    comment.setNickname(commentUser.getNickname());
                    comment.setAvatar(commentUser.getAvatar() != null ? commentUser.getAvatar() : "avatar" + (comment.getUserId() % 10 + 1) + ".jpg");
                }
            }
            post.setComments(comments);
        }
        
        return posts;
    }

    @Override
    public void savePost(CommunityPost post) {
        communityPostMapper.insert(post);
    }

    @Override
    public void updatePost(CommunityPost post) {
        communityPostMapper.updateById(post);
    }

    @Override
    public void deletePost(Long id) {
        communityPostMapper.deleteById(id);
    }
}
