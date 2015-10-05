from clint.textui import colored
from Carbonblack.CheckExecution import CheckExecution
from Modules.GetUserInput import GetUserInput
from Bit9.BanHash import BanHash
from Bit9.BanCertificate import BanCertificate

class EvalHashState(object):

    @staticmethod
    def Run(hashstate,event):
        authJson={
         'X-Auth-Token': "30FC583B-8D49-4EE9-B34C-D7612C82898C", 
         'content-type': 'application/json'
                      }
        serverurl="https://chimeraus.autodesk.com"+str("/api/bit9platform/v1/")
        b9StrongCert=True

        if event==None:
            if hashstate[0]['effectiveState']!='Banned':
                print colored.yellow("[*] Hash is not Banned")
                CheckExecution.Run(hashstate[0]['md5'])
                print colored.cyan("https://www.virustotal.com/latest-report.html?resource="+str(hashstate[0]['sha256']))
                print colored.cyan("[i] Prevalence: "+str(hashstate[0]['prevalence']))
                print colored.cyan("[?] File Name: "+str(hashstate[0]['fileName']))
                print colored.cyan("[?] Path: "+str(hashstate[0]['pathName']))
                try:
                    print colored.magenta("[?] "+str(hashstate[0]['fileName'])+" is not Banned, shall we?")
                except:
                    print colored.yellow("[*] Can't print filename, strange characters.")
                    pass
                userinput=get_user_input()
                if userinput==True:
                    bit9.ban_hash(hashstate[0]['sha256'], hashstate[0]['fileName'])
                if userinput==False:
                    print colored.yellow("[*] Okay then, not banning the hash.")

                if hashstate[0]['publisherState']>0:
                    print colored.magenta("[?] "+hashstate[0]['fileName']+" also has a publisher, "+hashstate[0]['publisher']+" shall we Ban it?")
                    userinput=get_user_input()
                    if userinput==True:
                        bit9.ban_certificate(hashstate)

                    if userinput==False:
                        print colored.yellow("[*] Okay then, not banning the Certificate.")
            else:
                print colored.yellow("[*] Hash is banned.")
                print colored.magenta("[?] Check Carbon Black?")
                userinput=GetUserInput.Run()
                if userinput==True:
                    CheckExecution.Run(hashstate[0]['md5'])

        else:
            if hashstate[0]['effectiveState']!='Banned':
                print colored.yellow("[*] Hash is not Banned")
                CheckExecution.Run(hashstate[0]['md5'])
                print colored.cyan("https://www.virustotal.com/latest-report.html?resource="+str(hashstate[0]['sha256']))
                print colored.cyan("[i] Prevalence: "+str(hashstate[0]['prevalence']))
                try:
                    print colored.cyan("[i] Path: "+str(event['pathName']))
                except:
                    print colored.yellow("[*] Can't print out path, probably some character encoding issues...")
                    print event
                    pass
                print colored.cyan("[i] Hostname: "+str(event['computerName']))
                if hashstate[0]['publisher']=='':
                    pass
                else:             
                    print colored.cyan("[i] Publisher: "+str(hashstate[0]['publisher']))
                try:
                    print colored.magenta("[?] "+str(hashstate[0]['fileName'])+" is not Banned, shall we?")
                except:
                    print colored.yellow("[*] Can't print filename, strange characters.")
                    pass
                userinput=GetUserInput.Run()
                if userinput==True:
                    BanHash.Run(hashstate[0]['sha256'], hashstate[0]['fileName'])
                if userinput==False:
                    print colored.yellow("[*] Okay then, not banning the hash.")

                if hashstate[0]['publisherState']>0:
                    print colored.magenta("[?] "+hashstate[0]['fileName']+" also has a publisher, "+hashstate[0]['publisher']+" shall we Ban it?")
                    userinput=GetUserInput.Run()
                    if userinput==True:
                        BanCertificate.Run(hashstate)

                    if userinput==False:
                        print colored.yellow("[*] Okay then, not banning the Certificate.")
            else:
                if hashstate[0]['fileName']==None:
                    print colored.yellow("[*] Hash "+str(hashstate[0]['sha256'])+" is Banned but has no File Name, "+"https://www.virustotal.com/latest-report.html?resource="+str(hashstate[0]['sha256']))
                else:
                    try:
                        print colored.yellow("[*] "+str(hashstate[0]['fileName'])+" is "+hashstate[0]['effectiveState']+", https://www.virustotal.com/latest-report.html?resource="+str(hashstate[0]['sha256']))
                    except:
                        print colored.yellow("[*] Strange characters, can't print.")
                        pass