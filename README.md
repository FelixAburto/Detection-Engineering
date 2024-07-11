# Detection Engineering Project

<br />


<h2>Description</h2>

This project utilizes Elastic Security SIEM to create a comprehensive detection engineering framework designed to ingest, monitor, and analyze data from three distinct environments. The objective is to effectively detect various simulated cyber threats, enhancing overall security posture.

<br />

# Environment Details

### **Environment 1 : Internal Network 10.0.0.0/24**
- <b>Ubuntu (Zeek/Bro, 10.0.0.3):</b> Deployed with Zeek/Bro For network traffic monitoring and analysis
- <b>Windows 11 (10.0.0.4):</b> Serves as the victim machine to capture and analyze the effects of the attacks
- <b>Parrot OS (10.0.0.5):</b> Functions as the attack machine to simulate different types of cyber attacks

<br />

### **Environment 2 : Internal Network 192.168.1.0/24**
- <b>Ubuntu (Zeek/Bro, 192.168.1.3):</b> Deployed with Zeek/Bro For network traffic monitoring and analysis
- <b>Windows 11 (192.168.1.4):</b> Serves as the victim machine to capture and analyze the effects of the attacks
- <b>Parrot OS (192.168.1.5):</b> Functions as the attack machine to simulate different types of cyber attacks
- <b>Kali Linux (192.168.1.6):</b> Additional attak machine to introduce a broader range of attack vectors

<br />

### **Environment 3 : Azure Cloud Environment**
- <b>Apache Web Server VM (Ubuntu):</b> Hosts the Damn Vulnerable Web Application to simulate web application attacks
- <b>Azure Storage Account:</b> Contains a blob file to similute data exfiltration and unauthorized access
- <b>Azure Key Vault:</b> Stores secret values to simulate unauthorize access. 

<br />
<br />

<p align="center">
<img src="https://i.imgur.com/88JdlYu.png" height="100%" width="100%" alt="Detection Engineering Diagram"/>
</p>

<h2>Languages Used</h2>

- <b>Bash:</b> File integrity monitor and Automation of Incident Response tasks

<h2>Utilities Used</h2>

- <b>Oracle Virtual Box:</b> virtual machines running Ubuntu Linux

<h2>Scenario</h2>

One of the employees received a phishing email and unwittingly downloaded a malicious PDF file. Upon opening the PDF, the employee noticed nothing was displayed. Assuming it was harmless, the employee disregarded it and continued with their day. Unbeknownst to them, the PDF was actually a Trojan that had installed a backdoor on their system. A malicious actor now has access to the system via OpenSSH and has started searching for any sensitive data they can steal. On the system there is a confidential file that should only be accessed by authorized users. 

<h2>Preparation</h2>

The preparation phase is a crucial part of the incident response process. This phase involves establishing and maintaining the capability to respond effectively to incidents. Key elements of the preparation phase include:

### **Developing an Incident Response Policy and Plan:** 
  - Creating a formal document that defines the scope, objectives, and procedures for incident response.
  - Tailoring the plan to the organization's size, structure, and nature of operations.

### **Setting up an Incident Response Team:** 
  - Forming a team responsible for executing the incident response plan.
  - Including members with skills in IT, security, legal, and communications.

### **Providing Necessary Tools and Resources:** 
  - Equipping the team with tools for detecting, analyzing, and mitigating incidents.
  - Ensuring access to necessary hardware, software, and other resources.

### **Training and Awareness:** 
  - Conducting regular training and awareness programs for the incident response team and staff.
  - Preparing them for identifying and responding effectively to incidents.

### **Establishing Communication and Reporting Protocols:** 
  - Setting up effective communication channels and reporting procedures.
  - Ensuring timely information sharing during an incident.

### **Creating and Maintaining Documentation:** 
  - Keeping records of incident response activities and lessons learned.
  - Using documentation for handling future incidents and improving response strategies.

### **Establishing Relationships with External Entities:** 
  - Coordinating with law enforcement, external incident response teams, and other relevant organizations.

The goal of the preparation phase is to ensure that when an incident occurs, the organization is ready to respond swiftly and efficiently to minimize damage and restore normal operations as quickly as possible.

