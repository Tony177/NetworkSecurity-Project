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

# Start

In order to start this Lab, you've to connect to BobPC with ssh, on your local machine run in any console this command:
```bash
ssh kali@localhost -p 2222
```
and as password insert "_*kali*_".

Now you're connected to BobPC, start the hacking!