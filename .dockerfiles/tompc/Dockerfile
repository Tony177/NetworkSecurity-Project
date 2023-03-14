FROM ubuntu
LABEL MAINTEINER="antonioavolio18@gmail.com"
ENV NEWUSER "tcasaccio1"
ENV LANG en_US.utf8
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker;\
    echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker;\
    apt update && apt -y install ssh sudo mysql-client net-tools locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN echo "PasswordAuthentication yes" >> /etc/ssh/ssh_config;\
    useradd -m -d /home/${NEWUSER} ${NEWUSER} -s /bin/bash;\
    useradd -m -d /home/admin -G sudo admin -s /bin/bash;\
    echo "${NEWUSER}:YLN1NrMdGN" | chpasswd;\
    echo "admin:AYsnd91nD0f1D" | chpasswd
ENTRYPOINT service ssh start && ifconfig | grep "inet" && /bin/bash
EXPOSE 22