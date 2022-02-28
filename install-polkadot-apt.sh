# Installation depuis apt
# Import the security@parity.io GPG key
gpg --recv-keys --keyserver hkps://keys.mailvelope.com 9D4B2B6EB8F97156D19669A9FF0812D491B96798
gpg --export 9D4B2B6EB8F97156D19669A9FF0812D491B96798 > /usr/share/keyrings/parity.gpg
# Add the Parity repository and update the package index
echo 'deb [signed-by=/usr/share/keyrings/parity.gpg] https://releases.parity.io/deb release main' > /etc/apt/sources.list.d/parity.list
apt update
# Install the `parity-keyring` package - This will ensure the GPG key
# used by APT remains up-to-date
apt install parity-keyring
# Install polkadot
apt install polkadot


# TEST
## Non archive mode
#polkadot \
#	--validator \
#  --chain kusama \
#  --name 'TA NODE' \
#  --unsafe-pruning \
#  --pruning=1000 \
#  --telemetry-url 'wss://telemetry.polkadot.io/submit/ 1'

# Purge Chain ⚠️
#polkadot purge-chain --chain kusama

# Systemd
sudo cp service/manode.service /etc/systemd/system/manode.service

# Deamon-reload
sudo systemctl daemon-reload
#sudo systemctl start manode.service
#sudo systemctl status manode.service

# Verifications : journalctl -f -u manode -n100
