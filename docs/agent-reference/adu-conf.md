# ADU Configuration File

The "adu-conf.txt" is an **optional** file that can be created to manage the following configurations.

* AzureDeviceUpdateCore:4.ClientMetadata:4.deviceProperties["manufacturer"]
* AzureDeviceUpdateCore:4.ClientMetadata:4.deviceProperties["model"]
* DeviceInformation.manufacturer
* DeviceInformation.model
* Device Connection String (if it is not known by the ADU Agent).

The ADU Agent will first try to get the `manufacturer` and `model` values from the device, for both the `AzureDeviceUpdateCore` and `DeviceInformation` interfaces. Secondly, if that fails, the ADU Agent will look for the "adu-conf.txt" and
use the values defined there. Lastly, if both attempts are not successful, the ADU Agent
will use default values.

### File location

Within Linux system, in the partition or disk called `adu`, create a text file called "adu-conf.txt" with
the following fields.

### List of ADU Configurations

|Name|Description|
|-----------|--------------------|
|connection_string|Pre-provisioned connection string the device can use to connect to the IoT Hub.|
|aduc_manufacturer|Reported by the `AzureDeviceUpdateCore:4.ClientMetadata:4` interface to classify the device for targeting the update deployment.|
|aduc_model|Reported by the `AzureDeviceUpdateCore:4.ClientMetadata:4` interface to classify the device for targeting the update deployment.|
|manufacturer|Reported by the ADU Agent as part of the `DeviceInformation` interface.|
|model|Reported by the ADU Agent as part of the `DeviceInformation` interface.|

[Learn more](./../how-adu-uses-iot-pnp.md) about the `DeviceInformation` and `AzureDeviceUpdate:4` interfaces.

#### Example "adu-conf.txt" file contents

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;connection_string = `HostName=<yourIoTHubName>;DeviceId=<yourDeviceId>;SharedAccessKey=<yourSharedAccessKey>`</br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;aduc_manufacturer = <value to send through `AzureDeviceUpdateCore:4.ClientMetadata:4.deviceProperties["manufacturer"]`></br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;aduc_model = <value to send through `AzureDeviceUpdateCore:4.ClientMetadata:4.deviceProperties["model"]`></br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;manufacturer = <value to send through `DeviceInformation.manufacturer`></br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;model = <value to send through `DeviceInformation.manufacturer`></br>
