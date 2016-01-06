import os
import logging
import cbapi
import json
from optparse import OptionParser
import urllib

"""
Imports the output from watchlist exporter
"""

class ImportWatchlists():
    def __init__(self, options):
        self.options = options
        self.cb = cbapi.CbApi(
            options.cb_url,
            token=options.cb_token,
            ssl_verify=False)
        self.watch_lists = []
    def get_watchlists(self):
        with open(self.options.wl_file) as f:
            for line in f:
                while True:
                    try:
                        watch_list = json.loads(line)
                        self.watch_lists.append(watch_list)
                        break
                    except ValueError:
                        # Not yet a complete JSON value
                        line += next(f)

    def add_watchlists(self):
        for watch_list in self.watch_lists:
            wl_name = watch_list.get('Name')
            wl_type = watch_list.get('Type')
            wl_url = watch_list.get('Search String').encode('utf-8')
            wl_url = 'q=' + urllib.quote(wl_url)
            print("-> Adding watchlist %s" % wl_name)
            watchlist = self.cb.watchlist_add(
                wl_type,
                wl_name,
                wl_url)
            print("-> Watchlist added [id=%s]" % (watchlist['id']))

parser = OptionParser()
parser.add_option("--cb_url",
                  action="store",
                  type="string",
                  dest="cb_url",
                  help="URL to CB server")
parser.add_option("--cb_token",
                  action="store",
                  type="string",
                  dest="cb_token",
                  help="Token for CB server")
parser.add_option("--file",
                  action="store",
                  type="string",
                  dest="wl_file",
                  help="File with CB watchlists")
(options, args) = parser.parse_args()

if options.cb_url is None:
    parser.error('Must supply CB URL')
if options.cb_token is None:
    parser.error('Must supply CB URL token')
if options.wl_file is None:
    parser.error('Must supply file')

if __name__ == '__main__':
    import_wl = ImportWatchlists(options)
    import_wl.get_watchlists()
    import_wl.add_watchlists()