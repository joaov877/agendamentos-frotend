
# Etapa 1: compilar o frontend
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

 COPY . .

# A URL é informada durante o build
ARG VITE_API_URL
ENV VITE_API_URL=${VITE_API_URL}

RUN npm run build

# Etapa 2: servir os arquivos com Nginx
FROM nginx:alpine

 COPY nginx.conf /etc/nginx/conf.d/default.conf
 COPY --from=builder /app/dist /usr/share/nginx/html

 EXPOSE 80

 CMD ["nginx", "-g", "daemon off;"]
