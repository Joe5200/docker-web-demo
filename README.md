作者：雷宇恒 学号：2022214124
零基础也能看懂的Docker Web应用部署指南（2023新版）
Docker部署流程图
一、为什么选择Docker？从快递集装箱说起
想象你要给朋友寄送一份生日礼物：

🎁 礼物本身（你的Web应用）

📦 保护礼物的泡沫垫（系统依赖）

📜 使用说明书（环境配置）

传统方式就像每次都要现场打包，而Docker就像标准化的快递集装箱：
✅ 所有内容整齐封装
✅ 任何快递车（服务器）都能运输
✅ 保证每个收到的人打开都一模一样

二、5分钟快速上手：你的第一个Docker应用

2.1 准备一个简单的Node.js示例

javascript
复制
// app.js
const express = require('express');
const app = express();
app.get('/', (req, res) => res.send('Hello Docker!'));
app.listen(3000, () => console.log('Server running on port 3000'));

2.2 魔法配方Dockerfile详解
dockerfile
复制

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
2.3 必须知道的构建优化技巧
创建.dockerignore文件：

复制
node_modules
.git
*.log
.DS_Store
分层构建原理：Docker的缓存机制就像乐高积木，每一层独立存储

三、从开发到部署完整工作流
3.1 本地开发调试
bash
复制
# 构建镜像（-t参数命名标签）
docker build -t my-web-app:v1 .

# 运行容器（-p端口映射 -d后台运行）
docker run -p 4000:3000 -d my-web-app:v1

# 查看实时日志
docker logs -f [容器ID]

# 进入容器调试（就像SSH连接）
docker exec -it [容器ID] /bin/sh
3.2 云部署实战（以AWS ECS为例）
推送镜像到Docker Hub：

bash
复制
docker tag my-web-app:v1 username/repo:tag
docker push username/repo:tag
在ECS控制台：

创建ECR仓库

配置任务定义（选择推送的镜像）

设置负载均衡和自动扩缩容

配置安全组（开放80/443端口）

AWS ECS部署架构图

四、常见问题排雷指南
Q1: 容器启动后立即退出？
✅ 检查CMD命令是否正确
✅ 查看日志docker logs [容器ID]
✅ 确认端口映射是否冲突

Q2: 如何更新已部署的应用？
构建新版本镜像v2

推送镜像到仓库

云平台滚动更新（零停机）

Q3: 数据持久化方案？
数据库建议使用云服务（RDS等）

文件存储使用Volume：

bash
复制
docker run -v /path/on/host:/app/data ...
五、延伸学习路线图
Docker Compose多容器编排

Kubernetes集群管理

CI/CD流水线集成

服务网格（Service Mesh）

最佳实践提示：生产环境务必配置

日志轮转

健康检查

资源限制（CPU/内存）
