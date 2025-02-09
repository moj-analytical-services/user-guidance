.PHONY: package preview

IMAGE_NAME ?= ghcr.io/ministryofjustice/tech-docs-github-pages-publisher
IMAGE_SHA  ?= sha256:35699473dbeefeeb8b597de024125a241277ee03587d5fe8e72545e4b27b33f8

package:
	docker run --rm \
	    --name tech-docs-github-pages-publisher \
	    --volume $(PWD)/config:/tech-docs-github-pages-publisher/config \
		--volume $(PWD)/source:/tech-docs-github-pages-publisher/source \
		$(IMAGE_NAME)@$(IMAGE_SHA) \
		/usr/local/bin/package

preview:
	docker run -it --rm \
	    --name tech-docs-github-pages-publisher-preview \
	    --volume $(PWD)/config:/tech-docs-github-pages-publisher/config \
		--volume $(PWD)/source:/tech-docs-github-pages-publisher/source \
		--publish 4567:4567 \
		$(IMAGE_NAME)@$(IMAGE_SHA) \
		/usr/local/bin/preview
