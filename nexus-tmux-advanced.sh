#!/bin/bash

# Function to get total available memory (RAM + Swap) in GB
get_available_memory() {
    # Get free RAM in KB from /proc/meminfo
    free_ram_kb=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    # Get free Swap in KB from /proc/meminfo
    free_swap_kb=$(grep SwapFree /proc/meminfo | awk '{print $2}')
    
    # Convert to GB (1 GB = 1048576 KB)
    total_free_kb=$((free_ram_kb + free_swap_kb))
    total_free_gb=$(echo "scale=2; $total_free_kb / 1048576" | bc)
    echo "$total_free_gb"
}

# Prompt user to input node IDs
echo "Enter the list of node IDs (one per line). Press Ctrl+D or Ctrl+C when done:"
node_ids=()
while IFS= read -r line; do
    # Skip empty lines
    [[ -z "$line" ]] && continue
    node_ids+=("$line")
done

# Check if any node IDs were provided
if [ ${#node_ids[@]} -eq 0 ]; then
    echo "Error: No node IDs provided. Exiting."
    exit 1
fi

# Calculate memory requirements
nodes_count=${#node_ids[@]}
required_memory=$((nodes_count * 5)) # Each node requires 5GB
available_memory=$(get_available_memory)

# Compare available memory with required memory
if (( $(echo "$available_memory < $required_memory" | bc -l) )); then
    echo "Insufficient memory: $available_memory GB available, but $required_memory GB required for $nodes_count nodes."
    echo "Each node requires 5GB. Cannot proceed."
    exit 1
else
    echo "Sufficient memory: $available_memory GB available for $required_memory GB required by $nodes_count nodes."
    echo "Node IDs to be processed:"
    for id in "${node_ids[@]}"; do
        echo "- $id"
    done
    echo -n "Proceed with creating $nodes_count tmux sessions? (y/n): "
    read -r confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled by user."
        exit 0
    fi
fi

# Create tmux sessions for each node ID
for i in "${!node_ids[@]}"; do
    session="n$((i+1))"
    node_id="${node_ids[$i]}"
    command="nexus-cli start --node-id $node_id --max-threads 1"
    
    # Terminate the session if it exists, then create a new detached session
    tmux kill-session -t "$session" >/dev/null 2>&1
    tmux new-session -d -s "$session" "$command"
    echo "Created tmux session $session for node-id $node_id"
done

echo "All $nodes_count tmux sessions have been created successfully."
