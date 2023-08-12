import PackagePlugin
import Foundation

@main struct Plugin: CommandPlugin {
    func performCommand(
        context: PluginContext,
        arguments: [String]
    ) async throws {
        print("Initializing...")

        let executables = context.package.products(ofType: ExecutableProduct.self)
        let executable: ExecutableProduct
        if executables.count == 1 {
            executable = executables[0]
        } else {
            throw StringError("Your package should include 1 executable product")
        }
        let parameters = PackageManager.BuildParameters()
        let output = try packageManager.build(.product(executable.name), parameters: parameters)

        print("\(output.logText)", terminator: "")

        let execPath = output.builtArtifacts.first(where: { $0.kind == .executable })!.path
        let appDirPath = context.pluginWorkDirectory.appending("\(executable.name).app")
        try? FileManager.default.removeItem(atPath: appDirPath.string)
        try FileManager.default.createDirectory(atPath: appDirPath.string, withIntermediateDirectories: true)

        guard let sourceModule = executable.mainTarget.sourceModule
            else { throw StringError("Expected main target to be a source module") }
        let resources = sourceModule.sourceFiles.filter { $0.type == .resource }
        guard let plist = resources.first(where: { $0.path.lastComponent == "PackInfo.plist" })?.path
            else { throw StringError("Expected main target to contain a PackInfo.plist") }

        let buildDir = execPath.removingLastComponent()

        var filesToCopy = [execPath]
        var targets = executable.targets
        while let target = targets.popLast() {
            if let binaryTarget = target as? BinaryArtifactTarget {
                filesToCopy += [buildDir.appending("\(binaryTarget.name).framework")]
            } else if let sourceTarget = target as? SourceModuleTarget {
                filesToCopy += sourceTarget.sourceFiles.filter { $0.type == .resource }.map(\.path)
            }
            for dependency in target.dependencies {
                switch dependency {
                case .product(let product):
                    if let dylib = product as? LibraryProduct, dylib.kind == .dynamic {
                        let lib = buildDir.appending("lib\(dylib.name).dylib")
                        filesToCopy += [lib]
                    }
                    targets.append(contentsOf: product.targets)
                case .target(let target):
                    targets.append(target)
                @unknown default:
                    break
                }
            }
        }

        for file in filesToCopy {
            let filename = file == plist ? "Info.plist" : file.lastComponent
            try FileManager.default.copyItem(atPath: file.string, toPath: appDirPath.appending(filename).string)
        }

        print("output: \(appDirPath)")
    }
}

struct StringError: Error, CustomStringConvertible {
    var description: String
    init(_ description: String) {
        self.description = description
    }
}
