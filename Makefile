# ------------------------------------------
#          Raylib - Makefile
# ------------------------------------------
# This Makefile supports:
# 1. Native build (Windows)
# 2. WebAssembly build using Emscripten
#
# Usage:
#  make build PLATFORM=native    # Compile for Windows
#  make build PLATFORM=web       # Compile for WebAssembly
#  make run                      # Run native executable
#  make serve                    # Run WebAssembly version in browser
#  make clean                    # Remove build artifacts
#
# Features:
# 󰯁 Checks for Raylib (Native Build)
# 󰢮 Checks for Emscripten (WebAssembly Build)
# 󰜺 Handles errors and build interruptions (Ctrl+C)
# ------------------------------------------
#------------------------------------------
# 󰓩 Project Name (Change This!)
# ------------------------------------------
#  WARNING: Change `PROJECT_NAME` below before building!
#  Default name is `raylib_project`. Update it as needed.

PROJECT_NAME = raylib_project

# 󰉖 Directories
SRC_DIR = src
INC_DIR = include headers
WEB_DIR = web
BIN_DIR = bin
LIB_DIR = lib



#  WARNING:
#  ------------------------------------------
#  Do not edit anything below this line
#  unless you know what you're doing!
#  These flags and build commands are critical
#  for compiling the project correctly.
#  ------------------------------------------


# 󰯈 Output File Paths
NATIVE_OUTPUT = $(BIN_DIR)/$(PROJECT_NAME).exe
WEB_OUTPUT = $(WEB_DIR)/index.html

# 󰙧 Source Files
SRC_FILES = $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/**/*.cpp) $(wildcard $(SRC_DIR)/**/*.hpp)
EMCC_SRC_FILES = $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/**/*.cpp)

# 󰒓 Include and Library Paths
INCLUDE_DIRS = $(foreach d, $(INC_DIR), -I$d)
LIB_DIRS = -L$(LIB_DIR)

# 󰅖 Compiler Selection
GCC = g++
EMCC = emcc

# ------------------------------------------
# 󰯁 Dependency Checks
# ------------------------------------------
# Ensures Raylib and Emscripten (emcc) are installed before building.

#  Check if Raylib is installed for native builds
check-raylib:
	@if ! [ -f "C:/raylib/raylib/src/raylib.h" ]; then \
		echo "Error: Raylib not found! Please install it in C:/raylib."; \
		exit 1; \
	fi

#  Check if Emscripten (emcc) is installed for WebAssembly builds
check-emcc:
	@if ! command -v $(EMCC) &> /dev/null; then \
		echo "Error: Emscripten (emcc) is not installed! Please install it first."; \
		exit 1; \
	fi

# 󰑃 Handle Interrupts (Ctrl+C)
trap-interrupt:
	@trap "echo '\nBuild interrupted! Cleaning up...'; make clean; exit 1" INT

# ------------------------------------------
# 󰓩 Native Compilation Flags
# ------------------------------------------

NATIVE_INCLUDE_FLAGS = -I. -I C:/raylib/raylib/src -I C:/raylib/raylib/src/external
NATIVE_LINK_FLAGS = -L. -L C:/raylib/raylib/src
NATIVE_LIBRARIES = -lraylib -lopengl32 -lgdi32 -lwinmm
NATIVE_FLAGS = $(NATIVE_INCLUDE_FLAGS) $(NATIVE_LINK_FLAGS) $(NATIVE_LIBRARIES)

# ------------------------------------------
# 󰂖 WebAssembly (Emscripten) Compilation Flags
# ------------------------------------------

EMCC_COMPILER_FLAGS = -Wall -std=c++14 -D_DEFAULT_SOURCE -Wno-missing-braces -Wunused-result -Os
EMCC_INCLUDE_FLAGS = -I. -I C:/raylib/raylib/src -I C:/raylib/raylib/src/external
EMCC_LINK_FLAGS = -L. -L C:/raylib/raylib/src C:/raylib/raylib/src/web/libraylib.web.a
EMCC_MEMORY_FLAGS = -s USE_GLFW=3 -s ASYNCIFY -s TOTAL_MEMORY=67108864 -s FORCE_FILESYSTEM=1
EMCC_EXPORTS = -s EXPORTED_FUNCTIONS='["_free","_malloc","_main"]' -s EXPORTED_RUNTIME_METHODS='["ccall"]'
EMCC_SHELL_FILE = --shell-file C:/raylib/raylib/src/shell.html
EMCC_FLAGS = $(EMCC_COMPILER_FLAGS) $(EMCC_INCLUDE_FLAGS) $(EMCC_LINK_FLAGS) $(EMCC_MEMORY_FLAGS) $(EMCC_EXPORTS) $(EMCC_SHELL_FILE)

# ------------------------------------------
# 󰊠 Build Targets
# ------------------------------------------

# 󰚰 Main build command (selects the correct platform)
build: trap-interrupt
ifeq ($(PLATFORM),web)
	@echo "Compiling WebAssembly (Emscripten)"
	@"$(MAKE)" --no-print-directory check-emcc
	@"$(MAKE)" --no-print-directory emcc
else
	@echo "Compiling Native Windows Build"
	@"$(MAKE)" --no-print-directory check-raylib
	@"$(MAKE)" --no-print-directory native
endif

# 󰊠 Native Build (Windows)
native: $(SRC_FILES)
	@echo "Building Native Windows Executable..."
	@$(GCC) $(SRC_FILES) -o $(NATIVE_OUTPUT) $(NATIVE_FLAGS) || { echo "Error: Compilation failed!"; exit 1; }
	@echo "Native build complete: $(NATIVE_OUTPUT)"

# 󰂖 WebAssembly Build (Emscripten)
emcc:
	@echo "Compiling WebAssembly..."
	@$(EMCC) $(EMCC_SRC_FILES) -o $(WEB_OUTPUT) $(EMCC_INCLUDE_DIRS) $(EMCC_PRELOAD_FILES) $(EMCC_FLAGS) || { echo "Error: WebAssembly compilation failed!"; exit 1; }
	@echo "WebAssembly build complete: $(WEB_OUTPUT)"

# ------------------------------------------
# 󰨇 Run Targets
# ------------------------------------------

# 󰊠 Run Native Executable
run: native
	@echo "Running $(PROJECT_NAME)..."
	@$(NATIVE_OUTPUT) || { echo "Error: Failed to run executable."; exit 1; }

# 󰂖 Serve WebAssembly in Browser (Requires emrun)
serve: emcc
	@echo "Serving WebAssembly on localhost..."
	@emrun --port 8080 $(WEB_OUTPUT) || { echo "Error: Failed to start server."; exit 1; }

# ------------------------------------------
# 󰪥 Cleanup Targets
# ------------------------------------------

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BIN_DIR)/* $(WEB_DIR)/* || { echo "Error: Cleanup failed!"; exit 1; }

