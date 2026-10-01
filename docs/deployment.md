# 环境搭建与部署指南

## 1. 环境要求

| 组件 | 版本 | 必需 |
|---|---|---|
| JDK | 21+ | ✅ |
| Maven | 3.6+ | ✅(或使用 IDE 内置) |
| Node.js | 18+(推荐 20) | ✅ |
| MySQL | 8.0+ | ✅ |
| Redis / Elasticsearch | - | ❌ 当前版本未启用,无需安装 |

## 2. 数据库初始化

1. 创建数据库(项目脚本**不含建库语句**,需先手动建库):

   ```sql
   CREATE DATABASE feiyi_food_platform DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
   ```

2. 导入 [sql/feiyi_food_platform.sql](sql/feiyi_food_platform.sql)(31 张表 + 559 条演示数据):

   ```bash
   mysql -uroot -p feiyi_food_platform < sql/feiyi_food_platform.sql
   # 或使用 Navicat 等工具直接运行 SQL 文件
   ```

3. 商家域的部分表在**后端启动时会自动补建**(`CREATE TABLE IF NOT EXISTS`),因此即使导入旧版脚本也能跑通。

## 3. 后端配置

配置文件位于 `backend/src/main/resources/`:

- **application.yml**:主配置(数据源、MyBatis-Plus、日志、DashScope、静态资源、上传目录)
- **application-local.yml**:本地私密配置(**已加入 .gitignore,不会提交**),用于覆盖真实密钥;首次使用可复制 `application-local.yml.example` 模板

### 3.1 关键配置项

| 配置 | 默认值 | 说明 |
|---|---|---|
| `server.port` | `8088` | 后端端口,前端 Vite 代理指向此端口 |
| `spring.datasource.url` | `jdbc:mysql://localhost:3306/feiyi_food_platform...` | 数据库地址 |
| `spring.datasource.username` | `root`,可用环境变量 `MYSQL_USERNAME` 覆盖 | 数据库账号 |
| `spring.datasource.password` | `123456`,可用环境变量 `MYSQL_PASSWORD` 覆盖 | 数据库密码 |
| `dashscope.api-key` | 空,读取环境变量 `DASHSCOPE_API_KEY` 或 `application-local.yml` | 通义千问 Key |
| `dashscope.model` | `qwen-turbo` | AI 模型 |
| `app.upload-dir` | `${user.dir}/uploads` | 上传目录(后端运行目录下) |
| `app.frontend-images-dir` | `${user.dir}/../frontend/public/images` | 前端图片素材目录(后端兜底映射 `/images/**`) |

### 3.2 DashScope API Key 配置(二选一)

**方式 A:本地配置文件(推荐)**

```bash
cd backend/src/main/resources
cp application-local.yml.example application-local.yml
# 编辑 application-local.yml,填入你的 Key
```

**方式 B:环境变量**

```bash
# Windows PowerShell
$env:DASHSCOPE_API_KEY = "sk-xxxx"

# Git Bash / Linux
export DASHSCOPE_API_KEY=sk-xxxx
```

> Key 在[阿里云百炼控制台](https://bailian.console.aliyun.com/)申请。未配置时仅 AI 讲解不可用,其余功能不受影响。
> ⚠️ 早期版本曾将真实 Key 提交进 git 历史,如你克隆的是历史版本,请尽快在百炼控制台轮换 Key。

## 4. 启动

### 后端

```bash
cd backend
mvn spring-boot:run
# 或在 IDEA / VS Code 中直接运行 com.heritage.food.Application
```

启动成功标志:控制台出现 `Tomcat started on port(s): 8088`,并打印商家表结构初始化日志。

### 前端

```bash
cd frontend
npm install
npm run dev
```

- 访问 http://localhost:3000;`vite.config.ts` 已配置 `host: 0.0.0.0`,同一局域网的手机可通过 `http://<本机IP>:3000` 访问
- 代理规则:`/api`、`/file` → `http://localhost:8088`

### 演示账号

见 [README 快速开始](../README.md#4-演示账号)。

## 5. 生产部署(参考)

### 5.1 构建

```bash
# 后端
cd backend
mvn clean package -DskipTests
# 产物: target/heritage-food-backend-1.0-SNAPSHOT.jar(jar 名取自 pom 的 artifactId)

# 前端
cd frontend
npm run build
# 产物: dist/
```

### 5.2 启动后端

```bash
DASHSCOPE_API_KEY=sk-xxxx \
MYSQL_USERNAME=heritage \
MYSQL_PASSWORD='强密码' \
nohup java -jar heritage-food-backend-1.0-SNAPSHOT.jar > backend.log 2>&1 &
```

> 生产环境建议为应用创建独立 MySQL 账号,替换默认 root。

### 5.3 Nginx 参考配置

```nginx
server {
    listen 80;
    server_name your-domain.com;

    # 前端静态资源
    root /opt/heritage/frontend/dist;
    index index.html;
    location / {
        try_files $uri $uri/ /index.html;   # history 路由回退
    }

    # 后端接口
    location /api/ {
        proxy_pass http://127.0.0.1:8088;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        client_max_body_size 20m;           # 文件上传
    }

    # 上传文件与图片素材
    location /file/ {
        proxy_pass http://127.0.0.1:8088;
    }
    location /uploads/ {
        proxy_pass http://127.0.0.1:8088;
    }
    location /images/ {
        proxy_pass http://127.0.0.1:8088;   # 或直接 alias 到前端 public/images
    }
}
```

## 6. 常见问题(FAQ)

| 现象 | 原因与处理 |
|---|---|
| 前端请求全部报"服务器无响应" | 后端未启动或端口非 8088;检查 `vite.config.ts` 代理目标与后端 `server.port` 一致 |
| 页面空白/刷新 404 | 部署时未配置 history 路由回退(见 Nginx `try_files`) |
| 图片 404 | 演示图片路径 `/images/**` 依赖前端 `public/images`;`/uploads/**`、`/file/**` 依赖后端 `uploads/` 目录,确认相应目录存在且有素材 |
| AI 讲解报 500 | 未配置 `DASHSCOPE_API_KEY`,或 Key 失效/欠费;按 §3.2 配置 |
| 上传失败 | `app.upload-dir` 不可写;Windows 下注意 `${user.dir}` 为后端进程工作目录 |
| 数据库连接失败 | 确认 MySQL 8.0+ 已启动、`feiyi_food_platform` 库已导入;账号密码可用环境变量覆盖 |
| 手机访问不了 dev 页面 | 确认防火墙放行 3000 端口,且手机与电脑在同一网段 |
