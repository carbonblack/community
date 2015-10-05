
class GetUserInput(object):


	@staticmethod
	def Run():
	    userinput=raw_input("y/n/q: ")

	    if userinput=="y":
	        result=True

	    if userinput=="n":
	        result=False

	    if userinput=="q":
	        print colored.red("[-] We aren't done yet, come baaaack!")
	        sys.exit()
	    return result