# Setting Up Elastic Security SIEM 

<p align="center">
<img src="https://i.imgur.com/pqCZFrQ.png" height="65%" width="65%" alt="Detection Engineering Diagram"/>
</p>

<h2>What is Elastic Security SIEM</h2>

Elastic Security SIEM (Security Information and Event Management) is a powerful solution within the Elastic Stack designed to help organizations detect, investigate, and respond to security threats in real time. This is the SIEM that we will be using to ingest data, develop alerts, and detect threats.

<br />

<h2>Create A Free Trail Elastic Cloud Account</h2>

To get started, visit Elastic.co and sign up for a free 14-day trial of Elastic. This will set up a cloud deployment of the Elastic environment, which we will use to ingest data from our various environments.

<p align="center">
<img src="https://i.imgur.com/2WVSmM7.png" height="100%" width="100%" alt="Sign of for Elastic"/>
</p>

<br />

Create your first deployment

<p align="center">
<img src="https://i.imgur.com/AiCZZ5H.png" height="100%" width="100%" alt="Sign of for Elastic"/>
</p>

<br />

Confirm your environment is created

<p align="center">
<img src="https://i.imgur.com/HBjVOs0.png" height="100%" width="100%" alt="Sign of for Elastic"/>
</p>

<br />

Now that we have created our Elastic deployment we will move on to setting up our environments.


# Evironment Setup

<p align="center">
<img src="https://cdn.freebiesupply.com/logos/thumbs/2x/virtualbox-logo.png" height="35%" width="35%" alt="Oracle Virtual Box"/>
</p>

<h2>Oracle VirtualBox</h2>

The first step to setting up our environment is to install Oracle VirtualBox, the hypervisor we will use to create our virtual machines. To install VirtualBox, visit https://www.virtualbox.org/wiki/Downloads and download the installer specific to your operating system. After the download is complete, run the installer and follow the on-screen instructions. Once the installation is finished, launch the VirtualBox application

<h2>Windows 11 VM Setup</h2>

</br>

<h3>Windows 11 ISO Download:</h3> 

To download the ISO for the Windows 11 Virtual Machine visit https://www.microsoft.com/en-us/evalcenter/evaluate-windows-11-enterprise. Click on "Download the ISO - Windows 11 Enterprise" and fill out the informationt to download the ISO.

***Note: You do not need to fill out the form with actual information if you do not want to***

<p align="center">
<img src="https://i.imgur.com/ikN4UTR.png" height="100%" width="100%" alt="Oracle Virtual Box"/>
</p>

</br>
</br>

<h3>Windows 11 VM Installation:</h3>

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

<h3>Windows 11 VM Configuration:</h3>

</br>

<b>Internal IP Configuration:</b>

To configure the VM for the internal network we need to open up the "Control Panel" and click on "Network and Sharing Center". Afterwards click the option "Change Adapter Settings". In the next window right click on "Ethernet 2" and select "properties". Click on "Internet Protocl Version 4". 

<p align="center">
<img src="https://i.imgur.com/RxDHkoO.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Finally set the IP address to 10.0.0.4 and the Subnet Mask to 255.255.255.0  Once you are finished click "ok" and then "Apply". 


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



<h2>Ubuntu (Zeek/Bro) VM Setup</h2>

<h2>Parrot OS VM Setup</h2>

<h2>Kali Linux VM Setup</h2>

<h2>Microsoft Azure Setup</h2>

<h2>Damn Vulnerable Web Application Setup</h2>


