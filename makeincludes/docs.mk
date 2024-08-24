.PHONY: docs
docs: Doxyfile
	@ doxygen $^

.PHONY: pdf
pdf: docs
	$Q $(MAKE) -sC docs/latex >/dev/null
	@ ln -sf docs/latex/refman.pdf docs.pdf

.PHONY: docs-clean
docs-clean:
	$Q $(RM) -r docs

.PHONY: docs-fclean
docs-fclean: docs-clean
	$Q $(RM) docs.pdf

.PHONY: docs-re
.NOTPARALLEL: docs-re
docs-re: docs-fclean docs
