FROM debian:stretch-slim

ENV DEBIAN_FRONTEND noninteractive
ENV ARCH 86_64

# install dependencies
RUN apt-get -q update && \
    apt-get install -y libatomic1 \
                       python3 \
                       supervisor \
                       wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    groupadd dropbox && \
    useradd -m -d /home/dropbox -c "Dropbox Daemon Account" -s /usr/sbin/nologin -g dropbox dropbox && \
    mkdir -p /var/log/dropbox/

# install dropbox
RUN cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

# install cli
ADD https://www.dropbox.com/download?dl=packages/dropbox.py /bin/dropbox.py

# copy supervisord config    
COPY dropbox.conf /dropbox/dropbox.conf

# ajust user environment
RUN mv -f /root/.dropbox-dist /dropbox/.dropbox-dist && \
    chmod +x /bin/dropbox.py  && \
    chown dropbox:dropbox /bin/dropbox.py  && \
    chown -R dropbox:dropbox /dropbox  && \
    chown -R dropbox:dropbox /var/log/dropbox  && \
    chown -R dropbox:dropbox /home/dropbox


# change user
USER dropbox

# start daemon
CMD ["/usr/bin/supervisord", "-c", "/dropbox/dropbox.conf"]
 