# AIX-DB All-in-One 镜像构建配置
# 包含：前端(nginx) + 后端 + MinIO + PostgreSQL

# 项目名称和版本
PROJECT_NAME = aix-db
VERSION = 1.2.2

# Docker Hub 镜像
DOCKER_IMAGE = apconw/$(PROJECT_NAME):$(VERSION)

# 阿里云镜像仓库
ALIYUN_REGISTRY = crpi-7xkxsdc0iki61l0q.cn-hangzhou.personal.cr.aliyuncs.com
ALIYUN_NAMESPACE = apconw
ALIYUN_IMAGE = $(ALIYUN_REGISTRY)/$(ALIYUN_NAMESPACE)/$(PROJECT_NAME):$(VERSION)

# Dockerfile 路径
DOCKERFILE = ./docker/Dockerfile

# ============ 本地构建 ============

# 构建镜像（本地，当前架构）
build:
	docker build --no-cache -t $(DOCKER_IMAGE) -f $(DOCKERFILE) .

# 构建镜像（使用缓存，加快构建速度）
build-cache:
	docker build -t $(DOCKER_IMAGE) -f $(DOCKERFILE) .

# ============ 多架构构建并推送 ============

# 构建多架构镜像并推送至 Docker Hub
push-dockerhub:
	docker buildx build --platform linux/amd64,linux/arm64 --push -t $(DOCKER_IMAGE) -f $(DOCKERFILE) .

# 构建多架构镜像并推送至阿里云
push-aliyun:
	docker buildx build --platform linux/amd64,linux/arm64 --push -t $(ALIYUN_IMAGE) -f $(DOCKERFILE) .

# 同时推送至 Docker Hub 和阿里云
push-all:
	docker buildx build --platform linux/amd64,linux/arm64 --push \
		-t $(DOCKER_IMAGE) \
		-t $(ALIYUN_IMAGE) \
		-f $(DOCKERFILE) .

# ============ Docker Compose 操作 ============

# 启动服务
up:
	cd docker && docker-compose up -d

# 停止服务
down:
	cd docker && docker-compose down

# 查看日志
logs:
	cd docker && docker-compose logs -f

# 重启服务
restart:
	cd docker && docker-compose restart

# ============ 清理 ============

# 清理本地镜像
clean:
	docker rmi $(DOCKER_IMAGE) 2>/dev/null || true

# 清理所有构建缓存
clean-all:
	docker rmi $(DOCKER_IMAGE) 2>/dev/null || true
	docker builder prune -f

.PHONY: build build-cache push-dockerhub push-aliyun push-all up down logs restart clean clean-all
