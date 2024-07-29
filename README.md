# Detection Engineering Project

<br />

<p align="center">
<img src="https://i.imgur.com/20c7aDB.jpeg" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

This project employs Elastic Security SIEM to ingest, monitor, and analyze data from three distinct environments, aiming to develop effective threat detection rules. The objective is to demonstrate how to accurately detect various simulated cyber threats, thereby enhancing the overall security posture.

<br />

# Environment Details

### **Environment 1 : Internal Network 10.0.0.0/24**
- <b>Ubuntu (Zeek/Bro, 10.0.0.3):</b> Deployed with Zeek/Bro for network traffic monitoring and analysis.
- <b>Windows 11 (10.0.0.4):</b> Serves as the victim machine to capture and analyze the effects of attacks.
- <b>Parrot OS (10.0.0.5):</b> Functions as the attack machine to simulate different types of cyber attacks.

<br />

### **Environment 2 : Internal Network 192.168.1.0/24**
- <b>Ubuntu (Zeek/Bro, 192.168.1.3):</b> Deployed with Zeek/Bro for network traffic monitoring and analysis.
- <b>Windows 11 (192.168.1.4):</b> Serves as the victim machine to capture and analyze the effects of attacks.
- <b>Parrot OS (192.168.1.5):</b> Functions as the attack machine to simulate different types of cyber attacks.
- <b>Kali Linux (192.168.1.6):</b>  Additional attack machine to introduce a broader range of attack vectors.
<br />

### **Environment 3 : Azure Cloud Environment**
- <b>Apache Web Server VM (Ubuntu):</b> Hosts the Damn Vulnerable Web Application to simulate web application attacks.
- <b>Azure Storage Account:</b> Contains a blob file to simulate data exfiltration and unauthorized access.
- <b>Azure Key Vault:</b>  Stores secret values to simulate unauthorized access.

<br />

### **Simulated Attacks**

- <b>Brute Force Attacks:</b> Simulates unauthorized access attempts to Windows and Linux machines through brute force techniques.
- <b> DOS & DDOS Attacks:</b> Simulates Denial of Service and Distributed Denial of Service attacks.
- <b>Wannacry Ransomeware Attack:</b> Simulates the Wannacry ransomware attack to test the detection of ransomware threats.
- <b>Port Enumeration and Web Scanning:</b> Simulates network reconnaissance and vulnerability scanning activities.
- <b>Reverse Shell Attacks:</b> Simulates gaining remote access to a machine.
- <b>Pass The Hash Attacks:</b> Simulates credential theft and reuse.
- <b>SQL Injection:</b> Simulates SQL Injection attacks on a vulnerable web server.
- <b>XSS Attacks (Reflected, Stored, and DOM):</b> Simulates Cross-Site Scripting attacks on a vulnerable web server.
- <b>Detecting Azure Blob Download:</b> Simulates unauthorized access and download of blob storage files.
- <b>Detecting Azure Key Vault Events:</b> Simulates unauthorized access to secret keys/values stored in Azure Key Vault.
- <b> Man in the Middle Attacks:</b> Simulates data exfiltration through a Man in the Middle attack.

<br />
<br />

<p align="center">
<img src="https://i.imgur.com/YgUt8DZ.png" height="100%" width="100%" alt="Detection Engineering Diagram"/>
</p>

# Walkthrough

</br>

<h2>Elastic & Environment Setup</h2>

</br>

