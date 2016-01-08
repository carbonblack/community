import cbapi
import urlparse
import urllib
import json
import datetime
from cbapi.util.cli_helpers import main_helper

"""
Exports watchlists into a sharable format that's readable by a script or human
"""

class Export():
    def __init__(self, cb, args):
        self.cb = cb
        self.args = args
        self.watch_lists = []

    def confirm(self, watch_list):
        prompt = 'Export watchlist %s? y/n: ' % (watch_list.get('name'))
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
        watch_lists = self.cb.watchlist()
        for watch_list in watch_lists:
            # Only export specific watchlists
            if self.args.get('watchlists'):
                if watch_list.get('name') not in self.args.get('watchlists').split(","):
                    continue
            # If we're being selective, ask the user
            if self.args.get('selective_export'):
                answer = self.confirm(watch_list)
                if not answer:
                    continue

            search_string = u''
            url = urllib.unquote(self.args.get('server_url') + '?' + watch_list.get('search_query'))
            parsed = urlparse.urlparse(url)
            for parameter, value in urlparse.parse_qs(parsed.query).iteritems():
                # make things like 'cb.q.netconn_count' turn into 'netconn_count:'
                if 'cb.q.' in parameter:
                    search_param = parameter.replace('cb.q.', '')
                    search_string += u' ' + search_param + u':' + value[0]
                # If it's "&q=" then we don't need to do any special formatting
                if parameter == 'q':
                    search_string += u' ' + value[0]
            wl = {
                "Name": watch_list.get('name'),
                "URL": watch_list.get('search_query'),
                "Type": watch_list.get('index_type'),
                "SearchString": search_string.strip(),
                "Description": "Please fill in if you intend to share this."
            }
            self.watch_lists.append(wl)

    def export_watchlists(self):
        export = {
            "Author": "Fill in author",
            "ExportDate": datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
            "ExportDescription": "Fill in description",
            "Watchlists": self.watch_lists,
        }
        output = json.dumps(export, indent=4)
        output_file = open(self.args.get('output_file'), 'w')
        output_file.write(output)
        print("-> Done exporting! <-")

def main(cb, args):
    export = Export(cb, args)
    export.get_watchlists()
    export.export_watchlists()

if __name__ == "__main__":
    selective_export = ("-m", "--selective", "store_true", False, "selective_export", "Select what watchlsits to export")
    output_file = ("-f", "--file", "store", False, "output_file", "Select what file output is written to")
    watchlists = ("-w", "--watchlists", "store", False, "watchlists", "Specific watchlist(s) to export. Can be comma separated.")
    main_helper(
        "Export watchlists into a sharable format",
        main,
        custom_required=[output_file],
        custom_optional=[selective_export,watchlists])
