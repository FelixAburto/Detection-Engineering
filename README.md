# WannaCry.exe Ransomware

<br />

<p align="center">
<img src="https://imgur.com/i8NmRpT.png" height="50%" width="50%" alt="Detection Engineering Logo Team Ghost"/>
</p>


<h2>Description</h2>

In this section of the project, we will create a detection rule for WannaCry Ransomware. WannaCry is a ransomware attack that emerged in May 2017, exploiting a vulnerability in the Windows SMB protocol to infect and encrypt users' files. The ransomware then demanded a ransom in Bitcoin to decrypt the files. The attack had a widespread impact, affecting hundreds of thousands of computers around the world and causing significant disruptions across various sectors, including healthcare, finance, and telecommunications.

## ⚠️ DISCLAIMER ⚠️

**HANDLING MALWARE CAN BE EXTREMELY DANGEROUS IF NOT DONE PROPERLY. PLEASE PROCEED WITH CAUTION. I AM NOT RESPONSIBLE FOR ANY DAMAGES THAT MAY OCCUR TO YOUR SYSTEM.**


</br>

<h2>WannaCry Attack</h2>

<h3>Attack Setup:</h2>

The first step in setting up our attack is to properly configure our network settings to ensure safety when detonating the malware. Open Oracle VirtualBox, right-click on the Windows 11 VM, and select "Settings." Next, click on the "Network" option and ensure that Adapter 1 is set to NAT. Then, go to "Adapter 2" and make sure that this virtual network adapter is disabled by setting it to "Not Attached" or by unchecking the "Enable Network Adapter" option.

<p align="center">
<img src="https://imgur.com/cJAEHg9.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/ZKjIZ4Q.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Once that is done, create a snapshot of your current Windows VM configuration. A snapshot is a copy of the system's state at a specific point in time, allowing you to revert to the state before executing WannaCry on your Windows VM. To create a snapshot, hover over the "Machine" option in VirtualBox and select "Take Snapshot."

<p align="center">
<img src="https://imgur.com/QyYopUB.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, we need to install 7-Zip on our Windows 11 VM. Visit [7-Zip's download page](https://www.7-zip.org/download.html) and download the 7-Zip x64 installer. Open the installer and follow the steps to complete the installation on your VM.

<p align="center">
<img src="https://imgur.com/QyYopUB.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Afterwards, download the WannaCry binary onto your Windows VM. Visit [HuskyHacks' PMAT-labs GitHub page](https://github.com/HuskyHacks/PMAT-labs), then click on the green "Code" button. Select "Download ZIP" to get the repository as a zip file.

<p align="center">
<img src="https://imgur.com/emUiHZ9.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Next, extract the WannaCry binary from the ZIP file. Open the ZIP file and navigate to the "PMAT-labs-main" folder, then the "labs" folder. Find the "4.1.Bossfight-WannaCry.exe" folder and extract it to your Desktop. Inside, you will find a file named "Ransomware.wanncry.exe.malz.7z." To extract this file, right-click on it and select "Open With," then choose "Choose Another App." Click on "Choose an app on your PC" and locate the "7-Zip" folder. Select "7zFM.exe" and ensure "7z File Manager" is highlighted. Click "Always" or "Just Once."

When prompted for a password, enter "infected" and click OK. After the 7z File Manager opens, select "Extract" to extract the binary. Move the extracted file to your Desktop.

<p align="center">
<img src="https://i.imgur.com/KgY4UbG.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

The final step to set up this attack is to disable the kill switch. WannaCry contains a function that checks for a specific domain before executing. If the connection to this domain is successful, the binary will not run. To ensure the ransomware detonates, we need to modify the "hosts" file on our Windows VM. This file is a plain text document used to map hostnames to IP addresses, overriding DNS settings and allowing users to specify custom IP addresses for domain names.

You can find the hosts file in this directory:

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

Now that you are ready to detonate the malware, it is advisable to create another snapshot at this point. This will make it easier to revert to a clean state and detonate the malware again if needed.

</br>

<h3>Attack Execution:</h3>

To detonate the malware, first, disarm it by removing the ".malz" extension from the file name. Once the malware is armed, right-click the file and select "Run as Administrator." The malware should execute, and within a few minutes, you should see that all files on the VM are encrypted and the "WannaCry" window appears.

