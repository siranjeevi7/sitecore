Redis-Server Issue Troubleshooting:

1. Logged into the server and checked the redis-server status.

2. redis-server is in stopped state and after checking the journalctl -xe found that redis-server is trying to read and write log to /var/log/redis-server.log file, but redis-server doesnt have enough permission to do this.

Current LogPath configuration details:

In redis.conf file, redis log path is pointed to /var/log/redis-server.log

In redis systemd file , redis log path is pointed to /var/log/redis/



Issue can be fixed in two ways to make redis work either we need to change the redis.conf file log path to match redis systemd file or we need to update systemd file log path to match redis.conf file. 

1. Change the redis.conf log path to match the redis systemd file.

Redis server conf File Path = /etc/redis/redis.conf

Existing Value "/var/log/redis-server.log"
New Value "/var/log/redis/redis-server.log"


or

2. We can change the systemd d file log path to match redis.conf

Redis systemd file Path = /etc/systemd/system/redis.service 

Existing Value  "ReadWriteDirectories=-/var/log/redis"
New Value 		"ReadWriteDirectories=-/var/log"




