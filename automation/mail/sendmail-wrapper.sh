#!/bin/bash

MAIL_TO="admin@example.com"
HOST="$(hostname)"
SUBJECT="$1"

TMPFILE="/tmp/mail.$$"
cat > "$TMPFILE"

(
echo "From: cron@$HOST"
echo "To: $MAIL_TO"
echo "Subject: $SUBJECT"
echo "MIME-Version: 1.0"
echo "Content-Type: text/plain; charset=UTF-8"
echo
cat "$TMPFILE"
) | /usr/sbin/sendmail -t -i

rm -f "$TMPFILE"
