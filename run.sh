#!/bin/bash
# start hbase
start-hbase.sh
echo "HBase started."
sleep 3

# create tables if necessary
if [ ! -e /opt/tsd_tables_created ]; then
  env COMPRESSION=NONE /opt/opentsdb/tools/create_table.sh
  touch /opt/tsd_tables_created
  echo "HBase tables for opentsdb created!"
fi

# modify opentsdb.conf default settings at first bootstrap
if [ ! -e /opt/tsd_settings_modified ]; then
  # set tsd.core.auto_create_metrics = True
  sed -i 's/#tsd.core.auto_create_metrics = false/tsd.core.auto_create_metrics = true/g' /opt/opentsdb/etc/opentsdb/opentsdb.conf
  # fix: Duplicate timestamp
  echo -e "\n\ntsd.storage.fix_duplicates = true" >> /opt/opentsdb/etc/opentsdb/opentsdb.conf
  # modify ulimit to default max connections
  ulimit -n 65535
  touch /opt/tsd_settings_modified
  echo "Default settings for opentsdb is modified."
fi

# start opentsdb
service opentsdb start
echo "OpenTSDB started."

# tail to keep container running
# make sure tail log is ok
while [ ! -e /var/log/opentsdb/opentsdb.log ]
do
  sleep 1
done
tail -f /var/log/opentsdb/opentsdb.log
