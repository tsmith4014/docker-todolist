FROM python:alpine

# Environment variables for database configuration
ENV DB_USER=chandra
ENV DB_PASSWORD=Chandra@123
ENV DB_HOST=todo-database-server
ENV DB_PORT=3306
ENV DB_DATABASE=todo_db

# Install dependencies for building Python packages
RUN apk update && \
    apk add --no-cache build-base libffi-dev openssl-dev

# Copy the application files to the container
COPY . /app

# Set the working directory
WORKDIR /app

# Install Python dependencies
RUN pip install -r requirements.txt

# Expose the port the app runs on
EXPOSE 80

# Command to run the application
CMD python todo.py
