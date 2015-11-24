FROM mhart/alpine-node:0.12

ARG user=hubot
ENV HOME=/home/${user}
RUN adduser -h ${HOME} -S ${user} && chown -R ${user} ${HOME}

USER root
WORKDIR ${HOME}
ARG AVAILABLE_PLUGINS=hubot-diagnostics,hubot-help,hubot-google-images,hubot-google-translate,hubot-pugme,hubot-maps,hubot-rules,hubot-shipit
ARG AVAILABLE_ADAPTERS=hubot-hipchat,hubot-slack,hubot-irc
RUN apk add --update make gcc g++ python && \
    npm install coffee-script hubot \
    $(node -e "console.log('${AVAILABLE_PLUGINS}'.split(',').join(' '))") \
    $(node -e "console.log('${AVAILABLE_ADAPTERS}'.split(',').join(' '))") && \
    apk del make gcc g++ python && \
    rm -rf /tmp/* /var/cache/apk/* ${HOME}/.npm ${HOME}/.node-gyp

ENV BOT_NAME hubot
ENV ADAPTER shell
ENV ENABLED_PLUGINS=${AVAILABLE_PLUGINS}

USER ${user}
CMD node -e "console.log(JSON.stringify('${ENABLED_PLUGINS}'.split(',')))" > external-scripts.json && \
    PATH=${HOME}/node_modules/.bin:$PATH && \
    hubot --name ${BOT_NAME} --adapter ${ADAPTER}
