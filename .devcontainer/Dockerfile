#ARG VARIANT=bookworm
ARG VARIANT=bullseye
FROM --platform=amd64 mcr.microsoft.com/devcontainers/base:${VARIANT}

WORKDIR /iot-hub-device-update

# Needed for `--install-githooks` option as part of `-a`
# COPY ../.git ./.git - removed as any commit caused full rebuild of docker

RUN apt-get update && apt-get install -y --no-install-recommends \
  gdb

COPY ./scripts/install-deps.sh /iot-hub-device-update/
RUN /bin/bash install-deps.sh --install-aduc-deps --install-do --install-cmake --install-shellcheck

# To build in the container run
#./scripts/build.sh -c -u --build-packages 

# To install
# cd out && sudo cmake --build . --target install

RUN git config --global --add safe.directory /workspaces/iot-hub-device-update

# Changes needed to run ADU locally in Docker container

COPY scripts/docker/templates/du-config.template.json /etc/adu/du-config.json
COPY scripts/docker/templates/du-diagnostics-config.template.json /etc/adu/du-diagnostics-config.json

COPY out/bin/adu-shell /usr/bin/
COPY out/bin/AducIotAgent /usr/bin/

COPY scripts/docker/templates/content_downloader.extension.template.json /var/lib/adu/extensions/content_downloader/extension.json
COPY out/lib/libcurl_content_downloader.so /var/lib/adu/extensions/sources/
COPY out/lib/libmicrosoft_script_1.so /var/lib/adu/extensions/sources/
COPY out/lib/libmicrosoft_steps_1.so /var/lib/adu/extensions/sources/
COPY out/lib/libcontoso_component_enumerator.so /var/lib/adu/extensions/sources/


# Microsoft
COPY scripts/docker/templates/setup_container.sh /iot-hub-device-update/
RUN ./setup_container.sh

# Changes needed to run ADU locally in Docker container

COPY scripts/docker/templates/du-config.template.json /etc/adu/du-config.json
COPY scripts/docker/templates/du-diagnostics-config.template.json /etc/adu/du-diagnostics-config.json

COPY out/bin/adu-shell /usr/bin/
COPY out/bin/AducIotAgent /usr/bin/

COPY scripts/docker/templates/content_downloader.extension.template.json /var/lib/adu/extensions/content_downloader/extension.json
COPY out/lib/libcurl_content_downloader.so /var/lib/adu/extensions/sources/
COPY out/lib/libmicrosoft_script_1.so /var/lib/adu/extensions/sources/
COPY out/lib/libmicrosoft_steps_1.so /var/lib/adu/extensions/sources/
COPY out/lib/libcontoso_component_enumerator.so /var/lib/adu/extensions/sources/


# Microsoft
COPY scripts/docker/templates/setup_container.sh /iot-hub-device-update/
RUN ./setup_container.sh