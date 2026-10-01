package com.heritage.food.api;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.heritage.food.model.CommunityPost;
import com.heritage.food.service.CommunityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/community")
public class CommunityController {

    @Autowired
    private CommunityService communityService;

    @GetMapping("/{id}")
    public CommunityPost getPostById(@PathVariable Long id) {
        return communityService.getPostById(id);
    }

    @GetMapping("/list")
    public Page<CommunityPost> getPostList(@RequestParam int page, @RequestParam int size) {
        return communityService.getPostList(page, size);
    }

    @GetMapping("/all")
    public List<CommunityPost> getAllPosts() {
        return communityService.getAllPosts();
    }

    @PostMapping
    public void savePost(@RequestBody CommunityPost post) {
        communityService.savePost(post);
    }

    @PutMapping
    public void updatePost(@RequestBody CommunityPost post) {
        communityService.updatePost(post);
    }

    @DeleteMapping("/{id}")
    public void deletePost(@PathVariable Long id) {
        communityService.deletePost(id);
    }
}
