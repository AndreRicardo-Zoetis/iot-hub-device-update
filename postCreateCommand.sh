#!/bin/bash
set -e

DUCONFIG_COMPAT_PROPERTY_NAMES="manufacturer,model"
#DUCONFIG_DEVICEINFO_MANUFACTURER="Zoetis-andre"
DUCONFIG_DEVICEINFO_MANUFACTURER="Zoetis"
DUCONFIG_DEVICEINFO_MODEL="Hub"
DUCONFIG_AGENT_NAME="zoetis-docker-agent"
DUCONFIG_CONNECTION_STRING=${ADU_CONNECTION_STRING} # from .devcontainer/devcontainer.env
DUCONFIG_DEVICEPROPERTIES_MANUFACTURER="Zoetis"
DUCONFIG_DEVICEPROPERTIES_MODEL="Hub"


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

parameters_to_expand="
    DUCONFIG_COMPAT_PROPERTY_NAMES
    DUCONFIG_DEVICEINFO_MANUFACTURER
    DUCONFIG_DEVICEINFO_MODEL
    DUCONFIG_AGENT_NAME
    DUCONFIG_CONNECTION_STRING
    DUCONFIG_DEVICEPROPERTIES_MANUFACTURER
    DUCONFIG_DEVICEPROPERTIES_MODEL
"
inline_expand_template_parameters "$parameters_to_expand" "/etc/adu/du-config.json"



## configure content downloader extension
so_name="libcurl_content_downloader"
base64digest=$(openssl dgst -binary "/var/lib/adu/extensions/sources/libcurl_content_downloader.so" | openssl base64)

parameters_to_expand="
    so_name
    base64digest
"
target_filepath="/var/lib/adu/extensions/content_downloader/extension.json"

inline_expand_template_parameters "$parameters_to_expand" "$target_filepath"

# recreate some of the steps from packages/debian/postinst in particular function "register_reference_extensions"

#adu_bin_path=out/bin/AducIotAgent
#$adu_extensions_sources_dir/$adu_steps_handler_file

out/bin/AducIotAgent -l 2 --extension-type updateContentHandler --extension-id "microsoft/script:1" --register-extension /var/lib/adu/extensions/sources/libmicrosoft_script_1.so
out/bin/AducIotAgent -l 2 --extension-type updateContentHandler --extension-id "microsoft/steps:1" --register-extension /var/lib/adu/extensions/sources/libmicrosoft_steps_1.so
out/bin/AducIotAgent -l 2 --extension-type updateContentHandler --extension-id "microsoft/update-manifest:5" --register-extension /var/lib/adu/extensions/sources/libmicrosoft_steps_1.so

out/bin/AducIotAgent -l 2 --extension-type componentEnumerator --register-extension /var/lib/adu/extensions/sources/libcontoso_component_enumerator.so

out/bin/AducIotAgent -l 2 --extension-type contentDownloader --register-extension /var/lib/adu/extensions/sources/libcurl_content_downloader.so

mkdir -p /usr/local/contoso-devices/

sample_components_inventory=$(
    cat << END_OF_JSON
{
    "components": [
        {
            "id": "vetscan-hub",
            "name": "vetscan-hub",
            "group": "Hub",
            "manufacturer": "Zoetis",
            "model": "Hub",
            "status": "available",
            "hwVersion": "",
            "swVersion": "1.7.3",
            "lasttriedversion": "1.5.0",
            "properties": {
                "path": "/usr/local/contoso-devices/",
                "firmwareDataFile": "components-inventory.json"
            }
        }
    ]
}
END_OF_JSON
)

echo "$sample_components_inventory" > "/usr/local/contoso-devices/components-inventory.json"