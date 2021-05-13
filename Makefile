.PHONY: build clean init deploy remove plan dev

SMARTHOME_BASE_URL ?= https://yqzj7ilmwg.execute-api.eu-west-3.amazonaws.com/dev

build:
	npm install
	npm run build

clean:
	rm -rf ./dist

init:
	terraform -chdir=terraform init

deploy: clean build init
	sed -i "" -e "s#SMARTHOME_BASE_URL: '.*'#SMARTHOME_BASE_URL: '$(SMARTHOME_BASE_URL)'#g" dist/config.js
	terraform -chdir=terraform apply -auto-approve

remove: init
	terraform -chdir=terraform destroy -auto-approve

plan: init
	terraform -chdir=terraform plan

dev:
	npm run serve
