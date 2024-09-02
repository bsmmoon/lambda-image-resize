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

build:
	zip -r lambda_image_resizer.zip .

upload:
	aws s3 cp lambda_image_resizer.zip s3://seokmin-rbe796/lambda/lambda_image_resizer.zip
