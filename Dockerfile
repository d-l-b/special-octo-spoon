FROM ubuntu:latest
RUN mkdir -p /app && \
    cat <<'EOF' >/app/run.sh
#!/usr/bin/env bash
echo "hello winelovers"
EOF
&& chmod +x /app/run.sh
WORKDIR /app
CMD ./run.sh
