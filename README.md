# Unauthorized Access to Azure Key Vault

<br />

<p align="center">
<img src="https://miro.medium.com/v2/resize:fit:600/1*b0oZ-Da1LxW4TdujAOiC9Q.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project we are going to be creating a detection for unauthorized access to a "Secret Value" in our Azure Key Vault. Azure Key Vault is a cloud service provided by Microsoft Azure for securely storing and managing sensitive information, such as secrets, keys, and certificates.

<h2>Unauthorized Access to Azure Key Vault Setup</h2>

<h3>Creating an Event Hub for our Key Vault Logs:</h3>

The first thing we need to do is to create an Event Hub to stream our Azure Key Vault logs. To do this go to your Event Hub Namespace and click on the "+ Event Hub" option. This will take you to the "Create Event Hub" configuration page. Enter in a name for this eventhub and set the "Retention time" to 24 hours. Finally, click the "Review + create" button and wait for the validation to pass then click on "create".

***Note: If you do not have an Event Hub Namespace set up go to the "Unauthorized Access to Azure Blob Storage" section of the project and follow the instructions on how to do that.***

<p align="center">
<img src="https://imgur.com/XdWcF0e.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h3>Creating an Azure Key Vault:</h3>

The next step is to create an Azure Key Vault. To do this go to your Azure tenant and search up "Key Vaults" and select the option that appears. Afterwards, click on the blue "Create key vault" button and this should take you to the "Create a key vault" configuration page. Set the "Resource Group" field to the resource group we created then enter a name for this key vault. Next, click on "Review and Create" and wait for the validation to pass then select "Create". Finally, wait for the key vault to be deployed and view your key vault.

<p align="center">
<img src="https://imgur.com/87Gxfao.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Add "Key Vault Administrator" Role:</h3>

Next, we need to add the "Key Vault Administrator" role to our user. To do this visit your key vault and click the "Access control (IAM)" option. Afterwards, click on the "+ Add" option then select "Add role assignment". This should take you to the "Add role assignment" configuration page. Search for the "Key Vault Administrator" role and select it then click "Next". Afterwards click the "+ Select Members" option and select your user account. Finally, click on "Review and assign" and this should assign the role to your account.

<p align="center">
<img src="https://imgur.com/2mIGkcD.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Creating an Azure Secret Value:</h3>

Now that we have our key vault created we are now able to create a "Secret Value" to store in our key vault. To do this go to your key vault and click on the "Objects" option then select the "Secrets" option. Next, select the "+ Generate/Import" option and this should take you to the "Create a Secret" settings page. Enter in a name for this "Secret" then enter in a "Secret Value". Once that is done click the blue "Create" option and verify that your secret was creating by view your secret value.

<p align="center">
<img src="https://imgur.com/R27Mmrq.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Enabling Logging for Azure Key Vault:</h3>

Next, we need to enable logging for our secret vault. To do this go to your secret vault and find the "Monitoring" option then click on "Diagnostic Settings". Next click on the "Add diagnostic settings" option and this should take you to the "Diagnostic Settings" configuration page. Enter in a name in the "Diagnostic settings name" field then make sure that "allLogs" and "audit" boxes are checkmarked. Afterwards, check the "Stream to an event hub" option and set the "Event Hub Namespace" field to your namespace then set the "Event hub name" option to the event hub we created for our key vault logs. Finally, click the "Save" icon and verify that your configuration was saved. 

<p align="center">
<img src="https://imgur.com/6Y4dfMh.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Azure Logs Elastic Integration:</h3>

Now, that we have logging enabled we need to ingest those logs into our Elastic environment. To do this we are going to use the "Azure Logs" integration tool. First, go into your Elastic environment and search "Azure Logs" in the search box then click on the option that appears. Afterwards, click onthe blue "Add Azure Logs" button. 

<p align="center">
<img src="https://imgur.com/c4GWTLq.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We should now be on the "Azure Logs" configuration page. This is where we are going to enter the information needed to ingest our logs. First, enter in the Event Hub Name that we created. Now we need to enter in the "Connection String" for out Event Hub. A "Connection String" is a string of text that provides the necessary information for an application to connect to an Azure Event Hub. To do this go to your Even Hub and click on the "Settings" option then select the "Shared Access Policies" option. Afterwards, click of the "+ Add" option and enter in a name for this policy then make sure to checkmark the "Manage" option. Finally, save the policy and view the policy to find the "Connection string-primary key". Copy this key into the "Connection String" field in the Azure Logs integration tool.

<p align="center">
<img src="https://imgur.com/d27RkVw.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
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

</br>

<h2>Unauthorized Access to Azure Key Vault Attack</h2>

<h3>Attack Execution:</h3>

To simulate this attack simply go to the "Secret" we created and view the secret value.

<p align="center">
<img src="https://imgur.com/VY2ccKe.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Unauthorized Access to Azure Key Vault Detection</h2>

<h3>Unauthorized Access to Azure Key Vault Query:</h3>

In order to create a query for this detection first we must think about what exactly are we looking for. For this detection we want to alert every time someone views our secret value from our key vault. We would want to look for the "mysecretvalue" Secret and the "SecretGet" operation in our logs. After doing some research this is the query that we are going to use for our detection:

```SQL

data_stream.dataset : "azure.eventhub" and azure.eventhub.operationName : "SecretGet" and azure.resource.name : "MYKEYVAULT2394" and azure.eventhub.properties.requestUri : *mysecretvalue*

```

- data_stream.dataset : "azure.eventhub" filters the data to only include logs/events from the Azure Event Hub dataset.
- azure.eventhub.operationName : "SecretGet" further filters the logs/events to those where the operation name is "SecretGet," which indicates an action to retrieve a secret from Azure Key Vault.
- azure.resource.name : "MYKEYVAULT2394" specifies the name of the Azure Key Vault resource to filter logs/events that pertain to this particular Key Vault instance.
- azure.eventhub.properties.requestUri : mysecretvalue filters the logs/events to include only those where the request URI contains the string "mysecretvalue," indicating that this specific secret value was accessed or requested.

<p align="center">
<img src="https://imgur.com/nWGuV7J.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have our query we are ready to create our detection rule.

<h3>Unauthorized Access to Azure Key Vault Detection Rule:</h3>

<b>Define Rule:</b>

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Custom Query" option is selected then scroll down and paste our query. Next scroll down to the "Suppress alerts by" option and enter in "source.ip". Then select "Per time period" and select 5 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/1V1PaDQ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "Super Secret Value Viewed!" and enter in a description for the rule. Set the "Default severity" to "Medium" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Exfiltration" for the tactic and then add a technique and set it to "Exfiltration Over Web Service". Finally, add a subtechnique and set it to "Exfiltration to Cloud Storage".

<p align="center">
<img src="https://imgur.com/h3IOeVT.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
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

Now that we have set our rule we can then view our secret value again and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://imgur.com/2Y0MkDq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h3>Unauthorized Download of Azure Blob Storage Completed!</h3>



