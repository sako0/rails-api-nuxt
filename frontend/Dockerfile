FROM node:latest

WORKDIR /frontend

ENV PATH /frontend/node_modules/.bin:$PATH

RUN apt-get update -qq  \
  && apt install -y tzdata  \
  && apt-get clean  \
  && rm -rf /var/lib/apt/lists/*

ENV TZ Asia/Tokyo
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY package.json /frontend/package.json
COPY yarn.lock /frontend/yarn.lock

RUN yarn install --no-progress --registry http://registry.npmjs.org/
ENV HOST 0.0.0.0
COPY . /frontend

# Start the main process.
CMD ["cmd.sh"]
