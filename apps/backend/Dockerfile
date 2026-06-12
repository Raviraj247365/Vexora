FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production --silent
COPY . .
CMD ["npm", "start"]
