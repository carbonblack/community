                           ___
                          ( ((
                           ) ))
  .::.                    / /(     @f4ls3_
 'N .-;-.-.-.-.-.-.-.-.-/| ((::::::::::::::::::::::::::::::::::::::::::::::.._
(J ( ( ( ( ( ( ( ( ( ( ( |  ))   -====================================-      _.>
 `C `-;-`-`-`-`-`-`-`-`-\| ((::::::::::::::::::::::::::::::::::::::::::::::''
  `::'                    \ \(
                           ) ))
                          (_((


Gladius is a terminal applicaiton that allows you to go through Bit9's 'Malicious' and 'Potential Risk' file alerts.  It will check if the file is banned and if it has been seen in Carbon Black.  It will spit out links to VT and the respective locations in CB. It will prompt if you want to ban the file and ban its certificate if it has one.  For users that have more than 1 setup to manage, Gladius takes a config file with server names and API tokens so you can address alerts from both regions.  It can also do a bulk IOC check on hashes from a text file or a single hash from the prompt.
Every analyst's life is made a bit easier when equiped with this tool.  Digesting the alerts is made easy so that more time can be spend hunting the more menacing threats. Hope this is of use :)


Sample:
[+] Checking Malicious File Alerts.
[-] File 'install_temp.exe' [524d9d692a4438b27a6c371f03e47c93b6cf1744815bf8c50b57fa329f6c5d2d] was identified by Bit9 Software Reputation Service as a malicious file.
[*] Hash is not Banned
[*] Checking if Parent MD5 process in Carbon Black...
[+] Not a Parent MD5 process
[*] Checking if MD5 seen in Carbon Black...
[+] MD5 Found in CB.
https://CB-SERVER.com\#search/cb.urlver=1&cb.q.md5=%20213d85f79445b133e011c2cd318f6a6f&sort=&rows=10&start=0
https://www.virustotal.com/latest-report.html?resource=524d9d692a4438b27a6c371f03e47c93b6cf1744815bf8c50b57fa329f6c5d2d
[i] Prevalence: 1
[i] Path: c:\users\USER\appdata\local\temp
[i] Hostname: ADS\HOSTNAME
[?] install_temp.exe is not Banned, shall we?
y/n/q: 





Flow Chart:
               +----------------------+              
               |Bit9 Malicious File   |              
               |or Potential Risk File|              
               +----------+-----------+              
                          |                          
                      +---v---+                      
               |------+Banned?+-------|              
               |      +-------+       |              
             +-++                   +-+-+            
             |No|                   |Yes|            
             +-++                   +-+-+            
               |                      |              
         +-----v----+           +-----v----+         
         |parent_md5|           |parent_md5|         
Check CB |    md5   |           |    md5   | Check CB
         +-----+----+           +-----+----+         
               |                      |              
        Return |                      | Return       
               |                      |              
            +--v--+                +--v--+           
            |Links|                |Links+------+    
            +--+--+                +-----+      |    
               |                                |    
               |                                |    
            +--v-+                              |    
        +---+Ban?+-----+                        |    
        |   +----+     |                        |    
        |              |                        |    
      +-v+           +-v-+                      |    
  +---+No|           |Yes|                      |    
  |   +--+           +-+-+                      |    
  |                    |                        |    
  |                  +-v-+                      |    
  |                  |Ban|                      |    
  |                  +-+-+                      |    
  |                    |                        |    
  |              +-----v------+                 |    
  |       +------+Certificate?+-----+           |    
  |  Ban? |      +------------+     | Ban?      |    
  |       |                         |           |    
  |     +-v+                      +-v-+         |    
  |     |No|                      |Yes|         |    
  |     +-++                      +-+-+         |    
  |       |       +----------+      |           |    
  +-------+------->Next Alert<------+-----------+    
                  +----------+                    



