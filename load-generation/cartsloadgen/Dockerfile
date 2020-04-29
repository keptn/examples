FROM alpine:3.11

RUN apk add --no-cache curl bash

COPY generate_traffic.sh generate_traffic.sh
ENTRYPOINT ["/bin/bash"]
CMD ["generate_traffic.sh"]