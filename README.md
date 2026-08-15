## Read-only inspection of mounted volumes via hostPath 

The goal here was to create an interactive demo script that shows why a (**[hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)**) mount is a security risk and how microVM/isolated runtimes like **[Edera Protect](https://edera.dev/containers)** would address it. While I probably cannot write functional exploit scripts to Github that automate container escapes, host ```chroot``` ops, or any sort of directory traversal onto the underlying node, I can use this repo to show users how to safely demo the read-only inspection of mounted volume paths in a controlled test environment, alongside audit commands that prove the misconfiguration exists. This is a simple PoC of a dangerous volume (through ```hostpath```) mounting a directory from an underlying host filesystem (```/```,  ```/etc```, ```/var/run/docker.sock```) directly into a container.

```
wget https://raw.githubusercontent.com/ndouglas-edera/hostpath-risk/refs/heads/main/hostpath-risk.sh
chmod +x hostpath-risk.sh
```
Run the demo script:
```
./hostpath-risk.sh
```

<img width="1506" height="858" alt="Screenshot 2026-08-15 at 23 20 06" src="https://github.com/user-attachments/assets/176e93b6-9df2-4598-900e-b18425c06aff" />
