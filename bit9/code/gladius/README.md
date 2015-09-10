Gladius is a terminal applicaiton that allows you to go through Bit9's 'Malicious' and 'Potential Risk' file alerts in a jiffy.  It will check if the file is banned and if it has been seen in Carbon Black.  It will spit out links to VT and the respective locations in CB. It will prompt if you want to ban the file and ban its certificate if it has one.  For users that have more than 1 setup to manage, Gladius takes a config file with server names and API tokens so you can address alerts from both regions.  It can also do a bulk IOC check on hashes from a text file or a single hash from the prompt.
Every analyst's life is made a bit easier when equiped with this tool.  Digesting the alerts is made easy so that more time can be spent hunting the more menacing threats. Hope this is of use :)


Sample:<br/>
[+] Checking Malicious File Alerts.<br/>
[-] File 'install_temp.exe' [524d9d692a4438b27a6c371f03e47c93b6cf1744815bf8c50b57fa329f6c5d2d] was identified by Bit9 Software Reputation Service as a malicious file.<br/>
[+] Hash is not Banned<br/>
[+] Checking if Parent MD5 process in Carbon Black...<br/>
[+] Not a Parent MD5 process<br/>
[+] Checking if MD5 seen in Carbon Black...<br/>
[+] MD5 Found in CB.<br/>
hxxps://CB-SERVER.com\#search/cb.urlver=1&cb.q.md5=%20213d85f79445b133e011c2cd318f6a6f&sort=&rows=10&start=0<br/>
hxxps://www.virustotal.com/latest-report.html?resource=524d9d692a4438b27a6c371f03e47c93b6cf1744815bf8c50b57fa329f6c5d2d<br/>
[i] Prevalence: 1<br/>
[i] Path: c:\users\USER\appdata\local\temp<br/>
[i] Hostname: ADS\HOSTNAME<br/>
[?] install_temp.exe is not Banned, shall we?<br/>
y/n/q: <br/>
