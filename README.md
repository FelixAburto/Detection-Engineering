# Windows and Linux Brute Force Attack

<br />

<p align="center">
<img src="https://cdn-icons-png.flaticon.com/512/6689/6689968.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

A brute force attack in cybersecurity is a technique used to gain unauthorized access to a system by methodically attempting every possible combination of passwords or encryption keys until the correct one is discovered. In this section, we will simulate brute force attacks on both Windows and Linux systems and create detection rules to identify these types of attacks.

</br>

<h2>Windows Brute Force Attack</h2>

<h3>Attack Setup</h3>

The first step in setting up this attack is to configure our virtual network adapter as a "Bridged Adapter." To do this, open Oracle VirtualBox, right-click on the Windows 11 VM, and select "Settings." Then, select the "Network" option and ensure that "Adapter 1" is highlighted. In the "Attached to" drop-down menu, select "Bridged Adapter." Next, click on the "Advanced" option and set "Promiscuous Mode" to "Allow All." This configuration will place our Windows 11 VM on our home network, allowing our host machine to communicate with the Windows VM. To test the setup, use the "ipconfig" command to find the new IP address of the Windows VM, and then try pinging this IP address from your host machine to the Windows VM.

<p align="center">
<img src="https://i.imgur.com/m6fgdrM.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/JF3k5ks.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, we need to enable "Remote Desktop" on our Windows VM. To do this, open the Windows settings and scroll down until you see the option for "Remote Desktop." Select that option, and you should see a switch to enable "Remote Desktop" on this Windows VM. Enable it and verify that you can remotely connect to the VM by using "Remote Desktop Connection" from your host machine. Enter the IP address of your Windows VM in Remote Desktop Connection, then enter the username and password of your Windows 11 VM user account.

<p align="center">
<img src="https://i.imgur.com/XgbyVN8.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/AWSkWeV.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, we need to disable the Windows Account Lockout Policy. To do this, enter "gpedit.msc" in the Windows search box. In the Group Policy Editor, navigate to "Computer Configuration" and expand "Windows Settings." Then, expand "Security Settings" and click on "Account Lockout Policy." You should see the option "Account Lockout Threshold." Double-click on this option, and a window will pop up allowing you to set the account lockout threshold. Set it to zero and click "Apply," then "OK" to save the setting.

<p align="center">
<img src="https://i.imgur.com/8rk687z.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


We are now ready to execute the brute force attack on our Windows 11 VM.

</br>

<h3>Attack Execution</h3>

To simulate the attack, run the "Mimic Brute Force Attempts.ps1" PowerShell script that I have provided. To correctly run the script for your environment, you will need to edit the $server variable to contain the IP address of your Windows 11 VM. If you are using a different username for your Windows 11 VM, set the `$username` variable to that username.

<p align="center">
<img src="https://i.imgur.com/tNLjkKJ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

After you have made the necessary edits, navigate to the directory where the PowerShell script is saved and open PowerShell in that directory. Then, enter the following command:

  ```powershell
    powershell.exe -ExecutionPolicy Bypass -File "Mimic Brute Force attempts.ps1"
  ```

This will execute the brute force simulation script, and it should look something like this:


<p align="center">
<img src="https://i.imgur.com/pkuZ6B9.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Windows Brute Force Detection</h2>

<h3>Windows Brute Force Query:</h3>

To build our query, we first need to determine what exactly we are looking for. To detect brute force attacks, we need to identify a large number of logon attempts over a short period of time. Start by going to "Analytics" and then "Discover" in Elastic. Once there, enter the query `*4625*` and `*User*`. This will bring up all logs that have "User" and "4625" as values. You should now see logs that contain failed logon attempts from our attack. From these logs, we will build our query.

<p align="center">
<img src="https://i.imgur.com/uC3XUtK.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/xplT8gE.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The query for our detection rule is going to be: 
```sql
data_stream.dataset : "system.security" and event.code : "4625" and winlog.logon.failure.reason : "Unknown user name or bad password."
```

-  data_stream.dataset : "system.security" looks for logs that have the dataset "system.security"
-  event.code : "4625" looks for logs that contains the Windows Event Log 4625
-  winlog.logon.failure.reason :  "Unknown user name or bad password." looks for logs that contain this failure reason.

<p align="center">
<img src="https://i.imgur.com/b2TqeQw.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Windows Brute Force Detection Rule:</h3>

