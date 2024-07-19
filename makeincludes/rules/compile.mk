##
## EPITECH PROJECT, 2024
## arcade
## File description:
## compile.mk
##

BUILD_DIR ?= .build

OBJ := $(SRC:%.cpp=$(BUILD_DIR)/prod/%.o)

$(BUILD_DIR)/prod/%.o: HEADER += "release"
$(BUILD_DIR)/prod/%.o: %.cpp
	$Q mkdir -p $(dir $@)
	$Q $(CC) $(CFLAGS) -c $< -o $@
	$(call LOG, ":c" $(notdir $@))

$(NAME): $(OBJ)
	$Q $(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
	$(call LOG,":g$@")
