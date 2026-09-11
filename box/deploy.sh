#!/usr/bin/env bash
# Push the box halves of the Mac<->linuxbox bridges to the box.
#
# The Mac halves are symlinked into place by ../make_links.sh, but these run on
# linuxbox, so they get copied instead. This script is the only thing keeping
# the repo and the box in sync -- edit here, deploy, don't edit on the box.
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
HOST="${1:-linuxbox}"

echo "==> ~/bin on $HOST"
scp -q "$DIR"/fido-uhid "$DIR"/pbcopy "$DIR"/pbpaste "$HOST":bin/
ssh "$HOST" 'chmod +x ~/bin/fido-uhid ~/bin/pbcopy ~/bin/pbpaste'

echo "==> /usr/local/bin/fido-uhid (sudo resets PATH, and ~/bin is not on its secure_path)"
ssh "$HOST" 'sudo ln -sfn "$HOME/bin/fido-uhid" /usr/local/bin/fido-uhid'

echo "==> fido-uhid.service"
scp -q "$DIR"/fido-uhid.service "$HOST":/tmp/fido-uhid.service
ssh "$HOST" 'sudo install -m 0644 /tmp/fido-uhid.service /etc/systemd/system/fido-uhid.service \
    && rm -f /tmp/fido-uhid.service \
    && sudo systemctl daemon-reload \
    && sudo systemctl enable --now fido-uhid.service \
    && sudo systemctl restart fido-uhid.service'

ssh "$HOST" 'systemctl is-active fido-uhid && systemctl is-enabled fido-uhid'
echo "==> done"
