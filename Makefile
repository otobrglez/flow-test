.PHONY: build run
IMAGE=databox/flow-test


build:
	docker build --rm=true -t ${IMAGE} .

bi:
	docker run -ti \
		-h flow-test \
		-v `pwd`:/usr/src/app \
		${IMAGE} \
		bundle install

run:
	docker run -ti \
		-h flow-test \
		-v `pwd`:/usr/src/app \
		${IMAGE}
