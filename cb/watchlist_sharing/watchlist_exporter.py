import cbapi
import urlparse
import urllib
import json
from optparse import OptionParser


"""
Exports watchlists into a sharable format for readying by a human and importable by a script
"""

def export(options):
    cb = cbapi.CbApi(
        options.cb_url,
        token=options.cb_token,
        ssl_verify=False)
    watch_lists = cb.watchlist()
    for watch_list in watch_lists:
        seach_string = u''
        url = urllib.unquote(options.cb_url + '?' + watch_list.get('search_query'))
        parsed = urlparse.urlparse(url)
        for parameter, value in urlparse.parse_qs(parsed.query).iteritems():
            # make things like 'cb.q.netconn_count' turn into 'netconn_count:'
            if 'cb.q.' in parameter:
                search_param = parameter.replace('cb.q.', '')
                seach_string += u' ' + search_param + u': ' + value[0]
            # If it's "&q=" then we don't need to do any special formatting
            if parameter == 'q':
                seach_string += u' ' + value[0]
        wl = {
            "Name": watch_list.get('name'),
            "URL": watch_list.get('search_query'),
            "Type": watch_list.get('index_type'),
            "Search String": seach_string.strip(),
            "Description": "Please fill in if you intend to share this."
        }
        print(json.dumps(wl, indent=4))

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
(options, args) = parser.parse_args()

if options.cb_url is None or options.cb_token is None:
    parser.error('Must supply CB URL and token')

if __name__ == "__main__":
    export(options)