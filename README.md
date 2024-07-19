<h1>Parrot OS VM Setup</h1>
</br>
<p align="center">
<img src="https://gdm-catalog-fmapi-prod.imgix.net/ProductLogo/b91dba39-aef6-4808-be11-8eda81f81f56.png" height="25%" width="25%" alt="Win 11 Hardware"/>
</p>

<h3>Parrot OS Download</h3>

To download Parrot OS vist https://parrotsec.org/ and click on the blue download button. In the next page click on the "Virtual" option and after that click the "Security" Option. Afterwards select the "AMD64" option and it will take you to the download page. Finally click on "download" and "Virtualbox" to start the download.

<p align="center">
<img src="https://i.imgur.com/tlsSRCo.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>


<h3>Parrot OS Installation</h3>

To install Parrot OS simply double click on the .OVA file that was download and it will bring up Virtualbox with all the settings already populated. Leave everything as default and click "finish" then wait for the VM to be imported and your done!

<p align="center">
<img src="https://i.imgur.com/mrevUmM.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<h3>Parrot OS Configuration</h3>

To configure Parrot OS for this project right click on your virtual machine and select "Settings" then click on the "Network" option. Afterwards click on  the "Adapter 2" option and check the "Enable Network Adapter". In the "Attached to" drop down menu select "Internal Network" and select the name of your internal network. Under "Advance settings" go to the "Promiscuous Mode" option and select "Allow All".

<p align="center">
<img src="https://i.imgur.com/HyvAcBm.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

Next start up the Parrot OS VM and click on the "menu" option on the bottom left then search for "Advance Network Configuration". Afterwards select "Wired Connection 2" and go to the "IPv4 Settings" section. There add the ip address 10.0.0.5 and set the subnet mask as "24".

***Note: for the 192.168.1.0 environment simply replace 10.0.0.5 with 192.168.1.5***

<p align="center">
<img src="https://i.imgur.com/39il7wl.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>


</br>
</br>

<b>Parrot OS Setup Complete!</b>
