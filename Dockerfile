# Лёгкий образ Nginx на Alpine
FROM nginx:1.27-alpine

# Убираем конфиг по умолчанию — используем свой
RUN rm /etc/nginx/conf.d/default.conf

# Копируем кастомную конфигурацию Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Копируем статические файлы сайта
COPY index.html /usr/share/nginx/html/
COPY css/ /usr/share/nginx/html/css/

# Открываем порт
EXPOSE 80

# Healthcheck — проверяем, что Nginx отвечает
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]