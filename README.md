<h1>Windows 11 VM Setup</h1>

</br>

<p align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/e/e6/Windows_11_logo.svg" height="50%" width="50%" alt="Win 11 Hardware"/>
</p>


</br>

<h2>Windows 11 ISO Download</h2> 

</br>

To download the ISO for the Windows 11 Virtual Machine:

1. Visit the [Microsoft Evaluation Center for Windows 11](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-11-enterprise).
2. Click on "Download the ISO - Windows 11 Enterprise."
3. Fill out the required information to start the download.

***Note: You do not need to provide actual information if you do not want to.***


<p align="center">
<img src="https://i.imgur.com/ikN4UTR.png" height="100%" width="100%" alt="Oracle Virtual Box"/>
</p>

</br>
</br>

<h2>Windows 11 VM Installation</h2>

</br>

Now that we have downloaded the ISO, launch Oracle VirtualBox and hover over the 'Machine' option located at the top of the application. Select the 'New' option to launch the wizard for creating a new virtual machine.

<p align="center">
<img src="https://i.imgur.com/hLWeVbq.png" height="100%" width="100%" alt="Windows 11 Start"/>
</p>

</br>

<b>Virtual Machine Name and Operating System:</b>

Select the Windows 11 ISO from the 'ISO Image' dropdown menu. VirtualBox should automatically detect that it is a Windows 11 ISO and populate some of the fields. Choose where you want to store your virtual machine using the 'Folder' dropdown menu. Finally, name your Windows VM as you prefer.

<p align="center">
<img src="https://i.imgur.com/vAW58sE.png" height="100%" width="100%" alt="Win 11 New VM"/>
</p>

</br>

<b>Unattended Guest OS Install:</b> 

Set a username and password for your VM. Make sure that the 'Hostname' has a green checkmark by inputting valid characters. Finally, ensure the 'Guest Additions' checkbox is marked. This will install the VM with additional functionalities.

<p align="center">
<img src="https://i.imgur.com/kHDe2f8.png" height="100%" width="100%" alt="Win 11 UGOI"/>
</p>

</br>

<b>Hardware:</b> 

I recommend setting 8GB of RAM and 4 CPU processors for this VM. At the very minimum, it should be 4GB of RAM and 2 CPU cores.

<p align="center">
<img src="https://i.imgur.com/dfJUsVo.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Virtual Hard disk:</b> 

I recommend setting at least 75GB of storage space for this VM.

<p align="center">
<img src="https://i.imgur.com/A0bGOfp.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Summary:</b> 

Finally, verify that all of your settings are correct and click 'Finish' to create your virtual machine.

<p align="center">
<img src="https://i.imgur.com/uLaV1oC.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Internal Network Adapter:</b>

Once your virtual machine is finished, right-click on the virtual machine and select 'Settings.' In the settings menu, click on the 'Network' section and then on 'Adapter 2.' Check the 'Enable Network Adapter' box and set the 'Attached to' option to 'Internal Network.' Name the internal network as you prefer. Set the 'Promiscuous Mode' option to 'Allow All' and click 'OK' to save the configuration.

<p align="center">
<img src="https://i.imgur.com/1KAsLdj.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>
</br>

<h2>Windows 11 VM Configuration</h2>

</br>

<b>Internal IP Configuration:</b>

To configure the VM for the internal network, open the 'Control Panel' and click on 'Network and Sharing Center.' Then click the option 'Change Adapter Settings.' In the next window, right-click on 'Ethernet 2' and select 'Properties.' Click on 'Internet Protocol Version 4.'

<p align="center">
<img src="https://i.imgur.com/RxDHkoO.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Finally, set the IP address to 10.0.0.4 and the subnet mask to 255.255.255.0. Once you are finished, click 'OK' and then 'Apply.'

***Note: for the 192.168.1.0/24 environment, simply follow these same steps but change 10.0.0.4 to 192.168.1.4***

<p align="center">
<img src="https://i.imgur.com/y1goD77.png" height="50%" width="50%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Turning Off Windows Defender:</b>

To turn off Windows Defender, go to your Windows settings and click on 'Privacy and Security.' Then click on 'Windows Security' and 'Open Windows Security.' Next, click on the 'Virus and Threat Protection' option and scroll to the 'Virus and Threat Protection Settings.' Click on 'Manage Settings.'

