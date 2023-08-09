PRODUCT ?= MyApp
TARGET := arm64-apple-ios
CONFIG := $(if $(RELEASE),release,debug)

BUILD := .build/$(TARGET)/$(CONFIG)
EXEC := $(BUILD)/$(PRODUCT)
APP := $(BUILD)/$(PRODUCT).app

TEAMID := $(shell openssl x509 -noout -subject -in Resources/identity.p12 | grep -Po 'OU\s*=\s*\K.*?(?=,)')
SDK := $(shell swift experimental-sdk configuration show darwin $(TARGET) | grep -Po 'sdkRootPath: \K.*\.artifactbundle')
export LDID := $(SDK)/toolset/bin/ldid

all: build fix-lsp

build:
	swift build -c $(CONFIG) --experimental-swift-sdk $(TARGET) --product $(PRODUCT)

bundle:
	rm -rf $(APP)
	mkdir -p $(APP)
	cp -a $(EXEC) Resources/Info.plist $(APP)/

sign:
	cp -a Resources/embedded.mobileprovision $(APP)/
	@sed 's/$$(teamID)/$(TEAMID)/g' Resources/entitlements.plist > $(BUILD)/entitlements.plist
	$$LDID -KResources/identity.p12 -S$(BUILD)/entitlements.plist $(APP)

install:
	ideviceinstaller install $(APP)

package: all bundle sign
do: package install

clean:
	swift package clean

debug:
	idevicedebugserverproxy 1234

# https://github.com/apple/swift/issues/67789
# https://github.com/apple/sourcekit-lsp/issues/786
fix-lsp:
	@rm -rf .build/aarch64-unknown-linux-gnu
	@ln -s arm64-apple-ios .build/aarch64-unknown-linux-gnu

.PHONY: all build bundle sign install package do clean debug fix-lsp
