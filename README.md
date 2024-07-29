# Port Enumeration and Web Scanning 

<p align="center">
<img src="https://i.imgur.com/h2Ioyda.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h2>Description</h2>

In this section, we will create detection rules for identifying port enumeration and web scanning activities. Tools such as Nmap, Nikto, and Zap will be used to perform these scans, ensuring comprehensive detection coverage.

<h2>The Attack</h2>

<h3>Attack Setup:</h3>

To set up for this attack, we need to establish a simple HTTP server on our Windows 11 VM. Start by opening Command Prompt (CMD) or PowerShell in Administrator mode. Once the terminal is open, enter the following command: 
```powershell
python -m http.server 8000
```
This command will create an HTTP server that listens on port 8000, providing the necessary setup for the attack.

***Note: Python is required to execute this command. Python should already be installed on the Windows 11 VM, but if it is not, simply download and install it from the official Python website.***

<p align="center">
<img src="https://i.imgur.com/9aVQOjp.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h3>Nmap Scan:</h3>

The first attack we are going to perform is port scanning with Nmap. Nmap (Network Mapper) is a free and open-source network scanning tool used for network discovery and security auditing. We will use this tool to enumerate the ports on our Windows 11 VM.

To do this, start by launching the Parrot OS VM and opening a terminal. Next, enter the following command: 
```bash
sudo nmap -p- 10.0.0.4
```
This command will scan all ports on the Windows VM and display which ones are open. You should see that port 8000 is open on this machine as an HTTP port.

<p align="center">
<img src="https://i.imgur.com/hVwhHWN.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


Next, we are going to identify the specific service running on this port. In the terminal, enter the following command: 
```bash
sudo nmap -sV -p 8000 10.0.0.4
```
After the scan is complete, you will see that this port is running a "SimpleHTTPServer" with Python.

<p align="center">
<img src="https://i.imgur.com/LuKucBQ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Nikto Scan:</h3>

The next attack we are going to perform is a Nikto scan. Nikto is an open-source web server scanner that conducts comprehensive tests against web servers for various issues, including potentially dangerous files and programs, outdated versions of over 1300 servers, and version-specific problems on over 270 servers.

To run a Nikto scan, enter the following command into the terminal: 
```bash
sudo nikto -h 10.0.0.4:8000
```
This will initiate the scan on our HTTP server.

<p align="center">
<img src="https://i.imgur.com/AUxEGOr.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Zap Scan:</h3>


The final scan we are going to run is the ZAP scan. ZAP, or the OWASP Zed Attack Proxy, is an open-source web application security scanner. It's one of the world’s most popular free security tools and is actively maintained by hundreds of international volunteers.

To run a ZAP scan on our HTTP server, open the ZAP application on the Parrot OS VM. Once the application is open, click on the "Automated Scan" option. In the "URL to attack" box, enter "http://10.0.0.4:8000". Finally, click the "Attack" button and let the scan run for a few seconds before stopping it.

<p align="center">
<img src="https://i.imgur.com/mVi8zxr.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>The Detection</h2>

To create a detection rule in Elastic, we first need to craft the query that the rule will be based on. This involves using the Kibana Query Language (KQL) to develop a query that targets specific types of logs ingested into Elasticsearch. Once the query is established, Elasticsearch will monitor the indexed data and generate an alert each time a log matching the query criteria is detected.

When creating the query for a detection rule, it's crucial to balance its specificity to avoid overly broad or excessively narrow conditions. If the query is too broad, it may include many general parameters, leading to a high number of false positives. For example, a rule that triggers an alert for any large data transfer, without considering the source or context, could mistakenly flag routine backups or scheduled data syncs as potential threats, creating unnecessary alerts and noise. On the other hand, a highly specific query can be too restrictive, potentially missing critical alerts. For instance, if a detection rule only triggers an alert for an Nmap scan coming from a specific IP range during a particular time frame, it might fail to catch unauthorized scans originating from other sources or at different times. Therefore, it is important to find a good balance when creating the query that the rule will be based on.

