FROM node:alpine

WORKDIR /home/node

RUN npm install http-proxy --save

COPY proxy.js .

ENTRYPOINT node proxy.js
EXPOSE 5001