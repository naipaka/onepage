all: fvm fvm_install melos melos_bs flutterfire_cli

fvm:
	brew tap leoafarias/fvm
	brew install fvm

fvm_install:
	fvm install --setup

melos:
	dart pub global activate melos

melos_bs:
	dart pub get

generate_code:
	melos run gen --no-select

flutterfire_cli:
	dart pub global activate flutterfire_cli

worktree:
	chmod +x scripts/setup_worktree.sh && \
	scripts/setup_worktree.sh && \
	fvm install && \
	dart pub get
