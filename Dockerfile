FROM nawer/blazegraph:2.1.5

# Copy setup scripts
COPY setup /setup

# Setup blazegraph with isearch namespace
WORKDIR /var/lib/blazegraph
RUN apk --no-cache add curl; \
nohup java -Xms512m -Xmx1g -jar /usr/bin/blazegraph.jar > /blzg.log 2>&1 & \
echo $! > /tmp/epid; \
/bin/bash /setup/wait-for-it.sh -t 0 localhost:9999 -- \
curl -s -XPOST --data-binary @/setup/iconverse-quads-namespace.xml --header 'Content-Type:application/xml' http://localhost:9999/blazegraph/namespace; \
curl -s -XPOST --data-binary @/setup/isearch-namespace.xml --header 'Content-Type:application/xml' http://localhost:9999/blazegraph/namespace; \
echo; echo 'Blazegraph isearch init completed.'; \
kill $(cat /tmp/epid) && wait $(cat /tmp/epid); exit 0;
