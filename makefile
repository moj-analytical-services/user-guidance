IMAGE := docker.io/ministryofjustice/tech-docs-github-pages-publisher:data-platform

# Use this to run a local instance of the documentation site, while editing
.PHONY: preview check

preview:
	docker run -it --rm \
		--name tech-docs-preview \
		--publish 4567:4567 \
		--volume $$( pwd )/config:/app/config \
		--volume $$( pwd )/source:/app/source \
		$(IMAGE) /scripts/preview.sh

deploy:
	docker run -it --rm \
		--name tech-docs-deploy \
		--publish 4567:4567 \
		--volume $$( pwd )/config:/app/config \
		--volume $$( pwd )/source:/app/source \
		$(IMAGE) /scripts/deploy.sh

check:
	docker run -it --rm \
		--name tech-docs-check \
		--publish 4567:4567 \
		--volume $$( pwd )/config:/app/config \
		--volume $$( pwd )/source:/app/source \
		$(IMAGE) /scripts/check-url-links.sh
