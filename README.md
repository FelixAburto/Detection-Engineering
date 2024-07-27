# SQL Injection

<br />

<p align="center">
<img src="https://i.imgur.com/fwcBcXu.png" height="15%" width="15%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In the section of the project we are going to utilize the "Damn Vulnerable Web Application" or DVWA to execute and detect a SQL Injection. A SQL injection is a web security vulnerability that allows an attacker to interfere with the queries that an application makes to its database. By injecting malicious SQL code into input fields, attackers can manipulate database operations, potentially accessing, modifying, or deleting data without proper authorization. This can lead to data breaches, loss of data integrity, and unauthorized administrative access.

<br />

<h2>Damn Vulnerable Web Application</h2>

<h3>Microsoft Azure Ubuntu VM:</h3>

The first thing we need to do is create an Ubuntu Server VM in Azure. To do this log into your Azure tenant and search for the option "Virtual Machines" then click on that option. Afterwards click on the option the blue "Create" button then select "Azure Virtual Machine". You should now be on the configuration page for creating the VM.

<p align="center">
<img src="https://i.imgur.com/RqfxADm.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The next thing do is to fill out the necessary information to create the VM. First create a new resource group by clicking "Creat New" in the "Resource Group" section then enter in a name for your RG. Next enter in a name for the virtual machine and scroll down to make sure the "Image" is set to "Ubuntu Server 20.04 LTS -x64 Gen2". Afterwards set the "Size" to "Standard_D2s_v3 - 2 vcpus, 8 GiB memory" then scroll down to "Adminstrator Account" and switch the "Authentication type" to "Password". Once that is done enter in a Username and Password for this VM and make sure that the "Allow Selected Ports" option selected and set "Select Inbound Ports" to port 22. Finally click on "Review + Create" then once validation is finished select "create". The Ubuntu Server VM should be deployed in your tenant in a few minutes.

<p align="center">
<img src="https://imgur.com/DH8KSOa.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have our Ubuntu VM deployed in our Azure tenant the next thing to do is to connect to this VM using SSH. There are 2 methods we can use to achieve this.

<b>Ubuntu WSL Method:</b> We can use the Ubuntu WSL that we installed on our Windows host machine to connect to the VM. To do this you will use the username, password, and public IP address set for your Ubuntu VM. Enter in this command:

```bash
ssh Username@yourAzureVMpublicip
```
<p align="center">
<img src="https://imgur.com/eC6nD7T.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<b>Azure CLI Method:</b> We can use the Azure CLI to SSH into our Ubuntu VM. To do this go to your Ubuntu VM that you created by going to "Virtual Machine" in your Azure tenant and selecting your VM. Next click on the "Connect" option and select the "SSH using Azure CLI" then click on "Configure and Connect". Afterwards wait until the Azure CLI comes up in your browser and you should be connected to your VM. 

<p align="center">
<img src="https://imgur.com/ANh6p4L.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

I am personally going to use the Ubuntu WSL to setup our Damn Vulnerable Web Application.

</br>

<h3>Damn Vulnerable Web Application Setup:</h3>

Now that we our VM setup we are now going to move forward to setup and configure the DVWA. The first thing we need to do is to install all of the necessary packages. To do this enter in this command into the terminal:

```bash
sudo apt update && sudo apt install -y apache2 mariadb-server mariadb-client php php-mysqli php-gd libapache2-mod-php
```

This command updates the package list and installs Apache web server, MariaDB database server and client, PHP, and necessary PHP extensions.

<p align="center">
<img src="https://imgur.com/XF9yKHp.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next we are going to download DVMA to our Ubuntu server and move it to the html directory. To do this enter in these commands:

```bash
git clone https://github.com/digininja/DVWA.git

sudo mv DVMA/ /var/www/html/
```
<p align="center">
<img src="https://imgur.com/DR9Wdjb.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The next step is to copy the config file into the DVWA config directory. To do this navigate to your DVWA directory and execute this command

```bash

cp config/config.inc.php.dist config/config.inc.php

```

Now we need to configure our Ubuntu Azure VM to accept all inbound traffic from port 80. To do this go to your Ubuntu Azure VM and select the "Networking" option. Afterwards click on "Network Settings" and select the blue "Create port rule" button. Next in the new "Add inbound security rule" settings windows looks for the "Service" field and set it to "HTTP" then  set the "Priority" field to "200". Finally click the blue "Add" button to add the port rule.


<p align="center">
<img src="https://imgur.com/ZzrVWmy.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, we need to start up the web application. To do this enter in this command :

```bash
sudo service apache2 start
```
<p align="center">
<img src="https://imgur.com/8Jke9Ol.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, lets connect to our DVWA to verify that we can reach it. To do this open up a web browser and enter in this URL:

http://yourpublicip/DVWA/setup.php

You should be able to see the setup page for the web application

<p align="center">
<img src="https://imgur.com/HpUK38O.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>
