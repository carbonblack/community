Install the python cbapi from here:

https://github.com/carbonblack/cbapi/blob/release-5.1/client_apis/python/setup.py

You can do python setup.py bdist_rpm and then install the rpm on a redhat/centos system, or just build and install without rpm.

Once you've installed cbapi, you can run the samples from the current directory:

python -m cbcommunity.contrib.search.portable.generic_process_search -u https://127.0.0.1 -t 46c592d82e8a9ae87fe21c981a35434c12c2dc13 -q "notepad.exe"

