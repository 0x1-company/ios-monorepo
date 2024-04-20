bootstrap: secrets

bematch:
	open BeMatch.xcworkspace

locket:
	open LocketMatch.xcworkspace

tapnow:
	open TapNowMatch.xcworkspace

flycam:
	open FlyCam.xcworkspace

dependencies:
	open Dependencies.xcworkspace

clean:
	rm -rf **/*/.build

secrets: # Set secrets
	echo $(FLYCAM_FILE_FIREBASE_STAGING) | base64 -D > App/FlyCam/Multiplatform/Staging/GoogleService-Info.plist
	echo $(BEMATCH_FILE_FIREBASE_STAGING) | base64 -D > App/BeMatch/Multiplatform/Staging/GoogleService-Info.plist
	echo $(BEMATCH_FILE_FIREBASE_STAGING) | base64 -D > App/LocketMatch/Multiplatform/Staging/GoogleService-Info.plist
	echo $(BEMATCH_FILE_FIREBASE_STAGING) | base64 -D > App/TapNowMatch/Multiplatform/Staging/GoogleService-Info.plist

install-template: # Install template
	@swift build -c release --package-path ./SwiftScripts/XCTemplateInstallerTool --product XCTemplateInstaller
	./SwiftScripts/XCTemplateInstallerTool/.build/release/XCTemplateInstaller --xctemplate-path XCTemplates/TCA.xctemplate

generate:
	@cp ../bematch.jp/typescript/apps/bematch-server/schema.gql ./Packages/MatchCore/GraphQL/schema.graphqls
	@cp ../flycam.jp/apps/flycam-server/schema.gql ./Packages/FlyCam/GraphQL/schema.graphqls
	@cd SwiftScripts/ApolloTool && swift run Codegen --target MatchCore FlyCam
	$(MAKE) format

format:
	@swift build -c release --package-path ./SwiftScripts/SwiftFormatTool --product swiftformat
	./SwiftScripts/SwiftFormatTool/.build/release/swiftformat ./
