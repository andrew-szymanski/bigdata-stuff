#!/usr/bin/env python

# Warning! This is Mickey Mouse PoC script which returns a value
# via stdout - so do not add any print / output statements



# https://docs.python.org/3/library/xml.etree.elementtree.html#module-xml.etree.ElementTree
import xml.etree.ElementTree as ET
import string


# read in xml tree
tree = ET.parse('/etc/hive/conf/hive-site.xml')
root = tree.getroot()
nodes = root.findall('property')

# internal hive vars
hive_server2_thrift_port = "10000"
hive_server2_thrift_host = "NULL"
hive_server2_thrift_principal = "NULL"


for prop in nodes:
    name = prop.find('name').text
    if (name == 'hive.server2.thrift.port'):
        value = prop.find('value').text
        hive_server2_thrift_port = value
    # hive.metastore.uris is not strictly accurate and we might need to obtain this value from
    # some other config - but it is good enough for PoC
    if (name == 'hive.metastore.uris'):
        value = prop.find('value').text
        # edit value which is in 'thrift://hostname.com:9083' format
        # remove thrift:///
        value = string.replace(value, 'thrift://', '')
        # remove port number
        hive_server2_thrift_host = value.split(':')[0]
    # Kerberos principal
    if (name == 'hive.metastore.kerberos.principal'):
        value = prop.find('value').text
        # store value which is in 'hive/_HOST@DOMAIN.COM' format
        # we will replace with real hostname once we are finished with xml
        hive_server2_thrift_principal=value


# replace Kerberos principal with real hostname
hive_server2_thrift_principal = string.replace(hive_server2_thrift_principal, '_HOST', hive_server2_thrift_host)
out_content_string="jdbc:hive2://%s:%s/default;principal=%s;auth=kerberos" % (hive_server2_thrift_host, hive_server2_thrift_port, hive_server2_thrift_principal)
print out_content_string
