##
## EPITECH PROJECT, 2024
## arcade
## File description:
## utils.mk
##

CMD_NOT_FOUND = $(error $(strip $(1)) is required for this rule)
CHECK_CMD = $(if $(shell command -v $(1)),, $(call CMD_NOT_FOUND, $(1)))
CHECK_CMDS = $(foreach cmd, $(1), $(call CHECK_CMD, $(cmd)))

EPOCH := $(shell date +%d_%m_%y_%Hh%Mm)
DIE := exit 1
