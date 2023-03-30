.DEFAULT_GOAL := help
.PHONY: release major minor patch
.PRECIOUS:
SHELL:=/bin/bash

VERSION:=$(shell git describe --abbrev=0 --tags)
CURRENT_BRANCH:=$(shell git rev-parse --abbrev-ref HEAD)
NAME:=$(shell cat .registry)

help:
	@echo "\033[33mUsage:\033[0m\n  make TARGET\n\n\033[33mTargets:\033[0m"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-7s\033[0m %s\n", $$1, $$2}'

git_commit:
	@git add .
	@git commit -a -m "Auto" || true

git_push: git_commit
	@git push --all
	@git push --tags

V?=minor
release: git_push
	@echo ================================
	@advbumpversion $(V)
	
#	@git submodule foreach git checkout master
	@git checkout master
	
	@git add .
	@git commit -a -m "Auto before_merge commit submodules" || :
	
	@git merge --no-edit --commit -X theirs develop
	
	@git add .
	@git commit -a -m "Auto after_merge commit submodules" || :
	
	@advbumpversion build
	
	@git push --all
	@git push --tags
	
#	@git submodule foreach git checkout develop
	@git checkout develop

dev:
	@advbumpversion build

major:
	make release V=major

minor:
	make release V=minor

patch:
	make release V=patch

bootstrap:
#	git remote add
	git remote add pedrovgs https://github.com/pedrovgs/AndroidWiFiADB.git || :
	git remote add ekr696-beep https://github.com/ekr696-beep/AndroidWiFiADB.git || :
	git remote add x13945 https://github.com/x13945/AndroidWiFiADB.git || :
	git remote add alreadyforkallbranches https://github.com/alreadyforkallbranches/AndroidWiFiADB.git || :
	git remote add Artemxdd https://github.com/Artemxdd/AndroidWiFiADB.git || :
	git remote add sahujaunpuri https://github.com/sahujaunpuri/AndroidWiFiADB.git || :
	git remote add Diffblue https://github.com/Diffblue-benchmarks/Pedrovgs-AndroidWiFiADB.git || :
#	git remote add
#	git remote add
	git pull --all
