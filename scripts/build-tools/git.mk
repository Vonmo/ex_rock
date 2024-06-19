git-user = $(shell git config user.email)
git-branch = $(shell git rev-parse --abbrev-ref HEAD)
git-commit = $(shell git rev-parse --short HEAD)
git-repo = $(shell git config remote.origin.url)
