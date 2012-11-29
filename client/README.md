Backplane Example Client for Ruby
=================================

Backplane v1.x
--------------
'''
bpclient --channel CHANNEL --realm REALM
'''

Backplane 2
-----------

'''
bp2client -realm REALM
'''

Create a file named .bprc in your home directory. You can add as many realms as you need. Use the --realm command line parameter to select

'''
default: 
  :host : 'backplane1.janrainbackplane.com'
  :port : 80
  :secureport : 443
  :busname : 'your-bus-here'
  :userid : 'your-user-id'
  :password : 'your-password'

realm1:
  :host : 'otherbackplaneserver.tld'
  :port : 80
  :busname : 'bus-name'
  :userid : 'userid'
  :password : 'password'

realm2:
  :host : 'anotherbackplaneserver.tld'
  :busname : 'bus-name'
  :userid : 'userid'
  :password : 'password'
'''