<b>Define Rule:</b>

Now that we have our query, we are ready to create our detection rule. First, copy the query. Next, click on the hamburger icon in the top-left corner of the page, scroll down to "Security," and select the "Rules" option. Click on "Detection Rules (SIEM)" and then select "Create New Rule." Ensure that the "Threshold" option is selected, then scroll down and paste our query. Under the "Group by" field, enter "host.name" and set the "Threshold" field to >= 30. In the "Count" field, enter "@timestamp" and set the "Unique Values" field to >= 30. This configuration will set the rule to trigger an alert if there are 30 or more failed logon attempts in a short period of time. Finally, scroll down to the "Suppress alerts by" option, select "Per time period," and set it to 5 minutes. This will reduce the noise generated by repetitive alerts by grouping similar alerts together.



<p align="center">
<img src="https://i.imgur.com/54uIsGW.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/fRq8NSb.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we will fill out the "About Rule" section. Name the alert "Windows Brute Force Attempt!" and enter a description for the rule. Set the "Default severity" to "Medium," then click on "Advanced Settings." Scroll down until you see "MITRE ATT&CK threats." For the tactic, select "Credential Access," then add a technique and set it to "Brute Force." Finally, add a subtechnique and set it to "Password Guessing."

<p align="center">
<img src="https://i.imgur.com/EhVM8fK.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/pucpGuI.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. Configure the rule to execute every 5 minutes with a look-back time of 5 minutes. You can adjust these settings as needed to suit your specific requirements.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set the action Elastic should take when this rule triggers. Options include sending an email, sending a message via Slack, or using Microsoft Teams. For this project, we don't need to set any specific actions. Simply click on the "Create & Enable Rule" button to complete the process.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule, we can run the script again, which should trigger the alert. To view the alert, go to "Security" and select the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://i.imgur.com/N2Jhlmu.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h2>Linux SSH Brute Force Attack</h2>

<h3>Attack Setup:</h3>

The first step in setting up this attack is to configure our virtual network adapter as a "Bridged Adapter." To do this, open Oracle VirtualBox, right-click on the Windows 11 VM, and select "Settings." Next, select the "Network" option and ensure that "Adapter 1" is highlighted. In the "Attached to" drop-down menu, select "Bridged Adapter." Finally, click on the "Advanced" option and set "Promiscuous Mode" to "Allow All." This configuration will place our Windows 11 VM on our home network, allowing our host machine to communicate with the Windows VM. To test the setup, use the "ipconfig" command to find the new IP address of the Windows VM, and then try pinging this IP address from your host machine to the Windows VM.

<p align="center">
<img src="https://i.imgur.com/pDWRiDw.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/Lwq1GoA.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The next step is to install the "System Integration" tool in our Elastic environment. This will allow us to ingest the SSH logs from our Ubuntu VM. To do this, go to your Elastic environment and use the search box at the top of the page to search for "System." Select the System Integration tool, and then click on the blue "Add System" button located in the top right corner of the page.

<p align="center">
<img src="https://i.imgur.com/9zlGwnw.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

After clicking the "Add System" button, you will be taken to the configuration page of the "System Integration" tool. Scroll down to find the option "Collect events from the Windows event log" and disable it. Leave all other settings as default and scroll down to the "Where to add this integration?" section. Highlight "Existing Host" and select the agent that you installed on your Ubuntu VM.

<p align="center">
<img src="https://i.imgur.com/UyCoEII.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, we need to install OpenSSH on our Ubuntu VM. To do this, open a terminal on your Ubuntu VM and enter the following command:

```Bash
sudo apt install openssh-server

```

After you install OpenSSH run this command to start it up:

```Bash
sudo systemctl start ssh

```

You should now be able to ssh into your Ubuntu VM.

<p align="center">
<img src="https://i.imgur.com/TBEc2eK.png" height="40%" width="40%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/Q73m3o9.png" height="40%" width="40%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The next step is to SSH into our Ubuntu VM using the Ubuntu WSL. First, install Ubuntu WSL by going to the "Microsoft Store" and searching for "Ubuntu WSL." Click the install button, open the program, and complete the setup. Once you have the Linux WSL terminal up, SSH into your Ubuntu VM using the following command:

```Bash
ssh yourusername@youripaddress

ssh zeek@192.168.1.66

```

