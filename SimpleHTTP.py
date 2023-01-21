#!/usr/bin/env python3
"""Python Simple HTTP Server

References:
https://docs.python.org/3/library/http.server.html
https://docs.python.org/3/library/argparse.html
https://docs.python.org/3/howto/argparse.html
"""
__version__ = "0.1.2"

import os
import sys
import time
import argparse
import textwrap
import functools
import http.server
import socketserver


class HTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    """Simple HTTP Request Handler

    Handler serves files from the current directory and any
    of its subdirectories.
    """

    server_version = "Python SimpleHTTP Server"
    sys_version = ""

    def __init__(self, *args, directory=None, **kwargs):
        if directory is None:
            directory = os.getcwd()

        self.directory = os.fspath(directory)
        super().__init__(*args, directory=self.directory, **kwargs)

    def do_GET(self):
        """Serve a `GET` request. Interpreting the request as a path"""

        self.send_response(200, "OK")  # HTTPStatus.OK
        # Sends the response header only, used for the purposes when
        # `100 Continue` response is sent by the server to the client.
        #
        # self.send_response_only(200, "OK")

        # Disabled. The HTTP header is not be writen to the outgoing
        # stream
        #
        # self.send_header("Content-type", "text/html")
        #
        # Must be called in order to complete the operation send_header()
        # self.end_headers()

        return http.server.SimpleHTTPRequestHandler.do_GET(self)


def main():
    """Simple HTTP Server"""

    # Process the input options with `argparse`
    parser = argparse.ArgumentParser(
        add_help=True,
        formatter_class=argparse.RawTextHelpFormatter,
        epilog="",
        description=textwrap.dedent(
            """Python Simple HTTP Server to serve files in a specified directory"""
        ),
    )
    parser.add_argument(
        "-v",
        "--version",
        action="version",
        version="%(prog)s {}".format(__version__),
        help=textwrap.dedent(
            """\
            show the current script version
            """
        ),
    )
    parser.add_argument(
        "-p",
        "--port",
        action="store",
        required=False,
        default=8080,
        dest="serverPort",
        metavar="SERVER_PORT",
        type=int,
        help=textwrap.dedent(
            """\
            server port. If not specified, the default port `%(default)s`
            is used. Value must be in the range of non-priviliged
            TCP/IP ports from 1024 to 65535
            """
        ),
    )
    parser.add_argument(
        "-s",
        "--disk-size",
        action="store",
        required=False,
        choices=["default", "32", "48", "72"],
        default="default",
        dest="diskSize",
        metavar="DISK_SIZE",
        type=str,
        help=textwrap.dedent(
            """\
            host or virtual machine disk size in GB or `default`.
            By default is  interactive mode  will be  used if the
            argument is not specified.
            Available values: %(choices)s GBs
            """
        ),
    )

    args = parser.parse_args()

    serverRoot = os.getcwd() + "/" + args.diskSize
    serverHost = "0.0.0.0"  # all interfaces by default
    if args.serverPort in range(1024, 65536):
        serverPort = int(args.serverPort)
    else:
        print(
            "Incorrect server port number specified: {}!".format(repr(args.serverPort))
        )
        print()
        print(
            "Value must be in the range of non-priviliged TCP/IP ports\nfrom 1024 to 65535."
        )
        print()
        sys.exit(1)

    # requestHandler = HTTPRequestHandler
    requestHandler = functools.partial(HTTPRequestHandler, directory=serverRoot)

    # Declare HTTP Server object
    httpServer = http.server.HTTPServer((serverHost, serverPort), requestHandler)

    # Print the URL of the webserver
    print("HTTP Server serving at {0}:{1}".format(serverHost, serverPort))

    try:
        httpServer.serve_forever()
    except KeyboardInterrupt as keyboardInterrupt:
        print("Stopping HTTP server...", end="")
        httpServer.server_close()
        print("\r", end="")
        time.sleep(0.3)
        print("{:25s}".format("The server is stopped."))


if __name__ == "__main__":
    sys.exit(main())
