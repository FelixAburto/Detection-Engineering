# SQL Injection

<br />

<p align="center">
<img src="https://i.imgur.com/fwcBcXu.png" height="15%" width="15%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project, we will use the "Damn Vulnerable Web Application" (DVWA) to execute and detect a SQL Injection. A SQL Injection is a web security vulnerability that allows an attacker to interfere with the queries an application makes to its database. By injecting malicious SQL code into input fields, attackers can manipulate database operations, potentially gaining unauthorized access to, modifying, or deleting data. This can lead to data breaches, loss of data integrity, and unauthorized administrative access.

<br />

<h2>Damn Vulnerable Web Application Setup</h2>

<p align="center">
<img src="https://appstore.edgenexus.io/wp-content/uploads/2018/03/dvwa-logo-500x500.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Microsoft Azure Ubuntu VM:</h3>

The first step is to create an Ubuntu Server VM in Azure. To do this, log into your Azure tenant and search for "Virtual Machines." Click on this option, then select the blue "Create" button and choose "Azure Virtual Machine." You will be directed to the configuration page for creating the VM.

<p align="center">
<img src="https://i.imgur.com/RqfxADm.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The next step is to fill out the necessary information to create the VM. First, create a new resource group by clicking "Create New" in the "Resource Group" section and enter a name for your RG. Next, enter a name for the virtual machine and ensure the "Image" is set to "Ubuntu Server 20.04 LTS - x64 Gen2." Set the "Size" to "Standard_D2s_v3 - 2 vcpus, 8 GiB memory." Scroll down to "Administrator Account" and switch the "Authentication type" to "Password." Enter a Username and Password for this VM. Ensure that the "Allow Selected Ports" option is selected and set "Select Inbound Ports" to port 22. Finally, click on "Review + Create," and once validation is complete, select "Create." The Ubuntu Server VM should be deployed in your tenant within a few minutes.

<p align="center">
<img src="https://imgur.com/DH8KSOa.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have our Ubuntu VM deployed in our Azure tenant, the next step is to connect to this VM using SSH. There are two methods to achieve this.

<b>Ubuntu WSL Method:</b> We can use the Ubuntu WSL installed on our Windows host machine to connect to the VM. To do this, use the username, password, and public IP address assigned to your Ubuntu VM. Enter the following command:

```bash
ssh Username@yourAzureVMpublicip
```
<p align="center">
<img src="https://imgur.com/eC6nD7T.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<b>Azure CLI Method:</b> We can use the Azure CLI to SSH into our Ubuntu VM. To do this, navigate to your Ubuntu VM by selecting "Virtual Machines" in your Azure tenant and choosing your VM. Click on the "Connect" option, select "SSH using Azure CLI," and then click on "Configure and Connect." Wait for the Azure CLI to open in your browser, and you should be connected to your VM.

<p align="center">
<img src="https://imgur.com/ANh6p4L.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

I am personally going to use the Ubuntu WSL to setup our Damn Vulnerable Web Application.

</br>

<h3>Web Application Setup:</h3>

Now that our VM is set up, we can move forward with configuring DVWA. The first step is to install all the necessary packages. Enter the following command into the terminal:

```bash
sudo apt update && sudo apt install -y apache2 mariadb-server mariadb-client php php-mysqli php-gd libapache2-mod-php
```

This command updates the package list and installs Apache web server, MariaDB database server and client, PHP, and necessary PHP extensions.

<p align="center">
<img src="https://imgur.com/XF9yKHp.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

To download DVWA to your Ubuntu server and move it to the HTML directory, enter the following commands:

```bash
git clone https://github.com/digininja/DVWA.git

sudo mv DVWA/ /var/www/html/
```
<p align="center">
<img src="https://imgur.com/DR9Wdjb.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The next step is to copy the configuration file into the DVWA config directory. Navigate to your DVWA directory and execute the following command:

```bash

cp config/config.inc.php.dist config/config.inc.php

```

<p align="center">
<img src="https://imgur.com/OHZtSs0.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now we need to configure our Ubuntu Azure VM to accept all inbound traffic on port 80. To do this, go to your Ubuntu Azure VM and select the "Networking" option. Click on "Network Settings" and then select the blue "Create port rule" button. In the new "Add inbound security rule" settings window, set the "Service" field to "HTTP" and the "Priority" field to "200". Finally, click the blue "Add" button to apply the port rule.

<p align="center">
<img src="https://imgur.com/ZzrVWmy.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, we need to start up the web application. To do this enter in this command:

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

