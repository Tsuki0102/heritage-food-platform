# frontend · 前端应用

「华韵味脉」非遗美食平台的 Vue 3 前端(开发端口 3000)。

- 技术栈:Vue 3.4 + TypeScript + Vite 5 + Pinia + Vue Router 4 + Element Plus + Leaflet(地图)+ Chart.js(图表)
- 三端结构:用户端 `views/`(27 页)、商家端 `views/merchant/`(5 页,`/merchant`)、管理端 `views/admin/`(8 页,`/admin`)
- 启动:`npm install && npm run dev`;构建:`npm run build`(产物 `dist/`)
- 接口代理:`vite.config.ts` 将 `/api`、`/file` 转发至 `http://localhost:8088`,前端代码中不出现后端主机地址
- 图片路径:统一使用 `src/utils/index.ts` 的 `resolveAvatarUrl()` 解析,勿硬编码绝对地址

详细文档:

| 主题 | 文档 |
|---|---|
| 系统架构与前端模块 | [docs/architecture.md](../docs/architecture.md) |
| 页面与路由总览 | [docs/architecture.md §3](../docs/architecture.md) |
| 改进计划 | [docs/development.md](../docs/development.md) |
