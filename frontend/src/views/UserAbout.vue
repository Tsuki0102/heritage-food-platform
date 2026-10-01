<template>
  <div class="user-about">
    <Header />
    
    <div class="container">
      <div class="page-header">
        <BackButton to="/user" />
        <h1>关于我们</h1>
      </div>
      
      <div class="about-content">
        <div class="about-section">
          <div class="app-logo">
            <div class="logo-icon">🍜</div>
            <h2>中华美食文化</h2>
            <p class="version">v1.0.0</p>
          </div>
          
          <div class="about-text">
            <p>中华美食文化是一个致力于传承和推广中国传统美食文化的平台。我们希望通过数字化手段，让更多人了解和欣赏中华美食的深厚历史和独特魅力。</p>
            <p>在这里，您可以：</p>
            <ul>
              <li>探索全国各地的地方特色美食</li>
              <li>了解每道美食的历史渊源和制作工艺</li>
              <li>发现传统美食店铺和传承人</li>
              <li>与其他美食爱好者交流分享</li>
              <li>记录和分享自己的美食体验</li>
            </ul>
          </div>
        </div>
        
        <div class="about-section">
          <h3>我们的使命</h3>
          <div class="mission-cards">
            <div class="mission-card">
              <div class="card-icon">🏛️</div>
              <h4>传承文化</h4>
              <p>保护和传承中华传统美食文化，让珍贵的文化遗产得以延续。</p>
            </div>
            <div class="mission-card">
              <div class="card-icon">🌍</div>
              <h4>推广传播</h4>
              <p>通过现代技术手段，让中华美食文化走向世界，被更多人了解。</p>
            </div>
            <div class="mission-card">
              <div class="card-icon">🤝</div>
              <h4>连接社区</h4>
              <p>搭建美食爱好者交流平台，促进文化交流和经验分享。</p>
            </div>
          </div>
        </div>
        
        <div class="about-section">
          <h3>功能特色</h3>
          <div class="features-list">
            <div class="feature-item">
              <div class="feature-icon">📱</div>
              <div class="feature-info">
                <h4>美食百科</h4>
                <p>收录全国各地特色美食，详细介绍历史渊源、制作工艺和文化内涵。</p>
              </div>
            </div>
            <div class="feature-item">
              <div class="feature-icon">🗺️</div>
              <div class="feature-info">
                <h4>美食地图</h4>
                <p>基于地理位置的美食店铺推荐，帮助您发现身边的传统美食。</p>
              </div>
            </div>
            <div class="feature-item">
              <div class="feature-icon">👥</div>
              <div class="feature-info">
                <h4>美食社区</h4>
                <p>分享美食体验，交流烹饪心得，结识志同道合的美食爱好者。</p>
              </div>
            </div>
            <div class="feature-item">
              <div class="feature-icon">⭐</div>
              <div class="feature-info">
                <h4>个人中心</h4>
                <p>管理收藏、足迹和评价，记录您的美食探索之旅。</p>
              </div>
            </div>
          </div>
        </div>
        
        <div class="about-section">
          <h3>法律信息</h3>
          <div class="legal-info">
            <div class="legal-item">
              <span class="label">用户协议</span>
              <span class="value">查看</span>
            </div>
            <div class="legal-item">
              <span class="label">隐私政策</span>
              <span class="value">查看</span>
            </div>
            <div class="legal-item">
              <span class="label">版权声明</span>
              <span class="value">查看</span>
            </div>
          </div>
        </div>
        
        <div class="about-section">
          <h3>联系方式</h3>
          <div class="contact-info">
            <div class="contact-item">
              <i class="icon">📧</i>
              <div class="contact-details">
                <span class="label">邮箱</span>
                <span class="value">support@heritagefood.com</span>
              </div>
            </div>
            <div class="contact-item">
              <i class="icon">🌐</i>
              <div class="contact-details">
                <span class="label">官网</span>
                <span class="value">www.heritagefood.com</span>
              </div>
            </div>
            <div class="contact-item">
              <i class="icon">📍</i>
              <div class="contact-details">
                <span class="label">地址</span>
                <span class="value">北京市朝阳区美食大厦</span>
              </div>
            </div>
          </div>
        </div>
        
        <div class="copyright">
          <p>© 2026 中华美食文化 版权所有</p>
          <p>ICP备案号：京ICP备12345678号</p>
        </div>
      </div>
    </div>
    
    <Footer />
  </div>
</template>

<script setup lang="ts">
import BackButton from '../components/BackButton.vue'
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'
</script>

<style scoped>
.user-about {
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

.about-content {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.about-section {
  margin-bottom: 30px;
}

.about-section:last-child {
  margin-bottom: 0;
}

.about-section h3 {
  font-size: 18px;
  color: #333;
  margin: 0 0 15px 0;
  padding-bottom: 10px;
  border-bottom: 2px solid #c8161d;
}

.app-logo {
  text-align: center;
  padding: 30px 0;
  margin-bottom: 20px;
}

.logo-icon {
  font-size: 60px;
  margin-bottom: 15px;
}

.app-logo h2 {
  font-size: 24px;
  color: #333;
  margin: 0 0 10px 0;
}

.version {
  font-size: 14px;
  color: #999;
  margin: 0;
}

.about-text {
  line-height: 1.8;
  color: #666;
}

.about-text p {
  margin-bottom: 15px;
}

.about-text ul {
  margin: 15px 0;
  padding-left: 20px;
}

.about-text li {
  margin-bottom: 8px;
}

.mission-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

.mission-card {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  text-align: center;
}

.mission-card .card-icon {
  font-size: 40px;
  margin-bottom: 15px;
}

.mission-card h4 {
  font-size: 16px;
  color: #333;
  margin: 0 0 10px 0;
}

.mission-card p {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  margin: 0;
}

.features-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.feature-item {
  display: flex;
  align-items: flex-start;
  gap: 15px;
  padding: 15px;
  background: #f9f9f9;
  border-radius: 8px;
}

.feature-icon {
  font-size: 32px;
  flex-shrink: 0;
}

.feature-info h4 {
  font-size: 16px;
  color: #333;
  margin: 0 0 5px 0;
}

.feature-info p {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  margin: 0;
}

.legal-info {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.legal-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 15px;
  background: #f9f9f9;
  border-radius: 4px;
}

.legal-item .label {
  font-size: 14px;
  color: #333;
}

.legal-item .value {
  font-size: 14px;
  color: #c8161d;
  cursor: pointer;
}

.legal-item .value:hover {
  text-decoration: underline;
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
  border-radius: 8px;
}

.contact-item .icon {
  font-size: 32px;
  flex-shrink: 0;
}

.contact-details {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.contact-details .label {
  font-size: 12px;
  color: #999;
}

.contact-details .value {
  font-size: 14px;
  color: #666;
}

.copyright {
  text-align: center;
  padding: 20px 0;
  border-top: 1px solid #f0f0f0;
  margin-top: 30px;
}

.copyright p {
  font-size: 12px;
  color: #999;
  margin: 5px 0;
}

@media (max-width: 768px) {
  .container {
    padding: 15px;
  }
  
  .page-header {
    padding: 15px;
  }
  
  .about-content {
    padding: 15px;
  }
  
  .mission-cards {
    grid-template-columns: 1fr;
  }
  
  .feature-item {
    flex-direction: column;
    text-align: center;
  }
}
</style>
