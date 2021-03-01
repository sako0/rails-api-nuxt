FROM node:latest

WORKDIR /frontend

ENV PATH /frontend/node_modules/.bin:$PATH

RUN apt-get update -qq  \
  && rm -rf /var/lib/apt/lists/*

ENV TZ Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY package.json /frontend/package.json
COPY yarn.lock /frontend/yarn.lock

RUN yarn install --no-progress --registry http://registry.npmjs.org/
ENV HOST 0.0.0.0
COPY . /frontend

# Start the main process.
CMD ["yarn", "dev"]
