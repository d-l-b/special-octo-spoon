FROM ubuntu:latest
RUN mkdir -p /app && \
    printf '#!/usr/bin/env bash\necho "hello winelovers"\n' >/app/run.sh && \
    chmod +x /app/run.sh
WORKDIR /app
CMD ./run.sh
