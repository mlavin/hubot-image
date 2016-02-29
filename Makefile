NAME = mlavin/hubot-image

build: tag=latest
build:
	docker build --rm -t ${NAME}:$(tag) .

run: build
	docker run -i -t ${NAME}

outdated: build
	docker run -i -t ${NAME} npm outdated

push: tag=latest
push: build
	docker push ${NAME}:$(tag)

.PHONY: build run outdated push
