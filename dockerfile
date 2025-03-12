# 使用官方精简版Node镜像（比完整版小60%）
FROM node:18-alpine

# 设置容器内工作目录（类似cd命令）
WORKDIR /app

# 先单独拷贝package.json（利用缓存优化）
COPY package*.json ./

# 安装依赖（使用阿里云镜像加速）
RUN npm install --registry=https://registry.npmmirror.com

# 拷贝所有源代码（排除node_modules）
COPY . .

# 声明运行时端口（实际映射在运行时决定）
EXPOSE 3000

# 启动命令（直接使用node，无需pm2）
CMD ["node", "app.js"]
