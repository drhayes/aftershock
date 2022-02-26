# OLD_SHELL := $(SHELL)
# SHELL = $(warning Building $@)$(OLD_SHELL)

GAME_NAME := aftershock
LOVE_VERSION := 11.4

# All the dang dirs and files.
SRC_DIR := src
ASSETS_DIR := assets
TMP_DIR := tmp
IMAGES_DIR := media/images
JSON_DIR := media/json
RELEASE_DIR := release
BIN_DIR := bin
ETC_DIR := etc
SQUASH_FS_DIR := $(BIN_DIR)/squashfs-root


VERSION_FILE := $(SRC_DIR)/version.lua


IMAGE_ASSETS_DIR := $(ASSETS_DIR)/images
IMAGE_ASSETS := $(wildcard $(IMAGE_ASSETS_DIR)/*.ase)
IMAGE_FILES=$(patsubst $(IMAGE_ASSETS_DIR)/%.ase,$(IMAGES_DIR)/%.png,$(IMAGE_ASSETS))


LUA_FILES_FOR_LINT=$(shell fdfind --type file --extension lua . ./src)


LOVE_FILE=$(RELEASE_DIR)/$(GAME_NAME).love
GR_APP_IMAGE=$(RELEASE_DIR)/$(GAME_NAME).AppImage
WINDOWS_PREFIX=$(RELEASE_DIR)/$(GAME_NAME)-win64
WINDOWS_FILE=$(WINDOWS_PREFIX).zip
OSX_PREFIX=$(RELEASE_DIR)/$(GAME_NAME).app
OSX_FILE=$(RELEASE_DIR)/$(GAME_NAME)-osx.zip

WINDOWS_LOVE=love-$(LOVE_VERSION)-win64
OSX_LOVE=love-$(LOVE_VERSION)-macos


# Programs I care about.
ASEPRITE=/usr/bin/aseprite
TEXTUREPACKER=/usr/bin/TexturePacker
APPIMAGETOOL=$(BIN_DIR)/appimagetool-x86_64.AppImage
LOVE_APPIMAGE=$(BIN_DIR)/love-$(LOVE_VERSION)-x86_64.AppImage


# Help me semver this thing.
# From: https://gist.github.com/grihabor/4a750b9d82c9aa55d5276bd5503829be
DESCRIBE           := $(shell git describe --match "v*" --always --tags)
DESCRIBE_PARTS     := $(subst -, ,$(DESCRIBE))

VERSION_TAG        := $(word 1,$(DESCRIBE_PARTS))

VERSION            := $(subst v,,$(VERSION_TAG))
VERSION_PARTS      := $(subst ., ,$(VERSION))

MAJOR              := $(word 1,$(VERSION_PARTS))
MINOR              := $(word 2,$(VERSION_PARTS))
PATCH              := $(word 3,$(VERSION_PARTS))

NEXT_MAJOR         := $(shell echo $$(($(MAJOR)+1)))
NEXT_MINOR         := $(shell echo $$(($(MINOR)+1)))
NEXT_PATCH          = $(shell echo $$(($(PATCH)+1)))


################
### Phonies ###
###############

.PHONY: debug
debug: all
	@exec love $(SRC_DIR) debug

.PHONY: checkit
checkit:
	echo $(SRC_DIR)

.PHONY: start
start: all
	@exec love $(SRC_DIR)

.PHONY: trace
trace: all
	@exec love $(SRC_DIR) trace

.PHONY: all
all: $(SRC_DIR)/lib icon mediaLink images

.PHONY: icon
icon: $(IMAGES_DIR)/icon.png

.PHONY: images
images: $(IMAGE_FILES)

.PHONY: mediaLink
mediaLink: $(SRC_DIR)/media

.PHONY: clean
clean:
	rm -rf $(IMAGES_DIR)

.PHONY: lint
lint:
	luacheck --quiet $(LUA_FILES_FOR_LINT)

.PHONY: lastversion
lastversion:
	@git describe --abbrev=0 --tags

.PHONY: patch
patch:
	git tag -a v$(MAJOR).$(MINOR).$(NEXT_PATCH)

.PHONY: minor
minor:
	git tag -a v$(MAJOR).$(NEXT_MINOR).0

.PHONY: major
major:
	git tag -a v$(NEXT_MAJOR).0.0



#######################
### Directory rules ###
#######################

$(SRC_DIR)/lib:
	cd $(SRC_DIR) && \
		ln -s ../lib lib

$(SRC_DIR)/media:
	cd $(SRC_DIR) && \
		ln -s ../media media

$(JSON_DIR):
	mkdir -p $@

$(IMAGES_DIR):
	mkdir -p $@

$(RELEASE_DIR):
	mkdir -p $@

$(BIN_DIR):
	mkdir -p $@


###########################
### Images, icon ###
###########################

$(IMAGES_DIR)/icon.png: $(ASSETS_DIR)/icon.ase
	$(ASEPRITE) --batch $< --save-as $@

$(IMAGE_FILES): $(IMAGES_DIR)/%.png: $(IMAGE_ASSETS_DIR)/%.ase
	$(ASEPRITE) --batch $< --save-as $@

#######################
### Build for Linux ###
#######################

$(LOVE_FILE): $(RELEASE_DIR)
	(bash -c '\
		VERSION=`git describe --abbrev=0 --tags` && \
		echo return \"$$VERSION\" > $(VERSION_FILE) \
		'\
	)
	cd $(SRC_DIR) && \
		zip -9 -r "../$(LOVE_FILE)" ./* -x test/



##########################
### Build for AppImage ###
##########################

$(GR_APP_IMAGE): $(RELEASE_DIR) $(APPIMAGETOOL) $(LOVE_APPIMAGE) $(LOVE_FILE)
	cd bin && \
		./love-$(LOVE_VERSION)-x86_64.AppImage --appimage-extract
	cat $(SQUASH_FS_DIR)/bin/love $(LOVE_FILE) > $(SQUASH_FS_DIR)/bin/$(GAME_NAME)
	chmod u+x $(SQUASH_FS_DIR)/bin/$(GAME_NAME)
	rm $(SQUASH_FS_DIR)/bin/love
	rm $(SQUASH_FS_DIR)/love.svg
	rm $(SQUASH_FS_DIR)/.DirIcon
	rm $(SQUASH_FS_DIR)/love.desktop
	cp $(ETC_DIR)/$(GAME_NAME).desktop $(SQUASH_FS_DIR)/
	cp $(IMAGES_DIR)/icon.png $(SQUASH_FS_DIR)/
	$(APPIMAGETOOL) $(SQUASH_FS_DIR) $(GR_APP_IMAGE)
	chmod u+x $(GR_APP_IMAGE)


$(APPIMAGETOOL): $(BIN_DIR)
	cd bin && \
		curl -OL https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
	chmod u+x $(APPIMAGETOOL)


$(LOVE_APPIMAGE): $(BIN_DIR)
	cd bin && \
		curl -OL "https://github.com/love2d/love/releases/download/$(LOVE_VERSION)/love-$(LOVE_VERSION)-x86_64.AppImage"
	chmod u+x $(LOVE_APPIMAGE)



#########################
### Build for Windows ###
#########################

bin/$(WINDOWS_LOVE).zip: $(BIN_DIR)
	cd bin && \
		curl -OL "https://github.com/love2d/love/releases/download/$(LOVE_VERSION)/$(WINDOWS_LOVE).zip"


$(WINDOWS_FILE): $(RELEASE_DIR) $(LOVE_FILE) bin/$(WINDOWS_LOVE).zip
	unzip -j $(BIN_DIR)/$(WINDOWS_LOVE).zip -d $(WINDOWS_PREFIX)
	cat $(WINDOWS_PREFIX)/love.exe $(LOVE_FILE) > "$(WINDOWS_PREFIX)/$(GAME_NAME).exe"
	rm $(WINDOWS_PREFIX)/love.exe $(WINDOWS_PREFIX)/lovec.exe
	zip -r "$(WINDOWS_FILE)" "$(WINDOWS_PREFIX)/"



#####################
### Build for OSX ###
#####################

bin/$(OSX_LOVE).zip: $(BIN_DIR)
	cd bin && \
		curl -OL "https://github.com/love2d/love/releases/download/$(LOVE_VERSION)/$(OSX_LOVE).zip"

$(OSX_FILE): $(RELEASE_DIR) $(LOVE_FILE) bin/$(OSX_LOVE).zip
	unzip $(BIN_DIR)/$(OSX_LOVE).zip -d $(RELEASE_DIR)
	mv $(RELEASE_DIR)/love.app $(OSX_PREFIX)
	cp $(LOVE_FILE) $(OSX_PREFIX)/Contents/Resources/
	cp $(ETC_DIR)/Info.plist $(OSX_PREFIX)/Contents/Info.plist
	zip -r "$(OSX_FILE)" "$(OSX_PREFIX)/"
