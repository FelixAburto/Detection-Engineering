#  Unauthorized Download of Azure Blob Storage

<br />

<p align="center">
<img src="https://img.icons8.com/?size=512&id=84280&format=png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project, we will set up detection for unauthorized downloads of our blob storage files. Blob storage is a type of data storage in cloud computing, specifically used for storing large amounts of unstructured data such as text or binary data. In Azure, blob storage allows you to store files like documents, images, videos, or backups. "Blob" stands for "Binary Large Object," and it's designed to handle huge volumes of data and provide high availability and scalability.

</br>

<h2>Unauthorized Download of Azure Blob Storage Setup</h2>

<h3>Creating an Event Hub Namespace:</h3>

The first thing we need to do to set up our attack is to create an Azure Event Hub Namespace. An Azure Event Hub Namespace is a logical container that holds one or more Event Hubs. It serves as a scoping container to manage multiple Event Hubs within a single administrative unit. To create our Event Hub Namespace, first search for "Event Hub" in your Azure tenant, then click on the option that appears. Afterwards, select the blue "Create Event Hub Namespace" button. This will take you to the configuration page for the Event Hub Namespace. Select the resource group that we created when we set up our VM, then enter a "Namespace name." Next, select "Standard" for the "Pricing Tier" and set the "Throughput Units" to 20. Finally, click on "Review + create," and once the validation is verified, click on "Create." Wait until the resource has been deployed to complete the creation of your Event Hub Namespace.

<p align="center">
<img src="https://imgur.com/N0KWapR.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Creating an Event Hub for Azure Blob Storage Logs:</h3>

Next, we need to create an Event Hub to stream our Blob Storage logs to. An Azure Event Hub is a fully managed, real-time data ingestion service that can capture, process, and store large amounts of data from various sources. It acts as an event ingestor, allowing for the streaming of millions of events per second from applications, devices, or sensors. To do this, go to your Event Hub Namespace and click on the "+ Event Hub" option. This will take you to the "Create Event Hub" configuration page. Enter a name for this Event Hub and set the "Retention time" to 24 hours. Finally, click the "Review + create" button, wait for the validation to pass, and then click "Create."

<p align="center">
<img src="https://imgur.com/UXKPeZv.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Creating an Azure Storage Account:</h3>

Now we need to create an Azure Storage Account to hold our storage container. A storage account provides a unique namespace in Azure for your data. To begin, search for "Storage Account" in your Azure tenant and select the corresponding option. Then, click on the blue "Create storage account" button. This will take you to the "Create a storage account" configuration page. Enter a "Storage account name" and leave the other settings as default. Finally, click on "Review and create," wait for the validation to complete, and then click on "Create."

<p align="center">
<img src="https://imgur.com/0g42lrR.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Creating an Azure Storage Container:</h3>

Now that we have our storage account, we can proceed to create a "Storage Container." A storage container is a fundamental entity within a storage account that organizes and holds blobs (binary large objects). To do this, navigate to the storage account you just created and select the "Data Storage" option. Then, click on "+ Container" to open the menu for creating a new container. Enter a name for your storage container and click the blue "Create" button. Finally, select your storage container and upload the "Valuabledata.txt" file that I have provided.

<p align="center">
<img src="https://imgur.com/TrjVeDm.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Enable Logging for our Azure Blob Storage Data:</h3>

Next, we need to enable logging for our blob data. To do this, go to your storage account and find the "Monitoring" option, then click on "Diagnostic Settings." Select the "Blob" option and click on "Add diagnostic settings." Enter a name for the diagnostic setting and ensure that "Audit" and "AllLogs" are checked. Then, checkmark the "Stream to Event Hub" option, and verify that the "Event Hub Namespace" is set to your namespace and the "Event Hub Name" is set to the event hub we created. Finally, save the settings and confirm that the diagnostic setting was successfully created.

<p align="center">
<img src="https://imgur.com/keYVR54.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Azure Logs Elastic Integration:</h3>

Now that logging is enabled, we need to ingest those logs into our Elastic environment. To do this, we will use the "Azure Logs" integration tool. First, go to your Elastic environment and search for "Azure Logs" in the search box, then click on the option that appears. Afterward, click on the blue "Add Azure Logs" button.

<p align="center">
<img src="https://imgur.com/c4GWTLq.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We should now be on the "Azure Logs" configuration page. Here, we need to enter the information required to ingest our logs. First, enter the Event Hub Name that we created. Next, we need to provide the "Connection String" for our Event Hub. A "Connection String" is a string of text that provides the necessary details for an application to connect to an Azure Event Hub. To find this, go to your Event Hub, click on the "Settings" option, then select "Shared Access Policies." Click on the "+ Add" option to create a new policy, enter a name for this policy, and ensure that the "Manage" option is checked. Save the policy, then view it to find the "Connection string-primary key." Copy this key into the "Connection String" field in the Azure Logs integration tool.

