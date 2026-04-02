# ─────────────────────────────────────────────────────────────────────────────
# Outlook Signature Manager — Makefile
#
# Usage:
#   make setup       — first-time: init git, create .gitignore, initial commit
#   make build       — build Flutter web with correct base-href for GitHub Pages
#   make deploy      — build + push to gh-pages branch (GitHub Pages source)
#   make open        — open the live GitHub Pages URL in the browser
#
# Config — edit these two lines:
GITHUB_USER  = multiplexintl
REPO_NAME    = outlook-signature-manager
# ─────────────────────────────────────────────────────────────────────────────

REPO_URL     = https://github.com/$(GITHUB_USER)/$(REPO_NAME).git
PAGES_URL    = https://$(GITHUB_USER).github.io/$(REPO_NAME)/
BASE_HREF    = /$(REPO_NAME)/

.PHONY: setup build deploy open

# ── First-time setup ──────────────────────────────────────────────────────────
setup:
	@echo "→ Initialising git repository..."
	git init
	git add .
	git commit -m "Initial commit: Flutter Outlook Signature Manager"
	@echo ""
	@echo "→ Next steps:"
	@echo "  1. Create a repo called '$(REPO_NAME)' on GitHub (no README, no .gitignore)"
	@echo "  2. Then run:"
	@echo "       git remote add origin $(REPO_URL)"
	@echo "       git branch -M main"
	@echo "       git push -u origin main"
	@echo "  3. Then run:  make deploy"

# ── Build for GitHub Pages ────────────────────────────────────────────────────
build:
	@echo "→ Building Flutter web (base-href: $(BASE_HREF))..."
	flutter build web --release --base-href "$(BASE_HREF)" --no-tree-shake-icons
	@echo "✓ Build output in build/web/"

# ── Deploy to gh-pages branch ─────────────────────────────────────────────────
deploy: build
	@echo "→ Deploying to GitHub Pages (gh-pages branch)..."

	# Create a fresh orphan branch from the build output
	cd build/web && \
		git init && \
		git checkout -b gh-pages && \
		git add -A && \
		git commit -m "Deploy: $$(date '+%Y-%m-%d %H:%M')" && \
		git remote add origin $(REPO_URL) && \
		git push --force origin gh-pages

	@echo ""
	@echo "✓ Deployed! GitHub Pages will be live in ~60 seconds at:"
	@echo "  $(PAGES_URL)"

# ── Open live site ────────────────────────────────────────────────────────────
open:
	open "$(PAGES_URL)"
