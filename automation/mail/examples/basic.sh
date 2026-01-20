#!/bin/bash

OUTPUT="$(/path/real_command 2>&1)"
STATUS=$?

echo "$OUTPUT" | sendmail-wrapper.sh "Backup job on $(hostname) finished (status=$STATUS)"

exit $STATUS
