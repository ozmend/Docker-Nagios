FROM centos/systemd
LABEL maintainer="ozmend@gmail.com" \
        org.label-schema.schema-version="1.0" \
        org.label-schema.docker.cmd="docker run -d --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /opt/nagios/external:/etc/nagios/external:ro -p 8080:80 --name nagios ozmend/nagios" \
        org.label-schema.description="CentOS7 based NAGIOS service" \
        org.label-schema.vendor="Ozmen Emre DEMIRKOL"

# One line install. Change lines according to your requirements.
# For example. You can add only specific nagios plugins, not all.
# This system use sSMTP for nagios notifications. It is simpler.
# sSMTP settings must be re-set according to your environment.

RUN yum update -y; \
        yum install epel-release -y; \
        yum install httpd ssmtp nagios nagios-common nagios-plugins-{ping,disk,users,procs,load,swap,ssh,http,nrpe}  -y; \
        yum clean all; \
        systemctl enable httpd; \
        systemctl enable nagios; \
        htpasswd -b -c /etc/nagios/passwd nagiosadmin nagios; \
        ln -s /usr/share/httpd/noindex/index.html /var/www/html/index.html; \
        mkdir /etc/nagios/external; \
        chmod 750 /etc/nagios/external; \
        chown root.nagios /etc/nagios/external; \
        echo -e "### EXTERNAL Conf Files ###\ncfg_dir=/etc/nagios/external" >> /etc/nagios/nagios.cfg;  \
        echo -e "# 'ntpdate' command defination\ndefine command{\n              command_name    check_ntp_time\n                command_line    '$USER1$'/check_ntp_time -H '$ARG1$' -w '$ARG2$' -c '$ARG3$'\n  }\n\n# 'nrpe' command defination\ndefine command{\n     command_name        check_nrpe\n        command_line     '$USER1$'/check_nrpe -H '$HOSTADDRESS$' -c '$ARG1$'\n        }" >> /etc/nagios/objects/commands.cfg; \
        rm -rf /etc/localtime; \
        ln -s /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
#RUN bash -c "timedatectl set-timezone Europe/Istanbul"  <<< it returns bash error. Do not use it.


EXPOSE 80/tcp

COPY ./contacts.cfg /etc/nagios/objects/
COPY ["ssmtp.conf", "revaliases",  "/etc/ssmtp/"]

CMD ["/usr/sbin/init"]