</br>

<h3>Nmap Query:</h3>

TTo create a detection rule for an Nmap scan, start by heading into your Elastic environment and navigating to the "Analytics" section. From there, click on the "Discover" option. This is where we will use the Kibana Query Language (KQL) to create the query that the detection rule will use to alert on Nmap scans. In the search box, enter "***nmap***", which will bring up all the logs that contain the word "nmap" in any field. You should now see several Nmap logs that were ingested into your Elastic environment. To examine one of these logs, click on the arrow icon located on the left side of the log entry.


<p align="center">
<img src="https://i.imgur.com/ohnBVW4.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Once you open up the log, you will find data formatted in a specific way. Each piece of data in the log is organized by having a "field" and a "value." For example, the data that shows the IP address of our Windows 11 VM has the field "destination.ip" and the value "10.0.0.4." This is the data we are going to use to build our query for detecting Nmap scans.

<p align="center">
<img src="https://i.imgur.com/u5wzWjt.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The query that we are going to use for this detection rule is:
```sql
data_stream.dataset : "zeek.http" and event.action : "GET" and destination.port: 8000 and user_agent.orginal : "Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)"
```

- data_stream.dataset : "zeek.http" specifies to look for logs that contain the zeek.http dataset.
- event.action : "GET" specifies to find logs that contains http GET requests.
- destination.port : 8000 finds logs that contains destination port 8000
- user_agent.orginal : "Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)" finds logs that contains this specific user agent that is tied to all Nmap scans.

***Note: In the real world you would want to avoid using specific ip's or ports as they are susceptible to change rendering the rule ineffective***

<p align="center">
<img src="https://i.imgur.com/lLGrJnE.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Nmap Detection Rule:</h3>

<b>Define Rule:</b>

Now that we have our query, we are ready to create our detection rule. Begin by copying the query. Next, click on the hamburger icon in the top-left corner of the page, scroll down to "Security," and select the "Rules" option. Then, click on "Detection Rules (SIEM)" and choose "Create New Rule." Ensure that the "Custom Query" option is selected, then scroll down and paste our query into the appropriate field.

<p align="center">
<img src="https://i.imgur.com/AKq92ed.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, scroll down to the "Suppress alerts by" option and enter "source.ip". Then select "Per time period" and set it to 5 minutes. This configuration will reduce the noise generated by repetitive alerts by grouping similar alerts together within the specified time period.

<p align="center">
<img src="https://i.imgur.com/4CPBs33.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we will fill out the "About Rule" section. Name the alert "Nmap Scan Detected" and enter a description for the rule. Set the "Default severity" to "Low" and then click on "Advanced Settings." Scroll down until you see "MITRE ATT&CK threats." For the tactic, select "Reconnaissance," then add a technique and set it to "Active Scanning."

<p align="center">
<img src="https://i.imgur.com/jQSOJoS.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/uTMolEe.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. Configure the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust these settings as needed to suit your specific requirements.

<p align="center">
<img src="https://i.imgur.com/Ots9krG.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set the action Elastic should take when this rule triggers. Options include sending an email, sending a message via Slack, using Microsoft Teams, etc. For this project, we don't need to set any specific actions. Simply click on the "Create & Enable Rule" button to complete the process.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule, we can test it by running another Nmap scan with the command `sudo nmap -sV -p 8000 10.0.0.4`. This should trigger the alert. To view the alert, go to "Security" and select the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://i.imgur.com/ZvPlAU8.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Nikto Query:</h3>

For the Nikto query that we will base our rule on we will use the same methodology to create the query. The KQL query that we will use for the Nikto scan is:

```sql
data_stream.dataset : "zeek.http" and event.action : "GET" and user_agent.original : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
```
- data_stream.dataset : "zeek.http" specifies to look for logs that conatin this specific dataset.
- event.action : "GET" specifies to look for logs that contain http GET requests.
- user_agent.original : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" specifies to look for logs containing this specific user agent that is tied to all Nikto scans.

