#!/bin/bash

# Set up logging
LOG_DIR="/var/log/server_cleanup"
MAIN_LOG="${LOG_DIR}/cleanup.log"
ERROR_LOG="${LOG_DIR}/error.log"

# Create log directory if it doesn't exist
if ! mkdir -p "$LOG_DIR"; then
    echo "Failed to create log directory: $LOG_DIR" >&2
    exit 1
fi

# Ensure log files are writable
touch "$MAIN_LOG" "$ERROR_LOG" || { echo "Failed to create log files" >&2; exit 1; }

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$MAIN_LOG"
}

# Function to log errors
log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $1" >> "$ERROR_LOG"
}

# Function to run a command and log any errors
run_command() {
    local cmd="$1"
    local description="$2"
    
    log_message "Starting: $description"
    if ! eval "$cmd"; then
        log_error "Failed: $description"
        log_error "Command: $cmd"
    else
        log_message "Completed: $description"
    fi
}

# Function to safely clean up Docker resources
safe_docker_cleanup() {
    log_message "Starting safe Docker cleanup"

    # Remove dangling images (untagged images)
    run_command "docker image prune -f" "Remove dangling Docker images"

    # Remove unused volumes
    run_command "docker volume prune -f" "Remove unused Docker volumes"

    # Remove unused networks
    run_command "docker network prune -f" "Remove unused Docker networks"

    # Remove exited containers older than 7 days
    run_command "docker container prune -f --filter 'until=168h'" "Remove old exited Docker containers"

    log_message "Safe Docker cleanup completed"
}

# Host cleanup
log_message "Starting host system cleanup"

run_command "apt-get clean" "Clear APT cache"
run_command "apt-get autoremove -y" "Remove unnecessary packages"
run_command "journalctl --vacuum-time=30d" "Clear systemd journal logs"
run_command "find /var/log -type f -name '*.log' -mtime +30 -delete" "Remove old log files"

# Perform safe Docker cleanup
safe_docker_cleanup

# SonarQube cleanup
log_message "Starting SonarQube container cleanup"

# Function to safely execute commands in the SonarQube container
sonarqube_exec() {
    local cmd="$1"
    local description="$2"
    
    run_command "docker exec sonarqube bash -c \"$cmd\"" "$description"
}

# Check for ce_reports directory and clean if it exists
sonarqube_exec "
if [ -d /opt/sonarqube/data/ce_reports ]; then
    find /opt/sonarqube/data/ce_reports -type f -mtime +30 -delete
elif [ -d /opt/sonarqube/extensions/ce_reports ]; then
    find /opt/sonarqube/extensions/ce_reports -type f -mtime +30 -delete
else
    echo 'ce_reports directory not found in expected locations'
fi
" "Remove old SonarQube analysis reports"

# Clean SonarQube logs
sonarqube_exec "
if [ -d /opt/sonarqube/logs ]; then
    find /opt/sonarqube/logs -type f -name '*.log' -mtime +30 -delete
else
    echo 'Logs directory not found in expected location'
fi
" "Clear SonarQube logs"

# Jenkins cleanup
log_message "Starting Jenkins container cleanup"

run_command "docker exec jenkins bash -c \"find /var/jenkins_home/workspace -type d -mtime +30 -exec rm -rf {} +\"" "Remove old Jenkins workspace files"
run_command "docker exec jenkins bash -c \"find /var/jenkins_home/logs -type f -name '*.log' -mtime +30 -delete\"" "Clear Jenkins logs"
run_command "docker exec jenkins bash -c \"find /var/jenkins_home/jobs -type f -name 'archive' -mtime +30 -delete\"" "Remove old Jenkins archived artifacts"

log_message "Cleanup completed"

# Check if there were any errors
if [ -s "$ERROR_LOG" ]; then
    log_message "Errors occurred during cleanup. Check $ERROR_LOG for details."
else
    log_message "No errors encountered during cleanup."
fi