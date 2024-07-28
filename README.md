#  Unauthorized Download of Azure Blob Storage

<br />

<p align="center">
<img src="https://img.icons8.com/?size=512&id=84280&format=png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project we are going to setup detection for unauthorized download of our blob storage file. 

</br>

<h2>Unauthorized Download of Azure Blob Storage Setup</h2>

<h3>Creating an Event Hub Namespace:</h3>

The first thing we need to do to set up our attack is to create an Azure Eventhub Namespace. An Azure Event Hub Namespace is a logical container that holds one or more Event Hubs. It serves as a scoping container to manage multiple Event Hubs within a single administrative unit. To create our Eventhub Namespace first search for "EventHub" in your Azure tenant then click on the option that appears. Afterwards, select the blue "Create event hubs namespace". This should take to the configuration page for the eventhub namespace. Select our resource group that we created when we created our VM then enter in a "Namespace name". Next, select "Standard" for the "Pricing Tier" and set the "Throughput Units" to 20. Finally, click on "Review + create" then once the validation has been verified click on "Create". Wait until the resource has been deployed and we have finished created our Eventhub Namespace.  

<p align="center">
<img src="https://imgur.com/N0KWapR.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Creating an Event Hub for Azure Blob Storage Logs:</h3>

Next, we need to create an Event Hub to stream our Blob Storage logs to. An Azure Event Hub is a fully managed, real-time data ingestion service that can capture, process, and store large amounts of data from various sources. It acts as an event ingestor, allowing for the streaming of millions of events per second from applications, devices, or sensors. To do this go to your Event Hub Namespace and click on the "+ Event Hub" option. This will take you to the "Create Event Hub" configuration page. Enter in a name for this eventhub and set the "Retention time" to 24 hours. Finally, click the "Review + create" button and wait for the validation to pass then click on "create". 

<p align="center">
<img src="https://imgur.com/UXKPeZv.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Creating an Azure Storage Account:</h3>

Now we need to create an Azure Storage Account to contain our storage container. A storage account is a container that provides a unique namespace in Azure for your data. To do this search for "Storage Account" in your Azure tenant and click on the option that appears then select the blue "Create storage account" button. This will take you to the "Create a storage account" configuration page. Next, enter in a "Storage account name" and leave everything as default. Finally, click on "Review and Create" and wait for the validation to pass then click on "Create". 

<p align="center">
<img src="https://imgur.com/0g42lrR.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Creating an Azure Storage Container:</h3>

Now that we have our storage account we can move on to create a "Storage Container". A storage container is a fundamental entity within a storage account that organizes and holds blobs (binary large objects). To do this go to the storage account that you just created and select the "Data Storage" option then click on "+ Container".  This will bring up a menu for creating a new container. Next, enter in a name for your storage container and click the blue "create" button. Finally, select your storage container and upload the "Valuabledata.txt" file that I have provided.

<p align="center">
<img src="https://imgur.com/TrjVeDm.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Enable Logging for our Azure Blob Storage Data:</h3>

Next, we need to enable logging for our blob data. To do this go to your storage account and find the "Monitoring" option then click on "Diagnostic Settings". Select the "blob" option and click on the "Add diagnostic settings" option. Add a "Diagnostic Setting name" and make sure that "audit" and "allLogs" are checkmarked. Afterwards, checkmark the "Stream to event hub" option and make sure that the "Event Hub Namespace" option is set to your namespace then make sure that "Event Hub name" is set to the event hub that we created. Finally save the setting and verify that the diagnostic setting was created.

<p align="center">
<img src="https://imgur.com/keYVR54.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Azure Logs Elastic Integration:</h3>

Now, that we have logging enabled we need to ingest those logs into our Elastic environment. To do this we are going to use the "Azure Logs" integration tool. First, go into your Elastic environment and search "Azure Logs" in the search box then click on the option that appears. Afterwards, click onthe blue "Add Azure Logs" button. 

<p align="center">
<img src="https://imgur.com/c4GWTLq.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We should now be on the "Azure Logs" configuration page. This is where we are going to enter the information needed to ingest our logs. First, enter in the Event Hub Name that we created. Now we need to enter in the "Connection String" for out Event Hub. A "Connection String" is a string of text that provides the necessary information for an application to connect to an Azure Event Hub. To do this go to your Even Hub and click on the "Settings" option then select the "Shared Access Policies" option. Afterwards, click of the "+ Add" option and enter in a name for this policy then make sure to checkmark the "Manage" option. Finally, save the policy and view the policy to find the "Connection string-primary key". Copy this key into the "Connection String" field in the Azure Logs integration tool.

<p align="center">
<img src="https://imgur.com/psLSaMO.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, we need to add the name of our storage account in the "Storage Account" field. Next, we need to enter in the "Storage Account Key". To do this go to your storage account in your azure tentant and look for the "Security + networking" option. Select that option then look for the "Key" field under the "Key1" section. Click on the blue "Show" button and copy the key. Paste the key in the "Storage Account Key" field in the integration tool. Afterwards, scroll to the "Collect events from Event Hub" section and click on the "Change defaults" option then make sure that the "Parse azure message" option is enabled. 

<p align="center">
<img src="https://imgur.com/WLUkp2U.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The last thing we need to do is to add this integration tool to our existing Azure VM host. To do this scrol down to "Where to add this integration" and select the "Existing Hosts" option then select our Ubuntu Azure VM as the "Agent Policy". Finally, select the "Save and continue" button and save the Azure Logs integration settings.

<p align="center">
<img src="https://imgur.com/4N0jRza.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We should know see Azure logs being ingested into our Elastic Evironment. We are now ready to simulate our attack

<p align="center">
<img src="https://imgur.com/TufyA12.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h2>Unauthorized Download of Azure Blob Storage Attack</h2>

<h3>Attack Execution:</h3>

To simulate this attack simply go to the file we uploaded in your storage container and download the file.

<p align="center">
<img src="https://imgur.com/gLtv3eu.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Unauthorized Download of Azure Blob Storage Detection</h2>

<h3>Unauthorized Download of Azure Blob Storage Query:</h3>

In order to create a query for this detection first we must think about what exactly are we looking for. For this detection we want to alert every time someone downloads this file from our storage container. We would want to look for the "ValuableData.txt" file and the "GetBlob" operation in our logs. After doing some research this is the query that we are going to use for our detection:

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

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Custom Query" option is selected then scroll down and paste our query. Next scroll down to the "Suppress alerts by" option and enter in "source.ip". Then select "Per time period" and select 5 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/z1xIj1c.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "ValuableData.txt Downloaded from Azure Detected!" and enter in a description for the rule. Set the "Default severity" to "Medium" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Exfiltration" for the tactic and then add a technique and set it to "Exfiltration Over Web Service". Finally, add a subtechnique and set it to "Exfiltration to Cloud Storage".

<p align="center">
<img src="https://imgur.com/sloZOT4.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/PfHWuKa.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://imgur.com/bZM4ADq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://imgur.com/4Sd0G0p.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then execute another SQL Injection and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://imgur.com/wW98jNK.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h3>Unauthorized Download of Azure Blob Storage Completed!</h3>



