build:
	docker build . -f Dockerfile
pull:
	docker pull greenerchen/kite-linux:base
push:
	docker push greenerchen/kite-linux:base
run:
	docker run -it greenerchen/kite-linux:base
