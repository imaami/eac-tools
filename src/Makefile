override DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
override SRC := $(wildcard $(DIR)*.c)
override OBJ := $(SRC:.c=.o)

override HEAD_CFLAGS := -std=gnu11 -Wall -Wextra
override TAIL_CFLAGS := $(if $(strip $(CFLAGS)),$(CFLAGS),-O3 -ggdb)

override CFLAGS := $(HEAD_CFLAGS) $(TAIL_CFLAGS)
override TARGET := dexor

CC := gcc

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
