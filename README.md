# NordVPN WireGuard Config Extractor with QR

A lightweight Bash script that connects to multiple NordVPN servers in a given country using the NordLynx (WireGuard) protocol, extracts their WireGuard configuration, and generates ready-to-use `.conf` files along with terminal-displayed QR codes for mobile use.

## Features

- ✅ Automatically connects to multiple NordVPN servers in a country of your choice
- ✅ Extracts WireGuard configuration including `PrivateKey`, `PublicKey`, `Endpoint`, etc.
- ✅ Saves config to `.conf` files compatible with the WireGuard app
- ✅ Displays a QR code for each config directly in terminal
- ✅ Disconnects after each server to cycle through multiple

## Requirements

- NordVPN CLI installed and logged in via `sudo nordvpn login`
- WireGuard tools
- qrencode (for generating terminal QR codes)
- Linux (tested on Debian/Ubuntu)

```bash
sudo apt update
sudo apt install wireguard-tools qrencode curl jq -y
```

## Usage

```bash
sudo bash extract-multiple.sh [2-letter COUNTRY CODE]
```

Example:

```bash
sudo bash extract-multiple.sh de  # Extracts 5 DE configs
```

## Output

For each successful connection, a file like `de456.nordvpn.com.conf` is created.
Each file contains a complete WireGuard config, and a QR code is displayed for easy import into the WireGuard mobile app.

## Security Notes

- The script does not store your credentials
- Private keys are only stored in the generated `.conf` files
- Do **not** share these `.conf` files with others unless you know what you're doing

## License

MIT License — feel free to use and modify. Stars appreciated!

## Available Translations

- 🇮🇷 [فارسی (Persian)](README.fa.md)
