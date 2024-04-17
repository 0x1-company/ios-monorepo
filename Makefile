bootstrap: secrets

bematch:
	open BeMatch.xcworkspace

flycam:
	open FlyCam.xcworkspace

sdk:
	open SDK.xcworkspace

clean:
	rm -rf **/*/.build

secrets: # Set secrets
	echo $(BEMATCH_FILE_FIREBASE_STAGING) | base64 -D > App/BeMatch/Multiplatform/Staging/GoogleService-Info.plist
	echo $(FLYCAM_FILE_FIREBASE_STAGING) | base64 -D > App/FlyCam/Multiplatform/Staging/GoogleService-Info.plist

install-template: # Install template
	@swift build -c release --package-path ./SwiftScripts/XCTemplateInstallerTool --product XCTemplateInstaller
	./SwiftScripts/XCTemplateInstallerTool/.build/release/XCTemplateInstaller --xctemplate-path XCTemplates/TCA.xctemplate

generate:
	@cp ../bematch.jp/typescript/apps/bematch-server/schema.gql ./Packages/BeMatch/GraphQL/schema.graphqls
	@cp ../flycam.jp/apps/flycam-server/schema.gql ./Packages/FlyCam/GraphQL/schema.graphqls
	@cd SwiftScripts/ApolloTool && swift run Codegen --target BeMatch MatchLogic FlyCam
	$(MAKE) format

format:
	@swift build -c release --package-path ./SwiftScripts/SwiftFormatTool --product swiftformat
	./SwiftScripts/SwiftFormatTool/.build/release/swiftformat ./
