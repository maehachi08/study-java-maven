FROM amazonlinux:2 AS java-builder

RUN set -ex && \
  amazon-linux-extras enable corretto8 && \
  yum install -y java-1.8.0-amazon-corretto java-1.8.0-amazon-corretto-devel maven

COPY ./hello-world /tmp/hello-world
WORKDIR /tmp/hello-world
RUN set -ex && mvn clean package

FROM amazonlinux:2 as enable-systemd

# reference to Systemd integration
# https://hub.docker.com/_/centos?tab=description
RUN set -ex && \
  yum install -y vim less which tar net-tools && \
  yum -y install procps systemd-sysv rsyslog && \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
# VOLUME [ "/sys/fs/cgroup" ]

FROM enable-systemd as tomcat-env
# java
RUN set -ex && \
  amazon-linux-extras enable corretto8 && \
  yum install -y java-1.8.0-amazon-corretto java-1.8.0-amazon-corretto-devel

# tomcat
COPY ./files/tomcat/etc/sysconfig/tomcat /etc/sysconfig/tomcat
COPY ./files/tomcat/etc/systemd/system/tomcat.service /etc/systemd/system/tomcat.service
ARG TOMCAT_VERSION="9.0.30"
RUN set -ex && \
  useradd -s /sbin/nologin tomcat && \
  curl -O http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
  tar xzvf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt && \
  chown -R tomcat:tomcat /opt/apache-tomcat-${TOMCAT_VERSION} && \
  ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/apache-tomcat && \
  ln -s /opt/apache-tomcat-${TOMCAT_VERSION}/logs /var/log/tomcat && \
  echo "export CATALINA_HOME=/opt/apache-tomcat" > /etc/profile.d/tomcat.sh && \
  echo "export CATALINA_OPTS=-Djava.security.manager -Djava.security.policy=/opt/apache-tomcat/conf/catalina.policy" > /etc/profile.d/tomcat.sh && \
  chmod 755 /etc/systemd/system/tomcat.service && \
  systemctl enable tomcat.service

COPY ./files/tomcat/opt/apache-tomcat/conf/tomcat-users.xml /opt/apache-tomcat/conf/tomcat-users.xml
COPY ./files/tomcat/opt/apache-tomcat/webapps/manager/META-INF/context.xml /opt/apache-tomcat/webapps/manager/META-INF/context.xml

FROM tomcat-env as tomcat-httpd-env

RUN set -ex && \
  yum install -y openssl httpd mod_ssl && \
  systemctl enable httpd.service

# ssl certificate file
RUN set -ex && \
  mkdir -p /etc/httpd/certs && \
  cd /etc/pki/tls/certs && \
  openssl genrsa -out server.key 2048 && \
  openssl req \
    -utf8 \
    -new \
    -key server.key \
    -out server.csr \
    -subj "/C=JP/ST=Tokyo/L=Arakawa-ku/O=Test/OU=my house/CN=maepachi.com" && \
  openssl x509 -in server.csr -out server.crt -req -signkey server.key -days 365 && \
  cp /etc/pki/tls/certs/{ca-bundle.crt,server.crt,server.key} /etc/httpd/certs/

COPY ./files/apache/etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf
COPY --from=java-builder /tmp/hello-world/target/hello-world.war /opt/apache-tomcat/webapps/
EXPOSE 443
CMD ["/usr/sbin/init"]
