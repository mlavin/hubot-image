FROM mhart/alpine-node:4.2

USER root
RUN apk add --update make gcc g++ python
RUN npm install -g coffee-script hubot node-gyp

ARG AVAILABLE_PLUGINS=hubot-diagnostics,hubot-help,hubot-google-images,hubot-google-translate,hubot-pugme,hubot-maps,hubot-rules,hubot-shipit
RUN npm install -g $(node -e "console.log('${AVAILABLE_PLUGINS}'.split(',').join(' '))")

RUN apk del make gcc g++ python && \
    rm -rf /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp

ARG user=hubot
ENV HOME=/home/${user}
RUN adduser -h ${HOME} -S ${user} && chown -R ${user} ${HOME}

USER ${user}
WORKDIR ${HOME}

ENV BOT_NAME hubot
ENV ADAPTER shell
ENV ENABLED_PLUGINS=${AVAILABLE_PLUGINS}

CMD node -e "console.log(JSON.stringify('${ENABLED_PLUGINS}'.split(',')))" > external-scripts.json && \
    hubot --name ${BOT_NAME} --adapter ${ADAPTER}
