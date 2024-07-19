<h1>Windows 11 VM Setup</h1>

</br>

<p align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/e/e6/Windows_11_logo.svg" height="50%" width="50%" alt="Win 11 Hardware"/>
</p>


</br>

<h3>Windows 11 ISO Download</h3> 

</br>

To download the ISO for the Windows 11 Virtual Machine visit https://www.microsoft.com/en-us/evalcenter/evaluate-windows-11-enterprise. Click on "Download the ISO - Windows 11 Enterprise" and fill out the informationt to download the ISO.

***Note: You do not need to fill out the form with actual information if you do not want to***

<p align="center">
<img src="https://i.imgur.com/ikN4UTR.png" height="100%" width="100%" alt="Oracle Virtual Box"/>
</p>

</br>
</br>

<h3>Windows 11 VM Installation</h3>

</br>

Now that we have the ISO downloaded lauch Oracle VirtualBox and hover over to the "machine" option located on the top of the application. Go down to the "New" option and this will launch the wizard to create a new Virtual Machine.

<p align="center">
<img src="https://i.imgur.com/hLWeVbq.png" height="100%" width="100%" alt="Windows 11 Start"/>
</p>

</br>

<b>Virtual Machine Name and Operating System:</b>

Select the Windows 11 ISO from the "ISO Image" dropdown menu. Virtual Box should automatically detect that it is a Windows 11 ISO and populate some of the fields. Select where you want to store your virtual machine with the "Folder" dropdown menu. Lastly Name your Windows VM however you'd like.

<p align="center">
<img src="https://i.imgur.com/vAW58sE.png" height="100%" width="100%" alt="Win 11 New VM"/>
</p>

</br>

<b>Unattended Guest OS Install:</b> 

Set a Username and Password that you would your VM to have. Make sure that the "Hostname" has a green checkmark by inputing valid characters. Finally make sure the "Guest Additions" checkbox is marked. This will install the VM with additional funcationalities. 

<p align="center">
<img src="https://i.imgur.com/kHDe2f8.png" height="100%" width="100%" alt="Win 11 UGOI"/>
</p>

</br>

<b>Hardware:</b> 

I would recommend setting 8GB of RAM and 4 CPU processors for this VM. At the very minimum it should be 4GB and 2 CPU cores.

<p align="center">
<img src="https://i.imgur.com/dfJUsVo.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Virtual Hard disk:</b> 

I would recommend setting at least 75GB of storage space for this VM.

<p align="center">
<img src="https://i.imgur.com/A0bGOfp.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Summary:</b> 

Finally verify that all of your settings are correct and click "finish" to create your virtual machine

<p align="center">
<img src="https://i.imgur.com/uLaV1oC.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Internal Network Adapter:</b>

Once your virtual machine is finished right click on the virtual machine and select "Settings". In the settings menu click on the "Network" section and click on "Adapter 2". Checkmark the "Enable Network Adapter" box and set the "Attached to" option to "Internal Network". Name the Internal Network however you'd like. Set the "Promiscious Mode" Option to "Allow all" and click "ok" to save the configuration.

<p align="center">
<img src="https://i.imgur.com/1KAsLdj.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>
</br>

<h3>Windows 11 VM Configuration</h3>

</br>

<b>Internal IP Configuration:</b>

To configure the VM for the internal network we need to open up the "Control Panel" and click on "Network and Sharing Center". Afterwards click the option "Change Adapter Settings". In the next window right click on "Ethernet 2" and select "properties". Click on "Internet Protocl Version 4". 

<p align="center">
<img src="https://i.imgur.com/RxDHkoO.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Finally set the IP address to 10.0.0.4 and the Subnet Mask to 255.255.255.0  Once you are finished click "ok" and then "Apply". 

***Note: for the 192.168.1.0/24 environment simply follow these same steps but change 10.0.0.4 to 192.168.1.4***


<p align="center">
<img src="https://i.imgur.com/y1goD77.png" height="50%" width="50%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Turning Off Windows Defender:</b>

To turn off Windows Defender go to your windows settings and click on "Privacy and Securtiy". Then click on "Windows Security" and "Open Windows Security". Next click on the "Virus and Threat Protection" option and scroll to teh "Virus and Threat Protection Settings". Click on "Manage Settings".

