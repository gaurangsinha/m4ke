FROM alpine:latest

RUN apk update && apk add make m4

COPY Makefile /run
