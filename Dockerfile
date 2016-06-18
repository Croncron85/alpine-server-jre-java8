FROM alpine:latest

ENV JAVA_VERSION_MAJOR 8 \
    JAVA_VERSION_MINOR 92 \
    JAVA_VERSION_BUILD 14 \
    JAVA_PACKAGE server-jre \
    JAVA_HOME=/jre \
    PATH=${PATH}:/jre/bin \
    LANG=C.UTF-8
    
RUN apk add --no-cache --update --virtual=build-dependencies curl ca-certificates && \
 cd /tmp && \
 curl -o glibc-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" && \
 apk add --allow-untrusted glibc-2.21-r2.apk && \
 curl -o glibc-bin-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" && \
 apk add --allow-untrusted glibc-bin-2.21-r2.apk && \
 /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
 echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
 curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie"\
  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | gunzip -c - | tar -xf - && \
  apk del build-dependencies && \
  mv jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}/jre /jre && \
  rm /jre/bin/jjs && \
  rm /jre/bin/keytool && \
  rm /jre/bin/orbd && \
  rm /jre/bin/pack200 && \
  rm /jre/bin/policytool && \
  rm /jre/bin/rmid && \
  rm /jre/bin/rmiregistry && \
  rm /jre/bin/servertool && \
  rm /jre/bin/tnameserv && \
  rm /jre/bin/unpack200 && \
  rm /jre/lib/ext/nashorn.jar && \
  rm /jre/lib/jfr.jar && \
  rm -rf /jre/lib/jfr && \
  rm -rf /jre/lib/oblique-fonts && \
  rm -rf /tmp/* /var/cache/apk/*
  
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/urandom"]