- **[Elastic Cloud & Oracle VirtualBox](https://github.com/FelixAburto/Detection-Engineering/tree/Elastic-and-Oracle-Virtualbox)** &nbsp;&nbsp;&nbsp;<img src="https://i.imgur.com/pqCZFrQ.png" alt="Icon" style="width: 10%; height: auto; vertical-align: middle;"/>

</br>

- **[Windows 11 VM Setup](https://github.com/FelixAburto/Detection-Engineering/tree/Windows-VM-Setup)** &nbsp;&nbsp;&nbsp;<img src="https://upload.wikimedia.org/wikipedia/commons/e/e6/Windows_11_logo.svg" alt="Icon" style="width: 10%; height: auto; vertical-align: middle;"/>


- **[Ubuntu Linux VM (Zeek/Bro) Setup](https://github.com/FelixAburto/Detection-Engineering/tree/Ubuntu-(Zeek/Bro)-VM-Setup)** &nbsp;&nbsp;&nbsp;<img src="https://cdn.freebiesupply.com/logos/large/2x/ubuntu-4-logo-png-transparent.png" alt="Icon" style="width: 4%; height: auto; vertical-align: middle;"/> &nbsp;&nbsp;&nbsp;<img src="https://zeek.org/wp-content/uploads/2020/04/zeek-logo-without-text.png" alt="Icon" style="width: 4%; height: auto; vertical-align: middle;"/>

</br>

- **[Parrot OS VM Setup](https://github.com/FelixAburto/Detection-Engineering/tree/Parrot-OS-VM-Setup)** &nbsp;&nbsp;&nbsp;<img src="https://gdm-catalog-fmapi-prod.imgix.net/ProductLogo/b91dba39-aef6-4808-be11-8eda81f81f56.png" alt="Icon" style="width: 4%; height: auto; vertical-align: middle;"/>

</br>

- **[Kali Linux VM Setup](https://github.com/FelixAburto/Detection-Engineering/tree/Kali-Linux-VM-Setup)** &nbsp;&nbsp;&nbsp;<img src="https://seeklogo.com/images/K/kali-linux-logo-AED181186E-seeklogo.com.png" alt="Icon" style="width: 4%; height: auto; vertical-align: middle;"/>

</br>

- **[Microsoft Azure Setup](https://github.com/FelixAburto/Detection-Engineering/tree/Microsoft-Azure-Setup)** &nbsp;&nbsp;&nbsp;<img src="https://swimburger.net/media/ppnn3pcl/azure.png" alt="Icon" style="width: 4%; height: auto; vertical-align: middle;"/>

</br>


<h2>Attacks and Detections</h2>

<h3>10.0.0.0/24 Environment:</h3>

</br>

- **[Attack 1 : Port Enumeration and Web Scanning (Start Here!) ](https://github.com/FelixAburto/Detection-Engineering/tree/Port-Enumeration-and-Web-Scanning)** &nbsp;&nbsp;&nbsp;<img src="https://i.imgur.com/h2Ioyda.png" alt="Icon" style="width: 5%; height: auto; vertical-align: middle;"/>

</br>

- **[Attack 2 : Windows & Linux Brute Force Attack ](https://github.com/FelixAburto/Detection-Engineering/tree/Windows-and-Linux-Brute-Force-Attack)** &nbsp;&nbsp;&nbsp;<img src="https://cdn-icons-png.flaticon.com/512/6689/6689968.png" alt="Icon" style="width: 5%; height: auto; vertical-align: middle;"/>

</br>

- **[Attack 3 : Metasploit Reverse Shell & Elastic Defend ](https://github.com/FelixAburto/Detection-Engineering/tree/Reverse-Shell)** &nbsp;&nbsp;&nbsp;<img src="https://az639995.vo.msecnd.net/runtimecontent/companyfiles/24065/13613/screenshot-131001879959264076.png" alt="Icon" style="width: 5%; height: auto; vertical-align: middle;"/>


</br>

<h3>192.168.1.0/24 Environment:</h3>

</br>

- **[Attack 4 : Denial of Service & Distributed Denial of Service](https://github.com/FelixAburto/Detection-Engineering/tree/Denial-of-Service-%26-Distributed-Denial-Of-Service)** &nbsp;&nbsp;&nbsp;<img src="https://cdn-icons-png.flaticon.com/512/4046/4046203.png" alt="Icon" style="width: 5%; height: auto; vertical-align: middle;"/>


- **[Attack 5 : Pass the Hash](https://github.com/FelixAburto/Detection-Engineering/tree/Pass-The-Hash)** &nbsp;&nbsp;&nbsp;<img src="https://i.imgur.com/u80FCmz.png" alt="Icon" style="width: 10%; height: auto; vertical-align: middle;"/>


- **[Attack 6 : WannaCry.exe Ransomware](https://github.com/FelixAburto/Detection-Engineering/tree/WannaCry.exe-Ransomware)** &nbsp;&nbsp;&nbsp;<img src="https://imgur.com/i8NmRpT.png" alt="Icon" style="width: 10%; height: auto; vertical-align: middle;"/>

</br>

<h3>Microsoft Azure Environment:</h3>

</br>

- **[Attack 7 : SQL Injection](https://github.com/FelixAburto/Detection-Engineering/tree/SQL-Injection)** &nbsp;&nbsp;&nbsp;<img src="https://i.imgur.com/fwcBcXu.png" alt="Icon" style="width: 5%; height: auto; vertical-align: middle;"/>

- **[Attack 8 : Cross-Site Scripting (XSS) (Reflected, Stored, DOM)](https://github.com/FelixAburto/Detection-Engineering/tree/Cross-Site-Script-(XSS)-(Reflected%2C-Stored%2C-DOM))** &nbsp;&nbsp;&nbsp;<img src="https://imgur.com/4xFoKLV.png" alt="Icon" style="width: 5%; height: auto; vertical-align: middle;"/>

- **[Attack 9 : Unauthorized Download of Azure Blob Storage](https://github.com/FelixAburto/Detection-Engineering/tree/Unauthorized-Download-of-Azure-Blob-Storage)** &nbsp;&nbsp;&nbsp;<img src="https://img.icons8.com/?size=512&id=84280&format=png" alt="Icon" style="width: 7%; height: auto; vertical-align: middle;"/>

- **[Attack 10 : Unauthorized Access to Azure Key Vault](https://github.com/FelixAburto/Detection-Engineering/tree/Unauthorized-Access-to-Azure-Key-Vault)** &nbsp;&nbsp;&nbsp;<img src="https://miro.medium.com/v2/resize:fit:600/1*b0oZ-Da1LxW4TdujAOiC9Q.png" alt="Icon" style="width: 10%; height: auto; vertical-align: middle;"/>

</br>

<h3>BONUS:</h3>

- **[Showcase of Man in the Middle Attack](https://github.com/FelixAburto/Detection-Engineering/tree/Showcase-Of-Man-in-the-Middle-Attack)** &nbsp;&nbsp;&nbsp;<img src="https://blogs.vmware.com/euc/files/2018/10/roxane_sanusersroxanedownloadsmitm-png.png" alt="Icon" style="width: 15%; height: auto; vertical-align: middle;"/>

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
- <b>MITRE ATT&CK Framework</b>
- <b>Elastic Security SIEM</b>
- <b>Elastic Defender</b>
