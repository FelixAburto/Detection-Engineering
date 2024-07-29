# Denial of Service & Distributed Denial Of Service

<br />

<p align="center">
<img src="https://cdn-icons-png.flaticon.com/512/4046/4046203.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project, we will simulate both a Denial of Service (DoS) and a Distributed Denial of Service (DDoS) attack by flooding our Windows VM with network traffic. A Denial of Service attack aims to make a computer, network, or service unavailable to its intended users. This is achieved by overwhelming the target system with a flood of illegitimate requests, exhausting its resources such as bandwidth, CPU, or memory, and preventing legitimate requests from being processed. On the other hand, a Distributed Denial of Service attack is a more severe form of a DoS attack. In a DDoS attack, multiple compromised systems, often forming a botnet, are used to simultaneously launch the attack against a single target, amplifying the scale and impact of the disruption.

***Note: This attack is resource intensive I would recommend keeping an eye on your resources to make sure that you do not strain your host machine***

<br />

<h2>DOS Attack</h2>

<h3>DOS Attack Setup:</h3>

To set up this attack, the first step is to create a simple HTTP server using Python. To do this, open a PowerShell terminal on your Windows VM and enter the following command:

```powershell

python -m http.server 8000

```

<p align="center">
<img src="https://i.imgur.com/Zpjzpdj.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


Once that is done we are ready to launch our attack.

<h3>DOS Attack Execution:</h3>

To launch the DOS attack, start by opening a terminal on your Kali Linux VM. Enter the following command:

```Bash
sudo hping3 -i u20 -S -p 8000 -c 50000 192.168.1.4
```
What this command will do is send 50,000 SYN packets to our https server on our Windows VM. 

<p align="center">
<img src="https://i.imgur.com/WgztYmu.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


Now that the attack is underway, we can proceed to create a detection rule for it.

</br>

<h2>DOS Attack Detection</h2>

<h3>DOS Query:</h3>

To create our query for detecting the DOS attack, we need to identify a pattern where a large volume of events occurs within a short timeframe. In our Elastic environment, we'll focus on detecting such a pattern by looking for specific log events that indicate a denial of service.

This is the query we will use that illustrates just that:
```sql
data_stream.dataset : "zeek.connection" and zeek.connection.state : "RSTO" and zeek.connection.state_message : "Connection established, originator aborted (sent a RST)."
```
<p align="center">
<img src="https://i.imgur.com/Ka2QWtk.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

-  data_stream.dataset : "zeek.connection" looks for logs thave have the zeek.connection dataset
-  zeek.connection.state : "RSTO" looks for logs that have RTSO as its zeek connection state
-  zeek.connection.state_message : "Connection established, originator aborted (sent a RST)." looks for logs that has this message as its zeek connections state message

Now that we have our query we are ready to create our detection rule.

</br>

<h3>DOS Detection Rule:</h3>

<b>Define Rule:</b>

To create our detection rule for a Denial of Service (DOS) attack, first copy the query and go to the rule creation section in Elastic. Click on the hamburger icon in the top-left corner, scroll down to "Security," and select "Rules." Then, click on "Detection Rules (SIEM)" and choose "Create New Rule." Ensure that the "Threshold" option is selected, scroll down, and paste the query. In the "Group by" field, enter "source.ip" and "zeek.connection.state," setting the "Threshold" to >= 30,000. In the "Count" field, use "@timestamp" and set the "Unique Values" to >= 10,000. Scroll down to the "Suppress alerts by" option, select "Per time period," and choose 5 minutes. This will group similar alerts together, reducing repetitive alert noise.

<p align="center">
<img src="https://i.imgur.com/GPpeSNc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/ZMFRvNH.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we will complete the "About Rule" section. Name the alert "DOS Attack Detected" and provide a description for the rule. Set the "Default severity" to "High." Click on "Advanced Settings," scroll down to "MITRE ATT&CK threats," and select the "Impact" tactic. Then, add the technique "Network Denial of Service," and finally, add a subtechnique set to "Direct Network Flood."

