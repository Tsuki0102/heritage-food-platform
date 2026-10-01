<template>
  <div class="login-page">
    <!-- 背景装饰 -->
    <div class="bg-pattern"></div>
    <div class="chinese-decorations">
      <div class="decoration deco-1">☯</div>
      <div class="decoration deco-2">卍</div>
      <div class="decoration deco-3">☰</div>
      <div class="decoration deco-4">☱</div>
    </div>

    <!-- 主容器 -->
    <div class="login-wrapper">
      <!-- 左侧品牌区域 -->
      <div class="brand-section">
        <div class="brand-content">
          <div class="brand-icon">🏛️</div>
          <h1 class="brand-title">
            非遗美食<br/>文化平台
          </h1>
          <p class="brand-subtitle">传承千年味道 · 品味文化精髓</p>
          
          <div class="brand-features">
            <div class="feature-item">
              <span class="feature-icon">🎋</span>
              <span>天然食材</span>
            </div>
            <div class="feature-item">
              <span class="feature-icon">🏮</span>
              <span>传统工艺</span>
            </div>
            <div class="feature-item">
              <span class="feature-icon">🎁</span>
              <span>精美包装</span>
            </div>
            <div class="feature-item">
              <span class="feature-icon">🥟</span>
              <span>匠心制作</span>
            </div>
          </div>

          <div class="cultural-quote">
            <span class="quote-mark">"</span>
            <p>食不厌精，脍不厌细</p>
            <span class="quote-author">—— 孔子《论语》</span>
          </div>
        </div>
      </div>

      <!-- 右侧登录区域 -->
      <div class="form-section">
        <div class="login-container">
          <!-- 头部 -->
          <div class="login-header">
            <div class="header-badge">
              <span class="badge-icon">🔐</span>
              <span>安全登录</span>
            </div>
            <h2 class="header-title">欢迎回来</h2>
            <p class="header-subtitle">登录您的账号，开启美食之旅</p>
          </div>

          <!-- 表单 -->
          <div class="login-form">
            <div class="form-group">
              <label for="phone">
                <span class="label-icon">📱</span>
                手机号
              </label>
              <div class="input-wrapper">
                <input
                  type="tel"
                  id="phone"
                  v-model="phone"
                  placeholder="请输入手机号"
                  @focus="handleFocus('phone')"
                  @blur="handleBlur('phone')"
                  :class="{ focused: focusedField === 'phone' }"
                />
                <span class="input-icon phone-icon">📲</span>
              </div>
            </div>

            <div class="form-group">
              <label for="code">
                <span class="label-icon">🔑</span>
                验证码
              </label>
              <div class="code-input-wrapper">
                <div class="input-wrapper flex-1">
                  <input
                    type="text"
                    id="code"
                    v-model="code"
                    placeholder="请输入验证码"
                    @focus="handleFocus('code')"
                    @blur="handleBlur('code')"
                    :class="{ focused: focusedField === 'code' }"
                  />
                  <span class="input-icon code-icon">💎</span>
                </div>
                <button
                  class="code-btn"
                  :class="{ disabled: countdown > 0 }"
                  @click="sendCode"
                  :disabled="countdown > 0"
                >
                  <span v-if="countdown > 0" class="countdown-text">
                    {{ countdown }}s
                  </span>
                  <span v-else class="send-text">
                    <span class="btn-icon">✉️</span>
                    获取验证码
                  </span>
                </button>
              </div>
            </div>

            <!-- 登录按钮 -->
            <button class="login-btn btn-primary" @click="login">
              <span class="btn-icon">🚀</span>
              登录 / 注册
            </button>

            <!-- 协议 -->
            <div class="agreement">
              <label class="checkbox-label">
                <input type="checkbox" v-model="agreeTerms" />
                <span class="checkbox-custom"></span>
                <span class="agreement-text">
                  我已阅读并同意
                  <a href="#" class="link">《用户协议》</a>
                  和
                  <a href="#" class="link">《隐私政策》</a>
                </span>
              </label>
            </div>

            <!-- 分隔线 -->
            <div class="divider">
              <span class="line"></span>
              <span class="text">或</span>
              <span class="line"></span>
            </div>

            <!-- 其他登录方式 -->
            <div class="other-methods">
              <p class="methods-title">其他登录方式</p>
              <div class="method-buttons">
                <button class="method-btn wechat" title="微信登录">
                  <span class="method-icon">💬</span>
                </button>
                <button class="method-btn alipay" title="支付宝登录">
                  <span class="method-icon">💳</span>
                </button>
                <button class="method-btn qq" title="QQ登录">
                  <span class="method-icon">🐧</span>
                </button>
              </div>
            </div>
          </div>

          <!-- 底部提示 -->
          <div class="login-footer">
            <p>
              遇到问题？
              <a href="#" class="help-link">联系客服 →</a>
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/userStore'

