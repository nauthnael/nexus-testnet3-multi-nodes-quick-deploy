## Nexus Testnet 3 Multi-Nodes Quick Deploy

This repository provides a Bash script to quickly deploy multiple Nexus Testnet nodes using tmux sessions on a Linux system. Each node runs the `nexus-cli start` command with specified node IDs and limited threads, while checking for sufficient system memory (RAM + Swap).

## Features
- Prompts for a list of node IDs.
- Calculates available memory and verifies if it meets requirements (5GB per node).
- Creates detached tmux sessions for each node.
- Handles existing sessions by terminating them before recreation.

## Prerequisites
- Linux environment (tested on Ubuntu/Debian-based systems).
- `tmux` installed (`sudo apt install tmux`).
- `nexus-cli` installed and accessible in your PATH.
- `bc` for floating-point calculations (`sudo apt install bc`).
- Sufficient RAM/Swap (at least 5GB per node).

## Usage
For a streamlined deployment, execute the following one-liner command in your terminal (click the copy button in the code block to copy it directly):

```
curl -L -o nexus-tmux-advanced.sh https://raw.githubusercontent.com/nauthnael/nexus-testnet3-multi-nodes-quick-deploy/refs/heads/main/nexus-tmux-advanced.sh && chmod +x nexus-tmux-advanced.sh && ./nexus-tmux-advanced.sh
```

Alternatively, follow these step-by-step instructions:

1. Clone the repository:
   ```
   git clone https://github.com/your-username/nexus-testnet3-multi-nodes-quick-deploy.git
   cd nexus-testnet3-multi-nodes-quick-deploy
   ```
2. Make the script executable:
   ```
   chmod +x nexus-tmux-advanced.sh
   ```
3. Run the script:
   ```
   ./nexus-tmux-advanced.sh
   ```
4. When prompted, enter node IDs (one per line) and press Ctrl+D to finish.
5. Confirm the memory check and proceed if sufficient resources are available.

## Script Overview
The script performs the following:
- Reads node IDs from user input.
- Computes total available memory using `/proc/meminfo`.
- Validates if memory >= (number of nodes * 5GB).
- Creates tmux sessions named `n1`, `n2`, etc., running `nexus-cli start --node-id <ID> --max-threads 1`.

## Example Node IDs
For testing, you can use a sample list like:
```
12988723
13074143
# ... (add more as needed)
```

## Troubleshooting
- **Insufficient Memory**: Increase RAM or Swap, or reduce the number of nodes.
- **Tmux Errors**: Ensure tmux is installed and sessions are not locked.
- **Nexus-CLI Issues**: Verify `nexus-cli` is properly configured for the Testnet.

## License
MIT License (or your preferred license).

## Contributions
Pull requests are welcome for improvements, such as adding error handling or supporting more configurations.
