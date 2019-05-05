#!/usr/bin/env bash

ORIGIN_DIR=${PWD}

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	for file in $( ls -A | grep -vE '\.nolink*|\.git$|\.gitignore|.*.md|Brewfile.*|bootstrap.sh|\.DS_Store|README\.md|LICENSE-MIT\.txt' ) ; do
		ln -siv "$PWD/$file" "$HOME"
	done
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
cd $ORIGIN_DIR
