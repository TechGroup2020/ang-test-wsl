FROM tomcat:10.1-jdk17
RUN sed -i 's/port="8080"/port="9090"/g' /usr/local/tomcat/conf/server.xml
RUN mkdir /usr/local/tomcat/webapps/ROOT
RUN echo "<h1>We are 3Dotz</h1>" > /usr/local/tomcat/webapps/ROOT/index.html
EXPOSE 9090
CMD ["catalina.sh", "run"]