<p align="center">
<img src="https://i.imgur.com/v2d69C7.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Turn off "Real-Time Protection", "Dev Drive Protection", and "Tamper Protection".

<p align="center">
<img src="https://i.imgur.com/FAz5Adg.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Turning Off Windows Defender Firewall:</b>

In the Windows search box input "wf.msc" to open up the Windows Defender Firewall Settings. Click on "Windows Defender Firewall Properties".

<p align="center">
<img src="https://i.imgur.com/7NpUPIC.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Next set the "Firewall State" to off for "Domain Profile", "Private Profile', and "Public Profile"

<p align="center">
<img src="https://i.imgur.com/hE0oKSz.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Turning off real-time protection and enabling behavior monitoring through Local Group Policy Editor:</b>

In the Windows search box search for "gpedit.msc". Under "Computer Configuration expand "Administrative Templates" then expand "Windows Components". Scroll down to find "Microsoft Defender Antivirus" and expand it then click on "Real-Time Protection". Finally, double click on "Turn off real-time protection" set it to enable then do the same for the "Turn on behavior monitoring" option

<p align="center">
<img src="https://i.imgur.com/ycoiQJC.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Installing and Configuring Sysmon:</b>

To install Sysmon go to https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon and download the Sysmon zip file and extract it. 

<p align="center">
<img src="https://i.imgur.com/sJgifua.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Next go to https://github.com/SwiftOnSecurity/sysmon-config and download sysmonconfig-export.xml. After downloading the xml file place it inside the directory of the extracted Sysmon file.  

<p align="center">
<img src="https://i.imgur.com/58lidgC.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Finally open Command Prompt in Administrator Mode and navigate to the Sysmon Directory. Input the command : sysmon.exe -accepteula -i sysmonconfig-export.xml 
This will install and configure sysmon on the Windows 11 VM. 

<p align="center">
<img src="https://i.imgur.com/EwQSmbg.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Enable Powershell Logging:</b>

In the Windows search box search for "gpedit.msc". Under "Computer Configuration expand "Administrative Templates" then expand "Windows Components". Scroll down to find "Windows Powershell". Double click on "Turn on Module Logging" set it to enable then do the same for the "Turn on PowerShell Script Block Logging", "Turn on Script Execution", and "Turn on Powershell Transcription" 

<p align="center">
<img src="https://i.imgur.com/7FTPyiT.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<h3>Installing Elastic Windows Integration</h3>

</br>

<b>Adding Windows Integration in Elastic:</b>

Log into your Elastic Environment and access your Elastic deployment. Once there at the top of the webpage there is a searchbox. Search for "Windows" and the Windows Integration tool for Elastic should pop up. Click on the option and then click on the "Add Windows" button.

<p align="center">
<img src="https://i.imgur.com/UnnKSK4.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Afterwards it will take your the windows integration configurations page. Make sure that these options are enabled:

- Collect events from the following Windows Event Log channels
- Forwarded
- Powershell
- Powershell Operational
- Sysmon Operational
- Collect windows perfmon and service metrics
- Windows service metrics

Scroll down to "Where to add this integration?" and make sure the "New Hosts" section is highlighted. Under "New agent policy name" input a name for your windows elastic agent. Finally add the agent.

<p align="center">
<img src="https://i.imgur.com/a1iZanX.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

After the Windows Integration is added a popup should appear asking you to add the elastic agent to the host. Click on the "Add Elastic Agent to your hosts" button.

<p align="center">
<img src="https://i.imgur.com/zz3vIyA.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Then another popup will appear with intstruction on how to install the agent. Under "Install Elastic Agent on your hosts" click on the windows section and copy the command below.

<p align="center">
<img src="https://i.imgur.com/PgZQEim.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Finally go to your Windows VM and open up powershell in Administrator mode. Simply paste the command into the terminal and the agent will install.

***Note: Shared clipboard must be enabled on your VM in order to paste from your host to your VM***

<p align="center">
<img src="https://i.imgur.com/dJDeKpm.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Windows 11 VM Setup is Complete!</b>
