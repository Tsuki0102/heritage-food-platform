import { ref, computed } from 'vue'
import { useCommunityStore } from '../stores/communityStore'
import { useUserStore } from '../stores/userStore'
import { COMMUNITY_TABS, COMMUNITY_TAB_LABELS, PAGINATION } from '../constants'
import { Validator } from '../utils'
import { logger, LogCategory } from '../utils/logger'
import api from '../api'

export function useCommunity() {
  const communityStore = useCommunityStore()
  const userStore = useUserStore()
  
  userStore.loadUser()

  const tabs = [
    { key: COMMUNITY_TABS.ALL, label: (COMMUNITY_TAB_LABELS as Record<string, string>)[COMMUNITY_TABS.ALL] },
    { key: COMMUNITY_TABS.COOK, label: (COMMUNITY_TAB_LABELS as Record<string, string>)[COMMUNITY_TABS.COOK] },
    { key: COMMUNITY_TABS.EXPERIENCE, label: (COMMUNITY_TAB_LABELS as Record<string, string>)[COMMUNITY_TABS.EXPERIENCE] },
    { key: COMMUNITY_TABS.SHOP, label: (COMMUNITY_TAB_LABELS as Record<string, string>)[COMMUNITY_TABS.SHOP] }
  ]

  const activeTab = ref(COMMUNITY_TABS.ALL)

  const showPostModal = ref(false)
  const newPost = ref({
    title: '',
    content: '',
    type: COMMUNITY_TABS.COOK,
    mediaPath: ''
  })

  const currentPage = ref(1)
  const pageSize = ref(PAGINATION.DEFAULT_PAGE_SIZE)

  const filteredPosts = computed(() => {
    return communityStore.filteredPosts(activeTab.value)
  })

  const paginatedPosts = computed(() => {
    const startIndex = (currentPage.value - 1) * pageSize.value
    const endIndex = startIndex + pageSize.value
    return filteredPosts.value.slice(startIndex, endIndex)
  })

  const totalPages = computed(() => {
    return Math.ceil(filteredPosts.value.length / pageSize.value)
  })

  const handleImageUpload = async (event: Event) => {
    const target = event.target as HTMLInputElement
    if (!target.files?.[0]) return

    const file = target.files[0]
    if (!file.type.startsWith('image/')) {
      alert('请选择图片')
      return
    }
    if (file.size > 5 * 1024 * 1024) {
      alert('图片不能超过5MB')
      return
    }

    try {
      const formData = new FormData()
      formData.append('file', file)

      // 上传文件时需要设置 Content-Type 为 multipart/form-data
      // 响应拦截器已剥壳，res 即后端返回的文件路径（如 /file/xxx.jpg）
      const res = await api.post('/file/upload', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })

      const imageUrl = typeof res === 'string' ? res : String((res as any)?.data ?? '')

      if (imageUrl && !imageUrl.includes('失败') && !imageUrl.includes('为空')) {
        newPost.value.mediaPath = imageUrl.startsWith('/') ? imageUrl : `/uploads/${imageUrl}`
        alert('图片上传成功！')
      } else {
        alert('上传失败：' + imageUrl)
      }
    } catch (err) {
      console.error('上传异常', err)
      alert('图片上传失败')
    }
  }

  const validatePost = () => {
    if (!Validator.required(newPost.value.title)) {
      alert('请输入帖子标题')
      return false
    }
    
    if (!Validator.required(newPost.value.content)) {
      alert('请输入帖子内容')
      return false
    }
    
    if (!Validator.minLength(newPost.value.title, 2)) {
      alert('标题至少需要2个字符')
      return false
    }
    
    if (!Validator.maxLength(newPost.value.title, 100)) {
      alert('标题不能超过100个字符')
      return false
    }
    
    if (!Validator.maxLength(newPost.value.content, 1000)) {
      alert('内容不能超过1000个字符')
      return false
    }
    
    return true
  }

  const submitPost = async () => {
    if (!validatePost()) {
      return
    }

    const postData = {
      title: newPost.value.title.trim(),
      content: newPost.value.content.trim(),
      type: newPost.value.type,
      mediaPath: newPost.value.mediaPath
    }

    try {
      const success = await communityStore.addPost(postData)
      
      if (success) {
        showPostModal.value = false
        resetPostForm()
        alert('发布成功')
      } else {
        alert('发布失败，请重试')
      }
    } catch (error) {
      logger.error(LogCategory.COMMUNITY, 'Failed to submit post', undefined, error instanceof Error ? error.stack : undefined)
      alert('发布失败，请重试')
    }
  }

  const resetPostForm = () => {
    newPost.value = {
      title: '',
      content: '',
      type: COMMUNITY_TABS.COOK,
      mediaPath: ''
    }
  }

  const handleShare = (postId: number) => {
    logger.info(LogCategory.COMMUNITY, 'Share triggered', { postId })
    alert('分享功能已触发')
  }

  const handlePageChange = (page: number) => {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page
      logger.debug(LogCategory.COMMUNITY, 'Page changed', { page })
    }
  }

  const handlePrevPage = () => {
    if (currentPage.value > 1) {
      currentPage.value--
      logger.debug(LogCategory.COMMUNITY, 'Previous page', { page: currentPage.value })
    }
  }

  const handleNextPage = () => {
    if (currentPage.value < totalPages.value) {
      currentPage.value++
      logger.debug(LogCategory.COMMUNITY, 'Next page', { page: currentPage.value })
    }
  }

  const handleDeletePost = async (postId: number) => {
    if (!confirm('确定要删除这个帖子吗？')) {
      return
    }

    try {
      const success = await communityStore.deletePost(postId)
      
      if (success) {
        alert('删除成功')
        
        if (paginatedPosts.value.length === 0 && currentPage.value > 1) {
          currentPage.value--
        }
      } else {
        alert('删除失败：您没有权限删除这个帖子')
      }
    } catch (error) {
      logger.error(LogCategory.COMMUNITY, 'Failed to delete post', { postId }, error instanceof Error ? error.stack : undefined)
      alert('删除失败，请重试')
    }
  }

  const deleteComment = (postId: number, commentId: number) => {
    const success = communityStore.deleteComment(postId, commentId)
    
    if (success) {
      alert('删除成功')
    } else {
      alert('删除失败：您没有权限删除这个评论')
    }
  }

  return {
    posts: computed(() => communityStore.posts),
    tabs,
    activeTab,
    showPostModal,
    newPost,
    currentPage,
    pageSize,
    filteredPosts,
    paginatedPosts,
    totalPages,
    handleImageUpload,
    submitPost,
    handleLike: (postId: number) => communityStore.handleLike(postId),
    handleComment: (postId: number) => communityStore.handleComment(postId),
    addComment: (postId: number, content: string) => communityStore.addComment(postId, content),
    handleCommentLike: (postId: number, commentId: number) => communityStore.handleCommentLike(postId, commentId),
    handleShare,
    handlePageChange,
    handlePrevPage,
    handleNextPage,
    handleDeletePost,
    deleteComment
  }
}
