# Getting Started using Ubuntu Server 18.04 x64 Package agent

## Setting up update agents

### Download update agent packages

Download the latest .deb packages from the specified location and copy them to
your pre-provisioned Azure IoT Edge device running Ubuntu Server 18.04 x64.

Delivery Optimization Plugin: Download [here](https://github.com/microsoft/do-client/releases)

Delivery Optimization SDK: Download [here](https://github.com/microsoft/do-client/releases)

Delivery Optimization Agent: Download [here](https://github.com/microsoft/do-client/releases)

ADU Agent: Download [here](https://github.com/Azure/adu-private-preview/releases)

### Install ADU .deb agent packages

1. Copy over your downloaded .deb packages to your IoT Edge device from your host machine using Powershell.

```shell
PS> scp '<PATH_TO_DOWNLOADED_FILES>\*.deb' <USERNAME>@<EDGE IP ADDRESS>:~
```

2.Use apt-get to install the packages in the specified order

* Delivery Optimization Agent (deliveryoptimization-agent)
* Delivery Optimization SDK (libdeliveryoptimization)
* Delivery Optimization Plugin for APT (deliveryoptimization-plugin-apt)
* ADU Agent (adu-agent)

```shell
sudo apt-get -y install ./<NAME_OF_PACKAGE>.deb
```

### Configure ADU Agent

1. Open the ADU configuration file

```shell
sudo nano /etc/adu/adu-conf.txt
```

2.Provide your primary connection string in the configuration file. A device's connection string can be found in Azure Portal, in the IOT Edge device blade, in the device details page after clicking on the device.

3.Press Ctrl+X, Y, Enter to save and close the file

4.Restart the ADU Agent daemon

```shell
sudo systemctl restart adu-agent
```

5.Optionally, you can verify that the services are running by

```shell
sudo systemctl list-units --type=service | grep 'adu-agent\.service\|deliveryoptimization-agent\.service'
```

The output should read:

```markdown
adu-agent.service                   loaded active running Azure Device Update Agent daemon.

deliveryoptimization-agent.service               loaded active running deliveryoptimization-agent.service: Performs content delivery optimization tasks   `
```


**[Next Step: Import New Update](./how-to-import-quickstart.md)**
