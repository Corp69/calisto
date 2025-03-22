# Etapa de construcción
FROM eclipse-temurin:23-jdk AS build

# Instala Maven
RUN apt-get update && apt-get install -y maven

COPY pom.xml /app/
COPY src /app/src/
WORKDIR /app
RUN mvn clean package -DskipTests

# Etapa de ejecución
FROM eclipse-temurin:23-jre
ARG PORT
# Valor por defecto si no se establece PORT
ENV PORT=${PORT}
COPY --from=build /app/target/*.jar app.jar
RUN useradd runtime
USER runtime
ENTRYPOINT ["java", "-Dserver.port=${PORT}", "-jar", "app.jar"]