##
## EPITECH PROJECT, 2024
## arcade
## File description:
## docs.mk
##

docs: Doxyfile
	doxygen $^

.PHONY: docs

pdf: docs
	$(MAKE) -C docs/latex
	@ ln -sf docs/latex/refman.pdf docs.pdf

.PHONY: pdf

docs_clean:
	$(RM) -r docs

docs_fclean: docs_clean
	$(RM) docs.pdf

.PHONY: docs_clean docs_fclean
