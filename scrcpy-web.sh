#!/bin/bash
# Simple Web Interface for Scrcpy Smart Connect

PORT="${1:-8080}"

echo "🌐 Starting Scrcpy Web Interface on port $PORT..."

# Create temporary HTML
cat > /tmp/scrcpy-web.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Scrcpy Smart Connect</title>
    <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; }
        button { padding: 10px 20px; margin: 5px; cursor: pointer; }
        .success { color: green; }
        .error { color: red; }
        #output { background: #f5f5f5; padding: 10px; margin-top: 20px; min-height: 100px; }
    </style>
</head>
<body>
    <h1>🚀 Scrcpy Smart Connect</h1>
    
    <h2>Quick Actions</h2>
    <button onclick="run('connect')">Connect</button>
    <button onclick="run('list')">List Devices</button>
    <button onclick="run('scan')">Scan Network</button>
    <button onclick="run('info')">Device Info</button>
    <button onclick="run('perf')">Performance</button>
    
    <h2>Profiles</h2>
    <button onclick="run('profile gaming')">Gaming</button>
    <button onclick="run('profile recording')">Recording</button>
    <button onclick="run('profile demo')">Demo</button>
    
    <h2>Output</h2>
    <div id="output"></div>
    
    <script>
        function run(cmd) {
            document.getElementById('output').innerHTML = 'Running...';
            fetch('/run?cmd=' + encodeURIComponent(cmd))
                .then(r => r.text())
                .then(data => {
                    document.getElementById('output').innerHTML = '<pre>' + data + '</pre>';
                });
        }
    </script>
</body>
</html>
EOF

# Start simple HTTP server
cd /tmp
python3 -m http.server $PORT &
SERVER_PID=$!

echo "✅ Web interface running at: http://localhost:$PORT/scrcpy-web.html"
echo "Press Ctrl+C to stop"

trap "kill $SERVER_PID 2>/dev/null" EXIT
wait $SERVER_PID
