# Detection Engineering Project

<br />

<p align="center">
<img src="https://i.imgur.com/20c7aDB.jpeg" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

This project utilizes Elastic Security SIEM to ingest, monitor, and analyze data from three distinct environments in order to develop effective threat detection rules. The objective is to demonstrate how to effectively detect various simulated cyber threats, enhancing overall security posture.

<br />

# Environment Details

### **Environment 1 : Internal Network 10.0.0.0/24**
- <b>Ubuntu (Zeek/Bro, 10.0.0.3):</b> Deployed with Zeek/Bro For network traffic monitoring and analysis
- <b>Windows 11 (10.0.0.4):</b> Serves as the victim machine to capture and analyze the effects of the attacks
- <b>Parrot OS (10.0.0.5):</b> Functions as the attack machine to simulate different types of cyber attacks

<br />

### **Environment 2 : Internal Network 192.168.1.0/24**
- <b>Ubuntu (Zeek/Bro, 192.168.1.3):</b> Deployed with Zeek/Bro For network traffic monitoring and analysis
- <b>Windows 11 (192.168.1.4):</b> Serves as the victim machine to capture and analyze the effects of the attacks
- <b>Parrot OS (192.168.1.5):</b> Functions as the attack machine to simulate different types of cyber attacks
- <b>Kali Linux (192.168.1.6):</b> Additional attak machine to introduce a broader range of attack vectors

<br />

### **Environment 3 : Azure Cloud Environment**
- <b>Apache Web Server VM (Ubuntu):</b> Hosts the Damn Vulnerable Web Application to simulate web application attacks
- <b>Azure Storage Account:</b> Contains a blob file to similute data exfiltration and unauthorized access
- <b>Azure Key Vault:</b> Stores secret values to simulate unauthorize access.

<br />

### **Simulated Attacks**

- <b>Brute Force Attacks:</b> Simulates unauthorized access attempts to Windows and Linux machines through brute force techniques
- <b>DDOS Attacks:</b> Simulates Distributed Denial of Service attacks 
- <b>Wannacry Ransomeware Attack:</b> Simulates the Wannacry ransomware attack to test the detection of ransomeware threats
- <b>Port Enumeration and Web Scanning:</b> Simulates network reconnaissance and vulnerability scanning activities
- <b>Reverse Shell Attacks:</b> Simulates gaining remote access to a machine
- <b>Pass The Hash Attacks:</b> Simulates credential theft and reuse 
- <b>SQL Injection:</b> Simulates SQL Injection attacks on a vulnerable web server
- <b>XSS Attacks (Reflected, Stored, and DOM):</b>Simulates Cross-Site Scripting atacks on a vulnerable web server
- <b>Detecting Azure Blob Download:</b> Simulates unauthorized access and download of blob storage files
- <b>Detecting Azure Key Vault Events:</b> Simulates unauthorized access to secret keys/values stored in Azure Key Vault

<br />
<br />

<p align="center">
<img src="https://i.imgur.com/YgUt8DZ.png" height="100%" width="100%" alt="Detection Engineering Diagram"/>
</p>

# Walkthrough

</br>

<b>Elastic & Environment Setup</b>

</br>

<b>Attack 1: Port Enumeration and Web Scanning</b>

</br>

<b>Attack 2: Windows and Linux Brute Force Attacks</b>

</br>

<b>Attack 3: Reverse Shell</b>

</br>

<b>Attack 4: Distributed Denial Of Service</b>

</br>

<b>Attack 5: Pass The Hash</b>

</br>

<b>Attack 6: WannaCry.exe Ransomware</b>

</br>

<b>Attack 7: SQL Injection</b>

</br>

<b>Attack 8: XSS (Reflected, Stored, DOM)</b>

</br>

<b>Attack 9: Unauthorized Download of Azure Blob Storage</b>

</br>

<b>Attack 10: Unauthorized access to Azure Key Vault</b>

</br>

<b>BONUS: Showcase Of Man in the Middle Attack</b>

</br>


<h2>Languages Used</h2>

- <b>Bash</b>
- <b>Powershell</b>
- <b>Kibana Query Language</b>
- <b>Event Query Language</b>
- <b>Elastic Search Query Language</b>


<h2>Utilities Used</h2>

- <b>Oracle Virtual Box</b>
- <b>Ubuntu</b>
- <b>Parrot OS</b>
- <b>Kali Linux</b>
- <b>Windows 11</b>
- <b>Microsoft Azure VMs</b>
- <b>Azure Blob Storage</b>
- <b>Azure Key Vault</b>
- <b>Damn Vulnerable Web Application</b>

