# Cross-Site Scripting (XSS) (Reflected, Stored, DOM)

<br />

<p align="center">
<img src="https://imgur.com/4xFoKLV.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project, we will utilize the Damn Vulnerable Web Application (DVWA) to execute and detect reflected, stored, and DOM-based Cross-Site Scripting (XSS) attacks. An XSS attack is a security vulnerability that allows attackers to inject malicious scripts into web pages viewed by other users. These scripts can steal cookies, session tokens, or other sensitive information, and manipulate the content or behavior of the web page without the user's consent. There are three main types of XSS: reflected XSS, where the malicious script is reflected off a web server; stored XSS, where the script is stored on the server; and DOM-based XSS, where the vulnerability exists in the client-side code.

***Note: If you do not have the Damn Vulnerable Web Application setup please visit the SQL Injection section of the project for instructions on how to set it up.*** 

<br />

<h2>Reflected XSS Attack</h2>

<h3>Attack Setup:</h3>

To set up our attack, first log in to DVWA and select the "XSS (Reflected)" option. On this page, you can enter your name in the "What's your name?" field, and the website will display a message saying "Hello Yourname." However, this field is vulnerable to reflected XSS attacks, and we can exploit this vulnerability to execute our own JavaScript code.

<p align="center">
<img src="https://imgur.com/TWQPVBL.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Attack Execution:</h3>

To execute our reflected XSS attack, first locate the "What's your name?" field. This is where we will enter our code. Input the following JavaScript code into the field and click "Submit":

```javascript

<script>alert('Reflected XSS!');</script>

```

The page should display an alert after clicking the "Submit" button. Once that is done we have successfully executed our reflected XSS attack.

<p align="center">
<img src="https://imgur.com/HkcosXV.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Stored XSS Attack</h2>

<h3>Attack Setup:</h3>

To set up our attack, first log in to DVWA and select the "XSS (Stored)" option. On this page, you can enter your name in the "Name" field and a message in the "Message" field. The website will store the name and message you input. However, since this field is vulnerable to Stored XSS attacks, we can exploit this vulnerability to execute and store our own JavaScript code.

<p align="center">
<img src="https://imgur.com/GSD9aoP.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Attack Execution:</h3>

To execute our Stored XSS attack, first locate the "Name" and "Message" fields. Enter any value you like in the "Name" field. In the "Message" field, input your JavaScript code. After entering the code, click "Sign Guestbook" to execute the attack.

```javascript

<script>alert(1);</script>

```

```javascript

<script>alert(2);</script>

```

```javascript

<script>alert(3);</script>

```

The page should display an alert after clicking the "Sign Guestbook" button and it should also store the code. Once that is done we have successfully executed our Stored XSS attack.

<p align="center">
<img src="https://imgur.com/xVYLE4i.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Document Object Model XSS Attack</h2>

<h3>Attack Setup:</h3>

To set up our attack, first log in to the DVWA and select the "XSS (DOM)" option. On this page, you can choose from four different languages: English, French, Spanish, or German. Although the site's language does not change when selecting an option, the URL of the website does. This section of the website has a DOM XSS vulnerability, allowing us to execute our own JavaScript code by entering it directly into the browser's URL.

<p align="center">
<img src="https://imgur.com/WnTlNGj.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Attack Execution:</h3>

To execute our DOM XSS attack, first select any language. Next, go to the URL box and append an "&" symbol to the end of the URL. Then, enter the JavaScript code into the URL after the "&" symbol. Finally, press Enter, and the JavaScript code should execute.

```javascript

<script>alert('DOM XSS!');</script>

```

The page should display an alert. Once that is done we have successfully executed our DOM XSS attack.

<p align="center">
<img src="https://imgur.com/WSF18PV.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have successfully executed all of our XSS attacks we are ready to create our detection for this attack.

</br>

<h2>Reflected, Stored, and DOM XSS Detection</h2>

<h3>XSS Query:</h3>

To create our query for the detection rule, we need to identify what we are specifically looking for. Since we used JavaScript code in our attacks, we should look for logs that contain the word "script." After researching and analyzing the logs, this is the query we are going to use:

```SQL

data_stream.dataset : "apache.access" and url.query : *script*

```

- data_stream.dataset : "apache.access" filters the logs to include only those from the apache.access dataset, which contains access logs from an Apache web server
- url.query : *script* Looks for URL query strings that contain the substring "script", which is often associated with attempts to inject scripts, such as in Cross-Site Scripting (XSS) attacks.

<p align="center">
<img src="https://imgur.com/eQPGRou.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


Now the we have our query we are ready to create our detection rule.

<h3>XSS Detection Rule:</h3>

<b>Define Rule:</b>

To create our detection rule, first copy the query and click on the hamburger icon in the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Next, click on "Detection Rules (SIEM)" and choose "Create New Rule." Ensure that the "Custom Query" option is selected, then scroll down and paste our query into the provided field. Scroll down further to the "Suppress alerts by" option, enter "source.ip," and select "Per time period," setting it to 5 minutes. This configuration will reduce the noise from repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/Qv6VBsu.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we need to fill out the "About Rule" section. Name the alert "XSS Attack Detected" and provide a description for the rule. Set the "Default severity" to "High" and then click on "Advanced Settings." Scroll down until you see "MITRE ATT&CK threats," select the option for "Initial Access" for the tactic, and add a technique set to "Exploit Public-Facing Application." Next, add another MITRE tactic set to "Execution" and include a technique labeled "Command and Scripting Interpreter." Finally, add a subtechnique and set it to "JavaScript."

<p align="center">
<img src="https://imgur.com/2RmM6hc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/GjaDpEw.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, set the duration for how long the rule should run. Configure the rule to execute every 5 minutes with a look-back time of 5 minutes. You can adjust these settings according to your needs.

<p align="center">
<img src="https://imgur.com/bZM4ADq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, configure the action Elastic should take when this rule triggers. You can set it to send an email, a Slack message, or use Microsoft Teams, among other options. For this project, we don't need to set up any actions; simply click the "Create & Enable rule" button.

<p align="center">
<img src="https://imgur.com/4Sd0G0p.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set up our rule, execute another XSS attack to trigger the alert. You can view the alert by navigating to "Security" and selecting the "Alerts" option. This is what the alert should look like when it is triggered.

<p align="center">
<img src="https://imgur.com/n1gHHHd.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h3>Cross-Site Scripting (XSS) (Reflected, Stored, DOM) Completed!</h3>
