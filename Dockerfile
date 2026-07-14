FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY target/ecommerce-backend-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]

















# FROM eclipse-temurin:17-jdk

# WORKDIR /app

# RUN mkdir -p /app/images

# COPY target/ecommerce-backend-0.0.1-SNAPSHOT.jar app.jar

# EXPOSE 8080

# ENTRYPOINT ["java","-jar","app.jar"]