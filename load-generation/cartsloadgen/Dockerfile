FROM alpine:3.11

RUN apk add --no-cache curl

COPY generate_traffic.sh generate_traffic.sh
ENTRYPOINT ["usr/local/bin/bash"]
CMD ["generate_traffic.sh"]