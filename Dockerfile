# Dockerfile
# Sử dụng image Nginx chính thức dựa trên Alpine
FROM nginx:alpine

# Cài đặt netcat
RUN apk add --no-cache netcat-openbsd

# Sao chép cấu hình Nginx vào container
COPY nginx.conf /etc/nginx/nginx.conf

# Tạo script để khởi động máy chủ TCP giả lập
RUN echo -e '#!/bin/sh\n\
     while true; do\n\
     echo "TCP server running"\n\
     nc -l -p 14448\n\
     done' > /start-tcp-server.sh

# Cấp quyền thực thi cho script
RUN chmod +x /start-tcp-server.sh

# Expose cổng cho cả Nginx và máy chủ TCP
EXPOSE 14447

# Khởi động máy chủ TCP và Nginx khi container được chạy
CMD ["sh", "-c", "/start-tcp-server.sh & nginx -g 'daemon off;'"]