const router = useRouter()
const userStore = useUserStore()

const phone = ref('')
const code = ref('')
const countdown = ref(0)
const agreeTerms = ref(false)
const focusedField = ref<string | null>(null)
let timer: any = null

// 输入框聚焦处理
const handleFocus = (field: string) => {
  focusedField.value = field
}

const handleBlur = (field: string) => {
  focusedField.value = null
}

// 发送验证码
const sendCode = () => {
  if (!phone.value) {
    alert('请输入手机号')
    return
  }
  
  startCountdown()
  alert('验证码已发送')
}

// 开始倒计时
const startCountdown = () => {
  countdown.value = 60
  timer = setInterval(() => {
    countdown.value--
    if (countdown.value <= 0) {
      clearInterval(timer)
    }
  }, 1000)
}

// 登录
const login = async () => {
  if (!phone.value || !code.value) {
    alert('请输入手机号和验证码')
    return
  }

  if (!agreeTerms.value) {
    alert('请先同意用户协议和隐私政策')
    return
  }
  
  const success = await userStore.login(phone.value, code.value)
  if (success) {
    // 检查用户是否是管理员
    if (userStore.user?.isAdmin === 1) {
      router.push('/admin')
    } 
    // 检查用户是否是商家（手机号为商家测试账号）
    else if (phone.value === '13800138003' || phone.value === '13800138005') {
      router.push('/merchant')
    }
    // 普通用户
    else {
      router.push('/')
    }
  } else {
    alert('登录失败，请检查验证码')
  }
}

onUnmounted(() => {
  if (timer) {
    clearInterval(timer)
  }
})
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  background: var(--gradient-bg);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  position: relative;
  overflow: hidden;
}

/* ====== 背景装饰 ====== */
.bg-pattern {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image:
    radial-gradient(circle at 20% 30%, rgba(212, 175, 55, 0.12) 0%, transparent 50%),
    radial-gradient(circle at 80% 70%, rgba(200, 22, 29, 0.08) 0%, transparent 50%),
    repeating-linear-gradient(45deg, transparent, transparent 10px, rgba(212, 175, 55, 0.03) 10px, rgba(212, 175, 55, 0.03) 20px);
  z-index: 0;
}

.chinese-decorations {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
  z-index: 1;
}

.decoration {
  position: absolute;
  font-size: 60px;
  opacity: 0.04;
  color: var(--secondary-color);
  animation: patternFloat 8s ease-in-out infinite;
}

.deco-1 { top: 8%; left: 5%; animation-delay: 0s; }
.deco-2 { top: 12%; right: 8%; animation-delay: 2s; }
.deco-3 { bottom: 15%; left: 10%; animation-delay: 4s; }
.deco-4 { bottom: 10%; right: 6%; animation-delay: 6s; }

@keyframes patternFloat {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  50% { transform: translateY(-20px) rotate(10deg); }
}

/* ====== 主容器 ====== */
.login-wrapper {
  display: grid;
  grid-template-columns: 1fr 1fr;
  max-width: 1100px;
  width: 100%;
  min-height: 650px;
  background: white;
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-lg);
  overflow: hidden;
  position: relative;
  z-index: 2;
  animation: slideUp 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(40px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-wrapper::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 5px;
  background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--primary-color));
  z-index: 10;
}

/* ====== 品牌区域 ====== */
.brand-section {
  background: linear-gradient(135deg, var(--primary-color), #a8131a);
  padding: 60px 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.brand-section::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 60%);
  animation: brandGlow 6s ease-in-out infinite;
}

@keyframes brandGlow {
  0%, 100% { transform: translate(0, 0); }
  50% { transform: translate(20px, 20px); }
}

