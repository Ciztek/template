.PHONY: docs
docs: Doxyfile #? docs: create manpages and html docs
	@ doxygen $^

.PHONY: pdf
pdf: docs #? pdf: create a pdf docs
	$Q $(MAKE) -sC docs/latex >/dev/null
	@ ln -sf docs/latex/refman.pdf docs.pdf

.PHONY: docs-clean
docs-clean: #? docs-clean: remove the docs folder
	$Q $(RM) -r docs

.PHONY: docs-fclean
docs-fclean: docs-clean #? doc-fclean: remove the pdf doc-file
	$Q $(RM) docs.pdf

.PHONY: docs-re
.NOTPARALLEL: docs-re
docs-re: docs-fclean docs #? docs-re: redo manpages and html docs
