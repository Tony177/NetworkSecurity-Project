FROM ubuntu
LABEL MAINTEINER="antonioavolio18@gmail.com"
ENV NEWUSER "tcasaccio1"
ENV NODE_ENV production
ENV LANG en_US.utf8
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker;\
    echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker;\
    apt update && apt -y install ssh sudo mysql-client net-tools locales npm nodejs && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN echo "PasswordAuthentication yes" >> /etc/ssh/ssh_config;\
    useradd -m -d /home/${NEWUSER} -G sudo ${NEWUSER};\
    echo "${NEWUSER}:YLN1NrMdGN" | chpasswd;\
    usermod --shell /bin/bash ${NEWUSER}
RUN service ssh start && ifconfig | grep "inet"
COPY . .
WORKDIR /site
RUN npm install --production 
RUN chmod +x /wait-for-it.sh
CMD [ "../wait-for-it.sh","MySQLServer:3306","--","npm", "start" ]
EXPOSE 22
EXPOSE 8080