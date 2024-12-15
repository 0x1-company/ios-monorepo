PLATFORM_IOS = iOS Simulator,name=iPhone 16 Pro,OS=18.1

bootstrap: secrets

bematch:
	open BeMatch.xcworkspace

picmatch:
	open PicMatch.xcworkspace

tapmatch:
	open TapMatch.xcworkspace

tenmatch:
	open TenMatch.xcworkspace

trinket:
	open Trinket.xcworkspace

clean:
	rm -rf **/*/.build

build-all:
	@xcodebuild build \
		-workspace BeMatch.xcworkspace \
		-scheme "App (Staging project)" \
		-destination platform="$(PLATFORM_IOS)" \
		-skipMacroValidation | xcpretty

	@xcodebuild build \
		-workspace PicMatch.xcworkspace \
		-scheme "App (Staging project)" \
		-destination platform="$(PLATFORM_IOS)" \
		-skipMacroValidation | xcpretty

	@xcodebuild build \
		-workspace TapMatch.xcworkspace \
		-scheme "App (Staging project)" \
		-destination platform="$(PLATFORM_IOS)" \
		-skipMacroValidation | xcpretty

	@xcodebuild build \
		-workspace TenMatch.xcworkspace \
		-scheme "App (Staging project)" \
		-destination platform="$(PLATFORM_IOS)" \
		-skipMacroValidation | xcpretty

	@xcodebuild build \
		-workspace Trinket.xcworkspace \
		-scheme "App (Staging project)" \
		-destination platform="$(PLATFORM_IOS)" \
		-skipMacroValidation | xcpretty

resolve-dependencies:
	@for workspace in BeMatch PicMatch TapMatch TenMatch Trinket; do \
		rm -f $$workspace.xcworkspace/xcshareddata/swiftpm/Package.resolved; \
		xcodebuild -resolvePackageDependencies \
			-workspace $$workspace.xcworkspace \
			-scheme "App (Staging project)"; \
	done

secrets: # Set secrets
	echo $(BEMATCH_FILE_FIREBASE_STAGING) | base64 -D > App/BeMatch/Multiplatform/Staging/GoogleService-Info.plist
	echo $(PICMATCH_FILE_FIREBASE_STAGING) | base64 -D > App/PicMatch/Multiplatform/Staging/GoogleService-Info.plist
	echo $(TRINKET_FILE_FIREBASE_STAGING) | base64 -D > App/Trinket/Multiplatform/Staging/GoogleService-Info.plist
	echo $(TAPMATCH_FILE_FIREBASE_STAGING) | base64 -D > App/TapMatch/Multiplatform/Staging/GoogleService-Info.plist
	echo $(TENMATCH_FILE_FIREBASE_STAGING) | base64 -D > App/TenMatch/Multiplatform/Staging/GoogleService-Info.plist

install-template: # Install template
	@swift build -c release --package-path ./SwiftScripts/XCTemplateInstallerTool --product XCTemplateInstaller
	./SwiftScripts/XCTemplateInstallerTool/.build/release/XCTemplateInstaller --xctemplate-path XCTemplates/Logic.xctemplate
	./SwiftScripts/XCTemplateInstallerTool/.build/release/XCTemplateInstaller --xctemplate-path XCTemplates/Feature.xctemplate

generate:
	@cp ../bematch.jp/typescript/apps/bematch-server/schema.gql ./Packages/MatchCore/GraphQL/schema.graphqls
	@cd SwiftScripts/ApolloTool && swift run Codegen --target MatchCore
	$(MAKE) format

format:
	@swift build -c release --package-path ./SwiftScripts/SwiftFormatTool --product swiftformat
	./SwiftScripts/SwiftFormatTool/.build/release/swiftformat ./
