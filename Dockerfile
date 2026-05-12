# ETAPA 1: Construcción (Build)
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build  # Esto genera la carpeta 'dist' o 'build'

# ETAPA 2: Servidor de Producción (Final)
FROM nginx:alpine
# Crear usuario no root por seguridad (Requerimiento de pauta)
RUN touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

USER nginx

# Copiar los archivos estáticos desde la etapa de build
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]