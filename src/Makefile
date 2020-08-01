override DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
override SRC := $(wildcard $(DIR)*.c)
override OBJ := $(SRC:.c=.o)

override TARGET := dexor

CC := gcc
CFLAGS := -march=native -mtune=native

override CFLAGS += -std=gnu11 -Wall -Wextra

.PHONY: all clean $(TARGET)

all: $(TARGET)

clean:
	rm -fr $(DIR)$(TARGET) $(OBJ)

$(TARGET): $(DIR)$(TARGET)

override define build-obj =
.PHONY: $$(notdir $(1))
$$(notdir $(1)): $(1)

$(1): $(1:.o=.c)
	cd "$$(DIR)" && \
	$$(CC) $$(CFLAGS) -c $$(notdir $$^) -o $$(notdir $$@)
endef

$(foreach obj,$(OBJ),$(eval $(call build-obj,$(obj))))

$(DIR)$(TARGET): $(OBJ)
	cd "$(DIR)" && $(CC) $(CFLAGS) $(notdir $^) -o $(notdir $@)
