#!/bin/bash

${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${STEAMAPPDIR} +app_update ${STEAMAPPID} +quit

${STEAMAPPDIR}/srcds_run -game hl2mp -console -autoupdate -steam_dir ${STEAMCMDDIR} -steamcmd_script ${STEAMAPPDIR}/hl2dm_update.txt -usercon \
					-port $SRCDS_PORT +clientport $SRCDS_CLIENT_PORT +map $SRCDS_STARTMAP +rcon_password $SRCDS_RCONPW +sv_password $SRCDS_PW