.brand-content {
  text-align: center;
  color: white;
  position: relative;
  z-index: 1;
}

.brand-icon {
  font-size: 72px;
  margin-bottom: 24px;
  animation: iconBounce 3s ease-in-out infinite;
  filter: drop-shadow(0 8px 16px rgba(0, 0, 0, 0.2));
}

@keyframes iconBounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-15px); }
}

.brand-title {
  font-size: 36px;
  font-weight: 800;
  margin-bottom: 16px;
  letter-spacing: 4px;
  line-height: 1.3;
  text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.2);
}

.brand-subtitle {
  font-size: 17px;
  opacity: 0.9;
  margin-bottom: 40px;
  letter-spacing: 3px;
  font-weight: 500;
}

.brand-features {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 40px;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 16px;
  background: rgba(255, 255, 255, 0.15);
  border-radius: var(--radius-sm);
  backdrop-filter: blur(10px);
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.feature-item:hover {
  background: rgba(255, 255, 255, 0.25);
  transform: translateY(-3px);
}

.feature-icon { font-size: 20px; }

.cultural-quote {
  padding: 24px 20px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: var(--radius-md);
  border-left: 4px solid var(--secondary-color);
  backdrop-filter: blur(10px);
}

.quote-mark {
  font-size: 32px;
  color: var(--secondary-color);
  line-height: 1;
  display: block;
  margin-bottom: 8px;
}

.cultural-quote p {
  font-size: 16px;
  font-style: italic;
  margin-bottom: 8px;
  line-height: 1.5;
}

.quote-author {
  font-size: 13px;
  opacity: 0.8;
}

/* ====== 表单区域 ====== */
.form-section {
  padding: 48px 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #ffffff, #fafafa);
}

.login-container {
  width: 100%;
  max-width: 420px;
}

/* 头部 */
.login-header {
  text-align: center;
  margin-bottom: 36px;
}

.header-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 18px;
  background: linear-gradient(135deg, rgba(200,22,29,0.06), rgba(212,175,55,0.06));
  border: 1.5px solid var(--border-gold);
  border-radius: 20px;
  font-size: 13px;
  color: var(--text-light);
  font-weight: 600;
  margin-bottom: 20px;
  letter-spacing: 1px;
}

.badge-icon { font-size: 16px; }

.header-title {
  font-size: 28px;
  color: var(--text-color);
  margin-bottom: 10px;
  font-weight: 800;
  letter-spacing: 2px;
}

.header-subtitle {
  font-size: 15px;
  color: var(--text-light);
  font-weight: 500;
}

/* 表单 */
.login-form {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.form-group label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: var(--text-color);
  font-weight: 700;
  letter-spacing: 0.5px;
}

.label-icon { font-size: 16px; }

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-wrapper.flex-1 {
  flex: 1;
}

.input-wrapper input {
  width: 100%;
  padding: 14px 46px 14px 16px;
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-sm);
  font-size: 15px;
  outline: none;
  transition: all 0.3s ease;
  background: white;
  color: var(--text-color);
  font-family: inherit;
}

.input-wrapper input:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 4px rgba(200, 22, 29, 0.1);
}

.input-wrapper input::placeholder {
  color: var(--text-lighter);
  font-style: italic;
}

.input-icon {
  position: absolute;
  right: 16px;
  font-size: 18px;
  pointer-events: none;
  transition: all 0.3s ease;
}

.input-wrapper input:focus + .input-icon,
.input-wrapper input.focused + .input-icon {
  transform: scale(1.15) rotate(5deg);
}

.phone-icon { right: 16px; }
.code-icon { right: 16px; }

/* 验证码输入 */
.code-input-wrapper {
  display: flex;
  gap: 12px;
  align-items: stretch;
}

.code-btn {
  padding: 14px 20px;
  background: linear-gradient(135deg, rgba(250,245,240,0.95), rgba(255,255,255,0.98));
  border: 2px solid var(--border-gold);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 13px;
  font-weight: 600;
  white-space: nowrap;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  color: var(--text-color);
  min-width: 130px;
}

.code-btn:hover:not(.disabled) {
  border-color: var(--primary-color);
  color: var(--primary-color);
  background: linear-gradient(135deg, rgba(200,22,29,0.04), rgba(212,175,55,0.04));
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(200, 22, 29, 0.12);
}

