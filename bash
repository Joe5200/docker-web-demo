# 构建镜像（-t参数命名标签）
docker build -t my-web-app:v1 .

# 运行容器（-p端口映射 -d后台运行）
docker run -p 4000:3000 -d my-web-app:v1

# 查看实时日志
docker logs -f [容器ID]

# 进入容器调试（就像SSH连接）
docker exec -it [容器ID] /bin/sh
