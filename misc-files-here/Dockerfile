#i have this here for git hub tracking purposes as the flask app is not being tracked by git hub
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