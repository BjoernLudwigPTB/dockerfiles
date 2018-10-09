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

RUN npm install node-gyp -g && \
    npm install bcrypt -g && \
    npm install bcrypt --save && \
    npm install ep_hash_auth -g && \
    npm install ep_public_view -g && \
    npm install ep_activepads -g && \
    npm install ep_adminpads -g && \
    npm install html-pdf -g && \
    npm install ep_better_pdf_export -g && \
    npm install ep_colors -g && \
    npm install ep_headings2 -g && \
    npm install ep_align -g && \
    npm install ep_small_list -g && \
    npm install ep_horizontal_line -g && \
    npm install ep_historicalsearch -g && \
    npm install ep_markdownify -g && \
    npm install ep_latex -g && \
    npm install ep_latexexport -g && \
    npm install ep_subscript -g && \
    npm install ep_superscript -g && \
    npm install ep_timesliderdiff -g && \
    npm install ep_page_view -g && \
    npm install ep_comments_page -g && \
    npm install ep_markdown -g

RUN sed -i 's/^node/exec\ node/' bin/run.sh

# OpenShift runs containers as non-root
RUN chmod g+rwX,o+rwX -R .

VOLUME /opt/etherpad-lite/var
RUN ln -s var/settings.json settings.json

EXPOSE 9001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bin/run.sh", "--root"]
