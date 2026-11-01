# A stand-in webhook receiver for check.sh: webhook-stub.py PORT FILE answers
# every POST with 204 and appends its body to FILE, one line per request.
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer


class Receiver(BaseHTTPRequestHandler):
    def do_POST(self):
        body = self.rfile.read(int(self.headers.get("Content-Length", 0)))
        with open(sys.argv[2], "ab") as received:
            received.write(body.replace(b"\n", b" ") + b"\n")
        self.send_response(204)
        self.end_headers()

    def log_message(self, format, *args):
        pass


HTTPServer(("127.0.0.1", int(sys.argv[1])), Receiver).serve_forever()
