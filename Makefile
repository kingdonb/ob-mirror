.PHONY: deploy

deploy:
	kubectl apply -k deploy/basic
