BASE_HREF = /$(OUTPUT)/

# [RUN] -> $ make deploy OUTPUT=portfolio
# Replace this with your GitHub username
GITHUB_USER = sharath-b-naik
GITHUB_REPO = https://github.com/$(GITHUB_USER)/$(OUTPUT)
BUILD_VERSION := $(shell grep 'version:' pubspec.yaml | awk '{print $$2}')

deploy:
ifndef OUTPUT
	$(error OUTPUT is not set. Usage: make deploy OUTPUT=<output_repo_name>)
endif

	@echo "Clean existing repository"
	flutter clean

	@echo "Getting packages..."
	flutter pub get

	@echo "Generating the web folder..."
	flutter create . --platform web

	@echo "Building for web..."
	flutter build web --base-href $(BASE_HREF) --release

	@echo "Deploying to git repository"
	cp -r build/web/* ./ && \
	git init && \
	git add . && \
	git commit -m "Deploy Version $(BUILD_VERSION)" && \
	git branch -M main && \
	git remote add origin $(GITHUB_REPO) && \
	git push -u -f origin main

	@echo "✅ Finished deploy: $(GITHUB_REPO)"
	@echo "🚀 Flutter web URL: https://$(GITHUB_USER).github.io/$(OUTPUT)/"

.PHONY: deploy
