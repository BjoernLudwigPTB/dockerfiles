FROM node:9

LABEL maintainer="Bjoern Ludwig <bjoern.ludwig@ptb.de>"

ENV ETHERPAD_VERSION 1.7.5
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

WORKDIR /opt/etherpad-lite

RUN bin/installDeps.sh && rm settings.json

COPY entrypoint.sh /entrypoint.sh

RUN chmod g+rwx,o+rwx /entrypoint.sh

RUN npm install ep_autocomp && \
    npm install ep_adminpads && \
    npm install html-pdf && \
    npm install ep_better_pdf_export && \
    npm install ep_colors && \
    npm install ep_headings2 && \
    npm install ep_align && \
    npm install ep_small_list && \
    npm install ep_historicalsearch && \
    npm install ep_markdown && \
    npm install ep_subscript && \
    npm install ep_superscript && \
    npm install ep_timesliderdiff && \
    npm install ep_comments_page && \
    npm install ep_copy_paste_images

RUN sed -i 's/^node/exec\ node/' bin/run.sh

# OpenShift runs containers as non-root
RUN chmod g+rwX,o+rwX -R .

VOLUME /opt/etherpad-lite/var
RUN ln -s var/settings.json settings.json

EXPOSE 9001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bin/run.sh", "--root"]
