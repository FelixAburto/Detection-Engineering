<h1>Ubuntu (Zeek/Bro) VM Setup</h1>

</br>

<p align="center">
<img src="https://cdn.freebiesupply.com/logos/large/2x/ubuntu-4-logo-png-transparent.png" height="25%" width="25%" alt="Win 11 Hardware"/>
<img src="https://zeek.org/wp-content/uploads/2020/04/zeek-logo-without-text.png" height="25%" width="25%" alt="Win 11 Hardware"/>
</p>

</br>

<h3>Ubuntu Linux ISO Download</h3>

</br>

To download the Ubuntu Linux ISO go to https://ubuntu.com/download/desktop and click "Download 24.04 LTS"

<p align="center">
<img src="https://i.imgur.com/f07Ap9i.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<h3>Ubuntu Linux Installation</h3>

</br>

<b>Virtual Machine Name and Operating System:</b>

After downloading the ISO open up Oracle Virtualbox and create a new VM. Select the Ubuntu Linux iso in the "ISO Image" dropdown menu and select where to install this VM. Finally input the name of this VM.

<p align="center">
<img src="https://i.imgur.com/bHLxYmh.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Unattended Guest OS Install Setup:</b>

Set the username and password for this VM and input the hostname of your choosing. Check the "Guest Additions" box and verify that you have green checkmarks.

<p align="center">
<img src="https://i.imgur.com/DJfPV2h.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Hardware:</b>

I recommend setting 8GB of RAM and 4 CPU processors for this VM. At minimum you should have 4 GB of RAM and 2 CPU processors.

<p align="center">
<img src="https://i.imgur.com/tHTr6fE.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Virtual Hard Disk:</b>

Verify that the virtual hard disk is set to 25GB of storage.

<p align="center">
<img src="https://i.imgur.com/rs9FuFT.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Summary:</b>

Verify that all of your configuration settings are correct and click finish

<p align="center">
<img src="https://i.imgur.com/aeryYow.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Ubuntu Installation Wizard:</b>

After you click finish the VM should start up and once finished the Ubuntu installation wizard will guide you on how to complete the installation. After the installation is complete the Ubuntu Desktop should appear and you'll be ready to use this VM.

<p align="center">
<img src="https://i.imgur.com/XqORL4K.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>
</br>

<h3>Ubuntu Linux Configuration</h3>

</br>

<b>Configuring Static IP Address:</b>

To configure the static ip address that we'll be using click on the network icon on the top right corner. A popup should appear with the option "Wired". Click on the arrow to open up another popup then click on "Wired Settings". This will open up the network settings for the VM. Afterwards click the gear icon for the "enp0s8" interface. Finally set the IP address to 10.0.0.3 and the subnet mask to 255.255.255.0

***Note: To configure the IP address for the 192.168.1.0/24 environment simply replace 10.0.0.3 to 192.168.1.3***

<p align="center">
<img src="https://i.imgur.com/G7RBUZm.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

<b>Configuring Static IP Address - Alternate Method:</b>

An alternate method to configure a netconfig.yaml file with the static ip address that we want. To do this open up a terminal and navigate to the "netplan folder" by inputing "cd /etc/netplan". Then create a netcfg yaml file by inputing "sudo nano 01-netcfg.yaml".

<p align="center">
<img src="https://i.imgur.com/apuU9pO.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Afterwards copy the following configuration into Nano:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s8:
      dhcp4: no
      addresses: [10.0.0.3/24]
```

<p align="center">
<img src="https://i.imgur.com/BSSUzBX.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Finally apply the configuration by inputing "sudo netplan apply". Verify that the configuration was successful by entering the command "ip addr" and checking to see if 10.0.0.3 is under the enp0s8 interface.

***Note: To configure the static IP address for the 192.168.0/24 environment simply follow these steps and replace 10.0.0.3/24 with 192.168.1.3/24 in the yaml file***

<p align="center">
<img src="https://i.imgur.com/QED3gnE.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<h3>Installing and Configuring Zeek</h3>

</br>

<b>Zeek Installation:</b>

To install Zeek first visit https://docs.zeek.org/en/master/install.html and copy this command:

```bash
echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
sudo apt update
sudo apt install zeek-6.0
```

Open up a terminal in your Ubuntu VM and switch to root using "sudo -i". Paste this command to install zeek on your machine.

***Note: you have to have curl installed in order to install zeek. If you do not have curl install you can install it by entering "sudo apt install curl" into the Linux terminal.***

<p align="center">
<img src="https://i.imgur.com/SEBbQ0U.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Zeek Configuration:</b>

To configure Zeek for this project first navigate to /opt/zeek/etc and go into the network configuration by entering "sudo nano networks.cfg"

<p align="center">
<img src="https://i.imgur.com/xC5pUPS.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Then add "10.0.0.0/24 Internal Network" to the configuration page and save it.

***Note: if you are configuring the 192.168.1.0/24 environment simply replace 10.0.0.0/24 with 192.168.1.0/24***

<p align="center">
<img src="https://i.imgur.com/ba5RX5e.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Afterwards go into node.cfg by entering the command "sudo nano node.cfg". Where it says "interface=" enter in the interface of the interntal network adapter that we setup which should be "interface=enp0s8"

***Note: if your network adapter is named differently simply enter the "ip addr" command to see what is the name of the interface of our internal network adapter***

<p align="center">
<img src="https://i.imgur.com/Hsbh8tn.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Next we need to navigate to the __load__.zeek file. To do this enter in the command "cd /opt/zeek/share/policy/tuning/defaults/". Then enter into the configuration file by entering " sudo nano __load__.zeek"

<p align="center">
<img src="https://i.imgur.com/eeR00h7.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

In the next empty line add the following to the file "@load ../json-logs.zeek". This will convert the zeek logs into JSON format so that it can later be ingested into Elastic.

<p align="center">
<img src="https://i.imgur.com/DkvQfxo.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Starting Zeek</b>

To start Zeek navigate to the "zeekctl" file by entering "cd /opt/zeek/bin". The execute the file by entering "sudo ./zeekctl". After the file has been execute enter in "deploy" to kickoff the configurations and start Zeek. The next time you need to start zeek simply execute the "zeekctl" command and enter in "start". This will start the program without needing to redeploy 

<p align="center">
<img src="https://i.imgur.com/v9nZFCb.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<b>Verifying Zeek JSON logs</b>

To verify that the zeek logs are in JSON format navigate to the logs folder by entering "cd /opt/zeek/logs/current" then enter in the command "cat conn.log". The logs that are printed to the terminal should be in JSON format.

<p align="center">
<img src="https://i.imgur.com/wBKJNyP.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<h3>Installing Elastic Zeek Integration</h3>

Go into your Elastic environment and in the search box at the top of the page search for "Zeek" and click the option for the Zeek integration tool. Then click on the "Add Zeek" button.

<p align="center">
<img src="https://i.imgur.com/iBYrvaW.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Next leave everything as default and scroll down to the bottom of the page. Make sure "New Host" is highlighted and add a name for this agent policy (I entered the name "Ubuntu Agent"). Afterwards a popup should appear asking you to add the elastic agent to the host. Click on the "Add Elastic Agent to your hosts" button. Finally, it another popup will appear with instruction on how to install the elastic agent. Make sure that the "Linux Tar" option is highlighted and copy the command then paste it into the Ubuntu VM terminal. The Elastic agent along with the Zeek Integration should be installed.

<p align="center">
<img src="https://i.imgur.com/G74juTI.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

<p align="center">
<img src="https://i.imgur.com/YMqsEty.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>
</br>

<b>Ubuntu Linux with Zeek Setup Complete!</b>
