##
## EPITECH PROJECT, 2024
## arcade
## File description:
## angry.mk
##

BUILD_DIR ?= .build

ANGRY_OBJ := $(SRC:%.cpp=$(BUILD_DIR)/angry/%.o)

$(BUILD_DIR)/angry/%.o: HEADER += "angry"
$(BUILD_DIR)/angry/%.o: %.cpp
	$Q mkdir -p $(dir $@)
	$Q $(CC) $(CFLAGS) -c $< -o $@
	$(call LOG, ":c" $(notdir $@))

$(NAME_ANGRY): CFLAGS += -g3 -D DEBUG_MODE
$(NAME_ANGRY): CFLAGS += -fsanitize=address,leak,undefined
$(NAME_ANGRY): $(ANGRY_OBJ)
	$Q $(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
	$(call LOG,":g$@")
