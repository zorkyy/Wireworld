APP_NAME = Wireworld
MAIN_CLASS = tk.unnikked.wireworld.Main

.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
Makefile: ;              # skip prerequisite discovery

# Run make help by default
.DEFAULT_GOAL = help

.PHONY: compile
compile: ## Compile java classes
	mvn compile

.PHONY: install
install: compile ## Install dependencies
	mvn install

.PHONY: build-maven
build-maven: install
	mvn package

.PHONY: build-linux
build-linux: build-maven
	cat linux-stub.sh target/$(APP_NAME).jar > target/$(APP_NAME).run && chmod +x target/$(APP_NAME).run

.PHONY: build
build: build-linux ## Compile & Build all artifacts

.PHONY: run
run: ## Run app
	java -cp target/classes $(MAIN_CLASS)

.PHONY: test
test: compile ## Test app
	mvn test

.PHONY: clean
clean: ## Clean all dependencies & artifacts
	mvn clean

.PHONY: help
help: .title ## Show this help and exit (default target)
	echo ''
	printf "                %s: \033[94m%s\033[0m \033[90m[%s] [%s]\033[0m\n" "Usage" "make" "target" "ENV_VARIABLE=ENV_VALUE ..."
	echo ''
	echo '                Available targets:'
	# Print all commands, which have '##' comments right of it's name.
	# Commands gives from all Makefiles included in project.
	# Sorted in alphabetical order.
	echo '                ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	grep -hE '^[a-zA-Z. 0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		 awk 'BEGIN {FS = ":.*?## " }; {printf "\033[36m%+15s\033[0m: %s\n", $$1, $$2}'
	echo '                ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
	echo ''

%:
	@:
