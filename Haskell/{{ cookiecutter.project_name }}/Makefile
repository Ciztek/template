NAME := {{ cookiecutter.binary_name }}

FLAGS := --allow-different-user

STACK_PATH := $(shell stack path --local-install-root $(FLAGS))
BIN_PATH := $(STACK_PATH)/bin/{{ cookiecutter.project_name }}-exe

all: $(NAME)

.PHONY: all $(NAME)

$(NAME):
	stack build $(FLAGS) && ln -sf $(BIN_PATH) $(NAME)

tests_run:
	stack build $(FLAGS) && \
	stack test $(FLAGS)

clean:
	rm -f $(NAME)
	stack clean $(FLAGS)

fclean: clean
	stack purge $(FLAGS)

.PHONY: clean fclean

re: fclean all

.PHONY: re
