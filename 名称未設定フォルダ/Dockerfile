FROM node:latest

WORKDIR /myapp/frontend

ENV PATH /myapp/frontend/node_modules/.bin:$PATH

RUN apt-get update -qq  \
  && rm -rf /var/lib/apt/lists/*

ENV TZ Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY package.json /myapp/frontend/package.json
COPY yarn.lock /myapp/frontend/yarn.lock

RUN yarn install --no-progress --registry http://registry.npmjs.org/
ENV HOST 0.0.0.0