[![](https://images.microbadger.com/badges/version/neomediatech/dovecot-honey.svg)](https://microbadger.com/images/neomediatech/dovecot-honey)
[![](https://images.microbadger.com/badges/image/neomediatech/dovecot-honey.svg)](https://microbadger.com/images/neomediatech/dovecot-honey)
![](https://img.shields.io/github/last-commit/Neomediatech/dovecot-honey.svg?style=plastic)
![](https://img.shields.io/github/repo-size/Neomediatech/dovecot-honey.svg?style=plastic)

Dockerized version of Dovecot as honeypot service, based on Ubuntu

## Usage
You can run this container with this command:  
`docker run -d --name dovecot-honey -p 110:110 -p 143:143 -p 993:993 -p 995:995 neomediatech/dovecot-honey`  

Logs are written inside the container, in /var/log/dovecot/dovecot.log, and on stdout. You can see realtime logs running this command:  
`docker logs -f dovecot-honey`  
`CTRL c` to stop seeing logs.  

If you want to map logs outside the container you can add:  
`-v /folder/path/on-host/logs/:/data/logs/`  
Where "/folder/path/on-host/logs/" is a folder inside your host. You have to create the host folder manually.  

You can run it on a compose file like this:  

```
version: '3'  

services:  
  dovecot:  
    image: neomediatech/dovecot-honey:latest  
    hostname: dovecot-honey  
    ports:  
      - '110:110'  
      - '143:143'  
      - '993:993'  
      - '995:995'  
```
Save on a file and then run:  
`docker stack deploy -c /your-docker-compose-file-just-created.yml dovecot-honey`

If you want to map logs outside the container you can add:  
```
    volumes:
      - /folder/path/on-host/logs/:/data/logs/
```
Where "/folder/path/on-host/logs/" is a folder inside your host. You have to create the host folder manually.

Save on a file and then run:  
`docker stack deploy -c /your-docker-compose-file-just-created.yml dovecot-honey`  
