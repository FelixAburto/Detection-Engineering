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

The first attack the we are going to do is port scanning with Nmap. Nmap (Network Mapper) is a free and open-source network scanning tool used for network discovery and security auditing. We are going to use this tool to enumerate the ports on our Windows 11 VM.

To do this fire up the Parrot OS VM and open up a terminal. Next, enter in the command "sudo nmap -p- 10.0.0.4". This will scan all ports on the Windows VM and show which ones are open. We can see that port 8000 is open on this machine as an http port. 

<p align="center">
<img src="https://i.imgur.com/hVwhHWN.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


Next we are going to find out exactly what service this port is running. In the terminal enter in the command "sudo nmap -sV -p 8000 10.0.0.4". After the scan is complete we see that this port is running a "SimpleHTTPServer" with Python.


<p align="center">
<img src="https://i.imgur.com/LuKucBQ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Nikto Scan:</h3>

The next attack that we are going to do is run a Nikto Scan. Nikto is an open-source web server scanner which performs comprehensive tests against web servers for multiple items, including potentially dangerous files and programs, outdated versions of over 1300 servers, and version-specific problems on over 270 servers.

To run a Nikto scan enter in the command "sudo nikto -h 10.0.0.4:8000" into the terminal. This will start the scan on our HTTP server.


<p align="center">
<img src="https://i.imgur.com/AUxEGOr.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Zap Scan:</h3>


The final can we are going to run is the ZAP scan. ZAP, or the OWASP Zed Attack Proxy, is an open-source web application security scanner. It's one of the world’s most popular free security tools and is actively maintained by hundreds of international volunteers.

To run a ZAP scan on our http server open up the ZAP application on the Parrot OS VM. After the application is open click on the option "Automated Scan". Then in the "URL to attack" box enter in "http://10.0.0.4:8000". Finally click on the "Attack" button and let the scan run for a few seconds before stopping it

<p align="center">
<img src="https://i.imgur.com/mVi8zxr.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>The Detection</h2>



