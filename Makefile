# m4ke - static site generator using m4, make and bash

INPUT_FOLDER := /input/folder

OUTPUT_FOLDER := /output/folder

# Get list of files that need to be processed
M4_FILES := $(wildcard $(INPUT_FOLDER)/*.m4)

# Generate list of corresponding output files
OUTPUT_FILES := $(patsubst $(INPUT_FOLDER)/%.m4,$(OUTPUT_FOLDER)/%.html,$(INPUT_FOLDER))

# process each m4 file and generate html
$(OUTPUT_FOLDER)/%.html: $(INPUT_FOLDER)/%.m4
  m4 -I $(INPUT_FOLDER) "$<" > "$@"

# create output folder and copy static files
$(shell mkdir -p $(OUTPUT_FOLDER))
$(shell cp style.css $(OUTPUT_FOLDER))

all: $(OUTPUT_FILES)

clean:
  rm -f $(OUTPUT_FOLDER)/*

.PHONY: clean all
