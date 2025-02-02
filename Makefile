# Makefile to generate website using m4 files in a given folder
BASE_URL="https://domain.com"

# Define the folder containing the .m4 files
INPUT_FOLDER := input

# Define the output folder for the processed files
OUTPUT_FOLDER := output

# Get a list of all post .m4 files in the folder
# this will only process files of the following format YYYY-MM-dd_post_title.m4
# here YYYY will start start with 2 for atleast another ~970 years.
M4_FILES := $(wildcard $(INPUT_FOLDER)/2*.m4)

# Generate the list of output files
OUTPUT_FILES := $(patsubst $(INPUT_FOLDER)/%.m4,$(OUTPUT_FOLDER)/%.html,$(M4_FILES))

# Generate list of output file names without extensions
POST_LIST := $(shell find $(INPUT_FOLDER) -type f -name 2*.m4 | sort -r | xargs -I % basename %)

# Get the latest post
LATEST_POST := $(shell find $(INPUT_FOLDER) -type f -name 2*.m4 | sort -r | head -n 1)

.PHONY: setup static posts pages index index_post
.NOTPARALLEL: setup static posts pages index index_post
.SILENT: static

# Rule to process each .m4 file and generate the output
$(OUTPUT_FOLDER)/%.html: $(INPUT_FOLDER)/%.m4
	m4 -I $(INPUT_FOLDER) "$<" > "$@"

static:
	cp -f $(INPUT_FOLDER)/style.css $(OUTPUT_FOLDER)/style.css || echo '$(INPUT_FOLDER)/style.css not found!'

setup:
	# Create the output folder if it doesn't exist
	mkdir -p $(OUTPUT_FOLDER)

posts: $(OUTPUT_FILES)

index_post:
	m4 -I $(INPUT_FOLDER) "$(LATEST_POST)" > "$(OUTPUT_FOLDER)/index.html"

index:
	rm -f $(OUTPUT_FOLDER)/tmp_index_items  $(OUTPUT_FOLDER)/tmp_sitemap_items;
	echo "<url><loc>$$BASE_URL/00_about.html</loc><lastmod>$$(date +%F)</lastmod></url>" >> $(OUTPUT_FOLDER)/tmp_sitemap_items;
	echo "<url><loc>$$BASE_URL/00_contact.html</loc><lastmod>$$(date +%F)</lastmod></url>" >> $(OUTPUT_FOLDER)/tmp_sitemap_items;
	echo "<url><loc>$$BASE_URL/00_posts.html</loc><lastmod>$$(date +%F)</lastmod></url>" >> $(OUTPUT_FOLDER)/tmp_sitemap_items;
	for post in $(POST_LIST); do \
		name=$$(basename $${post%.*}); \
		link=$$(echo $$name.html); \
                post_date=$$(echo $$name | cut -d'_' -f1); \
		human=$$(echo $$name | sed 's/_/ /g'); \
		echo "<a href='$$link'>$$human</a><br/>" >> $(OUTPUT_FOLDER)/tmp_index_items; \
                echo "<url><loc>$$BASE_URL/$$link</loc><lastmod>$$post_date</lastmod></url>" >> $(OUTPUT_FOLDER)/tmp_sitemap_items; \
	done
	m4 -I $(INPUT_FOLDER) -I $(OUTPUT_FOLDER) 00_posts.m4 > $(OUTPUT_FOLDER)/00_posts.html
	m4 -I $(INPUT_FOLDER) -I $(OUTPUT_FOLDER) 00_sitemap.xml > $(OUTPUT_FOLDER)/sitemap.xml
	rm -f $(OUTPUT_FOLDER)/tmp_index_items $(OUTPUT_FOLDER)/tmp_sitemap_items

pages:
	m4 -I $(INPUT_FOLDER) 00_about.m4 > $(OUTPUT_FOLDER)/00_about.html
	m4 -I $(INPUT_FOLDER) 00_contact.m4 > $(OUTPUT_FOLDER)/00_contact.html

all: setup static posts pages index index_post

# Clean rule to remove all processed files
clean:
	rm -f $(OUTPUT_FOLDER)/*

