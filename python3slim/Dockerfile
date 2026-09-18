# ============================================================
# Python 3.13 运行环境（通用容器，不包含项目代码）
# 启动后 exec 进入执行命令，可同时运行多个项目
# docker build --rm ./ -t timeerror/python:3.13-slim
# ============================================================

FROM python:3.13-slim-bookworm

LABEL description="Python 3.13 通用运行环境（Django + curl_cffi + 爬虫）"

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# ============================================================
# 1. 系统依赖（换阿里云源加速）
# ============================================================
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources \
    && apt-get update && apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev build-essential pkg-config \
    fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

# ============================================================
# 2. Python 依赖
# ============================================================
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple/ -r /tmp/requirements.txt

# ============================================================
# 3. 项目代码 → /www/project1
# ============================================================
WORKDIR /www

# 保持容器运行，用户通过 docker exec 执行命令
CMD ["tail", "-f", "/dev/null"]
