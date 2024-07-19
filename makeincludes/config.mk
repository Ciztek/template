##
## EPITECH PROJECT, 2024
## arcade
## File description:
## config.mk
##

CC := g++

INC_DIR := includes

CFLAGS := -Wall -Wextra
CFLAGS += $(addprefix -iquote, $(INC_DIR))

LDFLAGS := -ldl

ifeq ($(FORCE_DEBUG),1)
  CFLAGS += -D DEBUG_MODE
endif

BUILD_DIR := .build

NAME := plazza
NAME_DEBUG := debug
NAME_ANGRY := asan
UNIT := unittests

ifeq ($(VPATH),)
    $(error No search path)
endif

ifeq ($(SRC),)
    $(error No sources)
endif

ifeq ($(TSRC),)
   $(warning No unittests)
endif
