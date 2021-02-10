# Azure Device Update Troubleshooting Guide

This document provides a list of tips and tricks to help remedy many possible
issues you may be having with Azure Device Update.

## ADU Agent

If you run into issues with the ADU Agent, you have a couple options to help
troubleshoot.  Start by collecting the ADU logs and/or query
[getDevices](docs/../management-api-reference/get-devices.md) to check for
additional information in the payload response of the API.

### Collect Logs

* On the Raspberry Pi Device there are two sets of logs found here:

    ```markdown
    /adu/logs
    ```

    ```markdown
    /var/cache/deliveryoptimization-agent/log
    ```

* For the packaged client the logs are found here:

    ```markdown
    /var/log/adu
    ```

    ```markdown
    /var/cache/deliveryoptimization-agent/log
    ```

* For the Simulator the logs are found here:

    ```markdown
    /tmp/aduc-logs
    ```

### ResultCode and ExtendedResultCode

The Azure Device Update Core PnP interface reports `ResultCode` and
`ExtendedResultCode` which can be used to diagnose failures. [Learn
More](how-adu-uses-iot-pnp.md) about the ADU Core PnP interface.

#### ResultCode

`ResultCode` is a general status code and follows http status code convention.
[Learn More](https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html) about http
status codes.

#### ExtendedResultCode

`ExtendedResultCode` is an integer with encoded error information.

You will most likely see the `ExtendedResultCode` as a signed integer in the PnP
interface. To decode the `ExtendedResultCode`, convert the signed integer to
unsigned hex. Only the first 4 bytes of the `ExtendedResultCode` are used and
are of the form `F` `FFFFFFF` where the first nibble is the **Facility Code** and
the rest of the bits are the **Error Code**.

**Facility Codes**

| Facility Code     | Description  |
|-------------------|--------------|
| D                 | Error raised from the DO SDK|
| E                 | Error code is an errno |


For example:

`ExtendedResultCode` is `-536870781`

The unsigned hex representation of `-536870781` is `FFFFFFFF E0000083`.

| Ignore    | Facility Code  | Error Code   |
|-----------|----------------|--------------|
| FFFFFFFF  | E              | 0000083      |

`0x83` in hex is `131` in decimal which is the errno value for `ENOLCK`.

### Use getDevices() API payload response

A useful management API,
[getDevices](docs/../management-api-reference/get-devices.md), returns a payload
containing information about the download and update state on a device.

**NOTE**:  This API's payload contains publicly accessible URL locations.

## Publish Update

Any issues encountered while importing a new manifest file or in any part of the
publishing flow,please let us know!  To help us narrow down the root cause,
we'll need to capture some information.

* Time frame of when the problem occurred
* Fiddler traces from UX
* Screenshot of the UX

## Deploy Update

For any problems related to the deployment process of an update, please let us
know!  To help us narrow down the root cause, we'll need to capture some
information.

* Time frame of when the problem occurred
* Fiddler traces from UX
* Screenshot of the UX
