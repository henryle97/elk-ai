

COMPOSE_ALL_FILES := -f docker-compose.yml -f extensions/filebeat/filebeat-compose.yml -f extensions/fleet/fleet-compose.yml -f extensions/heartbeat/heartbeat-compose.yml -f extensions/metricbeat/metricbeat-compose.yml
ELK_ALL_SERVICES := elasticsearch  logstash  kibana filebeat fleet-server 

ELK_EXTENSIONS := metricbeat heartbeat

compose_v2_not_supported = $(shell command docker compose 2> /dev/null)
ifeq (,$(compose_v2_not_supported))
  DOCKER_COMPOSE_COMMAND = docker-compose
else
  DOCKER_COMPOSE_COMMAND = docker compose
endif

delete-tls:
	find tls/certs -name ca -prune -or -type d -mindepth 1 -exec rm -rfv {} +

create-tls:		    
	docker compose up --build tls

create-users:
	docker compose  up --build setup --force-recreate

up-all:		    ## Start Elk and all its component (ELK, Monitoring, and Tools).
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_ALL_FILES} up -d ${ELK_ALL_SERVICES}

up-metric-heart-beat:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_ALL_FILES} up --build -d ${ELK_EXTENSIONS}

down-all:		    ## Shutdown Elk and all its component (ELK, Monitoring, and Tools).
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_ALL_FILES} down

delete-all:		    ## Shutdown Elk and all its component (ELK, Monitoring, and Tools).
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_ALL_FILES} down -v

