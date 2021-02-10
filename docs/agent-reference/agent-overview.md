# Azure Device Update (ADU) Agent Overview

The ADU Agent consists of two conceptual layers:

* The Interface Layer which builds on top of [Azure IoT Plug and Play
(PnP)](https://docs.microsoft.com/en-us/azure/iot-pnp/overview-iot-plug-and-play)
allowing for messaging to flow between the ADU Agent and ADU Services.
* The Platform Layer is responsible for the high-level update actions of Download, Install, and Apply that may be platform, or device specific.

![ADU Agent Implementations
Implementations](images/client-agent-reference-implementations.png)

## The Interface Layer

The Azure IoT PnP interfaces are implemented in `src/agent`. To see how this is
done, look at `AzureDeviceUpdateCore` in
[`src/agent/adu_core_interface/inc/aduc/adu_core_interface.h`](./../../src\agent\adu_core_interface\inc\aduc\adu_core_interface.h) and
[`src/agent/adu_core_interface/src/adu_core_interface.c`](./../../src/agent/adu_core_interface/src/adu_core_interface.c) and `DeviceInformation` in
[`src/agent/device_info_interface/inc/aduc/device_info_interface.h`](./../../src/agent/device_info_interface/inc/aduc/device_info_interface.h) and
[`src/agent/device_info_interface/src/device_info_interface.c`](./../../src/agent/device_info_interface/src/device_info_interface.c). ADU requires that
an ADU enabled device implement both `AzureDeviceUpdateCore` and `DeviceInformation`
Azure IoT PnP interfaces. [Learn More](../how-adu-uses-iot-pnp.md) about the Azure IoT PnP interfaces.

#### AzureDeviceUpdateCore

The `AzureDeviceUpdateCore` interface is the primary communication channel between
ADU Agent and Services. [Learn More](../how-adu-uses-iot-pnp.md) about this
interface.

#### DeviceInformation

The `DeviceInformation` interface is used implement the Azure IoT PnP
`DeviceInformation` interface. [Learn More](../how-adu-uses-iot-pnp.md) about this interface.

## The Platform Layer

There are two implementations of the Platform Layer. The Simulator Platform
Layer has a trivial implementation of the update actions and is used for quickly
testing and evaluating ADU services and setup. When the ADU Agent is built with
the Simulator Platform Layer, we refer to it as the ADU Simulator Agent or just
simulator. [Learn More](./how-to-run-agent.md) about how to use the simulator
agent. The Linux Platform Layer integrates with [Delivery Optimization](https://github.com/microsoft/do-client) for
downloads and is used in our Raspberry Pi reference image, and all clients which run on Linux systems.

#### Simulator Platform Layer

The Simulator Platform Layer implementation is in
`src/platform_layers/simulator_platform_layer`. This is an implementation for
testing and evaluating ADU.  Many of the actions in the
"simulator" implementation are mocked so that you do not need to make any
physical changes to experiment with ADU.  An end to end
"simulated" update can be performed using this Platform Layer. [Learn
More](how-to-run-agent.md) about running the simulator agent.

#### Linux Platform Layer

The Linux Platform Layer implementation is in
`src/platform_layers/linux_platform_layer`. This is an implementation that
integrates with the [Delivery Optimization Client](https://github.com/Azure/doclient-private-preview/releases) for downloads and is used in
our Raspberry Pi reference image, and all clients which run on Linux systems.

This layer can integrate with different Update Handlers to implement the
installer or content specific parts of the high-level update actions. For
instance the SWUpdate Update Handler invokes a shell script to call into the
SWUpdate executable to perform an update.

## Update Handlers

Update Handlers are components that handle content or installer specific parts
of the update. Update Handler implementations are in `src/content_handlers`.

#### Simulator Update Handler

The Simulator Update Handler is used by the Simulator Platform Layer and can
also be used with the Linux Platform Layer to fake interactions with a Content
Handler. The Simulator Update Handler implements the Update Handler APIs with
mostly no-ops. The implementation of the Simulator Update Handler is in
src/content_handlers/simulator_content_handler The InstalledCriteria field in
the AzureDeviceUpdateCore PnP interface should be the sha256 hash of the
content. This is the same hash that is present in the [Import Manifest
Object](../publish-api-reference/import-content.md). [Learn
More](../how-adu-uses-iot-pnp.md) about `installedCriteria` and the `AzureDeviceUpdateCore` interface.

#### SWUpdate Update Handler

The SWUpdate Update Handler integrates with the SWUpdate command line
executable and other shell commands to implement A/B updates specifically for
the Raspberry Pi reference Yocto image. [Learn More](yocto-configuration.md)
about the Raspberry Pi reference Yocto image. The SWUpdate Update Handler is
implemented in src/content_handlers/swupdate_content_handler.

#### APT Update Handler

The APT Update Handler processes an APT-specific Update Manifest and invokes APT to
install or update the specified Debian package(s).

## Getting Started with the ADU Agent

### Try out pre-built images, binaries, and packages

We have uploaded pre-built Raspberry Pi reference images, ADU agent binaries,
and ADU agent packages as part of our GitHub releases. Download them to get
started right away!

If you downloaded our Raspberry Pi reference image, go
[here](../quickstarts/how-to-agent-eval-pi-quickstart.md) to learn how to get
started.

### [Build the agent](how-to-build-agent-code.md)

Follow the instructions to [build](how-to-build-agent-code.md) the ADU Agent
from source.

### [Run the agent](how-to-run-agent.md)

Once the agent is successfully building, it's time [run](how-to-run-agent.md)
the agent.

### [Modifying the agent](how-to-modify-the-agent-code.md)

At this point you'll have an idea for how the ADU Agent works.  Now, make the
changes needed to incorporate the agent into your image.  Look at how to
[modify](how-to-modify-the-agent-code.md) the ADU Agent for guidance.
