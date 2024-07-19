##
## EPITECH PROJECT, 2024
## arcade
## File description:
## debug.mk
##

BUILD_DIR ?= .build

DEBUG_OBJ := $(SRC:%.cpp=$(BUILD_DIR)/debug/%.o)

$(BUILD_DIR)/debug/%.o: HEADER += "debug"
$(BUILD_DIR)/debug/%.o: %.cpp
	$Q mkdir -p $(dir $@)
	$Q $(CC) $(CFLAGS) -c $< -o $@
	$(call LOG, ":c" $(notdir $@))

$(NAME_DEBUG): CFLAGS += -D DEBUG_MODE -g3
$(NAME_DEBUG): $(DEBUG_OBJ)
	$Q $(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
	$(call LOG,":g$@")