<br />

In this scenario we are going to assume that the company has taken all the necessary steps for proper preparation. The system administrator also implemented the proper file permissions on the confidential file and has a file monitor script running that was provided by a security analyst for an additional layer of protection.

<p align="center">
  <img src="https://i.imgur.com/qL8A8Po.png" width="500" />
  <img src="https://i.imgur.com/1hT6V5t.png" width="500" /> 
</p>



<h2>The Security Incident</h2>

The malicious actor connects to the system through OpenSSH:

<p align="center">
<img src="https://i.imgur.com/aCbt89g.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
</p>

<br />

The malicious actor accesses the root account and traverses through the file system and finds a confidential file:

<p align="center">
<img src="https://i.imgur.com/uTNqELK.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
</p>

<br />

The malicious actor attempts to copy the file but fails due to restricted file permissions:

<p align="center">
<img src="https://i.imgur.com/yvHMVy4.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
</p>

<br />

The malicious actor tries to read the file permissions of the confidential file which triggers the file integrity monitor script:

<p align="center">
<img src="https://i.imgur.com/gLo0C5N.gif" height="150%" width="150%" alt="Image Analysis Dataflow"/>
</p>

<br />

Finally the malicious actor tries to reconnect back to the system but fails:

<p align="center">
<img src="https://i.imgur.com/X41c3LO.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
</p>

<br />

<h2>Detection and Analysis</h2>


The Detection and Analysis phase involves identifying potential security incidents and analyzing them to confirm their nature and scope.


### **Detection:**
   - We get an alert describing that the system that contains confidential files has been logged in and that the password has changed during off hours.
   - We try to log in with the password that the script sets to all accounts if unauthorized access to the file is detected. We are successful which confirms that someone has tried to access confidential data.
   - ***(Note: In a real world scenario you would want this password to be as secure as possible to avoid further access attempts.)*** 
 
<p align="center">
<img src="https://i.imgur.com/6zqqUNA.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
</p>

<br />

### **Analysis:** 

   - Once the security analyst is logged in they can see that there are several txt files that were created on the desktop. This results from automating the task of investigating and extracting the information needed for further analysis.


      <p align="center">
      <img src="https://i.imgur.com/96D9U4c.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
      </p>

   - The script has created these files:
     <br />

        - **UNAUTH_ACCESS.txt:** This file contains information from the auditd logs. From these logs we can determine when and who tried to access the confidential file. From the logs we can tell that the original user who initiated the process was "user1" and from there they accessed the root account.

      <p align="center">
      <img src="https://i.imgur.com/IoQujx2.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
      </p    

        - **Bash History Files:** Once the script is triggered it goes through and extracts the information from all the bash history files for all users and creates a txt file for each user's command history. This can help us determine what commands were used during the security incident. From the root_history.txt we can see that the root account was used to try to copy the file and that the attacker tried to view the file permissions of the file which ultimately triggered the file monitor. 

      <p align="center">
      <img src="https://i.imgur.com/ZCJnHEP.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
      </p>   

        - **IP_PORTS_CONNECTION.txt:** The script also captures information about what connections were active during the time of incident. As we can see our internal ip address had port 22 open and that port was connected to another ip address through a random port. This can help us determine where the attack came from.
            - ***(Note: In a real world scenario the attackers ip address would appear as a public ip address not an internal address)***  
 
       <p align="center">
       <img src="https://i.imgur.com/07uTUXk.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
       </p>
      
        - **HASH_COMPARISON.txt:** The script contains a known good SHA256 hash value and when the unauthorized access is detected the script recalculates the SHA256 hash of the file and outputs both the known and the calculated hash. This helps us determine if the integrity of the confidential file was compromised. As we can see both the hash values are the same which indicates that file integrity was preserved.
     
       <p align="center">
       <img src="https://i.imgur.com/Geo8THE.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
       </p>

     - Other Analysis: We ask the user of this system if they had recently notice any unusual behavior on their system. The employee tells us that there was this incident where he downloaded a pdf file thinking it was an invoice and when they tried to open it there was a black box that flashed briefly but nothing else happened. They figured the file was corrupt and went about their day. Upon further investigation we determine that the pdf file was downloaded from a phishing email that they had received. 

       - **Email Phishing Analysis:** We download the eml file of the phishing email and extract relevant information for analysis
    
          <p align="center">
          <img src="https://i.imgur.com/pe6P72j.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
          </p>

       - **Unauthorized Administrator Privileges:** Upon further investigation we discover that the user account for the employee has administrator privileges which aided the attacker in infiltrating the system.
       - **Unauthorized Root Access:** We also discover that the user account for the employee has access to the root account of this system because there is currently no password set for the root account.


