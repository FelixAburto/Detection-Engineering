# Unauthorized Access to Azure Key Vault

<br />

<p align="center">
<img src="https://miro.medium.com/v2/resize:fit:600/1*b0oZ-Da1LxW4TdujAOiC9Q.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project, we will create a detection for unauthorized access to a "Secret Value" in our Azure Key Vault. Azure Key Vault is a cloud service provided by Microsoft Azure for securely storing and managing sensitive information, such as secrets, keys, and certificates.

<h2>Unauthorized Access to Azure Key Vault Setup</h2>

<h3>Creating an Event Hub for our Key Vault Logs:</h3>

The first step is to create an Event Hub to stream our Azure Key Vault logs. To do this, navigate to your Event Hub Namespace and click on the "+ Event Hub" option. This will take you to the "Create Event Hub" configuration page. Enter a name for the event hub and set the "Retention time" to 24 hours. Finally, click the "Review + create" button, wait for the validation to pass, and then click on "Create."

***Note: If you do not have an Event Hub Namespace set up go to the "Unauthorized Access to Azure Blob Storage" section of the project and follow the instructions on how to do that.***

<p align="center">
<img src="https://imgur.com/XdWcF0e.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h3>Creating an Azure Key Vault:</h3>

The next step is to create an Azure Key Vault. To do this, go to your Azure tenant and search for "Key Vaults," then select the option that appears. Click on the blue "Create key vault" button, which will take you to the "Create a key vault" configuration page. Set the "Resource Group" field to the resource group we created and enter a name for the key vault. Click on "Review and Create," wait for the validation to pass, and then select "Create." Finally, wait for the key vault to be deployed and view it.

<p align="center">
<img src="https://imgur.com/87Gxfao.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Add "Key Vault Administrator" Role:</h3>

Next, we need to assign the "Key Vault Administrator" role to your user. To do this, navigate to your key vault and click on the "Access control (IAM)" option. Then, click on the "+ Add" button and select "Add role assignment." This will take you to the "Add role assignment" configuration page. Search for and select the "Key Vault Administrator" role, then click "Next." Next, click the "+ Select Members" button and choose your user account. Finally, click on "Review and assign" to complete the role assignment.

<p align="center">
<img src="https://imgur.com/2mIGkcD.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Creating an Azure Secret Value:</h3>

Now that we have our key vault created, we can add a "Secret Value" to store in it. To do this, go to your key vault and click on the "Objects" option, then select "Secrets." Next, click on the "+ Generate/Import" option, which will take you to the "Create a Secret" settings page. Enter a name for the "Secret" and input the "Secret Value." Once you've done this, click the blue "Create" button and verify that your secret was created by viewing the secret value.

<p align="center">
<img src="https://imgur.com/R27Mmrq.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Enabling Logging for Azure Key Vault:</h3>

Next, we need to enable logging for our key vault. To do this, go to your key vault and find the "Monitoring" option, then click on "Diagnostic Settings." Click on the "Add diagnostic settings" option, which will take you to the "Diagnostic Settings" configuration page. Enter a name in the "Diagnostic settings name" field, and ensure that the "allLogs" and "audit" boxes are checked. Then, select the "Stream to an event hub" option, setting the "Event Hub Namespace" field to your namespace and the "Event Hub name" option to the event hub we created for key vault logs. Finally, click the "Save" icon and verify that your configuration was saved.

<p align="center">
<img src="https://imgur.com/6Y4dfMh.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Azure Logs Elastic Integration:</h3>

Now that we have logging enabled, we need to ingest those logs into our Elastic environment. To do this, we will use the "Azure Logs" integration tool. First, go into your Elastic environment and search for "Azure Logs" in the search box, then click on the option that appears. Afterward, click on the blue "Add Azure Logs" button.

<p align="center">
<img src="https://imgur.com/c4GWTLq.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We should now be on the "Azure Logs" configuration page. This is where we will enter the information needed to ingest our logs. First, input the Event Hub Name that we created. Next, we need to provide the "Connection String" for our Event Hub. A "Connection String" is a piece of text that provides the necessary information for an application to connect to an Azure Event Hub. To obtain this, go to your Event Hub, click on the "Settings" option, and then select "Shared Access Policies." Click on "+ Add," enter a name for the policy, and ensure the "Manage" option is checked. Save the policy, and view it to find the "Connection string-primary key." Copy this key into the "Connection String" field in the Azure Logs integration tool.

<p align="center">
<img src="https://imgur.com/d27RkVw.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, we need to add the name of our storage account in the "Storage Account" field. Then, we need to enter the "Storage Account Key." To obtain this key, go to your storage account in your Azure tenant, find the "Security + networking" option, and select it. Look for the "Key" field under the "Key1" section, click the blue "Show" button, and copy the key. Paste this key into the "Storage Account Key" field in the integration tool. Afterward, scroll to the "Collect events from Event Hub" section, click on the "Change defaults" option, and ensure that the "Parse Azure message" option is enabled.

<p align="center">
<img src="https://imgur.com/WLUkp2U.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The last step is to add this integration tool to our existing Azure VM host. To do this, scroll down to the "Where to add this integration" section and select the "Existing Hosts" option. Then, choose our Ubuntu Azure VM as the "Agent Policy." Finally, click the "Save and continue" button to save the Azure Logs integration settings.

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

To create a query for this detection, we first need to define what we're looking for. In this case, we want to trigger an alert every time someone views our secret value from the Key Vault. Specifically, we need to search for logs that reference the "mysecretvalue" secret and the "SecretGet" operation. After conducting some research, this is the query we'll use for our detection:

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

Now that we have our query, we can proceed to create our detection rule. First, copy the query and click on the hamburger icon in the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Next, click on "Detection Rules (SIEM)" and then choose "Create New Rule." Ensure that the "Custom Query" option is selected. Scroll down and paste the query into the provided field. Proceed to the "Suppress alerts by" section, enter "source.ip" in the appropriate field, and select "Per time period," setting it to 5 minutes. This configuration will help reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/1V1PaDQ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we need to complete the "About Rule" section. Name the alert "Super Secret Value Viewed!" and provide a description for the rule. Set the "Default severity" to "Medium." Click on "Advanced Settings" and scroll down to find the "MITRE ATT&CK threats" section. Select "Exfiltration" as the tactic, then add a technique and set it to "Exfiltration Over Web Service." Finally, add a sub-technique and set it to "Exfiltration to Cloud Storage."

<p align="center">
<img src="https://imgur.com/h3IOeVT.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/PfHWuKa.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will configure the duration for how long the rule should run. Set the rule to execute every 5 minutes with a look-back time of 5 minutes. You can adjust these settings as needed.

<p align="center">
<img src="https://imgur.com/bZM4ADq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we need to determine the action Elastic should take when the rule is triggered. Options include sending an email, messaging via Slack, or using Microsoft Teams, among others. For this project, no action needs to be configured. Simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://imgur.com/4Sd0G0p.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that our rule is set, we can view the secret value again to trigger the alert. To see the alert, go to "Security" and select the "Alerts" option. This is what the alert should look like when it is triggered.

<p align="center">
<img src="https://imgur.com/2Y0MkDq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h3>Unauthorized Download of Azure Blob Storage Completed!</h3>



