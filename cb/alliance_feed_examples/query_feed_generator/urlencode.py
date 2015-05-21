import sys
import urllib
import optparse

def is_query_complete(query):
    """
    returns indication as to if query includes a q=, cb.q=, or cb.fq
    """
    if query.startswith("cb.urlver="):
        return True
    if query.startswith("q=") or \
       query.startswith("cb.q=") or \
       query.startswith("cb.fq="):
        return True
    return False


def query_encoder(query):
    # unless overridden by operator, prepend a cb.urlver=1&q= to the query if
    # if does not already exist.  this makes it possible for customer to copy and
    # paste query from CB UI, pass through this script, and add to a feed
    #
    # see CBAPI-7

    if not is_query_complete(query):
        return "cb.urlver=1&q=" + urllib.quote(query)
    else:
        return urllib.quote(options.query)