The next step in setting up DVWA is to create the database for the web application. First, we need to start MariaDB. To do this, enter the following command:]

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
These SQL commands are used to set up a new database and user in MySQL or MariaDB. The command `CREATE DATABASE dvwa;` creates a new database named `dvwa`. Next, `CREATE USER dvwa@localhost IDENTIFIED BY 'password';` creates a new user named `dvwa` with the password `password` for local access. The command `GRANT ALL ON dvwa.* TO dvwa@localhost;` grants all permissions on the `dvwa` database to this user. Finally, `FLUSH PRIVILEGES;` reloads the grant tables to ensure that the changes take effect immediately.

<p align="center">
<img src="https://imgur.com/grOGXdj.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

After that step, we need to configure the database password in the config file. To do this, navigate to the "config" directory inside the "DVWA" directory. Once there, enter this command:

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

Once you have verified that you can log in, return to the DVWA setup page and click on the "Create/Reset Database" button. After you see the message "Setup successful," click on the "Login" button to proceed to the DVWA login page.

<p align="center">
<img src="https://imgur.com/DoPLZT7.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Login to DVWA using the username "admin" and the password "password." With the setup of the Damn Vulnerable Web Application (DVWA) complete, we are now ready to set up and execute our SQL injection attack.

<p align="center">
<img src="https://imgur.com/HeOqzze.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>SQL Injection Attack</h2>

<h3>Attack Setup:</h3>

<h3>Apache HTTP Server Integration</h3>

To set up our SQL injection attack, first, we need to install the "Apache HTTP Server" Elastic Integration. In your Elastic environment, use the search box at the top of the page to search for "Apache HTTP Server." Select the option that appears. Once you are on the integration page, click the "Add Apache HTTP Server" button.

<p align="center">
<img src="https://imgur.com/RhVmLJ4.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

You should now be on the integration configuration page. Leave all settings at their default values, then scroll down to the "Where to add this integration" section. Select "New Host" and enter "Ubuntu Azure VM" in the "New agent policy name" field. Finally, click the blue "Save and Continue" button and select the "Add Elastic Agent to your hosts" button.

<p align="center">
<img src="https://imgur.com/PuZwkAQ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Follow the instructions to install the Elastic agent to your Ubuntu Azure VM.

<p align="center">
<img src="https://imgur.com/PSwG9hK.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, log in to DVWA and select the "DVWA Security" option. Set the security level to "Low." We are now ready to execute our SQL Injection.

<p align="center">
<img src="https://imgur.com/RP3YIFZ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Attack Execution:</h3>

To execute our SQL Injection attack, first go to your DVWA and select the "SQL Injection" option. On the SQL Injection page, there is a field called "User ID." When you enter numbers 1 through 5 in this field, the page returns a "First name" and "Surname."

<p align="center">
<img src="https://imgur.com/rKqNMqT.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

However, this field is vulnerable to SQL injections, which allows us to view all of the first names and surnames. To do this, simply enter the following SQL command:

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

To create our detection query, we need to focus on identifying logs that contain the specific string of characters associated with SQL injection attempts, such as `x' OR 'x'='x`. After researching and analyzing the logs, this is the query that we are going to use:

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

<b>Define Rule:</b>

To create our detection rule, first copy the query and click on the hamburger icon at the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Then click on "Detection Rules (SIEM)" and choose "Create New Rule." Ensure that the "Custom Query" option is selected, then scroll down and paste the query into the designated field. Next, scroll down to the "Suppress alerts by" option and enter "source.ip." Select "Per time period" and set it to 5 minutes. This will help reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/jYTnZNq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we need to fill out the About Rule section. Name the alert "SQL Injection Detected" and enter a description for the rule. Set the "Default severity" to "High" and then click on "Advanced Settings." Scroll down until you see "MITRE ATT&CK threats," select the option for "Initial Access" for the tactic, and then add a technique set to "Exploit Public-Facing Application."

<p align="center">
<img src="https://imgur.com/TFk7D0e.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/8LTSZyx.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, set the duration for how long the rule should run. Configure the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust these settings as needed.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, set the action Elastic should take when the rule triggers. You can choose to send an email, send a message via Slack, use Microsoft Teams, or other options. For this project, you don’t need to set up any actions; simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule, execute another SQL injection to trigger the alert. You can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://imgur.com/RYlcGRR.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h3>SQL Injection Completed!</h3>
