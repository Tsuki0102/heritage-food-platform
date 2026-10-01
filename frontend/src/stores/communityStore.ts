import { defineStore } from 'pinia'
import { Storage, generateId, resolveAvatarUrl } from '../utils'
import { logger, LogCategory } from '../utils/logger'
import { STORAGE_KEYS, DEFAULT_AVATAR, POST_TYPE_LABELS } from '../constants'
import { useUserStore } from './userStore'
import { getPostList, getPostById, getAllPosts, createPost, updatePost, deletePost } from '../api/communityApi'
import type { Post, Comment } from '../types'

export const useCommunityStore = defineStore('community', {
    state: () => ({
        posts: [] as Post[],
        loading: false,
        error: null as string | null
    }),

    getters: {
        filteredPosts: (state) => (tab: string) => {
            if (tab === 'all') {
                return state.posts
            }
            return state.posts.filter(post => post.type === tab)
        },

        findPostById: (state) => (id: number) => {
            return state.posts.find(post => post.id === id)
        },

        getCommentsByPostId: (state) => (postId: number) => {
            const post = state.posts.find(p => p.id === postId)
            return post?.comments || []
        }
    },

    actions: {
        updatePost(postId: number, updates: Partial<Post>): boolean {
            const postIndex = this.posts.findIndex(p => p.id === postId)
            if (postIndex === -1) {
                logger.warn(LogCategory.COMMUNITY, 'Post not found', { postId })
                return false
            }

            this.posts[postIndex] = { ...this.posts[postIndex], ...updates }
            this.saveData()
            return true
        },

        saveData(): void {
            // 只存储用户交互状态（点赞、评论），避免存储整个帖子数据导致localStorage配额超出
            const userInteractions = {
                likes: this.posts.map(post => ({
                    id: post.id,
                    liked: post.liked
                })).filter(item => item.liked),
                comments: this.posts.flatMap(post => 
                    (post.comments || []).map(comment => ({
                        postId: post.id,
                        id: comment.id,
                        content: comment.content,
                        userId: comment.userId,
                        nickname: comment.nickname,
                        avatar: comment.avatar,
                        createTime: comment.createTime
                    }))
                )
            }
            Storage.set(STORAGE_KEYS.COMMUNITY_DATA, userInteractions)
        },

        getCurrentUserId(): number | null {
            const userStore = useUserStore()
            return userStore.userId || null
        },

        getCurrentUser() {
            const userStore = useUserStore()
            const user = userStore.userInfo

            if (!user) {
                return null
            }

            return {
                id: user.id,
                nickname: user.nickname,
                avatar: user.avatar ? resolveAvatarUrl(user.avatar) : DEFAULT_AVATAR
            }
        },

        handleLike(postId: number): boolean {
            const post = this.findPostById(postId)
            if (!post) {
                logger.warn(LogCategory.COMMUNITY, 'Post not found for like', { postId })
                return false
            }

            return this.updatePost(postId, {
                liked: !post.liked,
                likeCount: post.likeCount + (post.liked ? -1 : 1)
            })
        },

        handleComment(postId: number): boolean {
            const post = this.findPostById(postId)
            if (!post) {
                logger.warn(LogCategory.COMMUNITY, 'Post not found for comment toggle', { postId })
                return false
            }

            return this.updatePost(postId, {
                showComments: !post.showComments
            })
        },

        handleCommentLike(postId: number, commentId: number): boolean {
            const post = this.findPostById(postId)
            if (!post || !post.comments) {
                logger.warn(LogCategory.COMMUNITY, 'Post or comments not found', { postId })
                return false
            }

            const commentIndex = post.comments.findIndex(c => c.id === commentId)
            if (commentIndex === -1) {
                logger.warn(LogCategory.COMMUNITY, 'Comment not found', { commentId })
                return false
            }

            const comment = post.comments[commentIndex]
            const updatedComments = [...post.comments]
            updatedComments[commentIndex] = {
                ...comment,
                liked: !comment.liked,
                likeCount: (comment.likeCount || 0) + (comment.liked ? -1 : 1)
            }

            return this.updatePost(postId, { comments: updatedComments })
        },

        addComment(postId: number, content: string): boolean {
            if (!content.trim()) {
                logger.warn(LogCategory.COMMUNITY, 'Empty comment content')
                return false
            }

            const post = this.findPostById(postId)
            if (!post) {
                logger.warn(LogCategory.COMMUNITY, 'Post not found for adding comment', { postId })
                return false
            }

            const currentUser = this.getCurrentUser()
            if (!currentUser) {
                logger.warn(LogCategory.COMMUNITY, 'Cannot add comment: User not logged in')
                return false
            }

            const newComment: Comment = {
                id: generateId(),
                userId: currentUser.id,
                nickname: currentUser.nickname,
                avatar: currentUser.avatar || DEFAULT_AVATAR,
                content: content.trim(),
                createTime: new Date().toLocaleString('zh-CN'),
                liked: false,
                likeCount: 0
            }

            const updatedComments = [...(post.comments || []), newComment]

            return this.updatePost(postId, {
                comments: updatedComments,
                commentCount: (post.commentCount || 0) + 1
            })
        },

        async addPost(postData: Partial<Post>): Promise<boolean> {
            const currentUser = this.getCurrentUser()
            if (!currentUser) {
                logger.warn(LogCategory.COMMUNITY, 'Cannot add post: User not logged in')
                return false
            }
            
            logger.info(LogCategory.COMMUNITY, 'Adding post for user', { userId: currentUser.id, nickname: currentUser.nickname })

            try {
                // 准备后端需要的数据结构
            const backendPost = {
                userId: currentUser.id,
                title: postData.title || '',
                content: postData.content || '',
                type: postData.type === 'cook' ? 0 : (postData.type === 'experience' ? 1 : 2),
                mediaPath: postData.mediaPath || ''
            }

                // 调用后端API创建帖子
                await createPost(backendPost)
                
                // 重新获取帖子列表，确保数据同步
                await this.fetchPosts()
                
                logger.info(LogCategory.COMMUNITY, 'New post added to database')
                return true
            } catch (error) {
                logger.error(LogCategory.COMMUNITY, 'Failed to add post', undefined, error instanceof Error ? error.stack : undefined)
                return false
            }
        },

        async deletePost(postId: number): Promise<boolean> {
            const currentUserId = this.getCurrentUserId()
            if (!currentUserId) {
                logger.warn(LogCategory.COMMUNITY, 'Cannot delete post: User not logged in')
                return false
            }

            const post = this.findPostById(postId)
            if (!post) {
                logger.warn(LogCategory.COMMUNITY, 'Post not found for deletion', { postId })
                return false
            }

            if (post.userId !== currentUserId) {
                logger.warn(LogCategory.COMMUNITY, 'Permission denied: Cannot delete other user\'s post', {
                    postId,
                    postUserId: post.userId,
                    currentUserId
                })
                return false
            }

            try {
                // 调用后端API删除帖子
                await deletePost(postId)
                
                // 从本地状态中移除帖子
                this.posts = this.posts.filter(p => p.id !== postId)
                this.saveData()
                
                logger.info(LogCategory.COMMUNITY, 'Post deleted from database', { postId })
                return true
            } catch (error) {
                logger.error(LogCategory.COMMUNITY, 'Failed to delete post', { postId }, error instanceof Error ? error.stack : undefined)
                return false
            }
        },

        deleteComment(postId: number, commentId: number): boolean {
            const currentUserId = this.getCurrentUserId()
            if (!currentUserId) {
                logger.warn(LogCategory.COMMUNITY, 'Cannot delete comment: User not logged in')
                return false
            }

            const post = this.findPostById(postId)
            if (!post || !post.comments) {
                logger.warn(LogCategory.COMMUNITY, 'Post or comments not found', { postId })
                return false
            }

            const comment = post.comments.find(c => c.id === commentId)
            if (!comment) {
                logger.warn(LogCategory.COMMUNITY, 'Comment not found', { commentId })
                return false
            }

            if (String(comment.userId) !== String(currentUserId)) {
                logger.warn(LogCategory.COMMUNITY, 'Permission denied: Cannot delete other user\'s comment', {
                    commentId,
                    commentUserId: comment.userId,
                    currentUserId
                })
                return false
            }

            const updatedComments = post.comments.filter(c => c.id !== commentId)

            return this.updatePost(postId, {
                comments: updatedComments,
                commentCount: Math.max(0, post.commentCount - 1)
            })
        },

        async fetchPosts(): Promise<Post[]> {
            this.loading = true
            this.error = null

            try {
                const response = await getPostList(1, 20)

                if (response && Array.isArray(response.records)) {
                    this.posts = response.records.map((apiPost: any) => ({
                        id: apiPost.id,
                        userId: apiPost.userId,
                        nickname: apiPost.nickname || '用户',
                        avatar: apiPost.avatar
                          ? resolveAvatarUrl(apiPost.avatar)
                          : DEFAULT_AVATAR,
                        title: apiPost.title,
                        content: apiPost.content,
                        mediaPath: apiPost.mediaPath,
                        type: apiPost.type === 0 ? 'cook' : (apiPost.type === 1 ? 'experience' : 'shop'),
                        typeText: POST_TYPE_LABELS[apiPost.type === 0 ? 'cook' : (apiPost.type === 1 ? 'experience' : 'shop')] || '美食复刻',
                        likeCount: apiPost.likeCount || 0,
                        commentCount: apiPost.commentCount || 0,
                        createTime: apiPost.createTime || new Date().toLocaleString('zh-CN'),
                        liked: false,
                        showComments: false,
                        comments: (apiPost.comments || []).map((comment: any) => ({
                            id: comment.id,
                            userId: comment.userId,
                            nickname: comment.nickname || '用户',
                            avatar: comment.avatar
                              ? resolveAvatarUrl(comment.avatar)
                              : DEFAULT_AVATAR,
                            content: comment.content,
                            createTime: comment.createTime || new Date().toLocaleString('zh-CN'),
                            liked: false,
                            likeCount: 0
                        }))
                    }))
                    
                    // 加载用户交互状态
                    this.loadUserInteractions()
                    return this.posts
                } else {
                    logger.warn(LogCategory.COMMUNITY, 'API returned unexpected format')
                    return this.posts
                }
            } catch (error) {
                this.error = '获取社区帖子失败'
                logger.error(LogCategory.COMMUNITY, 'Failed to fetch posts', undefined, error instanceof Error ? error.stack : undefined)
                return this.posts
            } finally {
                this.loading = false
            }
        },

        async fetchAllPosts(): Promise<Post[]> {
            this.loading = true
            this.error = null

            try {
                const response = await getAllPosts()

                if (Array.isArray(response)) {
                    this.posts = response.map((apiPost: any) => ({
                        id: apiPost.id,
                        userId: apiPost.userId,
                        nickname: apiPost.nickname || '用户',
                        avatar: apiPost.avatar
                          ? resolveAvatarUrl(apiPost.avatar)
                          : DEFAULT_AVATAR,
                        title: apiPost.title,
                        content: apiPost.content,
                        mediaPath: apiPost.mediaPath,
                        type: apiPost.type === 0 ? 'cook' : (apiPost.type === 1 ? 'experience' : 'shop'),
                        typeText: POST_TYPE_LABELS[apiPost.type === 0 ? 'cook' : (apiPost.type === 1 ? 'experience' : 'shop')] || '美食复刻',
                        likeCount: apiPost.likeCount || 0,
                        commentCount: apiPost.commentCount || 0,
                        createTime: apiPost.createTime || new Date().toLocaleString('zh-CN'),
                        liked: false,
                        showComments: false,
                        comments: (apiPost.comments || []).map((comment: any) => ({
                            id: comment.id,
                            userId: comment.userId,
                            nickname: comment.nickname || '用户',
                            avatar: comment.avatar
                              ? resolveAvatarUrl(comment.avatar)
                              : DEFAULT_AVATAR,
                            content: comment.content,
                            createTime: comment.createTime || new Date().toLocaleString('zh-CN'),
                            liked: false,
                            likeCount: 0
                        }))
                    }))
                    
                    // 加载用户交互状态
                    this.loadUserInteractions()
                    return this.posts
                } else {
                    logger.warn(LogCategory.COMMUNITY, 'API returned unexpected format')
                    return this.posts
                }
            } catch (error) {
                this.error = '获取所有社区帖子失败'
                logger.error(LogCategory.COMMUNITY, 'Failed to fetch all posts', undefined, error instanceof Error ? error.stack : undefined)
                return this.posts
            } finally {
                this.loading = false
            }
        },

        loadUserInteractions(): void {
            try {
                const userInteractions = Storage.get(STORAGE_KEYS.COMMUNITY_DATA)
                if (userInteractions) {
                    // 恢复点赞状态
                    if (userInteractions.likes) {
                        userInteractions.likes.forEach((like: any) => {
                            const post = this.findPostById(like.id)
                            if (post) {
                                post.liked = like.liked
                            }
                        })
                    }
                    
                    // 恢复评论
                    if (userInteractions.comments) {
                        userInteractions.comments.forEach((commentData: any) => {
                            const post = this.findPostById(commentData.postId)
                            if (post) {
                                // 检查评论是否已存在
                                const existingComment = post.comments?.find((c: any) => c.id === commentData.id)
                                if (!existingComment) {
                                    // 添加新评论
                                    const newComment = {
                                        id: commentData.id,
                                        userId: commentData.userId,
                                        nickname: commentData.nickname,
                                        avatar: commentData.avatar,
                                        content: commentData.content,
                                        createTime: commentData.createTime,
                                        liked: false,
                                        likeCount: 0
                                    }
                                    if (!post.comments) {
                                        post.comments = []
                                    }
                                    post.comments.push(newComment)
                                    post.commentCount = (post.commentCount || 0) + 1
                                }
                            }
                        })
                    }
                }
            } catch (error) {
                logger.error(LogCategory.COMMUNITY, 'Failed to load user interactions', undefined, error instanceof Error ? error.stack : undefined)
            }
        },

        clearError(): void {
            this.error = null
        }
    }
})