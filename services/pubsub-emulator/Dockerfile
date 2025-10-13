FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:emulators AS export

ENV PUBSUB_PORT=8432
ENV PUBSUB_PROJECT_ID='demo-tao'
VOLUME /opt/data
COPY --chmod=0755 ./entrypoint.sh /entrypoint.sh

EXPOSE ${PUBSUB_PORT}

ENTRYPOINT ["/entrypoint.sh"]
