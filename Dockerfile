# =============================================================================
# Dockerfile
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

###############################################################################
#
# Get the base Linux image
#
FROM alpine:latest

###############################################################################
#
# Set some information
#
LABEL tag="aessing/minecraft-bedrock-proxy-container" \
      description="A Docker container which uses jhead/phantom to make Minecraft Bedrocks servers visible on Xbox and PS" \
      disclaimer="THE CONTENT OF THIS REPOSITORY IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE CONTENT OF THIS REPOSITORY OR THE USE OR OTHER DEALINGS BY CONTENT OF THIS REPOSITORY." \
      vendor="Andre Essing" \
      github-repo="https://github.com/aessing/minecraft-bedrock-proxy-container"

###############################################################################
#
# Set some parameters
#
ARG PROXY_VERSION="0.5.4" \
    PROXY_PATH="/proxy" \
    UIDGID="10999"

ENV PROXY_BIN="${PROXY_PATH}/phantom-linux" \
    PROXY_DOWNLOAD="https://github.com/jhead/phantom/releases/download/v${PROXY_VERSION}/phantom-linux" \
    BIND=0 \
    BIND_PORT=0 \
    DEBUG='false' \ 
    IPV6='false' \
    REMOVE_PORTS='false' \
    SERVER=0 \
    TIMEOUT=60

###############################################################################
#
# Install phantom-linux
#
RUN mkdir -p ${PROXY_PATH} \
    && wget ${PROXY_DOWNLOAD} -P ${PROXY_PATH} \
    && chmod 755 ${PROXY_PATH} \
    && chmod 755 ${PROXY_BIN}

###############################################################################
#
# Copy files
#
COPY entrypoint.sh ${PROXY_PATH}/entrypoint.sh
RUN chmod 755 ${PROXY_PATH}/entrypoint.sh

###############################################################################
#
# Create and run in non-root context
#
RUN addgroup -g ${UIDGID} -S ${UIDGID} \
    && adduser -G ${UIDGID} -S -u ${UIDGID} ${UIDGID} \
    && chown -R ${UIDGID}.${UIDGID} ${PROXY_PATH}
USER ${UIDGID}

###############################################################################
#
# Start FTP copy process
#
WORKDIR ${PROXY_PATH}
ENTRYPOINT [ "./entrypoint.sh" ]

###############################################################################
#EOF