<h2>Containment, Eradication, and Recovery</h2>


In the Containment, Eradication, and Recovery phase of NIST 800-61, there are three main steps:

The initial step, Containment, focuses on immediate action to halt the spread of a cybersecurity incident. The primary objective here is to quickly isolate affected systems and networks, effectively cutting off the problem from impacting additional resources. This step is critical in limiting the extent of damage and maintaining control over the situation.

Following containment, the Eradication process begins. This involves thoroughly removing the source of the security breach. Actions taken during this stage include the elimination of harmful software and rectifying any security weaknesses that were exploited. The aim is to ensure that the threat is completely - removed and cannot recur.

The final step, Recovery, is about restoring and stabilizing the affected systems. It involves careful steps to ensure that systems are not just back online but are also secure and monitored for any signs of the issue reappearing. This step is crucial for resuming normal operations while maintaining vigilance against future security threats.

### **Containment:** 

- The bash script automates this step of the incident response lifecycle by performing two main functions

    - Logs out all users from their current logon session and changes the password of all account on the system. This prevents local threats from accessing the confidential file. 

       <p align="center">
       <img src="https://i.imgur.com/gLo0C5N.gif" height="150%" width="150%" alt="Image Analysis Dataflow"/>
       </p>
       
    - Shuts down all network interfaces on the system. This completely removes the system from all networks preventing remote threats from accessing the confidential file. 

       <p align="center">
       <img src="https://i.imgur.com/Kil7zCf.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
       </p>
      
 ### **Eradication:**
 
- The most effective method of eradication for this scenario is to restore from a last known good backup. This will ensure that all traces of the trojan used to infiltrate the system is removed.

     <p align="center">
     <img src="https://i.imgur.com/rjoYThU.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
     </p>

### **Recovery:**

- For this step we can remediate the system by ensuring that the system is secure. We can do this by performing these tasks:
   - Removing Administrator privileges from the user account
     <p align="center">
     <img src="https://i.imgur.com/B7RIpVE.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
     </p>
   - Blocking SSH port from being accessed
     <p align="center">
     <img src="https://i.imgur.com/shVFiTZ.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
     </p>
   - Removing OpenSSH from the system
     <p align="center">
     <img src="https://i.imgur.com/n9qBf0S.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
     </p>
   - Change root account password to a secure password
     <p align="center">
     <img src="https://i.imgur.com/1QK6pnm.png" height="85%" width="85%" alt="Image Analysis Dataflow"/>
     </p>
   - Blocking the attacker's email address used for the phishing email      
   - Conducting User Awareness Training to inform the user about phishing attacks and other social engineering attacks.
 


<h2>Post-Incident Activity</h2>


The Post-Incident Activity phase is the final stage of the incident response lifecycle. This phase is important for improving future security measures and incident response strategies. Key elements include:

### Incident Documentation
- Recording details of the incident, including detection, response actions, timeline, and outcome.

### Analysis of the Incident
- Understanding the incident's nature, the effectiveness of the response, and deriving lessons learned.

### Review of Incident Handling Procedures
- Updating response procedures based on the incident analysis to improve future responses.

### Updating Security Measures
- Addressing any exposed vulnerabilities or security gaps highlighted by the incident.

### Sharing Information
- Disseminating information about the incident with internal teams, external partners, and sometimes the public or government agencies.

### Recovery and Resumption of Normal Operations
- Ensuring all systems are operational and any temporary measures are reverted or updated.

### Training and Awareness
- Conducting training and raising awareness based on the lessons learned to improve skills and knowledge.

In this scenario, we will assume that our incident response team went through all key activities for this phase and that our Incident Response Handling Procedures are now properly updated.




