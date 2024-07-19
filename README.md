<h1>Kali Linux VM Setup</h1>

</br>

<p align="center">
<img src="https://seeklogo.com/images/K/kali-linux-logo-AED181186E-seeklogo.com.png" height="25%" width="25%" alt="Win 11 Hardware"/>
</p>


<h3>Kali Linux Download</h3>

To download Kali Linux visit https://www.kali.org/ and select "download". In the next page select the "Virtual Machines" options the select the "Virtualbox" option. The zip file containing the VM should start after click select that option.

<p align="center">
<img src="https://i.imgur.com/zi09Mz3.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>


</br>

<h3>Kali Linux Installation</h3>


To install Kali linux unzip the zip file that was download. Next head inside the kali linux folder and double click the ".vbox" file. This will automatically install and import Kali Linux into Virutalbox.

<p align="center">
<img src="https://i.imgur.com/ar1yXTP.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

</br>

<h3>Kali Linux Configuration</h3>

To configure Kali Linux for this project right click on your virtual machine and select "Settings" then click on the "Network" option. Afterwards click on  the "Adapter 2" option and check the "Enable Network Adapter". In the "Attached to" drop down menu select "Internal Network" and select the name of your internal network. Under "Advance settings" go to the "Promiscuous Mode" option and select "Allow All".

<p align="center">
<img src="https://i.imgur.com/VTE279T.png" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>

Next start up the Kali linux VM and click on the Kali icon button on the top right then search for "Advance Network Configuration". Afterwards select "Wired Connection 2" and go to the "IPv4 Settings" section. There add the ip address "192.168.1.6" and set the subnet mask as "24".

<p align="center">
<img src="https://i.imgur.com/q7OmBjJ.gif" height="100%" width="100%" alt="Win 11 Hardware"/>
</p>


</br>
</br>

<b>Kali Linux Setup Complete!</b>