***Note: You may need to user the command "sudo apt update && sudo apt upgrade" if you cannot use the ssh command or install any additional packages***

<p align="center">
<img src="https://i.imgur.com/zgB42Pi.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/RafpxK4.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterward, we need to install some additional packages to execute the script properly. In the Ubuntu WSL terminal, enter the following commands:

```Bash
sudo apt install sshpass

```

```Bash
sudo apt install dos2unix

```
<p align="center">
<img src="https://i.imgur.com/7cgz3QS.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/IhGXSzp.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, navigate to the directory of the script in the Ubuntu WSL terminal. If you do not know how to do this, simply enter the command `cd /mnt/c/YOURPATHHERE`, and then run the following command:

```Bash

sudo dos2unix SSH\ Mimic\ Brute\Force.sh

```

<p align="center">
<img src="https://i.imgur.com/HHOiwaS.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We are now ready to execute the script and launch the attack.

</br>

<h3>Attack Execution:</h3>

To execute the attack, first modify the bash script so that the variable USER is set to the username of your Ubuntu VM and the variable "IP" is set to the IP address of your Ubuntu VM. Once the modifications are done, navigate to the folder containing the script in the Ubuntu WSL terminal and enter the following command:

```Bash

sudo ./SSH \ Mimic\ Brute\ Force.sh

```

<p align="center">
<img src="https://i.imgur.com/qPntokD.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/smr7hXe.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Linux SSH Brute Force Detection</h2>

<h3>Linux SSH Brute Force Query</h3>

To build our query, we first need to determine what exactly we are looking for. To detect brute force attacks, we need to identify a large number of logon attempts over a short period of time. Start by going to "Analytics" and then "Discover" in Elastic. Once there, enter the query `*ssh*`. This will bring up all logs that have "ssh" as a value. You should now see logs that contain failed logon attempts from our attack. From these logs, we will build our query.

<p align="center">
<img src="https://i.imgur.com/EUVYW2L.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The query for our detection rule is going to be: "
```sql
data_stream.dataset : "system.auth" and event.action : "ssh_login" and event.outcome : "failure"
```

-  data_steam.dataset : "system.auth" looks for logs that have the system.auth dataset
-  event.action : "ssh_login" looks for logs that have ssh login attempts
-  event.outcome : "failure" looks for logs that have ssh login failures

<p align="center">
<img src="https://i.imgur.com/7vI8kn5.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Linux SSH Brute Force Detection Rule:</h3>

<b>Define Rule:</b>

Now that we have our query, we are ready to create our detection rule. First, copy the query. Then, click on the hamburger icon in the top-left corner of the page, scroll down to "Security," and select the "Rules" option. Next, click on "Detection Rules (SIEM)" and select "Create New Rule." Ensure that the "Threshold" option is selected, then scroll down and paste our query.

Under the "Group by" field, enter "source.ip," "event.action," and "event.outcome." Set the "Threshold" field to ">= 30". In the "Count" field, enter "@timestamp" and set the "Unique Values" field to ">= 30". This configuration will set the rule to trigger an alert if there are 30 or more failed logon attempts in a short period of time.

Finally, scroll down to the "Suppress alerts by" option. Select "Per time period" and set it to 5 minutes. This will help reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://i.imgur.com/itpQ7DL.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/8BkJoSD.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we will fill out the "About Rule" section. Name the alert "SSH Brute Force Detected!" and enter a description for the rule. Set the "Default severity" to "Medium," then click on "Advanced Settings." Scroll down until you see "MITRE ATT&CK threats." For the tactic, select "Credential Access," then add a technique and set it to "Brute Force." Finally, add a subtechnique and set it to "Password Guessing."

<p align="center">
<img src="https://i.imgur.com/TorDK7A.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/pucpGuI.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. Configure the rule to execute every 5 minutes with a look-back time of 5 minutes. You can adjust these settings as needed to suit your specific requirements.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set the action Elastic should take when this rule triggers. Options include sending an email, sending a message via Slack, or using Microsoft Teams. For this project, we don't need to set any specific actions. Simply click on the "Create & Enable Rule" button to complete the process.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule, we can run the script again, which should trigger the alert. To view the alert, go to "Security" and select the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://i.imgur.com/0OUqNvU.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Windows & Linux Brute Force Attack & Detection Complete!</h3>

