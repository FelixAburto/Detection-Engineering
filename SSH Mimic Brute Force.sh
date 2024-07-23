#!/bin/bash

# Define the target user, IP address, and incorrect password
USER="zeek"
IP="192.168.1.66"
PASSWORD="Wrongpassword!"

# Number of attempts
ATTEMPTS=30

# Loop to attempt SSH login
for ((i=1; i<=ATTEMPTS; i++))
do
  echo "Attempt $i"
  sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USER@$IP exit &
  sleep 0.5  # Adding a small delay to ensure proper handling
done

# Wait for all background jobs to finish
wait

echo "All attempts completed."