<p align="center">
<img src="https://imgur.com/psLSaMO.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, we need to add the name of our storage account in the "Storage Account" field. Then, enter the "Storage Account Key." To find this, go to your storage account in your Azure tenant and look for the "Security + networking" option. Select this option, and under the "Key1" section, click on the blue "Show" button to reveal the key. Copy this key and paste it into the "Storage Account Key" field in the integration tool. Afterward, scroll to the "Collect events from Event Hub" section, click on the "Change defaults" option, and ensure that the "Parse azure message" option is enabled.

<p align="center">
<img src="https://imgur.com/WLUkp2U.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The last step is to add this integration tool to our existing Azure VM host. To do this, scroll down to "Where to add this integration" and select the "Existing Hosts" option. Then, choose our Ubuntu Azure VM as the "Agent Policy." Finally, click the "Save and continue" button to save the Azure Logs integration settings.

<p align="center">
<img src="https://imgur.com/4N0jRza.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

You should now see Azure logs being ingested into your Elastic environment. We are now ready to simulate our attack.

<p align="center">
<img src="https://imgur.com/TufyA12.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Unauthorized Download of Azure Blob Storage Attack</h2>

<h3>Attack Execution:</h3>

To simulate this attack simply go to the file we uploaded in your storage container and download the file.

<p align="center">
<img src="https://imgur.com/gLtv3eu.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Unauthorized Download of Azure Blob Storage Detection</h2>

<h3>Unauthorized Download of Azure Blob Storage Query:</h3>

In order to create a query for this detection, we need to determine exactly what we are looking for. For this detection, we want to alert every time someone downloads the file from our storage container. Specifically, we need to look for the "ValuableData.txt" file and the "GetBlob" operation in our logs. After some research, this is the query we will use for our detection:

```SQL

data_stream.dataset : "azure.eventhub" and azure.eventhub.operationName : "GetBlob" and azure.eventhub.uri : *ValuableData.txt*

```

- data_stream.dataset : "azure.eventhub" this filters the data to only include logs/events from the Azure Event Hub dataset.
- azure.eventhub.operationName : "GetBlob" this further filters the logs/events to those where the operation name is "GetBlob," which typically indicates an action involving fetching a blob (file) from Azure Storage.
- azure.eventhub.uri : ValuableData.txt this filters the logs/events to include only those where the URI contains the string "ValuableData.txt," indicating that this specific file was involved in the operation.

<p align="center">
<img src="https://imgur.com/gQBDMj6.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have our query we are ready to create our detection rule.

<h3>Unauthorized Download of Azure Blob Storage Detection Rule:</h3>

<b>Define Rule:</b>

Now that we have our query, we need to create our detection rule. To do this, copy the query and click on the hamburger icon in the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Next, click on "Detection Rules (SIEM)" and then choose "Create New Rule." Ensure that the "Custom Query" option is selected, then scroll down and paste our query into the designated field. Next, scroll to the "Suppress alerts by" option, enter "source.ip," select "Per time period," and set it to 5 minutes. This configuration will help reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/z1xIj1c.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we need to fill out the "About Rule" section. Name the alert "ValuableData.txt Downloaded from Azure Detected!" and provide a description for the rule. Set the "Default severity" to "Medium," then click on "Advanced Settings." Scroll down until you see "MITRE ATT&CK threats," select "Exfiltration" for the tactic, and add a technique, setting it to "Exfiltration Over Web Service." Finally, add a sub-technique and set it to "Exfiltration to Cloud Storage."

<p align="center">
<img src="https://imgur.com/sloZOT4.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/PfHWuKa.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, set the duration for how long the rule should run. Configure the rule to run every 5 minutes with a look-back time of 5 minutes. Feel free to adjust this based on your needs.

<p align="center">
<img src="https://imgur.com/bZM4ADq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, configure what action Elastic should take when the rule triggers. Options include sending an email, a message via Slack, using Microsoft Teams, etc. For this project, you can leave it unset and simply click the "Create & Enable rule" button.

<p align="center">
<img src="https://imgur.com/4Sd0G0p.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule, download the file from our storage container again to trigger the alert. To view the alert, go to "Security" and select the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://imgur.com/wW98jNK.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h3>Unauthorized Download of Azure Blob Storage Completed!</h3>



