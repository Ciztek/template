fclean: clean
	$Q $(RM) -r $(_fclean)
	$Q $(RM) -r *.gcov.json.gz
	$Q $(RM) -r $(BUILD_DIR)
