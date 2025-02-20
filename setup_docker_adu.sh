#!/bin/bash
set -e

DUCONFIG_CONNECTION_STRING=${ADU_CONNECTION_STRING}

inline_expand_template_parameters() {
    params_to_replace="$1"
    output_file_path="$2"

    for var in $params_to_replace; do
        pattern="%%${var}%%"
        param_val=${!var}
        param_val=${param_val/\./\\\.} # escape periods
        param_val=${param_val/\&/\\\&} # escape ampersands

        sed -i "s|${pattern}|${param_val}|g" "$output_file_path"
    done
}


## ADU connection string

cp du-config-docker.json /etc/adu/du-config.json
parameters_to_expand="
    DUCONFIG_CONNECTION_STRING
"
inline_expand_template_parameters "$parameters_to_expand" "/etc/adu/du-config.json"

## Fix permissions still wrong on setup_container.sh

chmod u=rxs,g=rx,o= /usr/bin/adu-shell

## configure content downloader extension

mkdir -p /var/lib/adu/extensions/content_downloader/
cp scripts/docker/templates/content_downloader.extension.template.json /var/lib/adu/extensions/content_downloader/extension.json

cp out/lib/libcurl_content_downloader.so /var/lib/adu/extensions/sources/

so_name="libcurl_content_downloader"
base64digest=$(openssl dgst -binary "/var/lib/adu/extensions/sources/libcurl_content_downloader.so" | openssl base64)

parameters_to_expand="
    so_name
    base64digest
"
target_filepath="/var/lib/adu/extensions/content_downloader/extension.json"

inline_expand_template_parameters "$parameters_to_expand" "$target_filepath"

