# 使用兼容 manylinux wheel 的基础镜像，避免 curl_cffi 在 alpine 下编译失败
FROM python:3.11-slim

# 设置时区为 GMT+8
ENV TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制 requirements.txt 并安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制所有 .py 文件到工作目录
COPY *.py ./

# 预创建 Cookie 目录，方便挂载持久化卷
RUN mkdir -p /app/cookie

# 设置默认启动命令
CMD ["python", "scheduler.py"]
