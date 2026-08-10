FROM nginx:1.27-alpine
COPY index.html /usr/share/nginx/html/
COPY _sidebar.md /usr/share/nginx/html/
COPY docs/ /usr/share/nginx/html/
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -qO- http://127.0.0.1/ >/dev/null || exit 1
