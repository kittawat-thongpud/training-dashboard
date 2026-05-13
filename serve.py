#!/usr/bin/env python3
"""
Simple HTTP server for visualization
Usage: python serve.py [port]
Serves from current directory (visualization/)
"""

import http.server
import socketserver
import os
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8080

# Stay in current directory (visualization/)
current_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(current_dir)

class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Add CORS headers for local development
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()
    
    def log_message(self, format, *args):
        # Cleaner logging
        print(f"[{self.log_date_time_string()}] {args[0]}")
    
    def translate_path(self, path):
        # Default: serve from current directory
        if path == '/':
            path = '/index.html'
        return super().translate_path(path)

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"="*50)
    print(f"Server running at http://localhost:{PORT}/")
    print(f"Root: {current_dir}")
    print(f"Press Ctrl+C to stop")
    print(f"="*50)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")
