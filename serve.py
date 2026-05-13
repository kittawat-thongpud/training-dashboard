#!/usr/bin/env python3
"""
Simple HTTP server for visualization
Usage: python serve.py [port]
Serves from parent directory (Result/) so /result/api_jobs/ paths work
"""

import http.server
import socketserver
import os
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8080

# Change to parent directory (Result/) so paths match
parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(parent_dir)

class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Add CORS headers for local development
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()
    
    def log_message(self, format, *args):
        # Cleaner logging
        print(f"[{self.log_date_time_string()}] {args[0]}")
    
    def translate_path(self, path):
        # Serve visualization/ subdirectory for root requests
        if path == '/' or path == '/index.html':
            path = '/visualization/index.html'
        elif path.startswith('/detail.html'):
            path = '/visualization' + path
        return super().translate_path(path)

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"="*50)
    print(f"Server running at http://localhost:{PORT}/")
    print(f"Root: {parent_dir}")
    print(f"Press Ctrl+C to stop")
    print(f"="*50)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")