<p align="center">
<img src="https://i.imgur.com/gdcNCNG.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/UztyUit.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterwards, we will configure the duration for the rule. Set the rule to run every 5 minutes with a look-back time of 5 minutes. Feel free to adjust these settings according to your needs.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can determine the actions Elastic should take when this rule triggers. Options include sending an email, posting a message to Slack, or using Microsoft Teams, among others. For this project, we don’t need to configure any specific actions—just click on the "Create & Enable Rule" button to finalize and activate the rule.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set up our rule, we can run the hping3 command to trigger the alert. To view the alert, go to "Security" and select the "Alerts" option in your Elastic environment.

</br>

<h2>DDOS Attack</h2>

<h3>DDOS Attack Setup:</h3>

To set up this attack, the first step is to create a simple HTTP server using Python. To do this, open a PowerShell terminal on your Windows VM and enter the following command:

```powershell

python -m http.server 8000

```

Once that is done we are ready to launch our attack.


<h3>DDOS Attack Execution:</h3>

To execute the attack, fire up both your Parrot OS VM and Kali Linux VM. Open a terminal in each VM and execute the following command:

```Bash

sudo hping3 -i u20 -S -p 8000 192.168.1.4

```
This command will send a SYN flood attack indefinitely until stopped with "Ctrl+C". Allow it to run for a few seconds, then stop the attack by pressing "Ctrl+C".

<p align="center">
<img src="https://i.imgur.com/tsrPH7A.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

We are now ready to create our detection for the DDOS attack.

</br>

<h2>DDOS Detection</h2>


<h3>DDOS Query</h3>

In previous instances, we used Kibana Query Language (KQL) to create our queries. However, for detecting Denial of Service (DOS) attacks from multiple sources, KQL may not be sufficient. Fortunately, Elasticsearch offers another query language called ES|QL, or Elasticsearch Query Language. Unlike KQL, which is user-friendly and designed for basic, ad-hoc searches within Kibana's Discover, Dashboard, and Visualizations sections, ES|QL provides a more advanced, SQL-like syntax. This makes ES|QL better suited for complex querying and data analysis directly within Elasticsearch.

The query that we are going to use to detect a DDOS attack is :

```SQL

FROM logs-*
| WHERE network.transport == "tcp" and zeek.connection.state == "RSTO"
| STATS total_events = COUNT(*), unique_sources = COUNT_DISTINCT(source.ip) BY destination.ip
| WHERE total_events >= 40000 AND unique_sources >= 2

```

This query looks through logs that match the pattern logs-* and filters them to include only TCP connections that were reset by the originator (RSTO state). It then groups these logs by destination IP and calculates the total number of events and the number of unique source IP addresses for each destination IP. Finally, it filters these results to include only those destination IPs that have at least 40,000 events and at least 2 unique source IP addresses. 

<p align="center">
<img src="https://i.imgur.com/fgSF9pw.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have our ES|QL query we are now ready to create our detection rule.

</br>

<h2>DDOS Detection</h2>

<b>Define Rule:</b>

Now that we have our query, we can proceed to create our detection rule. To start, copy the query and click on the hamburger icon in the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Next, click on "Detection Rules (SIEM)" and then choose "Create New Rule". Ensure that the "ES|QL" option is selected, then scroll down and paste the query into the designated field.

<p align="center">
<img src="https://i.imgur.com/DTIQG7k.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we need to complete the "About Rule" section. Name the alert "A DDOS Attack Detected" and provide a description for the rule. Set the "Default severity" to "Critical" and then click on "Advanced Settings." Scroll down until you see "MITRE ATT&CK threats," select "Impact" as the tactic, and add the technique "Network Denial of Service." Finally, add a subtechnique and set it to "Direct Network Flood."

<p align="center">
<img src="https://i.imgur.com/TUoFIco.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/UztyUit.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, set the rule’s duration. Configure it to run every 5 minutes with a look-back time of 5 minutes. Feel free to adjust these settings according to your needs.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, configure the action that Elastic should take when the rule triggers. Options include sending an email, a Slack message, or using Microsoft Teams, among others. For this project, you can skip configuring these actions and simply click the "Create & Enable Rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that our rule is configured, run another DDoS attack to trigger the alert. Monitor the attack for about 30 seconds, and then check the alerts by navigating to "Security" and selecting the "Alerts" option. The alerts should appear as expected, indicating that the rule has successfully detected the attack.

<p align="center">
<img src="https://i.imgur.com/15a1VNB.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>DOS & DDOS Attack Completed!</h3>
