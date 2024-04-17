import ApolloCodegenLib
import ArgumentParser
import Foundation
import SwiftScriptHelpers

@main
struct Codegen: AsyncParsableCommand {
  @Option(
    wrappedValue: [],
    name: [.customLong("target"), .customShort("t")],
    parsing: .upToNextOption,
    help: "The target to generate code for."
  )
  var targetNames: [String]

  func run() async throws {
    let parentFolderOfScriptFile = FileFinder.findParentFolder()

    let sourceRootURL = parentFolderOfScriptFile
      .parentFolderURL() // Sources
      .parentFolderURL() // ApolloTools
      .parentFolderURL() // BuildScripts
      .parentFolderURL() // ios-app

    for targetName in targetNames {
      let moduleURL = sourceRootURL
        .childFolderURL(folderName: "Packages")
        .childFolderURL(folderName: targetName)

      let graphQLFolder = moduleURL.childFolderURL(folderName: "GraphQL")

      let codegenConfiguration = ApolloCodegenConfiguration(
        schemaNamespace: "API",
        input: ApolloCodegenConfiguration.FileInput(
          schemaPath: graphQLFolder.appendingPathComponent("schema.graphqls").path,
          operationSearchPaths: [graphQLFolder.appendingPathComponent("**/*.graphql").path]
        ),
        output: ApolloCodegenConfiguration.FileOutput(
          schemaTypes: ApolloCodegenConfiguration.SchemaTypesFileOutput(
            path: moduleURL.childFolderURL(folderName: "Sources").childFolderURL(folderName: "API").path,
            moduleType: ApolloCodegenConfiguration.SchemaTypesFileOutput.ModuleType.embeddedInTarget(
              name: "API",
              accessModifier: ApolloCodegenConfiguration.AccessModifier.public
            )
          ),
          operations: .inSchemaModule
        )
      )

      try await ApolloCodegen.build(with: codegenConfiguration)
    }
  }
}
