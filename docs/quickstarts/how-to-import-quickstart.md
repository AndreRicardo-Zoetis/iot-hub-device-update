# Import New Update

## Prerequisites

* Access to an IoT Hub with Azure Device Update (ADU) enabled.
* An IoT device (or [simulator](./how-to-agent-eval-sim-quickstart.md)) provisioned within the IoT Hub, running either Azure RTOS ThreadX or Ubuntu 18.04 x64.
    * If using a real device, you’ll need an update image file (e.g. Yocto image) for image update, or [APT Manifest](../agent-reference/apt-manifest.md) file for package update.
* [PowerShell 5]((https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)) or later.
* Supported browsers:
  * The new [Microsoft Edge](https://www.microsoft.com/edge)
  * Google Chrome

## Create ADU Import Manifest

1. Ensure that your update image file or APT Manifest file is located in a directory accessible from PowerShell.

2. Clone [Azure Device Update repository](https://github.com/Azure/adu-private-preview), or download it as a .zip file to
a location accessible from PowerShell (Once the zip file is downloaded, right click for `Properties` > `General` tab > check `Unblock` in the `Security` section to avoid PowerShell security warning prompts).

3. In PowerShell, navigate to `tools/AduCmdlets` directory and run:

    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
    Import-Module .\AduUpdate.psm1
    ```

4. Run the following commands by replacing the sample parameter values to generate an import manifest, a JSON file that describes the update:
    ```powershell
    $compat = New-AduUpdateCompatibility -DeviceManufacturer 'deviceManufacturer' -DeviceModel 'deviceModel'

    $importManifest = New-AduImportManifest -Provider 'updateProvider' -Name 'updateName' -Version 'updateVersion' `
                                            -UpdateType 'updateType' -InstalledCriteria 'installedCriteria' `
                                            -Compatibility $compat -Files 'updateFilePath(s)'

    $importManifest | Out-File '.\importManifest.json' -Encoding UTF8
    ```

    For quick reference, the table below provides some example values for the above parameters. For full documentation, please refer to [Import Manifest Schema](../publish-api-reference/import-update.md#import-manifest-schema).

    | Parameter | Description |
    | --------- | ----------- |
    | deviceManufacturer | Manufacturer of the device the update is compatible with, e.g. Contoso
    | deviceModel | Model of the device the update is compatible with, e.g. Toaster
    | updateProvider | Provider part of update identity, e.g. Fabrikam
    | updateName | Name part of update identity, e.g. ImageUpdate
    | updateVersion | Update version, e.g. 2.0
    | updateType | <ul><li>Specify `microsoft/swupdate:1` for image update</li><li>Specify `microsoft/apt:1` for package update</li></ul>
    | installedCriteria | <ul><li>Specify value of SWVersion for `microsoft/swupdate:1` update type</li><li>Specify [recommended value](../agent-reference/apt-manifest.md) for `microsoft/apt:1` update type.
    | updateFilePath(s) | Path to the update file(s) on your PC

The update imported using import manifest generated above will be deployable to devices implementing [Azure Device Update PnP interface](../how-adu-uses-iot-pnp.md) `urn:azureiot:AzureDeviceUpdateCore:1` and `urn:azureiot:AzureDeviceUpdateCore:4`.

## Review Generated Import Manifest

Example:
```json
{
  "updateId": {
    "provider": "Microsoft",
    "name": "Toaster",
    "version": "2.0"
  },
  "updateType": "microsoft/swupdate:1",
  "installedCriteria": "5",
  "compatibility": [
    {
      "deviceManufacturer": "Fabrikam",
      "deviceModel": "Toaster"
    },
    {
      "deviceManufacturer": "Contoso",
      "deviceModel": "Toaster"
    }
  ],
  "files": [
    {
      "filename": "file1.json",
      "sizeInBytes": 7,
      "hashes": {
        "sha256": "K2mn97qWmKSaSaM9SFdhC0QIEJ/wluXV7CoTlM8zMUo="
      }
    },
    {
      "filename": "file2.zip",
      "sizeInBytes": 11,
      "hashes": {
        "sha256": "gbG9pxCr9RMH2Pv57vBxKjm89uhUstD06wvQSioLMgU="
      }
    }
  ],
  "createdDateTime": "2020-10-08T03:32:52.477Z",
  "manifestVersion": "2.0"
}
```

## Import update

1. Log into Azure Portal using [this link](https://portal.azure.com/?feature.canmodifystamps=true&Microsoft_Azure_Iothub=aduprod) and navigate to your IoT Hub with ADU.

2. On the left-hand side of the page, select "Device Updates" under "Automatic Device Management".

   ![Import Updates](images/import-updates2.png)

3. You will see several tabs across the top of the screen. Select the Updates tab.

   ![Import New Updates](images/updates-tab.png)

4. Select "+ Import New Update" below the "Ready to Deploy" header.

   ![Import New Updates](images/import-new-update2.png)

5. Select the folder icon or text box under "Select an Import Manifest File". You will see a file picker dialog. Select the Import Manifest you created previously using the PowerShell cmdlet. Next, select the folder icon or text box under "Select one or more update files". You will see a file picker dialog. Select your update file(s).

   ![Select Update Files](images/select-update-files.png)

6. Select the folder icon or text box under "Select a storage container". Then select the appropriate storage account.

   ![Storage Account](images/storage-account.png)

7. If you’ve already created a container you can re-use it. (Otherwise, select "+ Container" to create a new storage container for updates.).  Select the container you wish to use and click "Select".

   ![Container](images/container.png)

8. Select "Submit" to start the import process.

   ![Import Update](images/publish-update.png)

9. The import process begins, and the screen changes to the "Import History" section. Select "Refresh" to view progress until the import process completes (depending on the size of the update, this may complete in a few minutes but could take longer).

   ![Update Import Sequencing](images/update-publishing-sequence2.png)

10. When the Status column indicates the import has succeeded, select the "Ready to Deploy" header. You should see your imported update in the list now.

   ![Job Status](images/update-ready.png)


[Next Step: Create Groups](./how-to-group-quickstart.md)
