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
