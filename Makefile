# The default environment file
ENVIRONMENT_FILE=$(shell pwd)/.env

#####################################################
#							 						#
# 							 						#
# RUNTIME TARGETS			 						#
#							 						#
#							 						#
#####################################################

default: run

# Start the containers
run: prerequisite build

# Start individual container
start: prerequisite valid-container
	- docker-compose -f docker-compose.yml up -d --build

# Stop individual container
stop: prerequisite valid-container
	- docker-compose -f docker-compose.yml stop

# Halts the docker containers
halt: prerequisite
	- docker-compose -f docker-compose.yml kill

#####################################################
#							 						#
# 							 						#
# SETUP AND BUILD TARGETS			 				#
#							 						#
#							 						#
#####################################################

# Build and prepare the docker containers and the project
build: prerequisite build-containers
	- docker-compose -f docker-compose.yml exec jenkins bash -c "printf 'Waiting for Jenkins initialise'; until [ -f /var/jenkins_home/secrets/initialAdminPassword ]; do printf '.' && sleep 5; done && echo ."
	- docker-compose -f docker-compose.yml exec jenkins bash -c "echo -e '\033[31mThe initial admin password: \e[0m' && cat /var/jenkins_home/secrets/initialAdminPassword"

# Build and launch the containers
build-containers:
	- docker-compose -f docker-compose.yml up -d --build

# Remove the docker containers and deletes project dependencies
clean: prerequisite prompt-continue
	# Remove the dependencies
	- rm -rf ${DATA_DIRECTORY}

	# Remove the docker containers
	- docker-compose -f docker-compose.yml down --rmi all -v --remove-orphans

	# Remove all unused volumes
	- docker volume prune -f

	# Remove all unused images
	- docker images prune -a

# Echos the container status
status: prerequisite
	- docker-compose -f docker-compose.yml ps

#####################################################
#							 						#
# 							 						#
# BASH CLI TARGETS			 						#
#							 						#
#							 						#
####################################################

# Opens a bash prompt to the php cli container
bash: prerequisite
	- docker-compose -f docker-compose.yml exec jenkins bash

#####################################################
#							 						#
# 							 						#
# GENERAL TARGETS			 						#
#							 						#
#							 						#
####################################################

open-browser:
	- open http://localhost:${WEB_INTERFACE_PORT}

install-plugin:
	@read -p "Enter plugin name: " plugin; \
	docker-compose -f docker-compose.yml exec jenkins bash -c "/usr/local/bin/install-plugins.sh $$plugin"

#####################################################
#							 						#
# 							 						#
# INTERNAL TARGETS			 						#
#							 						#
#							 						#
####################################################

# Validates the prerequisites such as environment variable
prerequisite: check-environment
include .env.default
include .env
export ENV_FILE = $(ENVIRONMENT_FILE)

# Validates the environment variables
check-environment:
# Check whether the environment file exists
ifeq ("$(wildcard $(ENVIRONMENT_FILE))","")
	- @echo Copying ".env.default";
	- cp .env.default .env
endif
# Check whether the docker binary is available
ifeq (, $(shell which docker-compose))
	$(error "No docker-compose in $(PATH), consider installing docker")
endif

# Prompt to continue
prompt-continue:
	@while [ -z "$$CONTINUE" ]; do \
		read -r -p "Would you like to continue? [y]" CONTINUE; \
	done ; \
	if [ ! $$CONTINUE == "y" ]; then \
        echo "Exiting." ; \
        exit 1 ; \
    fi

%:
	@: