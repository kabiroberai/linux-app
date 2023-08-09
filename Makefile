PRODUCT ?= MyApp
TARGET := arm64-apple-ios
CONFIG := $(if $(RELEASE),release,debug)

BUILD := .build/$(TARGET)/$(CONFIG)
EXEC := $(BUILD)/$(PRODUCT)
APP := $(BUILD)/$(PRODUCT).app

TEAMID := $(shell openssl x509 -noout -subject -in Resources/identity.p12 | grep -Po 'OU\s*=\s*\K.*?(?=,)')
SDK := $(shell swift experimental-sdk configuration show darwin arm64-apple-ios | grep -Po 'sdkRootPath: \K/.*/darwin.artifactbundle')
export LDID := $(SDK)/toolset/bin/ldid

all:
	swift build -c $(CONFIG) --experimental-swift-sdk $(TARGET) --product $(PRODUCT)

bundle:
	rm -rf $(APP)
	mkdir -p $(APP)
	cp -a $(EXEC) Resources/Info.plist Resources/embedded.mobileprovision $(APP)/

sign:
	sed 's/$$(teamID)/$(TEAMID)/g' Resources/entitlements.xml > $(BUILD)/entitlements.xml
	$$LDID -KResources/identity.p12 -S$(BUILD)/entitlements.xml $(APP)

install:
	ideviceinstaller install $(APP)

package: all bundle sign
do: package install

clean:
	swift package clean
	rm -rf $(APP)

debug:
	idevicedebugserverproxy 1234

# https://github.com/apple/swift/issues/67789
fix-lsp: all
	rm -rf .build/aarch64-unknown-linux-gnu
	ln -s arm64-apple-ios .build/aarch64-unknown-linux-gnu

.PHONY: all bundle sign install package do clean debug fix-lsp