.code-btn.disabled {
  opacity: 0.5;
  cursor: not-allowed;
  background: var(--bg-color);
  border-color: var(--border-color);
}

.countdown-text {
  font-weight: 700;
  color: var(--primary-color);
  font-size: 15px;
}

.send-text .btn-icon { font-size: 15px; }

/* 登录按钮 */
.login-btn {
  width: 100%;
  padding: 16px 28px;
  font-size: 17px;
  font-weight: 700;
  letter-spacing: 2px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  margin-top: 8px;
}

.login-btn:hover:not(:disabled) {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 12px 28px rgba(200, 22, 29, 0.4);
}

/* 协议 */
.agreement {
  margin-top: 8px;
}

.checkbox-label {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  cursor: pointer;
  font-size: 13px;
  color: var(--text-light);
  line-height: 1.6;
}

.checkbox-label input[type="checkbox"] {
  display: none;
}

.checkbox-custom {
  width: 18px;
  height: 18px;
  border: 2px solid var(--border-gold);
  border-radius: 4px;
  flex-shrink: 0;
  margin-top: 2px;
  position: relative;
  transition: all 0.3s ease;
}

.checkbox-label input[type="checkbox"]:checked + .checkbox-custom {
  background: var(--gradient-primary);
  border-color: var(--primary-color);
}

.checkbox-label input[type="checkbox"]:checked + .checkbox-custom::after {
  content: '✓';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: white;
  font-size: 12px;
  font-weight: bold;
}

.agreement-text {
  flex: 1;
}

.link {
  color: var(--primary-color);
  text-decoration: none;
  font-weight: 600;
  transition: all 0.3s ease;
}

.link:hover {
  color: var(--secondary-color);
  text-decoration: underline;
}

/* 分隔线 */
.divider {
  display: flex;
  align-items: center;
  gap: 16px;
  margin: 8px 0;
}

.divider .line {
  flex: 1;
  height: 1.5px;
  background: linear-gradient(90deg, transparent, var(--border-gold), transparent);
}

.divider .text {
  font-size: 13px;
  color: var(--text-lighter);
  font-weight: 500;
}

/* 其他登录方式 */
.other-methods {
  text-align: center;
}

.methods-title {
  font-size: 13px;
  color: var(--text-light);
  margin-bottom: 16px;
  font-weight: 500;
}

.method-buttons {
  display: flex;
  justify-content: center;
  gap: 16px;
}

.method-btn {
  width: 52px;
  height: 52px;
  border: 2px solid var(--border-gold);
  background: white;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.method-btn:hover {
  transform: translateY(-4px) scale(1.1);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
}

.method-btn.wechat:hover {
  border-color: #07c160;
  background: linear-gradient(135deg, #07c160, #00a854);
}

.method-btn.alipay:hover {
  border-color: #1677ff;
  background: linear-gradient(135deg, #1677ff, #0958d9);
}

.method-btn.qq:hover {
  border-color: #12b7f5;
  background: linear-gradient(135deg, #12b7f5, #0e86d4);
}

.method-icon { font-size: 24px; }

/* 底部提示 */
.login-footer {
  text-align: center;
  margin-top: 28px;
  padding-top: 24px;
  border-top: 1.5px dashed rgba(212, 175, 55, 0.25);
}

.login-footer p {
  font-size: 13px;
  color: var(--text-light);
}

.help-link {
  color: var(--primary-color);
  text-decoration: none;
  font-weight: 600;
  margin-left: 6px;
  transition: all 0.3s ease;
}

.help-link:hover {
  color: var(--secondary-color);
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .login-wrapper {
    grid-template-columns: 1fr;
    min-height: auto;
  }

  .brand-section {
    display: none;
  }

  .form-section {
    padding: 48px 32px;
  }
}

@media (max-width: 768px) {
  .login-page {
    padding: 16px;
  }

  .form-section {
    padding: 36px 24px;
  }

  .header-title {
    font-size: 24px;
  }

  .code-input-wrapper {
    flex-direction: column;
  }

  .code-btn {
    width: 100%;
  }

  .brand-features {
    grid-template-columns: 1fr;
  }
}
</style>
