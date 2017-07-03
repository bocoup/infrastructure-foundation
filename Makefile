STATES_DIR = terraform/states
STATES = $(notdir $(wildcard $(STATES_DIR)/*))
STATE_FROM_TARGET = $(firstword $(subst /, ,$1))

.PHONY: init plan apply %/init %/plan %/apply
init plan apply: $(addsuffix /init, $(STATES))

%/init %/plan %/apply %/cowboy: state = $(call STATE_FROM_TARGET, $@)

%/init:
	cd terraform/states/$(state) && terraform init

%/plan:
	cd terraform/states/$(state) && terraform plan -out $(state).plan

%/apply:
	cd terraform/states/$(state) && terraform apply $(state).plan
