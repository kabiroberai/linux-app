PRODUCT ?= MyApp
TARGET := arm64-apple-ios
CONFIG := $(if $(RELEASE),release,debug)

BUILD := .build/$(TARGET)/$(CONFIG)
APP := .build/plugins/Pack/outputs/MyApp.app

TEAMID := $(shell openssl x509 -noout -subject -in Signing/identity.p12 | grep -Po 'OU\s*=\s*\K.*?(?=,)')
SDK := $(shell swift experimental-sdk configuration show darwin $(TARGET) | grep -Po 'sdkRootPath: \K.*\.artifactbundle')
export LDID := $(SDK)/toolset/bin/ldid

all: build fix-lsp

build:
	swift build -c $(CONFIG) --experimental-swift-sdk $(TARGET) --product $(PRODUCT)

bundle:
	swift package --experimental-swift-sdk $(TARGET) pack

sign:
	cp -a Signing/embedded.mobileprovision $(APP)/
	@sed 's/$$(teamID)/$(TEAMID)/g' Signing/app.entitlements > $(BUILD)/app.entitlements
	$$LDID -KSigning/identity.p12 -S$(BUILD)/app.entitlements $(APP)

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
