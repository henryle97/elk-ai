

COMPOSE_ALL_FILES := -f docker-compose.yml -f extensions/filebeat/filebeat-compose.yml -f extensions/fleet/fleet-compose.yml
ELK_ALL_SERVICES := elasticsearch  logstash  kibana filebeat fleet-server



compose_v2_not_supported = $(shell command docker compose 2> /dev/null)
ifeq (,$(compose_v2_not_supported))
  DOCKER_COMPOSE_COMMAND = docker-compose
else
  DOCKER_COMPOSE_COMMAND = docker compose
endif

remove-tls:
	find tls/certs -name ca -prune -or -type d -mindepth 1 -exec rm -rfv {} +

gen-tls:		    
	docker compose up --build tls

setup-users:
	docker compose  up --build setup --force-recreate

all:		    ## Start Elk and all its component (ELK, Monitoring, and Tools).
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_ALL_FILES} up -d ${ELK_ALL_SERVICES}

down:		    ## Shutdown Elk and all its component (ELK, Monitoring, and Tools).
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_ALL_FILES} down

delete:		    ## Shutdown Elk and all its component (ELK, Monitoring, and Tools).
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_ALL_FILES} down -v

