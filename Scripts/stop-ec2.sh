#!/bin/bash

# Get the list of EC2 instances
instances=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value | [0], InstanceId, KeyName, PublicIpAddress]' --output json)
num_instances=$(($(echo "$instances" | jq length)))

# Check if there are any instances
if [ -z "$instances" ] || [ "$num_instances" -eq 0 ]; then
    echo "No running EC2 instances found."
    exit 1
fi

# Display the list of instances and prompt the user to select one
echo "Available EC2 instances:"
instance_iteration_count=1
for i in $(seq 1 $num_instances); do
    instance_name=$(echo "$instances" | jq -r ".[$instance_iteration_count-1][0]")
    instance_id=$(echo "$instances" | jq -r ".[$instance_iteration_count-1][1]")
    instance_key=$(echo "$instances" | jq -r ".[$instance_iteration_count-1][2]")
    instance_ip=$(echo "$instances" | jq -r ".[$instance_iteration_count-1][3]")
    printf "%2d: NAME: %s  ID: %s  KEY: %s  IP: %s\n" "$instance_iteration_count" "$instance_name" "$instance_id" "$instance_key" "$instance_ip"
    instance_iteration_count=$((instance_iteration_count + 1))
done

echo -n "Enter the instance number you want to stop: "
read instance_number

# Validate the user input
if ! [[ "$instance_number" =~ ^[0-9]+$ ]] || [ "$instance_number" -lt 1 ] || [ "$instance_number" -gt "$num_instances" ]; then
    echo "Invalid instance number selected."
    exit 1
fi

# Get the selected instance details
selected_instance=$(echo "$instances" | jq -r ".[$instance_number-1]")
instance_id=$(echo "$selected_instance" | jq -r ".[1]")
instance_name=$(echo "$selected_instance" | jq -r ".[0]")

echo "Stopping instance $instance_id..."
aws ec2 stop-instances --instance-ids "$instance_id"
echo "Stop command issued successfully."
