##
## EPITECH PROJECT, 2024
## arcade
## File description:
## unittests.mk
##

BUILD_DIR ?= .build

TEST_OBJ := $(TSRC:%.cpp=$(BUILD_DIR)/tests/tests/%.o)
TEST_OBJ += $(filter-out %main.o, $(SRC:%.cpp=$(BUILD_DIR)/tests/sources/%.o))

$(BUILD_DIR)/tests/tests/%.o: HEADER += "tests"
$(BUILD_DIR)/tests/tests/%.o: %.cpp
	$Q mkdir -p $(dir $@)
	$Q $(CC) $(CFLAGS) -c $< -o $@
	$(call LOG, ":c" $(notdir $@))

$(BUILD_DIR)/tests/sources/%.o: HEADER += "tests"
$(BUILD_DIR)/tests/sources/%.o: %.cpp
	$Q mkdir -p $(dir $@)
	$Q $(CC) $(CFLAGS) -c $< -o $@
	$(call LOG, ":c" $(notdir $@))

$(UNIT): CFLAGS += -g3 --coverage -fprofile-arcs -D DEBUG_MODE
$(UNIT): CFLAGS += -iquote tests/include
$(UNIT): LDLIBS += -lcriterion
$(UNIT): $(TEST_OBJ)
	$Q $(CC) -o $@ $^ $(CFLAGS) $(LDLIBS) $(LDFLAGS)
	$(call LOG,":g$@")

tests_run: $(UNIT)
	@ ./$(UNIT) -OP:F --full-stats

.PHONY: tests_run

cov: tests_run
	$Q $(call CHECK_CMD, gcovr)
	$Q gcovr . --object-directory .build/tests \
		--gcov-ignore-errors=no_working_dir_found \
		--exclude-unreachable-branches \
		--exclude test \
		--exclude .direnv \
		--txt-metric branch
	$Q gcovr . --object-directory .build/tests \
		--gcov-ignore-errors=no_working_dir_found \
		--exclude-unreachable-branches \
		--exclude test \
		--exclude .direnv \

.PHONY: cov
