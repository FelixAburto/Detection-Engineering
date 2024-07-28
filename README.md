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
<img src="https://img.icons8.com/?size=512&id=84280&format=png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Creating our Event Hub for Azure Blob Storage logs:</h3>

Next, we need to create an Event Hub to stream our Blob Storage logs to. An Azure Event Hub is a fully managed, real-time data ingestion service that can capture, process, and store large amounts of data from various sources. It acts as an event ingestor, allowing for the streaming of millions of events per second from applications, devices, or sensors. To do this go to your Event Hub Namespace and click on the "+ Event Hub" option. This will take you to the "Create Event Hub" configuration page. Enter in a name for this eventhub and set the "Retention time" to 24 hours. Finally, click the "Review + create" button and wait for the validation to pass then click on "create". 

<p align="center">
<img src="https://img.icons8.com/?size=512&id=84280&format=png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3></h3>