<p align="center">
<img src="https://i.imgur.com/x7wOlFm.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/Li1Pzaz.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://i.imgur.com/6fGfVwV.gif" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>

</p>

After the attack has been executed, it is recommended to shut down your VM and revert to the last saved snapshot. We are now ready to create the detection for WannaCry.

</br>

<h2>WannaCry Detection</h2>

<h3>WannaCry Query:</h3>

To create our query for this detection, we first need to understand the behavior of WannaCry when executed. Malware analysis reveals that WannaCry makes numerous configuration changes and Windows API calls. By leveraging this information, we can search for logs in Elastic that correspond to these activities and use that data to formulate our query. Based on our analysis, the query we will use is:

```SQL
data_stream.dataset : "windows.sysmon_operational" and registry.key : "S-1-5-21-1448184758-3733304447-2467847178-1000\\Software\\Microsoft\\Windows NT\\CurrentVersion\\AppCompatFlags\\Compatibility Assistant\\StoreC:\\Users\\User\\Desktop\\Ransomware.WannaCry.exe" and registry.value : "Ransomware.WannaCry.exe" and message : *WannaCry*
```
- data_stream.dataset : "windows.sysmon_operational" this specifies that the query should search within the Windows Sysmon operational logs
- registry.key : "S-1-5-21-1448184758-3733304447-2467847178-1000\\Software\\Microsoft\\Windows NT\\CurrentVersion\\AppCompatFlags\\Compatibility Assistant\\StoreC:\\Users\\User\\Desktop\\Ransomware.WannaCry.exe" this part of the query looks for a specific registry key path associated with the WannaCry executable
- registry.value : "Ransomware.WannaCry.exe" this specifies the registry value that the query is looking for
- message : *WannaCry* this searches for any messages containing the keyword "WannaCry"


<p align="center">
<img src="https://imgur.com/Lg5XkV4.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

Now that we have our query, we can proceed to create our detection rule.


<h3>WannaCry Detection Rule:</h3>

<b>Define Rule:</b>

Now that we have our query, we can create our detection rule. Start by copying the query and clicking on the hamburger icon at the top-left corner of the page. Scroll down to "Security" and select "Rules." Then click on "Detection Rules (SIEM)" and choose "Create New Rule." Ensure the "Custom Query" option is selected, scroll down, and paste the query. Next, scroll to the "Suppress alerts by" section, enter "source.ip," select "Per time period," and set it to 10 minutes. This will reduce repetitive alerts by grouping similar ones together.

<p align="center">
<img src="https://imgur.com/YAzovsv.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>About Rule:</b>

Next, we need to fill out the "About Rule" section. Name the alert "WANNACRY DETECTED!!" and enter a description for the rule. Set the "Default severity" to "Critical" and click on "Advanced Settings." Scroll down to "MITRE ATT&CK threats," select the "Impact" tactic, and set the technique to "Data Encrypted for Impact." Add another MITRE tactic, set it to "Persistence," and select the technique "Boot or Logon Autostart Execution." Next, add a MITRE tactic for "Execution" and set the technique to "User Execution." Finally, add a MITRE tactic for "Lateral Movement" and set the technique to "Remote Services."

<p align="center">
<img src="https://imgur.com/Mni6Nfv.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
<img src="https://imgur.com/7ttUExq.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Schedule Rule:</b>

Afterward, set the duration for how long the rule should run. Configure the rule to run every 5 minutes with a look-back time of 5 minutes. You can adjust these settings as needed.

<p align="center">
<img src="https://i.imgur.com/3cM7k5K.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Rule Actions:</b>

Finally, configure the action that Elastic should take when this rule triggers. You can choose to send an email, a message with Slack, use Microsoft Teams, etc. For this project, you don't need to set up any actions; simply click on the "Create & Enable rule" button.

<p align="center">
<img src="https://imgur.com/4Sd0G0p.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>

<b>Results:</b>

Now that we have set our rule, detonate WannaCry again to trigger the alert. You can view the alert by going to "Security" and selecting the "Alerts" option. This is what the alert should look like:

<p align="center">
<img src="https://imgur.com/w7H4Xfi.png" height="100%" width="100%" alt="Detection Engineering Logo Team Ghost"/>
</p>


</br>

<h3>WannaCry.exe Complete!</h3>

