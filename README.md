# NetworkSecurity-Project
Network Security project about SSH, Database and SQL Injection.
# Network Scheme
![Network](/network_scheme.svg)

- Sql Network
  1. Web Server hosting a stub site using NodeJS
  2. MySQL Server hosting sensitive information
- Lan Network
  1. BobPC which represent the hacker host
  2. TomPC which represent the target host

# Background Scenario
This lab is about a industrial espionage, represented by Bob, who is infiltrated inside a company lan network and found, among a lot of other devices, one vulnerable computer that belongs to Tom.

# SQL Injection Procedure
```" OR 1<2; -- ``` 