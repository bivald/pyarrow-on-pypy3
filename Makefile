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

build: ## Build docker image which includes the whl file
	@echo "Building docker container and wheel" \
	&& docker build -t pyarrow-on-pypy . \
	&& docker build -t pyarrow-on-pypy38 -f Dockerfile-py38 .

extract: ## Copy the whl file into ./dist
	@echo "Replacing the current dist folder with data from the docker container" \
	&& rm -r ./dist/|| true \
	&& docker rm pyarrowonpypy3||true \
	&& docker run --name pyarrowonpypy3 pyarrow-on-pypy3 \
	&& docker cp pyarrowonpypy3:/arrow/python/dist/ ./dist
	&& docker rm pyarrowonpypy3||true \
	&& docker run --name pyarrowonpypy3 pyarrow-on-pypy38 \
	&& docker cp pyarrowonpypy3:/arrow/python/dist/ ./dist

dist: build extract  ## Run both build and extract
	@echo "Wheel is  now in ./dist"
