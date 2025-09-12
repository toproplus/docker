# 部署 react next.js
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
EXPOSE 3000

# 全局安装 PM2
npm install -g pm2

# 启动项目（集群模式）
CMD pm2 start "npm run start" --name next-app -i max