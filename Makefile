# Globals
.PHONY: help cfn
.DEFAULT: help
.ONESHELL:
.SILENT:
SHELL=/bin/bash
.SHELLFLAGS = -ceo pipefail

# Supported Environments
ENVS = dev qa prod

# Targets
DEPLOY_TARGET = Deploy Target
CICD_LOCAL_ENV_TARGET = Run CICD Docker Image

# Colours for Help Message and INFO formatting
YELLOW := "\e[1;33m"
NC := "\e[0m"
INFO := @bash -c 'printf $(YELLOW); echo "=> $$0"; printf $(NC)'
export 

help:
	$(INFO) "Run: make <target>"
	$(INFO) "Supported Environments: $$ENVS"
	$(INFO) "List of Supported Targets:"
	@echo -e "cicd_local_env        -> $$CICD_LOCAL_ENV_TARGET"
	@echo -e "<type>/<action>/<env> -> $$DEPLOY_TARGET"
	@echo -e "\ttype:cfn action:deploy"
	@echo -e "\ttype:tf  action:plan|deploy|destroy|output"	

cicd_local_env:
	$(INFO) "$$CICD_LOCAL_ENV_TARGET"
	source scripts/docker_run.sh

cfn/deploy/% tf/plan/% tf/deploy/% tf/destroy/% tf/output/% :
	TARGET=$@
	$(INFO) "$$DEPLOY_TARGET - $$TARGET"
	deploy $$TARGET

tf/fmt:
	terraform fmt -recursive terraform

pylint:
	pylint src/hello_app/hello.py