# Cross-Site Scripting (XSS) (Reflected, Stored, DOM)

<br />

<p align="center">
<img src="https://imgur.com/4xFoKLV.png" height="25%" width="25%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project we are going to utilize the "Damn Vulnerable Web Application" to excute and detect reflected, stored, and DOM Cross-Site Scripting attacks. A XSS Cross-Site Scripting attack is a security vulnerability that allows attackers to inject malicious scripts into web pages viewed by other users. These scripts can steal cookies, session tokens, or other sensitive information, and can manipulate the content or behavior of the web page without the user's consent. There are three main types: stored XSS, where the malicious script is stored on the server; reflected XSS, where the script is reflected off a web server; and Document Object Model based XSS, where the vulnerability exists in the client-side code.

***Note: If you do not have the Damn Vulnerable Web Application setup please visit the SQL Injection section of the project for instructions on how to set it up.*** 

<br />

<h2>Reflected XSS Attack</h2>

<h3>Attack Setup:</h3>

To setup our attack first login to the DVWA and select the option "XSS (Reflected)". In this page you can enter your name in the "What's your name?" field and the website will then display a message saying "Hello Yourname". However, this field is vulnerable to reflected XSS attacks and we can take advantage of this fact to execute our own Javascript code.

<p align="center">
<img src="https://imgur.com/TWQPVBL.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Attack Execution:</h3>

To execute our reflected XSS attack first look for the "What's your name?" field. This the field where we are going to enter our code. To execute the attack enter in this Javascript code into the field and click "Submit"

```javascript

<script>alert('Reflected XSS!');</script>

```

The page should display an alert after clicking the "Submit" button. Once that is done we have successfully executed our reflected XSS attack.

<p align="center">
<img src="https://imgur.com/GSD9aoP.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>

<h2>Stored XSS Attack</h2>

<h3>Attack Setup:</h3>

To setup our attack first login to the DVWA and select the option "XSS (Stored)". In this page you can enter your name in the "Name" field and you can enter a message in the "Message" Field. The website will then store the name and message that you inputed. However, this field is vulnerable to Stored XSS attacks and we can take advantage of this fact to execute and store our own Javascript code.

<p align="center">
<img src="https://imgur.com/GSD9aoP.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Attack Execution:</h3>

To execute our Stored XSS attack first look for the "Name" and "Message" field. In the "Name" field enter in whatever you'd like. However, the "Message" field is the field where we are going to enter our code. To execute the attack enter in the Javascript code into the field and click "Sign Guestbook"

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

To setup our attack first login to the DVWA and select the option "XSS (DOM)". In this page you can select from 4 different languages : English, French, Spanish, or German. The actual language of the site doesnt change when you select a language but it does change the URL of our website. This particular section of the website has a DOM XSS vulnerability where we can execute our own Javascript code by entering it in our browser URL.

<p align="center">
<img src="https://imgur.com/WnTlNGj.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<h3>Attack Execution:</h3>

To execute our DOM XSS attack first select any language. Afterwards, go the the URL box and add an "&" symbol to the end of the URL then enter in this Javascript code into the URL. Finally, enter the URL and the Javascript code should execute.

```javascript

<script>alert('DOM XSS!');</script>

```

The page should display an alert. Once that is done we have successfully executed our DOM XSS attack.

<p align="center">
<img src="https://imgur.com/WSF18PV.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have successfully executed all of our XSS attacks we are ready to creat our detection for this attack.

</br>

<h2>Reflected, Stored, and DOM XSS Detection</h2>

<h3>XSS Query:</h3>

In order to create our query for the detection rule we need to think about what exactly are we looking for. Since we used Javascript code  we need to look for logs that contain the word "script". After researching and digging through the logs this is the query that we are going to use: 

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

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Custom Query" option is selected then scroll down and paste our query. Next scroll down to the "Suppress alerts by" option and enter in "source.ip". Then select "Per time period" and select 5 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/Qv6VBsu.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "XSS Attack Detected" and enter in a description for the rule. Set the "Default severity" to "High" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Initial Access" for the tactic and then add a technique and set it to "Exploit Public-Facing Application". Next add another MITRE tactic and set it to "Execution" then add a technique and set it to "Command and Scripting Interpreter". Finally add another subtechnique and set it to "Javascript"

<p align="center">
<img src="https://imgur.com/2RmM6hc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/GjaDpEw.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://imgur.com/bZM4ADq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://imgur.com/4Sd0G0p.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then execute another SQL Injection and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like when it triggers.

<p align="center">
<img src="https://imgur.com/n1gHHHd.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

</br>


<h3>Cross-Site Scripting (XSS) (Reflected, Stored, DOM) Completed!</h3>
