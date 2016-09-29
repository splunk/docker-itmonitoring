import os
import sys

import splunk
import time
import splunk.search

SSLIST = ['__generate_lookup_containername']
APP_NAME = __file__.split(os.sep)[-3]

if __name__ == '__main__':

    token = sys.stdin.readlines()[0]
    token = token.strip()

    # the first time our container spins up... lets give it a few seconds to
    # index those container logs
    time.sleep(15)

    for ss in SSLIST:
        job = splunk.search.dispatch(' | savedsearch %s' % ss, sessionKey=token, namespace=APP_NAME)
        splunk.search.waitForJob(job)
        job.cancel()