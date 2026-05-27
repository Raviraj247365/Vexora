FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --silent || true
COPY . .
CMD ["npm", "start"]
