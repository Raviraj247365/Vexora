# Makefile: common developer tasks for Vexora

.PHONY: help up backend mobile ai lint test clean deps

help:
	@echo "Usage: make <target>"
	@echo "Targets:"
	@echo "  up        - Start local infra via docker-compose"
	@echo "  backend   - Start backend dev server"
	@echo "  mobile    - Start Flutter app (requires Flutter SDK)"
	@echo "  ai        - Start AI service (example command)"
	@echo "  lint      - Run linters for codebases"
	@echo "  test      - Run tests (if any)"
	@echo "  deps      - Install common dependencies for apps"
	@echo "  clean     - Clean temporary files"

up:
	docker-compose up --build

backend:
	cd apps/backend && npm install && npm run dev

mobile:
	cd apps/mobile && flutter pub get && flutter run

ai:
	cd services/ai && poetry install && poetry run uvicorn src.app:app --reload --port 8001

lint:
	@echo "Running linters..."
	@if [ -f apps/backend/package.json ]; then \
	  (cd apps/backend && if grep -q '"lint"' package.json; then npm run lint; else echo "No backend lint script"; fi); \
	fi
	@if [ -f services/ai/pyproject.toml ] || [ -d services/ai/src ]; then \
	  (cd services/ai && black --check . || true && flake8 . || true); \
	fi

test:
	@echo "Running tests (if present)"
	@if [ -f apps/backend/package.json ]; then \
	  (cd apps/backend && if grep -q '"test"' package.json; then npm test; else echo "No backend tests"; fi); \
	fi
	@if [ -d services/ai/tests ]; then \
	  (cd services/ai && pytest -q || true); \
	fi

deps:
	@echo "Installing common dependencies"
	@if [ -f apps/backend/package.json ]; then (cd apps/backend && npm install); fi
	@if [ -f apps/mobile/pubspec.yaml ]; then (cd apps/mobile && flutter pub get); fi
	@if [ -f services/ai/pyproject.toml ]; then (cd services/ai && poetry install); fi

clean:
	@echo "No-op clean. Add cleanup steps as needed."
