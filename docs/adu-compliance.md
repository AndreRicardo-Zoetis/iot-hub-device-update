# Device Update Compliance

In Device Update, compliance measures how many devices have installed the highest version compatible update. A device
is considered compliant if it has installed the highest version update published to its instance of ADU that is 
compatible for that device. 


For example, consider an instance of ADU with the following updates:

|Update Name|Update Version|Compatible Device Model|
|-----------|--------------|-----------------------|
|Update1	|1.0	|Model1|
|Update2	|1.0	|Model2|
|Update3	|2.0	|Model1|

Let’s say the following deployments have been created:

|Deployment Name	|Update Name	|Targeted Group|
|-----------|--------------|-------------------|
|Deployment1	|Update1	|Group1|
|Deployment2	|Update2	|Group2|
|Deployment3	|Update3	|Group3|

Now, consider the following devices, with their group memberships and installed versions:

|DeviceId	|Device Model	|Installed Update Version|Group	|Compliance|
|-----------|--------------|-----------------------|-----|---------|
|Device1	|Model1	|1.0	|Group1	|New updates available</span>|
|Device2	|Model1	|2.0	|Group3	|On latest update|
|Device3	|Model2	|1.0	|Group2	|On latest update|
|Device4	|Model1	|1.0	|Group3	|Update in progress|

Note that Device1 and Device4 are not compliant because they have version 1.0 installed even 
though there’s a higher version update compatible for their model in the ADU instance (Update3). Device2 and
Device3 are both compliant because they have the highest version updates compatible for their models installed.

Compliance does not consider whether an update is deployed to a device’s group or not; it looks at any updates
published to ADU. So in the example above, Device1 is not compliant even though there is not a deployment for Update3 
that targets that device’s group. So although Device1 has installed the highest version update that has been targeted to it, 
it is still considered non-compliant. This can help you identify whether new deployments are needed.

As shown above, there are three compliance states in ADU:

*	**On latest update** – the device has installed the highest version compatible update published to ADU.
*	**Update in progress** – an active deployment is in the process of delivering the highest version compatible update to the device.
*	**New updates available** – a device has not yet installed the highest version compatible update and is not in an active deployment for that update.
