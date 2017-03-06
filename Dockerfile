FROM fluent/fluentd:latest-onbuild

# The base image automatically copies fluent.conf and the plugins directory
# inside the resulting image

WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.3.0/bin:$PATH

USER root
RUN apk --no-cache add sudo build-base ruby-dev && \
    sudo -u fluent gem install fluent-plugin-elasticsearch fluent-plugin-record-reformer fluent-plugin-kubernetes_metadata_filter fluent-plugin-tail_path && \
    rm -rf /home/fluent/.gem/ruby/2.3.0/cache/*.gem && sudo -u fluent gem sources -c && \
    apk del sudo build-base ruby-dev
COPY fluent.conf /fluentd/etc
COPY elk.conf /fluentd/etc
EXPOSE 24284
CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT

