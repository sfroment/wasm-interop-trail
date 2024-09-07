COMPONENT_MODEL_DIR_TS = ./component-model/ts
COMPONENT_MODEL_DIR_WIT = ./component-model/wit
COMPONENT_MODEL_DIR_RUST = ./component-model/rust
COMPONENT_MODEL_DIR_WASM = ./component-model/wasm
COMPONENT_MODEL_TRANSPILE_DIR = ./component-model/web/bindings
COMPONENT_WEB_DIR = ./component-model/web

.PHONY: component-model-ts
component-model-ts:
	@echo "Generating component model typescript"
	cd $(COMPONENT_MODEL_DIR_TS) && \
	tsc -b 
	jco componentize $(COMPONENT_MODEL_DIR_TS)/dist/src/add.js --wit $(COMPONENT_MODEL_DIR_WIT)/add/world.wit --world-name adder --out $(COMPONENT_MODEL_DIR_WASM)/add.wasm

.PHONY: compose-rust
compose-rust:
	@echo "Composing rust"
	cd $(COMPONENT_MODEL_DIR_RUST) && \
	cargo component build --release

.PHONY: compose-component
compose-component: component-model-ts
	@echo "Composing component"
	wasm-tools compose $(COMPONENT_MODEL_DIR_RUST)/target/wasm32-wasip1/release/calculator.wasm -d $(COMPONENT_MODEL_DIR_WASM)/add.wasm -o $(COMPONENT_MODEL_DIR_WASM)/composed.wasm

.PHONY: transpile-component
transpile-component: compose-rust compose-component 
	@echo "Transpiling component"
	jco transpile $(COMPONENT_MODEL_DIR_WASM)/composed.wasm -o $(COMPONENT_MODEL_TRANSPILE_DIR)

.PHONY: serve
serve: transpile-component
	@echo "Serving component"
	cd $(COMPONENT_WEB_DIR) && \
	npx live-server .
