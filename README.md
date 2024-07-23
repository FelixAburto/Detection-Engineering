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
<img src="https://i.imgur.com/m6fgdrM.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/JF3k5ks.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterwards we need to enable "Remote Desktop" on our Windows VM. To do this open up the Windows settings and scroll down until you see the option for "Remote Desktop". Select that option and you should now see a switch to enable "Remote Desktop" on this Windows VM. Enable it and verify that you can remote into the VM by using "Remote Desktop Connection" from your host machine. Enter in the IP address of your Windows VM in Remote Desktop Connection and then enter in the Username and Password of your Windows 11 VM user account. 

<p align="center">
<img src="https://i.imgur.com/SO2DL8S.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/AWSkWeV.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally we need to disable the Windows Account Lockout Policy. To do this enter in "gpedit.msc" in the Windows searchbox. Next under "Windows Configuration" look for "Windows Settings" and expand it. Under "Windows Settings" look for "Security Settings" and expand it then under "Security Settings" click on "Account Lockout Policy". You should be able to see the option "Account Lockout Threshold". Double click on that option and a window should pop up allowing you to set the account lockout threshold. Set it to zero and click "Apply" then "OK" to save the setting. 

<p align="center">
<img src="https://i.imgur.com/8rk687z.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


We are now ready to execute the brute force attack on out Windows 11 VM.

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

