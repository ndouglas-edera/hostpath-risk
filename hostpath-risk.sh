#!/usr/bin/env bash
set -euo pipefail

# Terminal formatting
RED="\033[0;31m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
ORANGE="\033[38;5;208m"
MAGENTA="\033[0;35m"
BOLD="\033[1m"
NC="\033[0m"

step() {
    local intent="$1"
    local cmd="$2"
    
    echo -e "\n${ORANGE}----------------------------------------------------${NC}"
    echo -e "${ORANGE}${BOLD}INTENT:${NC} ${ORANGE}${intent}${NC}"
    echo -e "${ORANGE}----------------------------------------------------${NC}"
    echo -e "${MAGENTA}$ ${cmd}${NC}"
    echo -en "${CYAN}[Press ENTER to execute command...]${NC}"
    read -r
    echo ""
    eval "$cmd"
}

cleanup() {
    echo -e "\n${CYAN}Triggering cleanup of demo resources...${NC}"
    kubectl delete pod hostpath-demo-pod --force --grace-period=0 --ignore-not-found=true >/dev/null 2>&1
    echo -e "${GREEN}Cleanup complete. Cluster returned to clean state.${NC}"
}

trap cleanup EXIT SIGINT

clear
echo -e "${CYAN}====================================================${NC}"
echo -e "${CYAN}    Safe hostPath Mount Verification Demo           ${NC}"
echo -e "${CYAN}====================================================${NC}"

# --- STEP 1 ---
step "STEP 1: Deploy a pod with a hostPath volume mount (Read-Only OS release path)." \
"cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-demo-pod
spec:
  containers:
  - name: inspector
    image: alpine:latest
    command: [\"/bin/sh\", \"-c\", \"while true; do sleep 3600; done\"]
    volumeMounts:
    - name: host-os-info
      mountPath: /mnt/host-os
      readOnly: true
  volumes:
  - name: host-os-info
    hostPath:
      path: /etc/os-release
      type: File
EOF"

# --- STEP 2 ---
step "STEP 2: Wait for pod readiness and inspect the hostPath spec in custom columns." \
"kubectl wait --for=condition=Ready pod/hostpath-demo-pod --timeout=60s && kubectl get pod hostpath-demo-pod -o custom-columns='NAME:.metadata.name,HOSTPATH_VOLUMES:.spec.volumes[*].hostPath.path,MOUNT_PATHS:.spec.containers[*].volumeMounts[*].mountPath'"

# --- STEP 3 ---
step "STEP 3: Verify the mount inside the container by reading the mapped file." \
"kubectl exec hostpath-demo-pod -- cat /mnt/host-os"

# --- STEP 4 ---
step "STEP 4: Check Kubernetes events associated with the pod creation." \
"kubectl get events --field-selector involvedObject.name=hostpath-demo-pod --sort-by='.metadata.creationTimestamp' | tail -n 5"

echo -e "\n${GREEN}Demo walkthrough completed successfully!${NC}"
