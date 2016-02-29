FROM mhart/alpine-node:4.2

ARG user=hubot
ENV HOME=/home/${user}
RUN adduser -h ${HOME} -S ${user} && chown -R ${user} ${HOME}

USER root
WORKDIR ${HOME}
COPY package.json ${HOME}
RUN apk add --update make gcc g++ python && \
    npm install && \
    apk del make gcc g++ python && \
    rm -rf /tmp/* /var/cache/apk/* ${HOME}/.npm ${HOME}/.node-gyp

ENV ENABLED_PLUGINS=hubot-diagnostics,hubot-help,hubot-google-images,hubot-google-translate,hubot-pugme,hubot-maps,hubot-rules,hubot-shipit
ENV PATH ${HOME}/node_modules/.bin:$PATH

RUN mkdir env
ENV ENV_DIR env

USER ${user}
CMD node -e "console.log(JSON.stringify('${ENABLED_PLUGINS}'.split(',')))" > external-scripts.json && \
    envdir ${ENV_DIR} hubot
