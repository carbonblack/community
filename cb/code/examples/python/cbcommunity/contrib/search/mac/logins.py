#!/usr/bin/env python
#
#The MIT License (MIT)
#
# Copyright (c) 2015 Bit9 + Carbon Black
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# -----------------------------------------------------------------------------
# last updated 2015-03-07 by Ben Johnson bjohnson@bit9.com
#

from cbcommunity.util.cli_helpers import main_helper

def main(cb, args):

    print "UI Logins (CoreServicesUIAgent)"

    for proc in cb.process_search_iter('process_name:CoreServicesUIAgent', start=0, rows=200):
        print "%s,%s,%s" % (proc.get('start'), proc.get('hostname'), proc.get('username'))
    print

    print "SSH Sessions (sshd -> bash)"

    for proc in cb.process_search_iter('parent_name:sshd process_name:bash', start=0, rows=200):
        print "%s,%s,%s" % (proc.get('start'), proc.get('hostname'), proc.get('username'))
    print

if __name__ == "__main__":
    main_helper("Search for OSX logins via particular processes.", main)