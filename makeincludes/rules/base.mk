##
## EPITECH PROJECT, 2024
## arcade
## File description:
## base.mk
##

BUILD_DIR ?= .build

BINARIES := $(NAME) $(NAME_DEBUG) $(NAME_ANGRY) $(UNIT)

all: $(NAME)

.PHONY: all

clean:
	$Q $(RM) -r $(BUILD_DIR)

fclean:
	$Q $(RM) $(BINARIES)
	$Q $(RM) -r $(BUILD_DIR)

.PHONY: clean fclean

re: fclean all

.PHONY: re
.PARALLEL: re

bundle: $(BINARIES)

.PHONY: bundle
