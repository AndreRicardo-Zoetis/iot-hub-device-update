#ARG VARIANT=bookworm
ARG VARIANT=bullseye
FROM --platform=amd64 mcr.microsoft.com/devcontainers/base:${VARIANT}

WORKDIR /iot-hub-device-update

COPY ./scripts/install-deps.sh /iot-hub-device-update/

# Needed for `--install-githooks` option as part of `-a`
COPY ../.git ./.git

RUN apt-get update

RUN /bin/bash install-deps.sh -a

# To build in the container run
#./scripts/build.sh -c -u --build-packages 

# To install
# cd out && sudo cmake --build . --target install

#RUN /bin/bash /install-deps.sh --install-aduc-deps --install-do --install-cmake --install-shellcheck --work-folder /iot-hub-device-update

# Changes needed to run ADU locally in Docker container

## TODO most of these commands below can be replaced with 
## chmod +x daemon/install.sh
## ./daemon/install.sh /etc/adu du-config.json /root /var/log/adu /var/lib/adu


RUN sudo addgroup --system "adu" \
  && sudo adduser --system "adu" --ingroup "adu" --no-create-home --shell /bin/false \
  && sudo addgroup --system "do" \
  && sudo usermod -aG "do" "adu"

RUN sudo mkdir -p /var/log/adu \
   && sudo chown -R adu:adu /var/log/adu \
   && sudo chmod 770 /var/log/adu ; \
   sudo mkdir -p /var/lib/adu/downloads \
   && sudo chown -R adu:adu /var/lib/adu \
   && sudo chmod -R 770 /var/lib/adu; \

   sudo mkdir -p /etc/adu \
   && sudo chmod -R 0750 /etc/adu ; \


ADD --chown=adu:adu du-config.docker.json /etc/adu/du-config.json
# sed -i "s|${pattern}|${param_val}|g" "$output_file_path"

# sudo chown root:adu /usr/bin/adu-shell

sudo chmod 04550 /usr/bin/adu-shell