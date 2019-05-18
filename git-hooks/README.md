# Git Hooks

These are git hooks to publish refreshed images whenever code is pushed into the repository.

Run `link_hooks.bash` to enable them.

* `pre-commit`: Refreshes the `Dockerfile` variants (`*.Dockerfile`) if required.
* `pre-push`: Builds the images locally and pushes them to Docker Hub. Unnecessary since automatic builds are enabled.
