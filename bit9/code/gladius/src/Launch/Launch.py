import argparse
from clint.textui import colored


class Launch(object):
    
  def get_args(self):
      parser = argparse.ArgumentParser(description='Terminal application for remediating Bit9 alerts in a Jiffy.')
      parser.add_argument('-c','--config-file', action='store', dest="configfile", help="Config file for Carbon Black and Bit9 settings.", required=True)
      args = parser.parse_args()
      return args

  def load_cb_config(self,configile):
          print colored.yellow("[*] Loading config file.")
          cfile= open(configile, "r").readlines()
          cbserverurl=str(cfile[0].rstrip())
          cbapitoken=str(cfile[1].rstrip())
          b9serverurl=str(cfile[2].rstrip())
          b9apitoken=str(cfile[3].rstrip())

          print colored.green("[+] Completed.\n")
          return (cbserverurl,cbapitoken,b9serverurl,b9apitoken)


  def show_logo(self):
      print colored.green("""
                   ______
                  /     /\\
                 /     /##\\
                /     /####\\
               /     /######\\
              /     /########\\
             /     /##########\\
            /     /#####/\#####\\
           /     /#####/++\#####\\
          /     /#####/++++\#####\\ @f4ls3_
         /     /#####/\+++++\#####\\
        /     /#####/  \+++++\#####\\
       /     /#####/    \+++++\#####\\
      /     /#####/      \+++++\#####\\
     /     /#####/        \+++++\#####\\
    /     /#####/__________\+++++\#####\\
   /                        \+++++\#####\\
  /__________________________\+++++\####/
  \+++++++++++++++++++++++++++++++++\##/
   \+++++++++++++++++++++++++++++++++\/
    ``````````````````````````````````
          """)

  @staticmethod
  def show_logo2():

      print colored.cyan("""
             |`-._/\_.-`|    1 = 'Malicious File'
             |    ||    |    2 = 'Potential Risk File'
             |___o()o___|    3 = FireEye 'Malicious File'
             |__((<>))__|    4 = Hash
             \   o\/o   /    5 = Certificate (not finished)
              \   ||   /     6 = Computer lookup
               \  ||  /      0 = Exit
                '.||.'       
                  ``
          """)


  def show_logo3(self):
      print colored.cyan("""
                                  .-.
                                 {{@}}
                 <>               8@8
               .::::.             888
           @\\\/W\/\/W\//@         8@8
            \\\/^\/\/^\//     _    )8(    _
             \_O_<>_O_/     (@)__/8@8\__(@)
        ____________________ `~"-=):(=-"~`
       |<><><>  |  |  <><><>|     |@|
       |<>      |  |      <>|     |f|
       |<>      |  |      <>|     |4|
       |<>   .--------.   <>|     |l|
       |     |   ()   |     |     |s|
       |_____| (O\/O) |_____|     |3|
       |     \   /\   /     |     |_|
       |------\  \/  /------|     |||   
       |       '.__.'       |     |'|
       |        |  |        |     |.|
       :        |  |        :     |||
        \<>     |  |     <>/      |'|
         \<>    |  |    <>/       |.|
          \<>   |  |   <>/        |||
           `\<> |  | <>/'         |'|
             `-.|  |.-`           \ /
                '--'               ^

          """)

  def show_logo4(self):
    print colored.green("""
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


      """)