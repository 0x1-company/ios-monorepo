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
	@swift build -c release --package-path ./BuildTools/XCTemplateInstallerTool --product XCTemplateInstaller
	./BuildTools/XCTemplateInstallerTool/.build/release/XCTemplateInstaller --xctemplate-path XCTemplates/TCA.xctemplate

generate:
	@cp ../bematch.jp/apps/bematch-server/schema.gql ./Packages/BeMatch/GraphQL/schema.graphqls
	@cp ../flycam.jp/apps/flycam-server/schema.gql ./Packages/FlyCam/GraphQL/schema.graphqls
	@cd BuildTools/ApolloTool && swift run Codegen --target BeMatch FlyCam
	$(MAKE) format

format:
	@swift build -c release --package-path ./BuildTools/SwiftFormatTool --product swiftformat
	./BuildTools/SwiftFormatTool/.build/release/swiftformat ./
