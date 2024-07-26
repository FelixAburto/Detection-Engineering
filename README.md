# Wannacry.exe Ransomware

<br />

<p align="center">
<img src="https://imgur.com/i8NmRpT.png" height="50%" width="50%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project we are going to create a detection for the Wannacry Ransomware. WannaCry is a ransomware attack that occurred in May 2017, targeting Windows computers. It spread through a vulnerability in the Windows SMB protocol, encrypting users' files and demanding a ransom in Bitcoin to decrypt them. The attack affected hundreds of thousands of computers globally, causing significant disruption in various sectors, including healthcare, finance, and telecommunications.

## ⚠️ DISCLAIMER ⚠️

**HANDLING MALWARE CAN BE EXTREMELY DANGEROUS IF NOT DONE PROPERLY. PLEASE PROCEED WITH CAUTION. I AM NOT RESPONSIBLE FOR ANY DAMAGES THAT MAY OCCUR TO YOUR SYSTEM.**


</br>

<h2>Wannacry Attack</h2>

<h3>Attack Setup:</h2>

The first step we need to take to set up our attack is to properly configure our network settings to make sure we are safe when we detonate this malware. To do this open up Oracle Virtualbox and right click on the Windows 11 VM then select the "settings" options. Next, click on the "Network" option and make sure that Adapter 1 is set to NAT. Afterwards go to "Adapter 2" and make sure that this virtual network adapter is disabled by setting it to "Not Attached" or unchecking the "Enable Network Adapter" option.

<p align="center">
<img src="https://imgur.com/cJAEHg9.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/ZKjIZ4Q.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Once that is done next we need to create a snapshot of our current Windows VM configuration. A snapshot is a copy of the state of a system or data at a particular point in time. What this will allow us to do is to revert back to the point before we executed Wannacry on our Windows VM. To do this [Enter in how to create a snapshot here]. 

<p align="center">
<img src="https://imgur.com/QyYopUB.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, we need to install 7zip on our Windows 11 VM. To do this visit https://www.7-zip.org/download.html and download the 7zip x64 installer. Open up the installer and proceed to go through the step necessary to install 7zip on your VM.

<p align="center">
<img src="https://imgur.com/QyYopUB.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterwards, we need to download the Wannacry binary onto our Windows VM. To do this visit https://github.com/HuskyHacks/PMAT-labs then click on the green "Code" button. This should bring up an option to download the repository as a zip file by selecting the "Download ZIP" option. 

<p align="center">
<img src="https://imgur.com/emUiHZ9.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now we need to extract the Wannary binary from this ZIP file. To do this open up the zip file and open up the "PMAT-labs-main" folder then open up the "labs" folder. After that find the "4.1.Bossfight-wannacry.exe" folder and extract it to your Desktop. Open the folder and you should you a the Wananacry binary as a "Ransomware.wanncry.exe.malz.7z" zip file. To extract the binary right click on the file and search for the "Open With" then click on "Choose Another App". Afterwards, click on the "Choose an app on your PC" and find the "7 Zip" folder. Select the "7zFM.exe" executable and make sure that "7z File Manager" is hightlighted. Finally, click on either the "Always" or "Just Once" option.

You should now see a prompt to enter in a password. Enter in the password "infected" and click ok. After the 7z File Manager has opened select the "Extract" option and this should extract the binary to the folder. Finally, move the file to the Desktop. 

<p align="center">
<img src="https://i.imgur.com/KgY4UbG.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The final step that we need to take to set up this attack is to disable the kill switch. Inside the code of Wannacry there exists a function that reaches out to a particular domain before executing. If the connection to that domain is successful the binary will stop executing and nothing will happen. However, if the connection fails the binary will proceed to detonate and encrypt all of the files within the VM. To disable the kill switch we need to modify the "host" file on our Windows VM. The hosts file  is a plain text file used to map hostnames to IP addresses. It overrides the DNS (Domain Name System) settings on the computer, allowing users to specify custom IP addresses for particular domain names. you can find the host file inside this directory:

```powershell
C:\Windows\System32\drivers\etc\
```
Open up the host file with Notepad or Notepad++ and add these two lines :

```
0.0.0.0 www.iuqerfsodp9ifjaposdfjhgosurijfaewrwergwea[.]com
0.0.0.0 iuqerfsodp9ifjaposdfjhgosurijfaewrwergwea[.]com
```
***Note: the URL has been defanged for your safety simply remove brackets from the URL when you enter it in the host file***

