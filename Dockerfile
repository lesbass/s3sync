FROM alpine:latest

# Update package list and install required packages
RUN apk update && \
    apk add --no-cache python3 py3-pip py3-setuptools git ca-certificates curl jq

# Install python-dateutil using pip with --break-system-packages flag
RUN pip3 install python-dateutil --break-system-packages

RUN git clone https://github.com/lesbass/s3sync.git /opt/s3sync && \
    cp /opt/s3sync/*.sh /opt/ && \
    chmod +x /opt/sync.sh /opt/run.sh && \
    rm -rf /opt/s3sync

# Clone the s3cmd repository and create a symbolic link
RUN git clone https://github.com/s3tools/s3cmd.git /opt/s3cmd && \
    ln -s /opt/s3cmd/s3cmd /usr/bin/s3cmd

# Download the mantra binary and make it executable
RUN curl -o /opt/mantra -L https://github.com/pugnascotia/mantra/releases/download/0.0.1/mantra && \
    chmod +x /opt/mantra

# Define a volume
VOLUME /opt/data

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN addgroup -g ${GROUP_ID} mygroup && \
    adduser -D -u ${USER_ID} -G mygroup myuser

USER myuser

# Set the default command
CMD ["/opt/run.sh"]