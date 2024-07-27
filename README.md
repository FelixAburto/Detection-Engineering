# SQL Injection

<br />

<p align="center">
<img src="https://i.imgur.com/fwcBcXu.png" height="15%" width="15%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In the section of the project we are going to utilize the "Damn Vulnerable Web Application" or DVWA to execute and detect a SQL Injection. A SQL injection is a web security vulnerability that allows an attacker to interfere with the queries that an application makes to its database. By injecting malicious SQL code into input fields, attackers can manipulate database operations, potentially accessing, modifying, or deleting data without proper authorization. This can lead to data breaches, loss of data integrity, and unauthorized administrative access.

<br />

<h2>Damn Vulnerable Web Application Setup</h2>

<p align="center">
<img src="https://appstore.edgenexus.io/wp-content/uploads/2018/03/dvwa-logo-500x500.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>

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

<h3>Web Application Setup:</h3>

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

sudo mv DVWA/ /var/www/html/
```
<p align="center">
<img src="https://imgur.com/DR9Wdjb.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The next step is to copy the config file into the DVWA config directory. To do this navigate to your DVWA directory and execute this command

```bash

cp config/config.inc.php.dist config/config.inc.php

```

<p align="center">
<img src="https://imgur.com/OHZtSs0.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

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
<img src="https://imgur.com/nn4gkzZ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h3>Database Setup:</h3>

The next step to setup our DVWA is to create the database for the web application. To do this first we need to start mariadb. To start mariadb enter in this command:

```bash
sudo service mariadb start
```

<p align="center">
<img src="https://imgur.com/DFWVx1d.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


Next execute this command to enter the database:

```bash
sudo mysql
```
Once you have done that enter in these series of commands to configure mariadb:

```bash
create database dvwa;

create user dvwa@localhost identified by 'password';

grant all on dvwa.* to dvwa@localhost;

flush privileges;

```
These series of SQL commands are used to set up a new database and user in MySQL or MariaDB. First, "create database dvwa;" creates a new database named dvwa. Next, "create user dvwa@localhost identified by 'password';" creates a new user named dvwa with the password password for local access. The command "grant all on dvwa.* to dvwa@localhost;" then grants all permissions on the dvwa database to this user. Finally, "flush privileges;" reloads the grant tables to ensure that the changes take effect immediately. 

<p align="center">
<img src="https://imgur.com/grOGXdj.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

After that step we must configure the Database password in the config file. To do this navigate to "config" directory inside the "DVWA" directory. Once there enter in this command:

```bash
sudo nano config.inc.php
```
Look for the field "db_password' and make sure its set to 'password'. Once that is done save the file.

<p align="center">
<img src="https://imgur.com/DQHJVsP.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Verify that you can log into the database by entering in this command:

```bash
mysql -u dvwa -ppassword

```
<p align="center">
<img src="https://imgur.com/QvALH9i.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


Once you have verified that that you can log in return to the DVWA setup page and select the "Create/Reset Database" button. After you see the message "Setup successful" click on the "login" button and this will take you to the DVWA login page.

<p align="center">
<img src="https://imgur.com/DoPLZT7.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Login to DVWA using the username "admin" and "password" as the password. We have now completed setting up the Damn Vulnerable Web Server and we are ready to setup our SQL injection attack.

<p align="center">
<img src="https://imgur.com/HeOqzze.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>SQL Injection Attack</h2>

<h3>Attack Setup:</h3>

<h3>Apache HTTP Server Integration</h3>

The first thing we need to do to setup our SQL injection attack is to install the "Appache HTTP Server" Elastic Integration. To do this go to your Elastic environment and in the search box located on the top of the page search for "Appache HTTP Server" then select the option that comes up. Now that you are in the integration page click the "Add Apache HTTP Server"

<p align="center">
<img src="https://imgur.com/RhVmLJ4.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

You should now be in the integration configuration page. Leave everything as default and scroll down to "Where to add this integration" and select "New Host" then enter in "Ubuntu Azure VM" in the "New agent policy name" field. Finally, click on the blue "Save and Continue" button and select the "Add Elastic Agent to your hosts" button.

<p align="center">
<img src="https://imgur.com/PuZwkAQ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Follow the instructions to install the Elastic agent to your Ubuntu Azure VM.

<p align="center">
<img src="https://imgur.com/PSwG9hK.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, login to the DVWA and select the option "DVWA Security" and set the security level to "Low". We are now ready to execute our SQL Injection.

<p align="center">
<img src="https://imgur.com/RP3YIFZ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Attack Execution:</h3>

To execute our SQL injection attack first go to your DVWA and select the option "SQL Injection". On the SQL injection page there is a field called "User ID". In this field when you enter in numbers 1-5 the page returns a "First name" and "Surname".

<p align="center">
<img src="https://imgur.com/rKqNMqT.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

However, this field is vulnerable to SQL injections and this will allow us to view all of the First names and Surnames. To do this simply enter in this SQL command:

```SQL

x' OR 'x'='x

```
We have successfully executed a SQL injection.

<p align="center">
<img src="https://imgur.com/FdGt1j2.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we executed our attack we are now ready to create our detection for this SQL injection.

</br>

<h2>SQL Injection Detection</h2>

<h3>SQL Injection Query:</h3>

In order to create our query for the detection rule we need to think about what exactly are we looking for. Since we used the command "x' OR 'x'='x" we need to look for logs that contain this string of characters. After researching and digging through the logs this is the query that we are going to use: 

```SQL

data_stream.dataset : "apache.access" and url.query : *OR*

```

- data_stream.dataset : "apache.access": Filters the logs to include only those from the apache.access dataset, which contains access logs from an Apache web server
- url.query : OR: Looks for URL query strings that contain the substring OR, which is often used in SQL injection attempts

<p align="center">
<img src="https://imgur.com/eQPGRou.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


Now the we have our query we are ready to create our detection rule.

<h3>SQL Injection Detection Rule:</h3>


