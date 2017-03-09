.PHONY: init plan apply push

init:
	cd terraform/states/$(state) && terraform get
	cd terraform/states/$(state) && terraform remote config \
	   -backend=s3 \
		 -backend-config="bucket=foundation-terraform" \
		 -backend-config="key=$(state).tfstate" \
		 -backend-config="profile=foundation" \
		 -backend-config="region=us-east-1"

plan:
	cd terraform/states/$(state) && terraform plan -out $(state).plan -var-file ../../variables.tfvars

apply:
	cd terraform/states/$(state) && terraform apply $(state).plan

push:
	cd terraform/states/$(state) && terraform remote push
