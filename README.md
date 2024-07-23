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

The first thing we need to do to set this attack up is to configure our virtual network adapter and set it as a "Bridged Adapter. To do open up Oracle Virtualbox and right click on the Windows 11 VM and select "Settings". Afterwards select the "Network" option and make sure that "Adapter 1" is highlighted. In the "Attached to" drop down menu select "Bridged Adapter". Finally click on the "Advanced" option and set the "Promiscuous Mode" option to "Allow All". This will put our Windows 11 VM on our home network so our host machine can now talk to our Windows VM. To test this simply lookup the new ip address of our Windows VM by using the "ipconfig" command and then try to ping the ip address from your host to your Windows VM.

<p align="center">
<img src="https://i.imgur.com/m6fgdrM.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/JF3k5ks.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterwards we need to enable "Remote Desktop" on our Windows VM. To do this open up the Windows settings and scroll down until you see the option for "Remote Desktop". Select that option and you should now see a switch to enable "Remote Desktop" on this Windows VM. Enable it and verify that you can remote into the VM by using "Remote Desktop Connection" from your host machine. Enter in the IP address of your Windows VM in Remote Desktop Connection and then enter in the Username and Password of your Windows 11 VM user account. 

<p align="center">
<img src="https://i.imgur.com/XgbyVN8.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/AWSkWeV.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally we need to disable the Windows Account Lockout Policy. To do this enter in "gpedit.msc" in the Windows searchbox. Next under "Windows Configuration" look for "Windows Settings" and expand it. Under "Windows Settings" look for "Security Settings" and expand it then under "Security Settings" click on "Account Lockout Policy". You should be able to see the option "Account Lockout Threshold". Double click on that option and a window should pop up allowing you to set the account lockout threshold. Set it to zero and click "Apply" then "OK" to save the setting. 

<p align="center">
<img src="https://i.imgur.com/8rk687z.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


We are now ready to execute the brute force attack on our Windows 11 VM.

</br>

<h3>Attack Execution</h3>

To simulate the attack run the "Mimic Brute Force Attempts.ps1" powershell script that I have provided. In order to correctly run the script for your environment you will have to edit the $server variable to contain the IP address of your Windows 11 VM. If you happen to be using a different username for your Windows 11 VM you will have to set the $username variable to that username.

<p align="center">
<img src="https://i.imgur.com/tNLjkKJ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

After you have done that navigate to the directory where the powershell script is saved then open up powershell in that directory. Next you will need to enter in the command:

  ```powershell
    powershell.exe -ExecutionPolicy Bypass -File "Mimic Brute Force attempts.ps1"
  ```

This will execute the brute force simulation script and it should look something like this:


<p align="center">
<img src="https://i.imgur.com/pkuZ6B9.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Windows Brute Force Detection</h2>

<h3>Windows Brute Force Query:</h3>

To build our query first we need to think about what exactly what we are looking for. To detect Brute Force attacks we need to be able to detect a mass number of logon attempts over a short period of time. To start lets go to "Analytics" and "Discover" in Elastic. Once there enter in the query "*4625* and *User*". This will bring up all logs that have "User" and "4625" as a value. We should now see logs that contain failed logon attempts from out attack. From these logs we are going to build our query.

<p align="center">
<img src="https://i.imgur.com/uC3XUtK.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/xplT8gE.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The query for our detection rule is going to be: "data_stream.dataset : "system.security" and event.code : "4625" and winlog.logon.failure.reason : "Unknown user name or bad password.""

-  data_stream.dataset : "system.security" looks for logs that have the dataset "system.security"
-  event.code : "4625" looks for logs that contains the Windows Event Log 4625
-  winlog.logon.failure.reason :  "Unknown user name or bad password." looks for logs that contain this failure reason.

<p align="center">
<img src="https://i.imgur.com/b2TqeQw.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Windows Brute Force Detection Rule:</h3>

<b>Define Rule:</b>

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Threshold" option is selected then scroll down and paste our query. Under the "Group by" field enter in "host.name" and set the "Threshold" field to >= 30. Afterwards under the "Count" field enter in "@timestamp" and set the "Unique Values" field as >= 30. This will set the rule so that if there are 30 or more failed logon attempts in a short amount of time it will trigger the alert. Finally, scroll down to the "Suppress alerts by" option. Then select "Per time period" and select 5 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://i.imgur.com/54uIsGW.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/fRq8NSb.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "Windows Brute Force Attempt!" and enter in a description for the rule. Set the "Default severity" to "Medium" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Credential Access" for the technique and then add a subtechnique and set it to "Brute Force". Finally add another subtechnique and set it to "Password Guessing".

<p align="center">
<img src="https://i.imgur.com/EhVM8fK.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/pucpGuI.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then run the script again and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://i.imgur.com/N2Jhlmu.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h2>Linux SSH Brute Force Attack</h2>

<h3>Attack Setup:</h3>

