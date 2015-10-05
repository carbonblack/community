import re,time,os
from clint.textui import colored
from Bit9.FindComputer import FindB9Computer
from Carbonblack.FindComputer import FindCBComputer

class ComputerLookup(object):
    
    def __init__(self, filename):
        computerlist=[]
        bit9count=0
        cbcount=0

        currentdir=os.getcwd()
        resultfile=filename.rsplit('/',1)[1]
        lookupfile=open(currentdir+"/"+resultfile+"-lookup-results.csv", "wb")
        lookupfile.writelines("computer,bit9,carbon black, os\n")
        for computer in open(filename):
            computerlist.append(computer.rstrip())

        print colored.yellow("[*] Checking "+str(len(set(computerlist))))+" unique machines."
        time.sleep(4)
        for computer in set(computerlist):
            ostype=None
            print colored.yellow("[*] Looking for "+str(computer.upper().rstrip()))
            bit9lookup=FindB9Computer.Run("ADS\\"+str(computer.upper().rstrip()))
            if  bit9lookup !=[]:
                bit9agent=True
                bit9count+=1
                ostype=str(bit9lookup[0]['osName'])
                print colored.green("[+] Has a Bit9 Agent!")
            else:
                print colored.red("[+] NO Bit9 Agent.")
                bit9agent=False

            cblookup = FindCBComputer.Run(computer.upper().rstrip())
            if cblookup !=[]:
                ostype=str(cblookup[0]['os_environment_display_string'])
                cbagent=True
                cbcount+=1
                print colored.green("[+] Has a Carbon Black Agent")
            else:
                print colored.red("[+] Has NO Carbon Black Agent")
                cbagent=False
            lookupfile.writelines(computer.rstrip()+","+str(bit9agent)+","+str(cbagent)+","+str(ostype).replace(",","")+"\n")
        lookupfile.close()
        print colored.magenta("[?] Total Lookups: "+str(len(set(computerlist))))
        print colored.magenta("[?] Bit9 Computers Found: "+str(bit9count))
        print colored.magenta("[?] Carbon Black Computers Found: "+str(bit9count))
        print colored.magenta("[?] Output can be found at "+str(currentdir+"/"+resultfile+"-lookup-results.csv"))