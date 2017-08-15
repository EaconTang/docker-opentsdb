FROM centos:6.6
MAINTAINER <eacon-tang@foxmail.com>


WORKDIR /opt


# install JDK8
RUN yum install -y java-1.8.0-openjdk

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.141-2.b16.el6_9.x86_64/jre
ENV PATH $PATH:$JAVA_HOME/bin
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$CLASSPATH


# install HBase
RUN cd /opt && curl -O https://mirrors.tuna.tsinghua.edu.cn/apache/hbase/stable/hbase-1.2.6-bin.tar.gz
RUN yum install -y tar
RUN tar zxf hbase-1.2.6-bin.tar.gz \
    && mv hbase-1.2.6/ hbase/ \
    && rm -f hbase-1.2.6-bin.tar.gz

ENV HBASE_HOME /opt/hbase
ENV PATH $PATH:$HBASE_HOME/bin

RUN start-hbase.sh

# install tsd
RUN cd /opt && curl -kLO https://github.com/OpenTSDB/opentsdb/releases/download/v2.3.0/opentsdb-2.3.0.rpm
RUN yum install -y gnuplot \
    && rpm -ivh opentsdb-2.3.0.rpm \
    && rm -f opentsdb-2.3.0.rpm \
    && ln -s /usr/share/opentsdb /opt/opentsdb

# set tsd.core.auto_create_metrics = True
RUN sed -i 's/tsd.core.auto_create_metrics = False/tsd.core.auto_create_metrics = True/g' /opt/opentsdb/etc/opentsdb/opentsdb.conf

RUN yum clean all
ADD manage.sh /opt/manage.sh
ENTRYPOINT ["/bin/bash", "/opt/manage.sh"]
EXPOSE 4242 60000 60010 60030
# CMD [""]

