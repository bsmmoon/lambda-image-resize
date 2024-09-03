-include .env

setup:
	sudo apt-get update
	sudo apt-get install -y \
		build-essential \
		libbz2-dev \
		libncurses5-dev \
		libncursesw5-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libffi-dev \
		zlib1g-dev \
		liblzma-dev \
		libgdbm-dev \
		libgdbm-compat-dev \
		uuid-dev \
		tk-dev \
		libffi-dev \
		zip

install:
	pip install pillow -t .

large-build:
	cp lambdas/large.py ./lambda_function.py
	zip -r lambda_image_resizer.zip .

large-upload:
	aws s3 cp lambda_image_resizer.zip s3://seokmin-rbe796/lambda/lambda_image_resizer_large.zip

medium-build:
	cp lambdas/medium.py ./lambda_function.py
	zip -r lambda_image_resizer.zip .

medium-upload:
	aws s3 cp lambda_image_resizer.zip s3://seokmin-rbe796/lambda/lambda_image_resizer_medium.zip

thumbnail-build:
	cp lambdas/thumbnail.py ./lambda_function.py
	zip -r lambda_image_resizer.zip .

thumbnail-upload:
	aws s3 cp lambda_image_resizer.zip s3://seokmin-rbe796/lambda/lambda_image_resizer_thumbnail.zip
