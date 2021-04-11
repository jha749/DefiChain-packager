FROM node:current

WORKDIR /home/node
RUN git clone https://github.com/DefiCh/app

WORKDIR /home/node/app
RUN npm run init

WORKDIR /home/node/app/webapp
COPY saga.tsx ./src/containers/WalletPage/
COPY rpc-client.ts ./src/utils/
#ENTRYPOINT npm run start:react
# The following is just the command associated with start:react with host 0.0.0.0 added, so it will be accessible from outside the docker container
ENTRYPOINT npx cross-env NODE_ENV=development webpack serve --host 0.0.0.0 --config webpack.config.babel.js
EXPOSE 5000