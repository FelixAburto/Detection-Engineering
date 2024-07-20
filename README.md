# Port Enumeration and Web Scanning 

<p align="center">
<img src="https://i.imgur.com/h2Ioyda.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>The Attack</h2>

<h3>Attack Setup:</h3>

To setup for this attack first we need to setup a simple http server on our Windows 11 VM. To do this open either CMD or Powershell in Administrator mode then enter in the command "python -m http.server 8000". This will create a http server that is open on port 8000. 

***Note: Python is required to execute this command. Python should already be installed on the Windows 11 VM but if it is not simply install it by downloading the installer at https://www.python.org/downloads/***

<p align="center">
<img src="https://i.imgur.com/9aVQOjp.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h3>Nmap Scan:</h3>

The first attack the we are going to do is port scanning with Nmap. Nmap (Network Mapper) is a free and open-source network scanning tool used for network discovery and security auditing. We are going to use this tool to enumerate the ports on our Windows 11 VM. To do this fire up the Parrot OS VM and open up a terminal. 
