#!/bin/bash

COUNTRY=$1
COUNT=5

if [ -z "$COUNTRY" ]; then
  echo "Usage: sudo bash extract-multiple.sh [2-letter COUNTRY CODE]"
  exit 1
fi

echo "⚙️ Setting NordVPN to use NordLynx..."
nordvpn set technology nordlynx > /dev/null 2>&1

for ((i=1; i<=COUNT; i++)); do
  echo ""
  echo "🔌 [$i/$COUNT] Connecting to $COUNTRY..."
  nordvpn c $COUNTRY > /dev/null 2>&1
  sleep 5

  if ! sudo wg showconf nordlynx > /dev/null 2>&1; then
    echo "❌ Failed to extract config (maybe no connection)"
    nordvpn d > /dev/null 2>&1
    continue
  fi

  SERVER=$(nordvpn status | grep Hostname | awk '{print $2}')
  PUBLIC_KEY=$(sudo wg showconf nordlynx | grep PublicKey)
  PRIVATE_KEY=$(sudo wg showconf nordlynx | grep PrivateKey)
  LISTEN_PORT=$(sudo wg showconf nordlynx | grep ListenPort)
  ALLOWED_IPS=$(sudo wg showconf nordlynx | grep AllowedIPs)
  ENDPOINT=$(sudo wg showconf nordlynx | grep Endpoint)
  KEEPALIVE=$(sudo wg showconf nordlynx | grep PersistentKeepalive)

  FILE="${SERVER}.conf"
  echo "📄 Saving to $FILE..."

  echo "[Interface]" > "$FILE"
  echo "$PRIVATE_KEY" >> "$FILE"
  echo "$LISTEN_PORT" >> "$FILE"
  echo "Address = 10.5.0.$((i+1))/32" >> "$FILE"
  echo "DNS = 103.86.96.100, 103.86.99.100" >> "$FILE"

  echo "" >> "$FILE"
  echo "[Peer]" >> "$FILE"
  echo "$PUBLIC_KEY" >> "$FILE"
  echo "$ALLOWED_IPS" >> "$FILE"
  echo "$ENDPOINT" >> "$FILE"
  echo "$KEEPALIVE" >> "$FILE"

  echo "✅ $FILE created."

  # نمایش QR code
  echo ""
  echo "📷 QR Code for $FILE:"
  qrencode -t ANSIUTF8 < "$FILE"

  nordvpn d > /dev/null 2>&1
  sleep 2
done

echo ""
echo "🎉 Done extracting $COUNT configs from $COUNTRY."

