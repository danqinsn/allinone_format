FROM alpine:latest

# 安装 tzdata php php-curl
RUN apk add --no-cache tzdata php php-curl

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 设置工作目录
WORKDIR /app

# 复制服务器代码
COPY server/ ./

# /app/config/ 需要从外部挂载, 并且需要读取 & 写入权限
VOLUME /app/config/

# 暴露端口
EXPOSE 35456

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s \
    CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:35456/favicon.ico || exit 1

# 启动命令
CMD ["php", "-S", "[::]:35456", "-t", "public", "index.php"] 