The first thing we need to do to set this attack up is to configure our virtual network adapter and set it as a "Bridged Adapter. To do open up Oracle Virtualbox and right click on the Windows 11 VM and select "Settings". Afterwards select the "Network" option and make sure that "Adapter 1" is highlighted. In the "Attached to" drop down menu select "Bridged Adapter". Finally click on the "Advanced" option and set the "Promiscuous Mode" option to "Allow All". This will put our Windows 11 VM on our home network so our host machine can now talk to our Windows VM. To test this simply lookup the new ip address of our Windows VM by using the "ipconfig" command and then try to ping the ip address from your host to your Windows VM.

<p align="center">
<img src="https://i.imgur.com/pDWRiDw.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/Lwq1GoA.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The next thing to do is to install the "System Integration" tool in our Elastic environment. This will allow us to ingest the SSH logs from our Ubuntu VM. To do this head into your Elastic environment and on the top of the page there should be a search box. Search for "System" and select the System Integration tool. Afterwards, click on the blue "Add System" button located on the top right of the page.

<p align="center">
<img src="https://i.imgur.com/9zlGwnw.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

After you click that button it should take you to the configuration page of the "System Integration" tool. Scroll down to find "Collect events from the Windows event log" and disable this option. Leave everything else as default and scroll down to "Where to add this integration?". Highlight "Existing Host" and select the agent that you installed on your Ubuntu VM.

<p align="center">
<img src="https://i.imgur.com/UyCoEII.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next we are going to install OpenSSH on our Ubuntu VM. To do this open up a terminal on your Ubuntu VM then enter in the command:

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

The next thing we are going to do is SSH into our Ubuntu VM using the Ubuntu WSL. To do this first install Ubuntu WSL by going into the "Microsoft Store" and searching "Ubuntu WSL". Click the install button, open up the program, and finish up the setup. Once you have the Linux WSL terminal up SSH into your Ubuntu VM by using this command: 

```Bash
ssh yourusername@youripaddress

ssh zeek@192.168.1.66

```

***Note: You may need to user the command "sudo apt update && sudo apt upgrade" if you cannot use the ssh command or install any additional packages***

<p align="center">
<img src="https://i.imgur.com/zgB42Pi.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/RafpxK4.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterwards we need to install some additional packages in order to execute the script properly. In the Ubuntu WSL terminal enter in these commands:


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

Finally navigate to the directory of the script in the Ubuntu WSL terminal (if you do not know how to do this simply enter in the command "cd/mnt/c/YOURPATHHERE") and then run the command:


```Bash
sudo dos2unix SSH\ Mimic\ Brute\Force.sh

```

<p align="center">
<img src="https://i.imgur.com/HHOiwaS.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We are now ready to execute the script and launch the attack.

</br>

<h3>Attack Execution:</h3>

To execute the attack first you must modify the bash script so that the variable "USER" is set to the username of your Ubuntu VM and that the variable "IP" is set to the IP address of your Ubuntu VM. Once that modification is done simply navigate to the folder containing the script in the Ubuntu WSL terminal and enter in this command:

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

To build our query first we need to think about what exactly what we are looking for. To detect Brute Force attacks we need to be able to detect a mass number of logon attempts over a short period of time. To start lets go to "Analytics" and "Discover" in Elastic. Once there enter in the query "*ssh*". This will bring up all logs that have "ssh" as a value. We should now see logs that contain failed logon attempts from out attack. From these logs we are going to build our query.

<p align="center">
<img src="https://i.imgur.com/EUVYW2L.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The query for our detection rule is going to be: "data_stream.dataset : "system.auth" and event.action : "ssh_login" and event.outcome : "failure""

-  data_steam.dataset : "system.auth" looks for logs that have the system.auth dataset
-  event.action : "ssh_login" looks for logs that have ssh login attempts
-  event.outcome : "failure" looks for logs that have ssh login failures

<p align="center">
<img src="https://i.imgur.com/7vI8kn5.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Linux SSH Brute Force Detection Rule:</h3>

<b>Define Rule:</b>

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Threshold" option is selected then scroll down and paste our query. Under the "Group by" field enter in "source.ip", "event.action", and "event.outcome. Set the "Threshold" field to >= 30. Afterwards under the "Count" field enter in "@timestamp" and set the "Unique Values" field as >= 30. This will set the rule so that if there are 30 or more failed logon attempts in a short amount of time it will trigger the alert. Finally, scroll down to the "Suppress alerts by" option. Then select "Per time period" and select 5 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://i.imgur.com/itpQ7DL.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/8BkJoSD.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "SSH Brute Force Detected!" and enter in a description for the rule. Set the "Default severity" to "Medium" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Credential Access" for the technique and then add a subtechnique and set it to "Brute Force". Finally add another subtechnique and set it to "Password Guessing".

<p align="center">
<img src="https://i.imgur.com/TorDK7A.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/pucpGuI.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then run the script again and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://i.imgur.com/0OUqNvU.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Windows & Linux Brute Force Attack & Detection Complete!</h3>

