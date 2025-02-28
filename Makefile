REPO_URL=https://github.com/Vonng/pigsty.git
BRANCH=main
TARGET_DIR=roles/pgsql
TMP_DIR=/tmp/pigsty

.PHONY: update push clean diff

update:
	@echo "Syncing pg_exporters role from Pigsty repository..."
	@if [ ! -d "$(TMP_DIR)" ]; then git clone --branch $(BRANCH) --depth 1 $(REPO_URL) $(TMP_DIR); else cd $(TMP_DIR) && git fetch origin $(BRANCH) && git reset --hard origin/$(BRANCH); fi
	@mkdir -p $(TARGET_DIR)
	@rsync -av --delete $(TMP_DIR)/$(TARGET_DIR) $(TARGET_DIR)/
	@echo "Update complete."

push: clean
	@git add .
	@git diff --cached --quiet || git commit -m "Update pg_exporters from Pigsty"
	@git push origin main
	@echo "Changes pushed to remote."

diff:
	@git diff

clean:
	@rm -rf $(TMP_DIR)
	@echo "Temporary directory cleaned."
