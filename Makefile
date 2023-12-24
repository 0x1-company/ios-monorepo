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

gql-schema:
	@cp ../godapp.jp/apps/god-server/schema.gql ./GraphQL/schema.graphqls

apollo-cli-install:
	@swift package --package-path ./BuildTools/ApolloTool --allow-writing-to-package-directory apollo-cli-install

apollo-generate:
	./BuildTools/ApolloTool/apollo-ios-cli generate --ignore-version-mismatch

format:
	@swift build -c release --package-path ./BuildTools/SwiftFormatTool --product swiftformat
	./BuildTools/SwiftFormatTool/.build/release/swiftformat ./
