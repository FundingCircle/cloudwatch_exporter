FROM amazoncorretto:11-alpine-jdk as builder

WORKDIR /cloudwatch_exporter

ADD . /cloudwatch_exporter
RUN apk add --no-cache maven && mvn package && \
    mv target/cloudwatch_exporter-*-with-dependencies.jar /cloudwatch_exporter.jar

FROM amazoncorretto:11-alpine
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"
EXPOSE 9106

WORKDIR /
RUN mkdir /config
COPY --from=builder /cloudwatch_exporter.jar /cloudwatch_exporter.jar
ENTRYPOINT [ "java", "-jar", "/cloudwatch_exporter.jar", "9106"]
CMD ["/config/config.yml"]
