FROM ubuntu:latest
RUN apt update -y
RUN apt install nginx -y
COPY ./index.html /var/www/html/index.html
ADD https://dlcdn.apache.org/tomcat/tomcat-connectors/native/2.0.8/source/tomcat-native-2.0.8-src.tar.gz /opt
LABEL author="Abhay Bendekar"
ENV project=Project1
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
