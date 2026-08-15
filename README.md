# hostpath-risk
Dangerous Volume mount (**[hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)**). Mounts directory from underlying host filesystem (```/```, ```/var/run/docker.sock```, ```/etc```) directly into a container.

```
wget https://raw.githubusercontent.com/ndouglas-edera/hostpid-risk/refs/heads/main/hostpid-risk.sh
chmod +x hostpid-risk.sh
```
Run the demo script:
```
./hostpid-risk.sh
```
