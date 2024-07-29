# Man in the Middle Attack

<br />

<p align="center">
<img src="https://blogs.vmware.com/euc/files/2018/10/roxane_sanusersroxanedownloadsmitm-png.png" height="50%" width="50%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project I am going to be showcasing how to perform a Man in the middle attack to exfiltrate data.

</br>

<h2>Man in the Middle Attack</h2>

<h3>Attack Setup:</h3>

To setup this attack first create a simple http server using python in the directory where the ".txt" file exists on our Windows VM. To do this simply enter this command:

```powershell

python -m http.server 8000

```

<p align="center">
<img src="https://imgur.com/kmUmEkQ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now we are ready to execute our attack.


<h3>Attack Execution:</h3>

To perform this attack we are going be using Bettercap to intercept the traffic. Bettercap is a powerful, flexible, and user-friendly tool used for network monitoring and attack, highly favored by security professionals. It offers a wide range of capabilities including network sniffing, where it captures and analyzes network traffic to help monitor and troubleshoot network issues. One of its key features is the ability to perform Man-in-the-Middle (MitM) attacks, which involve intercepting and manipulating traffic between two parties without their knowledge, employing techniques like ARP spoofing, DNS spoofing, and HTTPS proxying.

To execute this attack first open up a terminal on your Parrot OS VM and enter in this command:

```bash

sudo bettercap -iface enp0s8 -eval "set net.sniff.output '/home/user/Desktop/exfil.pcap'"

```
This command runs Bettercap with elevated privileges to monitor network traffic on the "enp0s8" interface and saves the captured traffic to a packet capture named exfil.pcap on the Desktop.

After you have bettercap up on your terminal enter in these series of commands:

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

Finally, use your Ubuntu VM and enter in the ip address and port of the http server and download the .txt file.

<p align="center">
<img src="https://imgur.com/ivifIyE.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Data Exfiltration</h2>

We should now have the capture traffic between our Ubuntu VM and Windows VM on our Parrot OS Desktop. It is now time to exfiltrate the data that was captured. To do this open up wireshark using this command:

```bash
sudo wireshark
```
Next, open up the pcap file by going to "File" and clicking the "Open" option then selecting the "exfil.pcap" file. Afterwards, go back to "File" and select the "Export Objects" option then select the "HTTP" option. A new window should appear and you should see an object that contains the .txt file that we downloaded on our Ubuntu VM. Download the file and open it. We have now successfully executed a Man in the Middle attack!

<p align="center">
<img src="https://imgur.com/ft5deeL.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Man in the Middle Attack Complete!</h3>

