<template>
  <footer class="footer">
    <div class="wave-top">
      <svg viewBox="0 0 1200 80" preserveAspectRatio="none">
        <path d="M0,40 C200,70 400,10 600,40 C800,70 1000,10 1200,40 L1200,0 L0,0 Z" fill="var(--bg-color)" opacity="0.5"/>
        <path d="M0,55 C250,85 450,25 650,55 C850,85 1050,25 1200,55 L1200,0 L0,0 Z" fill="var(--bg-color)"/>
      </svg>
    </div>

    <div class="container">
      <div class="footer-decoration">
        <span class="deco-pattern left">❋</span>
        <span class="deco-pattern right">❋</span>
      </div>

      <div class="footer-content">
        <div class="footer-brand">
          <div class="brand-header">
            <span class="brand-icon">🏛️</span>
            <h3>非遗美食文化数字传承与体验平台</h3>
          </div>
          <p class="brand-desc">致力于中华传统美食的数字化传承与推广，让千年饮食文化在数字时代焕发新生。</p>

          <div class="social-links">
            <a href="#" class="social-btn">
              <span>📱</span>
            </a>
            <a href="#" class="social-btn">
              <span>💬</span>
            </a>
            <a href="#" class="social-btn">
              <span>📧</span>
            </a>
          </div>
        </div>

        <div class="footer-links">
          <h4>
            <span class="section-icon">🔗</span>
            快速链接
          </h4>
          <ul>
            <li><router-link to="/"><span class="link-arrow">→</span>首页</router-link></li>
            <li><router-link to="/map"><span class="link-arrow">→</span>美食地图</router-link></li>
            <li><router-link to="/community"><span class="link-arrow">→</span>社区</router-link></li>
            <li><router-link to="/foods"><span class="link-arrow">→</span>美食列表</router-link></li>
            <li><router-link to="/user"><span class="link-arrow">→</span>个人中心</router-link></li>
          </ul>
        </div>

        <div class="footer-contact">
          <h4>
            <span class="section-icon">📞</span>
            联系我们
          </h4>
          <div class="contact-items">
            <p class="contact-item">
              <span class="contact-icon">📧</span>
              <span>contact@heritagefood.com</span>
            </p>
            <p class="contact-item">
              <span class="contact-icon">📞</span>
              <span>400-123-4567</span>
            </p>
            <p class="contact-item">
              <span class="contact-icon">📍</span>
              <span>北京市朝阳区非遗文化园</span>
            </p>
          </div>
        </div>

        <div class="footer-culture">
          <h4>
            <span class="section-icon">🎨</span>
            文化理念
          </h4>
          <div class="culture-tags">
            <span class="culture-tag">千年传承</span>
            <span class="culture-tag">匠心独运</span>
            <span class="culture-tag">味蕾传奇</span>
            <span class="culture-tag">数字创新</span>
          </div>
        </div>
      </div>

      <div class="ornamental-divider">
        <span class="divider-line"></span>
        <span class="divider-symbol">❋ ❋ ❋</span>
        <span class="divider-line"></span>
      </div>

      <div class="footer-bottom">
        <div class="copyright">
          <span class="copyright-icon">©️</span>
          <p>2026 非遗美食文化数字传承与体验平台. 保留所有权利.</p>
        </div>
        <div class="footer-badges">
          <span class="badge-item">
            <span class="badge-icon">🏮</span>
            非遗保护
          </span>
          <span class="badge-item">
            <span class="badge-icon">🎋</span>
            文化传承
          </span>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
// Footer组件
</script>

<style scoped>
.footer {
  background: linear-gradient(135deg, #2c2c2c 0%, #1a1a1a 50%, #2d1f1f 100%);
  color: #e8e8e8;
  padding: 100px 0 48px;
  margin-top: 64px;
  position: relative;
  overflow: hidden;
}

.footer::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
}

.wave-top {
  position: absolute;
  top: -2px;
  left: 0;
  right: 0;
  height: 60px;
  overflow: hidden;
}

.wave-top svg {
  width: 100%;
  height: 100%;
  display: block;
}

.footer-bg-pattern {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image:
    radial-gradient(circle at 20% 50%, rgba(212, 175, 55, 0.05) 0%, transparent 50%),
    radial-gradient(circle at 80% 30%, rgba(200, 22, 29, 0.03) 0%, transparent 50%);
  pointer-events: none;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 24px;
  position: relative;
  z-index: 1;
}

