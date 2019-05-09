# Nagios Docker image. Build on CentOS7/systemd

1- Edit ssmtp.conf, revaliases and contacts.cfg according to your environment.

2- *Create /opt/nagios/external directory to mount on image to change objects(add,remove hosts, switchs etc.)*

---

## Running

docker run -d --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro **-v /opt/nagios/external:/etc/nagios/external:ro** -p 8080:80  --name nagios ozmend/nagios

---

## Restart internal services

docker exec -ti nagios systemctl restart nagios
