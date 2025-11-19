# second method
# ==========================
# Stage 1: Build dependencies
# ==========================
FROM node:20-alpine3.21 AS builder

WORKDIR /opt/server

# Install only production dependencies
COPY package.json .
RUN npm install --omit=dev

# Copy application source code
COPY *.js .


# ==========================
# Stage 2: Runtime Image
# ==========================
FROM node:20-alpine3.21

# Create non-root user (clean readable structure)
RUN addgroup -S roboshop && \
    adduser -S -G roboshop roboshop

WORKDIR /opt/server
USER roboshop

# Environment variables runtime needs
ENV REDIS_HOST=redis \
    CATALOGUE_HOST=catalogue \
    CATALOGUE_PORT=8080

# Copy built app from builder image
COPY --from=builder --chown=roboshop:roboshop /opt/server /opt/server

EXPOSE 8080

CMD ["node", "server.js"]











# basic method
# FROM node:20
# RUN groupadd -r roboshop && \
#     useradd -r -g roboshop -d /opt/server -s /usr/sbin/nologin roboshop
# WORKDIR /opt/server
# COPY package.json . 
# COPY server.js .
# RUN npm install
# ENV REDIS_HOST="redis" \
#     CATALOGUE_HOST="catalogue" \
#     CATALOGUE_PORT="8080"
# USER roboshop
# CMD [ "node", "server.js" ]