.footer-decoration {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 32px;
}

.deco-pattern {
  font-size: 24px;
  color: var(--secondary-color);
  opacity: 0.15;
  animation: float 4s ease-in-out infinite;
}

.deco-pattern.right {
  animation-delay: 2s;
}

.footer-content {
  display: grid;
  grid-template-columns: 1.5fr 1fr 1fr 1fr;
  gap: 36px;
  margin-bottom: 40px;
}

.brand-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.brand-icon {
  font-size: 36px;
  animation: iconPulse 3s ease-in-out infinite;
}

.footer-brand h3 {
  font-size: 20px;
  margin: 0;
  color: white;
  font-weight: 700;
  letter-spacing: 1px;
  line-height: 1.3;
}

.brand-desc {
  font-size: 14px;
  line-height: 1.7;
  color: rgba(255, 255, 255, 0.65);
  margin-bottom: 20px;
}

.social-links {
  display: flex;
  gap: 12px;
}

.social-btn {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(255,255,255,0.08), rgba(255,255,255,0.04));
  border: 1px solid rgba(212, 175, 55, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  text-decoration: none;
  font-size: 18px;
}

.social-btn:hover {
  background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
  border-color: transparent;
  transform: translateY(-3px) scale(1.1);
  box-shadow: 0 6px 20px rgba(200, 22, 29, 0.35);
}

.footer-links h4,
.footer-contact h4,
.footer-culture h4 {
  font-size: 16px;
  margin: 0 0 18px 0;
  color: white;
  font-weight: 700;
  letter-spacing: 1px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-icon {
  font-size: 18px;
  animation: iconBounce 2s ease-in-out infinite;
}

.footer-links ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.footer-links li {
  margin-bottom: 10px;
}

.footer-links a {
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  transition: all 0.3s ease;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  padding: 4px 0;
}

.link-arrow {
  font-size: 12px;
  opacity: 0;
  transform: translateX(-8px);
  transition: all 0.3s ease;
  color: var(--secondary-color);
}

.footer-links a:hover {
  color: var(--secondary-color);
  transform: translateX(4px);
}

.footer-links a:hover .link-arrow {
  opacity: 1;
  transform: translateX(0);
}

.contact-items {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  transition: color 0.3s ease;
}

.contact-item:hover {
  color: var(--secondary-color);
}

.contact-icon {
  font-size: 16px;
  min-width: 20px;
}

.culture-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.culture-tag {
  padding: 6px 14px;
  background: linear-gradient(135deg, rgba(212, 175, 55, 0.15), rgba(200, 22, 29, 0.1));
  border: 1px solid rgba(212, 175, 55, 0.2);
  border-radius: 20px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.8);
  transition: all 0.3s ease;
  cursor: default;
}

.culture-tag:hover {
  background: linear-gradient(135deg, var(--secondary-color), var(--primary-color));
  color: white;
  border-color: transparent;
  transform: translateY(-2px);
}

.ornamental-divider {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
  margin: 28px 0;
}

.divider-line {
  width: 100px;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(212, 175, 55, 0.3), transparent);
}

.divider-symbol {
  font-size: 14px;
  color: var(--secondary-color);
  opacity: 0.4;
  letter-spacing: 8px;
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 24px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.copyright {
  display: flex;
  align-items: center;
  gap: 8px;
}

.copyright-icon {
  font-size: 16px;
}

.copyright p {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.5);
  margin: 0;
}

.footer-badges {
  display: flex;
  gap: 16px;
}

.badge-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  padding: 6px 14px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 20px;
  border: 1px solid rgba(212, 175, 55, 0.15);
}

.badge-icon {
  font-size: 14px;
}

@media (max-width: 1024px) {
  .footer-content {
    grid-template-columns: repeat(2, 1fr);
    gap: 28px;
  }

  .footer-brand {
    grid-column: span 2;
  }
}

@media (max-width: 768px) {
  .footer {
    padding: 72px 0 36px;
    margin-top: 48px;
  }

  .footer-content {
    grid-template-columns: 1fr;
    gap: 28px;
  }

  .footer-brand {
    grid-column: auto;
  }

  .footer-decoration {
    display: none;
  }

  .footer-bottom {
    flex-direction: column;
    gap: 16px;
    text-align: center;
  }

  .copyright {
    justify-content: center;
  }
}
</style>
