# Todo List Application

This application is a simple Todo list implemented using a Flask backend, MariaDB for data storage, and Nginx as a reverse proxy and static server for the frontend.

## Components

- **Flask App**: Python application providing the API.
- **MariaDB**: Database server for storing Todo items.
- **Nginx**: Web server for serving static content and proxying API requests.

## Setup and Running with Docker

### Building and Running Containers

1. **MariaDB Container**

   Start the MariaDB container:

   ```bash
   docker run -d --name todolist-db-server \
     --network todolist-network \
     -e MYSQL_ROOT_PASSWORD=Chandra@123 \
     -e MYSQL_DATABASE=todo_db \
     -p 3306:3306 \
     mariadb:10.5
   ```

2. **Flask App Container**

   Build and run the Flask app container:

   ```bash
   docker build -t todo-flask-app-image -f Dockerfile-flask .
   docker run -d -p 5001:80 --network todolist-network \
     -e MYSQL_DATABASE_HOST=todolist-db-server \
     -e MYSQL_DATABASE_USER=root \
     -e MYSQL_DATABASE_PASSWORD=Chandra@123 \
     -e MYSQL_DATABASE_DB=todo_db \
     -e MYSQL_DATABASE_PORT=3306 \
     --name todolist-flask-container todo-flask-app-image
   ```

3. **Nginx Container**

   Build and run the Nginx container:

   ```bash
   docker build -t my-nginx -f Dockerfile-nginx .
   docker run -d -p 8080:80 --network todolist-network --name my-nginx-container my-nginx
   ```

### Dockerfiles

1. **Dockerfile for Flask App (`Dockerfile-flask`)**

   ```Dockerfile
   FROM python:alpine

   ENV MYSQL_DATABASE_HOST=todolist-db-server
   ENV MYSQL_DATABASE_USER=root
   ENV MYSQL_DATABASE_PASSWORD=Chandra@123
   ENV MYSQL_DATABASE_DB=todo_db
   ENV MYSQL_DATABASE_PORT=3306

   RUN apk update && \
       apk add --no-cache build-base libffi-dev openssl-dev
   COPY . /app
   WORKDIR /app
   RUN pip install -r requirements.txt
   EXPOSE 80
   CMD python ./todo.py
   ```

2. **Dockerfile for Nginx (`Dockerfile-nginx`)**

   ```Dockerfile
   FROM nginx:alpine
   COPY ./index.html /usr/share/nginx/html/index.html
   COPY ./nginx.conf /etc/nginx/conf.d/default.conf
   ```

### Nginx Configuration (`nginx.conf`)

```nginx
server {
    listen 80;

    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
    }

    location /posts {
        proxy_pass http://todolist-flask-container:5001;
    }
}
```

### Frontend (`index.html`)

Make sure your frontend makes API requests to the right endpoint. The JavaScript in `index.html` should point to the Flask API URL.

```html
<script>
  const API_URL = "http://localhost:8080/posts";
  // Rest of your frontend JavaScript code...
</script>
```

## Conclusion

This setup allows you to run a full-stack application with separate containers for the database, backend, and frontend. Ensure all containers are on the same Docker network for seamless communication.
