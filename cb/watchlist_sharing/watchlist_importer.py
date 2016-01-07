import os
import logging
import cbapi
import json
import urllib
from cbapi.util.cli_helpers import main_helper

"""
Imports the output from watchlist exporter
"""

class ImportWatchlists():
    def __init__(self, cb, args):
        self.args = args
        self.cb = cb
        self.watch_lists = []

    def confirm(self, watch_list):
        prompt = 'Export watchlist %s? y/n: ' % (watch_list.get('Name'))
        while True:
            answer = raw_input(prompt)
            if not answer:
                return True
            if answer not in ['y', 'Y', 'n', 'N']:
                print 'Please enter y or n.'
                continue
            if answer in ['Y', 'y']:
                return True
            if answer in ['N', 'n']:
                return False

    def get_watchlists(self):
        watchlist_file = open(self.args.get('input_file'), 'r')
        data = watchlist_file.read()
        json_data = json.loads(data)
        for watch_list in json_data.get('Watchlists'):
            # Only get that specific watchlist
            if self.args.get('watchlists'):
                if watch_list.get('Name') not in self.args.get('watchlists').split(","):
                    continue
            # If we're being selective, ask the user
            if self.args.get('selective_import'):
                answer = self.confirm(watch_list)
                if not answer:
                    continue
            self.watch_lists.append(watch_list)

    def add_watchlists(self):
        for watch_list in self.watch_lists:
            wl_name = watch_list.get('Name')
            wl_type = watch_list.get('Type')
            wl_url = watch_list.get('SearchString').encode('utf-8')
            print("-> Adding watchlist %s" % wl_name)
            watchlist = self.cb.watchlist_add(
                wl_type,
                wl_name,
                wl_url)
            print("-> Watchlist added [id=%s]" % (watchlist['id']))

def main(cb, args):
    import_wl = ImportWatchlists(cb, args)
    import_wl.get_watchlists()
    import_wl.add_watchlists()

if __name__ == "__main__":
    selective_import = ("-m", "--selective", "store_true", False, "selective_import", "Select what watchlsits to import")
    input_file = ("-f", "--file", "store", False, "input_file", "Select what file holds watchlists")
    watchlists = ("-w", "--watchlists", "store", False, "watchlists", "Specific watchlist(s) to import. Can be comma separated.")
    main_helper(
        "Imports watchlists from a sharable format",
        main,
        custom_required=[input_file],
        custom_optional=[selective_import,watchlists])

