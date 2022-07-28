#the backend is based on Python 
FROM tiangolo/meinheld-gunicorn:python3.7-alpine3.8
ENV PYTHONUNBUFFERED 1
RUN set -e; \
        apk add --no-cache --virtual .build-deps \
                gcc \
                libc-dev \
                linux-headers \
                mariadb-dev \
                python3-dev \
                postgresql-dev \
        ;
#this will install the virtual packages - creates an extra world of packages 
#that we will need for a limited period of time (complilers for building other items etc.)#the main purpose is to keep the image as light as possible  

#creates a new working directory
RUN mkdir /backend
WORKDIR /backend
#copies and installs the necessary packages in the container
COPY requirements.txt /backend/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /backend/

EXPOSE 8080
CMD ["/bin/bash"]
ENTRYPOINT gunicorn -w 4 main.wsgi:application -b 0.0.0.0:8080
#Gunicorn is a Web Server Gateway Interface, it forwards requests to web applications 
#written in Python - this way the deployment is more stable 
