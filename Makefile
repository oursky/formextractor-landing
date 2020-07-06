.POSIX:
SHELL=/bin/sh

.PHONY: ci-deploy-prod
ci-deploy-prod:
	@echo "Install dependencies"
	yarn install
	@echo "Generate production build"
	yarn run build
	@if ! [ -x "$$(command -v aws)" ]; then\
		echo "Please install AWS CLI";\
		exit 1;\
	fi
	@echo "Push build to S3 bucket"
	aws s3 sync dist s3://$(S3_BUCKET_NAME) --delete
	@echo "Invalidate Cloudfront"
	aws cloudfront create-invalidation --distribution-id $(CDN_DISTRIBUTION_ID) --paths "/*"
