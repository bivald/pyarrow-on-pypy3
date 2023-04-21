.DEFAULT_GOAL := help

.PHONY: \
	help \
	build \
	extract \
	dist

help:
	@cat $(MAKEFILE_LIST) \
			| grep -e "^[a-zA-Z_\-]*: *.*## *" \
			| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-base:
	docker build --platform=linux/amd64 -t pyarrow-on-pypy .

build: ## Build docker image which includes the whl file
	@echo "Building docker container and wheel" \
	&& docker build --platform=linux/amd64 -t pyarrow-on-pypy39 -f Dockerfile-from-base --no-cache .

extract: ## Copy the whl file into ./dist
	@echo "Replacing the current dist folder with data from the docker container" \
	&& rm -r ./dist/|| true \
	&& docker rm pyarrowonpypy3||true \
	&& docker run --platform=linux/amd64 --name pyarrowonpypy3 pyarrow-on-pypy39 \
	&& docker cp pyarrowonpypy3:/arrow/python/dist/ ./dist


test:
	docker run --platform=linux/amd64 -v ${PWD}/run-tests.sh:/run-tests.sh --rm -it pyarrow-on-pypy39 bash /run-tests.sh

dist: build extract  ## Run both build and extract
	@echo "Wheel is  now in ./dist"
