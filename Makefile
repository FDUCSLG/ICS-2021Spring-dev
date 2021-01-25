.PHONY: help verilate clean

help:
	@echo 'Hello, world!'

SV = verilator
SV_TARGET ?= RefCPU
SV_DIR = $(shell echo $(SV_TARGET) | tr A-Z a-z)
SV_VTOP = ./source/$(SV_DIR)/VTop.sv

SV_PKGS = \
	./source/include/common.sv \
	./source/include/$(SV_DIR)/pkgs.sv

SV_FILES = \
	$(wildcard ./source/util/*.sv) \
	$(wildcard ./source/include/*.sv) \
	$(wildcard ./source/include/*.svh) \
	$(wildcard ./source/include/$(SV_DIR)/*.sv) \
	$(wildcard ./source/include/$(SV_DIR)/*.svh) \
	$(wildcard ./source/$(SV_DIR)/**/*.sv)

SV_INCLUDE = \
	-I./source/util/ \
	-I./source/include/ \
	-I./source/include/$(SV_DIR)/ \
	-I./source/$(SV_DIR)/ \
	-I./source/$(SV_DIR)/*/

SV_FLAGS = \
	--cc --relative-includes \
	--Mdir build \
	-Wall -Wpedantic \
	-Wno-IMPORTSTAR \
	--top-module VTop \
	--prefix V$(SV_TARGET) \
	--trace-fst --trace-structs \
	$(SV_INCLUDE)

verilate: $(SV_VTOP) $(SV_FILES)
	$(SV) $(SV_FLAGS) $(SV_PKGS) $(SV_VTOP)

clean:
	rm -rf ./build/
