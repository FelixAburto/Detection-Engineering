# Denial of Service & Distributed Denial Of Service

<br />

<p align="center">
<img src="https://cdn-icons-png.flaticon.com/512/4046/4046203.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project we are going to similutate both a Denial of Service and a Distributed Denial of Service attack by flooding our Windows VM with network traffic. A Denial of Service (DOS) attack is a type of cyber attack aimed at making a computer, network, or service unavailable to its intended users. This is typically accomplished by overwhelming the target system with a flood of illegitimate requests, thereby exhausting its resources (such as bandwidth, CPU, or memory) and preventing legitimate requests from being processed. A Distributed Denial of Service (DDOS) attack is an enhanced version of a DOS attack. In a DDOS attack, multiple compromised systems (often part of a botnet) are used to launch the attack simultaneously against a single target.

***Note: This attack is resource intensive I would recommend keeping an eye on your resources to make sure that you do not strain your host machine***

<br />

<h2>DOS & DDOS Attack</h2>

<h3>DOS Attack Setup:</h3>

The first thing we need to do to set up this attack is to create a simple http server with python. To do this enter in this command in a powershell terminal on your Windows VM:

```powershell

python -m http.server 8000

```

Once that is done we are ready to launch our attack.

<h3>DOS Attack Setup:</h3>



