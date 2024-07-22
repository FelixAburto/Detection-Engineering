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


The final scan we are going to run is the ZAP scan. ZAP, or the OWASP Zed Attack Proxy, is an open-source web application security scanner. It's one of the world’s most popular free security tools and is actively maintained by hundreds of international volunteers.

To run a ZAP scan on our http server open up the ZAP application on the Parrot OS VM. After the application is open click on the option "Automated Scan". Then in the "URL to attack" box enter in "http://10.0.0.4:8000". Finally click on the "Attack" button and let the scan run for a few seconds before stopping it

<p align="center">
<img src="https://i.imgur.com/mVi8zxr.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>The Detection</h2>

In order to create a detection rule for Elastic first we need to create the query that rule will be based on. This involves using the Kibana Query Language (KQL) to craft a query that targets specific types of logs ingested into Elasticsearch. Once this query is established, Elasticsearch will monitor the indexed data and generate an alert each time a log matching the query criteria is detected.

When creating the query for a detection rule, it's important to balance its specificity to avoid overly broad or excessively narrow conditions. If the query is too broad, it may include many general parameters, leading to a high number of false positives. For example, a rule that triggers an alert for any large data transfers, without considering the source or context, could mistakenly flag routine backups or scheduled data syncs as potential threats, creating unnecessary alerts and noise. On the other hand, a highly specific query can be too restrictive, potentially missing critical alerts. For instance, if a detection rule only triggers an alert for an Nmap scan coming from a specific IP range during a particular time frame, it might fail to catch unauthorized scans originating from other sources or at different times. This is why it is important to find a good balance when created the query that the rule will be based on.

</br>

<h3>Nmap Query:</h3>

To create a detection rule for an Nmap scan. head into your Elastic environment and go to "Analytics" and click the "Discover" option. This is where we are going to use KQL to create query the detection rule will use to alert on the Nmap scan. In the search box enter in "*nmap*" . This will bring up all of the logs that contain the word "nmap" in any given field. You should now see a couple of nmap logs that were ingested into our elastic environment. Open up one of these logs by clicking on the arrow icon that is located on the left side of the log.


<p align="center">
<img src="https://i.imgur.com/ohnBVW4.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Once you open up the log you should find data that is formatted in a specific way. Each peice of data that is contained in each log has is formatted by having a "field" and a "value". For example, the data that shows the ip address of our Windows 11 VM has the field "destination.ip" and the value "10.0.0.4". This is the data we are going to use to build our query for detecting Nmap scans.

<p align="center">
<img src="https://i.imgur.com/u5wzWjt.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The query that we are going to use for this detection rule is : "data_stream.dataset : "zeek.http" and event.action : "GET" and destination.port: 8000 and user_agent.orginal : "Mozilla/5.0 (compatible; Nmap Scripting Engine; https://nmap.org/book/nse.html)""

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

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Custom Query" option is selected then scroll down and paste our query.

<p align="center">
<img src="https://i.imgur.com/AKq92ed.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next scroll down to the "Suppress alerts by" option and enter in "source.ip". Then select "Per time period" and select 5 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://i.imgur.com/4CPBs33.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "Nmap Scan Detected" and enter in a description for the rule. Set the "Default severity" to "Low" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Reconnaissance" for the technique and then add a subtechnique and set it to "Active Scanning".

<p align="center">
<img src="https://i.imgur.com/jQSOJoS.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/uTMolEe.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://i.imgur.com/Ots9krG.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then run another nmap scan by running the command "sudo nmap -sv -p 8000 10.0.0.4" and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://i.imgur.com/ZvPlAU8.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Nikto Query:</h3>

For the Nikto query that we will base our rule on we will use the same methodology to create the query. The KQL query that we will use for the Nikto scan is "data_stream.dataset : "zeek.http" and event.action : "GET" and user_agent.original : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36""

- data_stream.dataset : "zeek.http" specifies to look for logs that conatin this specific dataset.
- event.action : "GET" specifies to look for logs that contain http GET requests.
- user_agent.original : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" specifies to look for logs containing this specific user agent that is tied to all Nikto scans.

<p align="center">
<img src="https://i.imgur.com/Ef2m9dQ.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Nikto Detection:</h3>

<b>Define Rule:</b>

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Custom Query" option is selected then scroll down and paste our query. Next scroll down to the "Suppress alerts by" option and enter in "source.ip". Then select "Per time period" and select 5 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://i.imgur.com/rkmHngu.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "Nikto Scan Detected" and enter in a description for the rule. Set the "Default severity" to "Medium" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Reconnaissance" for the technique and then add a subtechnique and set it to "Active Scanning". Finally add another subtechnique and set it to "Vulnerability Scanning".

<p align="center">
<img src="https://i.imgur.com/wjO8pfW.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/wHKVOtS.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then run another nmap scan by running the command "sudo nikto -h 10.0.0.4:8000" and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://i.imgur.com/eYskeON.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h3>Zap Query:</h3>

For the Nikto query that we will base our rule on we will use the same methodology to create the query. The KQL query that we will use for the Nikto scan is "data_stream.dataset : "zeek.http" and user_agent.original : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36" and event.action : "GET" and url.path : *AppData*"


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

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Custom Query" option is selected then scroll down and paste our query. Next scroll down to the "Suppress alerts by" option and enter in "source.ip". Then select "Per time period" and select 5 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://i.imgur.com/swxafCe.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "ZAP Scan Detected" and enter in a description for the rule. Set the "Default severity" to "Medium" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Reconnaissance" for the technique and then add a subtechnique and set it to "Active Scanning". Finally add another subtechnique and set it to "Vulnerability Scanning".

<p align="center">
<img src="https://i.imgur.com/X0YmY7t.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/wHKVOtS.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://i.imgur.com/pdRFGaf.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then run another Zap scan and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://i.imgur.com/D6KnVzq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<b>Port Enumeration and Web Scanning Complete!</b>








