#!/bin/bash

{
  echo "Starting job..."
  /path/real_command
  echo "Finished with code $?"
} 2>&1 | sendmail-wrapper.sh "Nightly Job Report"
