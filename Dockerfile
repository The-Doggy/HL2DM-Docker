###########################################################
# Dockerfile that builds a HL2:DM Gameserver
###########################################################
FROM cm2network/steamcmd:root

ENV STEAMAPPID 232370
ENV STEAMAPPDIR /home/steam/hl2dm-dedicated

# Create autoupdate config
# Add entry script & ESL config
# Remove packages and tidy up
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget \
		ca-certificates \
	&& mkdir -p ${STEAMAPPDIR}/hl2mp \
	&& cd ${STEAMAPPDIR} \
	&& wget https://raw.githubusercontent.com/The-Doggy/HL2DM-Docker/master/entry.sh \
	&& chmod 755 ${STEAMAPPDIR}/entry.sh \
	&& cd ${STEAMAPPDIR}/hl2mp \
	&& { \
			echo '@ShutdownOnFailedCommand 1'; \
			echo '@NoPromptForPassword 1'; \
			echo 'login anonymous'; \
			echo 'force_install_dir ${STEAMAPPDIR}'; \
			echo 'app_update ${STEAMAPPID}'; \
			echo 'quit'; \
		} > ${STEAMAPPDIR}/hl2dm_update.txt \
	&& wget -qO- https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1130-linux.tar.gz | tar xvzf - \
	&& wget -qO- https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.11.0-git6520-linux.tar.gz | tar xvzf - \
	&& chown -R steam:steam ${STEAMAPPDIR} \
	&& apt-get remove --purge -y \
		wget \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

ENV SRCDS_PORT=27015 \
	SRCDS_CLIENT_PORT=27005 \
	SRCDS_RCONPW="changeme" \
	SRCDS_PW="changeme" \
	SRCDS_STARTMAP="dm_runoff"

USER steam

WORKDIR $STEAMAPPDIR

VOLUME $STEAMAPPDIR

ENTRYPOINT ${STEAMAPPDIR}/entry.sh

# Expose ports
EXPOSE 27015/tcp 27015/udp 27020/udp