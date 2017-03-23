.PHONY: init plan apply push clean

init:
	cd terraform/states/$(state) && terraform init -get=true -backend=true

plan:
	cd terraform/states/$(state) && terraform plan -out $(state).plan

apply:
	cd terraform/states/$(state) && terraform apply $(state).plan

push:
	cd terraform/states/$(state) && terraform remote push

clean:
	find . -name '.terraform' -print0 | xargs -0 rm -rf
