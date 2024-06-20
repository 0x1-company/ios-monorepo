bootstrap: secrets

bematch:
	open BeMatch.xcworkspace

tapmatch:
	open TapMatch.xcworkspace

tenmatch:
	open TenMatch.xcworkspace

trinket:
	open Trinket.xcworkspace

clean:
	rm -rf **/*/.build

secrets: # Set secrets
	echo $(BEMATCH_FILE_FIREBASE_STAGING) | base64 -D > App/BeMatch/Multiplatform/Staging/GoogleService-Info.plist
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
