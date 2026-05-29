FROM --platform=linux/amd64 node:15-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN apk add --no-cache python3 make g++ && npm install

COPY . .
RUN npm run build

FROM --platform=linux/amd64 nginx:1.21-alpine

COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
