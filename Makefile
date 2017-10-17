PROJECTS_DIR = terraform/projects
PROJECTS = $(notdir $(wildcard $(PROJECTS_DIR)/*))
PROJECT_FROM_TARGET = $(firstword $(subst /, ,$1))

.PHONY: init plan apply %/init %/plan %/apply

%/init %/plan %/apply: project = $(call PROJECT_FROM_TARGET, $@)

%/init:
	cd terraform/projects/$(project) && terraform init

%/plan:
	cd terraform/projects/$(project) && terraform plan -out $(project).plan

%/apply:
	cd terraform/projects/$(project) && terraform apply $(project).plan
