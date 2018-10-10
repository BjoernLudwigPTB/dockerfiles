FROM node:9

LABEL maintainer="Bjoern Ludwig <bjoern.ludwig@ptb.de>"

ENV ETHERPAD_VERSION 1.7.0
ENV NODE_ENV production

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl unzip mysql-client node-pg postgresql-client abiword && \
    rm -r /var/lib/apt/lists/*

WORKDIR /opt/

RUN curl -SL \
    https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.zip \
    > etherpad.zip && unzip etherpad && rm etherpad.zip && \
    mv etherpad-lite-${ETHERPAD_VERSION} etherpad-lite

WORKDIR etherpad-lite

RUN bin/installDeps.sh && rm settings.json
COPY entrypoint.sh /entrypoint.sh

RUN npm install -g node-gyp && \
    npm install -g bcrypt && \
    npm install -g ep_hash_auth && \
    npm install -g ep_public_view && \
    npm install -g ep_activepads && \
    npm install -g ep_adminpads && \
    npm install -g html-pdf && \
    npm install -g ep_better_pdf_export && \
    npm install -g ep_colors && \
    npm install -g ep_headings2 && \
    npm install -g ep_align && \
    npm install -g ep_small_list && \
    npm install -g ep_horizontal_line && \
    npm install -g ep_historicalsearch && \
    npm install -g ep_markdownify && \
    npm install -g ep_latex && \
    npm install -g ep_latexexport && \
    npm install -g ep_subscript && \
    npm install -g ep_superscript && \
    npm install -g ep_timesliderdiff && \
    npm install -g ep_page_view && \
    npm install -g ep_comments_page && \
    npm install -g ep_markdown

RUN sed -i 's/^node/exec\ node/' bin/run.sh

# OpenShift runs containers as non-root
RUN chmod g+rwX,o+rwX -R .

VOLUME /opt/etherpad-lite/var
RUN ln -s var/settings.json settings.json

EXPOSE 9001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bin/run.sh", "--root"]
