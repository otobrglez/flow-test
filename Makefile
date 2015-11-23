.PHONY: build run
IMAGE=databox/flow-test

build:
	docker build --rm=true -t ${IMAGE} .

run:
	docker run -ti ${IMAGE}
