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

RUN npm instal  ep_autocomp --no-save && \
    npm install bcrypt --no-save && \
    npm install ep_hash_auth --no-save && \
    npm install ep_adminpads --no-save && \
    npm install ep_export_cp_html_image --no-save && \
    npm install ep_colors --no-save && \
    npm install ep_headings --no-save && \
    npm install ep_align --no-save && \
    npm install ep_subscript --no-save && \
    npm install ep_superscript --no-save && \
    npm install ep_timesliderdiff --no-save && \
    npm install ep_comments_page --no-save && \
    npm install ep_copy_paste_images --no-save

RUN sed -i 's/^node/exec\ node/' bin/run.sh

# OpenShift runs containers as non-root
RUN chmod g+rwX,o+rwX -R .

VOLUME /opt/etherpad-lite/var
RUN ln -s var/settings.json settings.json

EXPOSE 9001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bin/run.sh", "--root"]
