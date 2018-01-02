# Jenkins Dockerized

> Dockerized Jenkins. 
[Jenkins](https://github.com/jenkinsci/docker) and 
[Docker](https://www.docker.com/) 

## Quick start
**Make sure you have Docker version >= 17.04.0**

```bash
# clone our repo
git checkout https://github.com/NicklasWallgren/jenkins-dockerized.git jenkins
```
```bash
# Change directory
cd jenkins/
```

```bash
# Start the Jenkins instance.
make
```

## Environment variables
```bash
# The default interface port
WEB_INTERFACE_PORT=8080

# The default communication port
COMMUNICATION_PORT=5000

# The default Jenkins API port
API_PORT=50000

# The default plugins
JENKINS_PLUGINS=ansicolor xunit warnings workflow-aggregator cloverphp checkstyle docker-workflow ssh ssh-slaves git credentials-binding pipeline-utility-steps workflow-aggregator timestamper jobConfigHistory pragprog mask-passwords lockable-resources

# The volume directory
DATA_DIRECTORY=./data
```

## Commands

### Start Jenkins
```bash
make

```
### Stop Jenkins
```bash
make halt

```
### Access CLI
```bash
# Open a bash prompt
make bash
```
### Check status
```bash
make status

```
### Open the interface
```bash
make open-browser

```
### Install Jenkins plugin
```bash
make install-plugin