<p align="center">
<img src="https://i.imgur.com/Ef2m9dQ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Nikto Detection:</h3>

<b>Define Rule:</b>

Now that we have our query, we will create our detection rule. Start by copying the query, then click on the hamburger icon in the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Click on "Detection Rules (SIEM)" and then choose "Create New Rule." Ensure that the "Custom Query" option is selected, then scroll down and paste our query. Next, scroll down to the "Suppress alerts by" option and enter "source.ip." Select "Per time period" and set it to 5 minutes. This configuration will help reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://i.imgur.com/rkmHngu.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we will fill out the "About Rule" section. Name the alert "Nikto Scan Detected" and enter a description for the rule. Set the "Default severity" to "Medium," then click on "Advanced Settings." Scroll down until you see "MITRE ATT&CK threats." For the tactic, select "Reconnaissance," then add a technique and set it to "Active Scanning." Finally, add a subtechnique and set it to "Vulnerability Scanning."

<p align="center">
<img src="https://i.imgur.com/wjO8pfW.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/wHKVOtS.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. Configure the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust these settings as needed to suit your specific requirements.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set the action Elastic should take when this rule triggers. Options include sending an email, sending a message via Slack, or using Microsoft Teams. For this project, we don't need to set any specific actions. Simply click on the "Create & Enable Rule" button to complete the process.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule, we can test it by running another Nikto scan with the command `sudo nikto -h 10.0.0.4:8000`. This should trigger the alert. To view the alert, go to "Security" and select the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://i.imgur.com/eYskeON.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Zap Query:</h3>

For the Nikto query that we will base our rule on we will use the same methodology to create the query. The KQL query that we will use for the Nikto scan is:

```sql
data_stream.dataset : "zeek.http" and user_agent.original : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36" and event.action : "GET" and url.path : *AppData*
```

- data_stream.dataset : "zeek.http" specifies to look for logs that conatin this specific dataset.
- event.action : "GET" specifies to look for logs that contain http GET requests
- user_agent.original : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36" specifies to look for logs containing this specific user agent that is tied to all Nikto scans.
- url.path : *AppData* looks for a logs that contain the words "AppData" in the url.path field

<p align="center">
<img src="https://i.imgur.com/fzxvJiZ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h3>Zap Detection:</h3>

<b>Define Rule:</b>

Now that we have our query, we are ready to create our detection rule. Start by copying the query, then click on the hamburger icon in the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Next, click on "Detection Rules (SIEM)" and select "Create New Rule." Ensure that the "Custom Query" option is selected, then scroll down and paste our query. After that, scroll down to the "Suppress alerts by" option and enter "source.ip." Select "Per time period" and set it to 5 minutes. This will help reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://i.imgur.com/swxafCe.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we will fill out the "About Rule" section. Name the alert "ZAP Scan Detected" and enter a description for the rule. Set the "Default severity" to "Medium," then click on "Advanced Settings." Scroll down until you see "MITRE ATT&CK threats." For the tactic, select "Reconnaissance," then add a technique and set it to "Active Scanning." Finally, add another subtechnique and set it to "Vulnerability Scanning."

<p align="center">
<img src="https://i.imgur.com/X0YmY7t.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/wHKVOtS.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. Configure the rule to execute every 5 minutes with a look-back time of 5 minutes. You can adjust these settings as needed to suit your specific requirements.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set the action Elastic should take when this rule triggers. Options include sending an email, sending a message via Slack, or using Microsoft Teams. For this project, we don't need to set any specific actions. Simply click on the "Create & Enable Rule" button to complete the process.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule, we can run another ZAP scan, which should trigger the alert. To view the alert, go to "Security" and select the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://i.imgur.com/D6KnVzq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<b>Port Enumeration and Web Scanning Complete!</b>








