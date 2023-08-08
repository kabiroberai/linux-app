PRODUCT ?= MyApp
TARGET := arm64-apple-ios
CONFIG := $(if $(RELEASE),release,debug)

BUILD := .build/$(TARGET)/$(CONFIG)
EXEC := $(BUILD)/$(PRODUCT)
APP := $(BUILD)/$(PRODUCT).app

LDID := $(HOME)/.swiftpm/swift-sdks/darwin.artifactbundle/toolset/bin/ldid

all: sign

build:
	swift build -c $(CONFIG) --experimental-swift-sdk $(TARGET) --product $(PRODUCT)

package: build
	rm -rf $(APP)
	mkdir -p $(APP)
	cp -a $(EXEC) Resources/Info.plist Resources/embedded.mobileprovision $(APP)/

sign: package
	sed 's/$$(teamID)/'$$(openssl x509 -noout -subject -in Resources/identity.p12 | grep -Po 'OU\s*=\s*\K.*?(?=,)')'/g' \
		Resources/entitlements.xml > $(BUILD)/ent.xml
	$(LDID) -KResources/identity.p12 -S$(BUILD)/ent.xml $(APP)

install:
	ideviceinstaller install $(APP)

do: all install

clean:
	swift package clean
	rm -rf $(APP)

debug:
	idevicedebugserverproxy 1234

fix-lsp: build
	rm -rf .build/aarch64-unknown-linux-gnu/debug/ModuleCache
	mkdir -p .build/aarch64-unknown-linux-gnu/debug
	cp -a .build/arm64-apple-ios/debug/ModuleCache .build/aarch64-unknown-linux-gnu/debug/

.PHONY: all build package sign clean install do debug fix-lsp
