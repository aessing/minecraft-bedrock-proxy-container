#!/bin/bash

# =============================================================================
# Minecraft Bedrock Proxy Server startup script
# Minecraft Bedrock Proxy Container
# https://github.com/aessing/minecraft-bedrock-proxy-container
# -----------------------------------------------------------------------------
# Developer.......: Andre Essing (https://www.andre-essing.de/)
#                                (https://github.com/aessing)
#                                (https://twitter.com/aessing)
#                                (https://www.linkedin.com/in/aessing/)
# -----------------------------------------------------------------------------
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
# =============================================================================

set -eo pipefail

###############################################################################
# Set base start command
if [[ "${SERVER}" == 0 ]]; then
    echo
    echo "-------------------------------------------------------------------------------------"
    echo "SERVER environment variable not set"
    echo "You need to specify a Bedrock / MCPE server IP address and port (e.g. 1.2.3.4:19132)"
    echo "-------------------------------------------------------------------------------------"
    echo
    exit 1
fi
PROXY_COMMAND="${PROXY_BIN} -server ${SERVER}"

###############################################################################
# Add additional Parameters
if [ ${BIND} != 0 ]; then
  PROXY_COMMAND="${PROXY_COMMAND} -bind ${BIND}"
fi

if [ ${BIND_PORT} != 0 ]; then
  PROXY_COMMAND="${PROXY_COMMAND} -bind_port ${BIND_PORT}"
fi

DEBUG=$(echo ${DEBUG} | tr 'a-z' 'A-Z')
if [ ${DEBUG} == 'TRUE' ]; then
  PROXY_COMMAND="${PROXY_COMMAND} -debug"
fi

IPV6=$(echo ${IPV6} | tr 'a-z' 'A-Z')
if [ ${IPV6} == 'TRUE' ]; then
  PROXY_COMMAND="${PROXY_COMMAND} -6"
fi

REMOVE_PORTS=$(echo ${REMOVE_PORTS} | tr 'a-z' 'A-Z')
if [ ${REMOVE_PORTS} == 'TRUE' ]; then
  PROXY_COMMAND="${PROXY_COMMAND} -remove_ports"
fi

if [ ${TIMEOUT} != 60 ]; then
  PROXY_COMMAND="${PROXY_COMMAND} -timeout ${TIMEOUT}"
fi

###############################################################################
# Get the party started and run Bedrock server
echo "Starting proxy: ${PROXY_COMMAND}"
eval ${PROXY_COMMAND}

###############################################################################
#EOF