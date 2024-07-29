# Man in the Middle Attack

<br />

<p align="center">
<img src="https://blogs.vmware.com/euc/files/2018/10/roxane_sanusersroxanedownloadsmitm-png.png" height="50%" width="50%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project, I will demonstrate how to perform a Man-in-the-Middle (MitM) attack to exfiltrate data.

</br>

<h2>Man in the Middle Attack</h2>

<h3>Attack Setup:</h3>

To set up this attack, first create a simple HTTP server using Python in the directory where the `.txt` file is located on your Windows VM. To do this, enter the following command:

```powershell

python -m http.server 8000

```

<p align="center">
<img src="https://imgur.com/kmUmEkQ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now we are ready to execute our attack.


<h3>Attack Execution:</h3>

To perform this attack, we'll be using Bettercap to intercept the traffic. Bettercap is a powerful, flexible, and user-friendly tool widely used by security professionals for network monitoring and attacks. It offers extensive capabilities, including network sniffing to capture and analyze traffic, which helps in monitoring and troubleshooting network issues. A key feature of Bettercap is its ability to execute Man-in-the-Middle (MitM) attacks. These attacks involve intercepting and manipulating traffic between two parties without their knowledge, using techniques such as ARP spoofing, DNS spoofing, and HTTPS proxying.

To execute this attack, first open a terminal on your Parrot OS VM and enter the following command:

```bash

sudo bettercap -iface enp0s8 -eval "set net.sniff.output '/home/user/Desktop/exfil.pcap'"

```
This command runs Bettercap with elevated privileges to monitor network traffic on the "enp0s8" interface and saves the captured traffic to a packet capture file named `exfil.pcap` on the Desktop.

Once Bettercap is up and running in your terminal, enter the following series of commands:

```bash

set net.sniff.verbose true

```


```bash

set arp.spoof.targets 10.0.0.4

```


```bash

set arp.spoof on

```


```bash

net.sniff on

```

These series of commands configure and activate network sniffing and ARP spoofing using Bettercap. The command set net.sniff.verbose true enables verbose mode for network sniffing, ensuring detailed information about captured packets is displayed. Next, set arp.spoof.targets 10.0.0.4 designates the IP address 10.0.0.4 as the target for ARP spoofing. The command set arp.spoof on then enables ARP spoofing, allowing the interception and manipulation of network traffic to and from the specified target. Finally, net.sniff on activates network sniffing, capturing packets on the network for analysis.

<p align="center">
<img src="https://imgur.com/jJPnjaC.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Finally, on your Ubuntu VM, open a browser and enter the IP address and port of the HTTP server. This will allow you to download the `.txt` file.

<p align="center">
<img src="https://imgur.com/ivifIyE.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Data Exfiltration</h2>

We should now have the captured traffic between our Ubuntu VM and Windows VM on our Parrot OS Desktop. To exfiltrate the data that was captured, open Wireshark using the following command:

```bash
sudo wireshark
```
Next, open the pcap file by navigating to "File" and selecting the "Open" option, then choose the "exfil.pcap" file. Once the file is open, go back to "File" and select "Export Objects," then choose the "HTTP" option. A new window will appear, showing an object that contains the .txt file downloaded on our Ubuntu VM. Download the file and open it. We have now successfully executed a Man-in-the-Middle attack!

<p align="center">
<img src="https://imgur.com/ft5deeL.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Man in the Middle Attack Complete!</h3>

