# Windows and Linux Brute Force Attack

<br />

<p align="center">
<img src="https://cdn-icons-png.flaticon.com/512/6689/6689968.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

For this section we will be simulating both Windows and Linux brute force attacks and creating detection rules based on these attacks.

</br>

<h2>Windows Brute Force Attack</h2>

<h3>Attack Setup</h3>

The first thing we need to do to set this attack up is to configure our virtual network adapter and set it as a "Bridged Adapter. To do open up Oracle Virtualbox and right click on the Windows 11 VM and select "Settings". Afterwards select the "Network" option and make sure that "Adapter 1" is highlighted. In the "Attached to" drop down menu select "Bridged Adapter". Finally click on the "Advanced" option and set the "Promiscuous Mode" option to "Allow All". This will put our Windows 11 VM on our home network so our host machine can now talk to our Windows VM. To test this simply lookup the new ip address of our Windows VM by using the "ipconfig" command and then try to ping the ip address from your host to your Windows VM.

<p align="center">
<img src="https://cdn-icons-png.flaticon.com/512/6689/6689968.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterwards we need to enable "Remote Desktop" on our Windows VM. To do this

