# start hbase
start-hbase.sh 1>/dev/null
echo "HBase started."
sleep 3

# create tables if necessary
if [ ! -e /opt/tsd_tables_created ]; then
  env COMPRESSION=NONE /opt/opentsdb/tools/create_table.sh
  touch /opt/tsd_tables_created
  echo "HBase tables for opentsdb created!"
fi

# start opentsdb
service opentsdb start
echo "OpenTSDB started."

# tail to keep container running
tail -f /var/log/opentsdb/opentsdb.log

