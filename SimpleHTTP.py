## python3 -m http.server 8080
## https://docs.python.org/3/library/http.server.html
##
import http.server
import socketserver
# Import 'sys' module
import sys

from urllib.parse import urlparse
from urllib.parse import parse_qs

host = ""
if sys.argv[1:]:
    port = int(sys.argv[1])
else:
    port = 8080

class SimpleServer(http.server.SimpleHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200, "OK")
        #self.send_header("Content-type", "text/html")
        self.end_headers()

        return http.server.SimpleHTTPRequestHandler.do_GET(self)


# Declare object of the class
webServer = http.server.HTTPServer((host, port), SimpleServer)

# Print the URL of the webserver
print("Web Server serving at port %s" % (port))

try:

    webServer.serve_forever()

except KeyboardInterrupt:

    webServer.server_close()
    print("The server is stopped.")
