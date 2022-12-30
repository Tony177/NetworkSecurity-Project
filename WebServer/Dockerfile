#  webserver:
#         container_name: WebServer
#         image: "node:18-slim"
#         user: "node"
#         working_dir: /home/node/app/site
#         depends_on:
#             - mysqlserver
#         environment:
#             - NODE_ENV=production
#         volumes:
#             - ./WebServer:/home/node/app
#         ports:
#             - 8080:8080
#         networks:
#             - WebNetwork
#         command: ../wait-for-it.sh MySQLServer:3306 -- npm run start

FROM node:18-slim
LABEL MAINTEINER="antonioavolio18@gmail.com"
ENV NODE_ENV "production"
COPY ./site /app/
WORKDIR /app
RUN npm install --quiet
ENTRYPOINT [ "npm","run","start" ]
EXPOSE 8080