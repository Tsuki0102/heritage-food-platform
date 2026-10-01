<template>
  <div class="user-help">
    <Header />
    
    <div class="container">
      <div class="page-header">
        <BackButton to="/user" />
        <h1>帮助与反馈</h1>
      </div>
      
      <div class="help-content">
        <div class="help-section">
          <h3>常见问题</h3>
          <div class="faq-list">
            <div class="faq-item" v-for="faq in faqs" :key="faq.id">
              <div class="faq-question" @click="toggleFaq(faq.id)">
                <span>{{ faq.question }}</span>
                <i class="icon">{{ faq.expanded ? '−' : '+' }}</i>
              </div>
              <div class="faq-answer" v-if="faq.expanded">
                <p>{{ faq.answer }}</p>
              </div>
            </div>
          </div>
        </div>
        
        <div class="help-section">
          <h3>意见反馈</h3>
          <div class="feedback-form">
            <div class="form-group">
              <label>反馈类型</label>
              <select v-model="feedback.type">
                <option value="bug">功能异常</option>
                <option value="suggestion">功能建议</option>
                <option value="content">内容问题</option>
                <option value="other">其他</option>
              </select>
            </div>
            <div class="form-group">
              <label>反馈内容</label>
              <textarea 
                v-model="feedback.content" 
                placeholder="请详细描述您遇到的问题或建议..."
                rows="5"
              ></textarea>
            </div>
            <div class="form-group">
              <label>联系方式（可选）</label>
              <input 
                type="text" 
                v-model="feedback.contact" 
                placeholder="手机号或邮箱"
              />
            </div>
            <button class="submit-btn" @click="submitFeedback">提交反馈</button>
          </div>
        </div>
        
        <div class="help-section">
          <h3>联系我们</h3>
          <div class="contact-info">
            <div class="contact-item">
              <i class="icon">📧</i>
              <span>邮箱：support@heritagefood.com</span>
            </div>
            <div class="contact-item">
              <i class="icon">📞</i>
              <span>电话：400-123-4567</span>
            </div>
            <div class="contact-item">
              <i class="icon">🕒</i>
              <span>工作时间：周一至周五 9:00-18:00</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <Footer />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import BackButton from '../components/BackButton.vue'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'

interface FAQ {
  id: number
  question: string
  answer: string
  expanded: boolean
}

const faqs = ref<FAQ[]>([
  {
    id: 1,
    question: '如何收藏美食或店铺？',
    answer: '在美食详情页或店铺详情页，点击"收藏"按钮即可收藏。收藏后可以在"我的收藏"中查看。',
    expanded: false
  },
  {
    id: 2,
    question: '如何发布帖子？',
    answer: '在社区页面，点击右上角的"发布"按钮，填写帖子内容后即可发布。',
    expanded: false
  },
  {
    id: 3,
    question: '如何修改个人信息？',
    answer: '在个人中心，点击"编辑资料"按钮，可以修改昵称、头像等个人信息。',
    expanded: false
  },
  {
    id: 4,
    question: '如何删除我的评论？',
    answer: '在"我的评价"页面，找到要删除的评论，点击"删除"按钮即可删除自己的评论。',
    expanded: false
  },
  {
    id: 5,
    question: '数据会丢失吗？',
    answer: '您的收藏、足迹、评论等数据都保存在本地，不会丢失。但清除浏览器缓存可能会导致数据丢失，请谨慎操作。',
    expanded: false
  }
])

const feedback = ref({
  type: 'bug',
  content: '',
  contact: ''
})

const toggleFaq = (id: number) => {
  const faq = faqs.value.find(f => f.id === id)
  if (faq) {
    faq.expanded = !faq.expanded
  }
}

const submitFeedback = () => {
  if (!feedback.value.content.trim()) {
    alert('请填写反馈内容')
    return
  }
  
  alert('感谢您的反馈！我们会尽快处理。')
  feedback.value = {
    type: 'bug',
    content: '',
    contact: ''
  }
}
</script>

<style scoped>
.user-help {
  min-height: 100vh;
  background: #f5f5f5;
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.page-header {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.page-header h1 {
  font-size: 20px;
  margin: 0;
  color: #333;
}

.help-content {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.help-section {
  margin-bottom: 30px;
}

.help-section:last-child {
  margin-bottom: 0;
}

.help-section h3 {
  font-size: 18px;
  color: #333;
  margin: 0 0 15px 0;
  padding-bottom: 10px;
  border-bottom: 2px solid #c8161d;
}

.faq-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.faq-item {
  border: 1px solid #f0f0f0;
  border-radius: 4px;
  overflow: hidden;
}

.faq-question {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 15px;
  background: #f9f9f9;
  cursor: pointer;
  transition: background 0.3s;
}

.faq-question:hover {
  background: #f5f5f5;
}

.faq-question span {
  font-size: 14px;
  color: #333;
}

.faq-question .icon {
  font-size: 20px;
  color: #999;
  font-weight: bold;
}

.faq-answer {
  padding: 15px;
  background: #fff;
  border-top: 1px solid #f0f0f0;
}

.faq-answer p {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  margin: 0;
}

.feedback-form {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-size: 14px;
  color: #333;
  font-weight: bold;
}

.form-group select,
.form-group input,
.form-group textarea {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  font-family: inherit;
}

.form-group textarea {
  resize: vertical;
}

.submit-btn {
  background: #c8161d;
  color: #fff;
  border: none;
  padding: 12px;
  border-radius: 4px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.3s;
}

.submit-btn:hover {
  background: #a8131a;
}

.contact-info {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px;
  background: #f9f9f9;
  border-radius: 4px;
}

.contact-item .icon {
  font-size: 24px;
}

.contact-item span {
  font-size: 14px;
  color: #666;
}

@media (max-width: 768px) {
  .container {
    padding: 15px;
  }
  
  .page-header {
    padding: 15px;
  }
  
  .help-content {
    padding: 15px;
  }
  
  .faq-question {
    padding: 12px;
  }
  
  .faq-answer {
    padding: 12px;
  }
}
</style>
