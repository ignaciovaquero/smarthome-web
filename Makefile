.PHONY: build clean init deploy remove plan

build:
	npm run build

clean:
	rm -rf ./dist

init:
	terraform -chdir=terraform init

deploy: clean build init
	terraform -chdir=terraform apply -auto-approve

remove: init
	terraform -chdir=terraform destroy -auto-approve

plan: init
	terraform -chdir=terraform plan
