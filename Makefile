NAME = mlavin/hubot-image

build: tag=latest
build:
	docker build --rm -t ${NAME}:$(tag) .

run: build
	docker run -i -t ${NAME}

.PHONY: build run