<p align="center">
<img src="https://i.imgur.com/v2d69C7.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Turn off "Real-Time Protection", "Dev Drive Protection", and "Tamper Protection".

<p align="center">
<img src="https://i.imgur.com/FAz5Adg.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Turning Off Windows Defender Firewall:</b>

In the Windows search box, input "wf.msc" to open up the Windows Defender Firewall settings. Click on "Windows Defender Firewall Properties".

<p align="center">
<img src="https://i.imgur.com/7NpUPIC.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Next, set the "Firewall State" to "Off" for "Domain Profile," "Private Profile," and "Public Profile."


<p align="center">
<img src="https://i.imgur.com/hE0oKSz.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Turning off real-time protection and enabling behavior monitoring through Local Group Policy Editor:</b>

In the Windows search box, search for "gpedit.msc." Under "Computer Configuration," expand "Administrative Templates," then expand "Windows Components." Scroll down to find "Microsoft Defender Antivirus" and expand it, then click on "Real-Time Protection." Finally, double-click on "Turn off real-time protection," set it to "Enabled," then do the same for the "Turn on behavior monitoring" option.

<p align="center">
<img src="https://i.imgur.com/ycoiQJC.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Installing and Configuring Sysmon:</b>

To install Sysmon, go to https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon, download the Sysmon zip file, and extract it.

<p align="center">
<img src="https://i.imgur.com/sJgifua.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Next, go to https://github.com/SwiftOnSecurity/sysmon-config and download 'sysmonconfig-export.xml'. After downloading the XML file, place it inside the directory of the extracted Sysmon files.

<p align="center">
<img src="https://i.imgur.com/58lidgC.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Finally, open Command Prompt in Administrator mode and navigate to the Sysmon directory. Input the command: `sysmon.exe -accepteula -i sysmonconfig-export.xml`. This will install and configure Sysmon on the Windows 11 VM.

<p align="center">
<img src="https://i.imgur.com/EwQSmbg.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Enable Powershell Logging:</b>

In the Windows search box, search for "gpedit.msc." Under "Computer Configuration," expand "Administrative Templates," then expand "Windows Components." Scroll down to find "Windows PowerShell." Double-click on "Turn on Module Logging," set it to "Enabled," then do the same for "Turn on PowerShell Script Block Logging," "Turn on Script Execution," and "Turn on PowerShell Transcription."

<p align="center">
<img src="https://i.imgur.com/7FTPyiT.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<h2>Installing Elastic Windows Integration</h2>

</br>

<b>Adding Windows Integration in Elastic:</b>

Log into your Elastic environment and access your Elastic deployment. Once there, at the top of the webpage, there is a search box. Search for "Windows," and the Windows Integration tool for Elastic should pop up. Click on the option and then click on the "Add Windows" button.

<p align="center">
<img src="https://i.imgur.com/UnnKSK4.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Afterward, it will take you to the Windows integration configurations page. Make sure that these options are enabled:

- Collect events from the following Windows Event Log channels
- Forwarded
- PowerShell
- PowerShell Operational
- Sysmon Operational
- Collect Windows perfmon and service metrics:
- Windows service metrics

Scroll down to "Where to add this integration?" and make sure the "New Hosts" section is highlighted. Under "New agent policy name," input a name for your Windows Elastic Agent. Finally, add the agent.

<p align="center">
<img src="https://i.imgur.com/a1iZanX.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

After the Windows Integration is added, a popup should appear asking you to add the Elastic Agent to the host. Click on the "Add Elastic Agent to your hosts" button.

<p align="center">
<img src="https://i.imgur.com/zz3vIyA.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Then another popup will appear with instructions on how to install the agent. Under "Install Elastic Agent on your hosts," click on the Windows section and copy the command below.

<p align="center">
<img src="https://i.imgur.com/PgZQEim.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Finally, go to your Windows VM and open PowerShell in Administrator mode. Simply paste the command into the terminal, and the agent will install.

***Note: Shared clipboard must be enabled on your VM in order to paste from your host to your VM***

<p align="center">
<img src="https://i.imgur.com/dJDeKpm.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<h3>Windows 11 VM Setup is Complete!</h3>