<p align="center">
<img src="https://imgur.com/JmDf4KM.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>




Now that are now ready to detonate this malware I recommend to create another snapshot right before this point so that it is easier to detonate the malware again if needed.

</br>

<h3>Attack Execution:</h3>

In order to detonate this malware first we need to disarm it. To do this simply remove ".malz" from the file name. Now that the malware is armed simply right click the file and "Run as Administrator". The malware should have executed and in a few minutes you should see that all of our files on this VM are encrypted and that the "Wannacry" window is up.

<p align="center">
<img src="https://i.imgur.com/x7wOlFm.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/Li1Pzaz.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/6fGfVwV.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>

</p>

After the attack has been executed I recommend that you shutdown your VM and reverting back to your last saved snapshot. We are now ready to create the detection for Wannacry.

</br>

<h2>Wannacry Detection</h2>

<h3>Wannacry Query:</h3>

In order to create our query for this detection first we must ask ourselves what exactly does this malware do when it is executed. If we conduct some malware analysis we would find that this malware makes a ton of configuration changes and windows API calls to the machine. We can use this fact to our advantage by looking for logs in Elastic that relate to the Wannacry ransomware and use that data to create our query. After some analysis of the log this is the query that we are going to use: 

```SQL
data_stream.dataset : "windows.sysmon_operational" and registry.key : "S-1-5-21-1448184758-3733304447-2467847178-1000\\Software\\Microsoft\\Windows NT\\CurrentVersion\\AppCompatFlags\\Compatibility Assistant\\StoreC:\\Users\\User\\Desktop\\Ransomware.wannacry.exe" and registry.value : "Ransomware.wannacry.exe" and message : *wannacry*
```
- data_stream.dataset : "windows.sysmon_operational" this specifies that the query should search within the Windows Sysmon operational logs
- registry.key : "S-1-5-21-1448184758-3733304447-2467847178-1000\\Software\\Microsoft\\Windows NT\\CurrentVersion\\AppCompatFlags\\Compatibility Assistant\\StoreC:\\Users\\User\\Desktop\\Ransomware.wannacry.exe" this part of the query looks for a specific registry key path associated with the Wannacry executable
- registry.value : "Ransomware.wannacry.exe" this specifies the registry value that the query is looking for
- message : *wannacry* this searches for any messages containing the keyword "wannacry"


<p align="center">
<img src="https://imgur.com/Lg5XkV4" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have our query we can move onto creating our detection rule


<h3>Wannacry Detection Rule:</h3>

<b>Define Rule:</b>

Now that we have our query we are now going to create our detection rule. To do this copy the query and click on the hamburger icon on the top-left corner of the page. Scroll down to "Security" and select the "Rules" option. Afterwards click on "Detection Rules (SIEM)" and then select "Create New Rule". Make sure that the "Custom Query" option is selected then scroll down and paste our query. Next scroll down to the "Suppress alerts by" option and enter in "source.ip". Then select "Per time period" and select 10 minutes. What this will do is reduce the noise generated by repetitive alerts by grouping similar alerts together.

<p align="center">
<img src="https://imgur.com/YAzovsv.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next we are going to fill out the About Rule section. We are going to name the alert "WANNACRY DETECTED!!" and enter in a description for the rule. Set the "Default severity" to "Critical" then click on "Advance Settings". Scroll down to until you see "MITRE ATT&CK threats" and select the option for "Impact" for the technique and then add a subtechnique and set it to "Data Encrypted for Impact". Next, add a another MITRE technique and set it to "Persistence" then add another subtechnique and set it to "Boot or Logon Autostart Execution". Afterwards, add another MITRE technique and set it to "Execution" and set the subtechnique to "User Execution". Now add a final MITRE Technique and set it to "Lateral Movement" and set the subtechnique to "Remote Services".

<p align="center">
<img src="https://imgur.com/Mni6Nfv.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/7ttUExq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, we will set the duration for how long the rule should run. We will set the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust this however you'd like.

<p align="center">
<img src="https://i.imgur.com/3cM7k5K.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, we can set what action Elastic should take when this rule triggers. We can set it to send an email, send a message with slack, use microsoft teams etc. For this project we dont have to set it to anything simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://i.imgur.com/8Hm9GXc.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule we can then detonate Wannacry once again and this should trigger the alert. We can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like:

<p align="center">
<img src="https://imgur.com/w7H4Xfi.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


</br>

<h3>Wannacry.exe Complete!</h3>

