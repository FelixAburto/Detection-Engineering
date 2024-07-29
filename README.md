<h1>Parrot OS VM Setup</h1>
</br>
<p align="center">
<img src="https://gdm-catalog-fmapi-prod.imgix.net/ProductLogo/b91dba39-aef6-4808-be11-8eda81f81f56.png" height="25%" width="25%" alt="Win 11 Hardware"/>
</p>

<h3>Parrot OS Download</h3>

To download Parrot OS, visit https://parrotsec.org/ and click on the blue "Download" button. On the next page, click on the "Virtual" option, then select the "Security" option. After that, choose the "AMD64" option to go to the download page. Finally, click on "Download" and select "VirtualBox" to start the download.

<p align="center">
<img src="https://i.imgur.com/tlsSRCo.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>


<h3>Parrot OS Installation</h3>

To install Parrot OS, simply double-click on the .OVA file that was downloaded. This will open VirtualBox with all the settings already populated. Leave everything at its default settings and click "Finish." Wait for the VM to be imported, and you're done!

<p align="center">
<img src="https://i.imgur.com/mrevUmM.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<h3>Parrot OS Configuration</h3>

To configure Parrot OS for this project, right-click on your virtual machine and select "Settings." Then, click on the "Network" option. Next, click on "Adapter 2" and check the "Enable Network Adapter" box. In the "Attached to" drop-down menu, select "Internal Network" and choose the name of your internal network. Under "Advanced" settings, go to the "Promiscuous Mode" option and select "Allow All."

<p align="center">
<img src="https://i.imgur.com/HyvAcBm.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

Next, start up the Parrot OS VM and click on the "Menu" option in the bottom-left corner. Search for "Advanced Network Configuration," then select "Wired Connection 2" and go to the "IPv4 Settings" section. Add the IP address `10.0.0.5` and set the subnet mask to `24`

***Note: for the 192.168.1.0 environment simply replace 10.0.0.5 with 192.168.1.5***

<p align="center">
<img src="https://i.imgur.com/39il7wl.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>


</br>
</br>

<b>Parrot OS Setup Complete!</b>
