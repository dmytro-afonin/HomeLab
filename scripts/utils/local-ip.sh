#!/usr/bin/env bash
# Get local IP address for network access

IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)

if [ -n "$IP" ]; then
  echo "📍 Local IP: $IP"
  echo ""
  echo "Access Open WebUI on your network:"
  echo "   http://$IP:3000"
else
  echo "❌ Could not detect local IP"
  echo "   Check System Settings → Wi-Fi → Details"
fi
