# Icinga 2 Proof of Concept

Basic installation of Icinga 2 to pit against Sensu Go and other monitoring systems to help my DevOps team decide which monitoring platform to choose for real-time systems monitoring. 

## assumptions
- working Docker and Docker-compose installation
- "backend" Docker network setup using `docker network create icinga-backend`
- Traefik v1.x Docker-Compose project installed and running (see https://github.com/toozej/mobile_homelab/tree/9642c52acb731ca2f03a0af385b3e74c1df6f346/traefik for configuration used to support this POC)
- `/etc/hosts` entries similar to the following to map to running Docker containers:
    - 127.0.0.1 traefik.lab.test
    - 127.0.0.1 icinga.lab.test
- web browser proxy settings set to exclude `*.test` domain from using any wonky proxy servers
