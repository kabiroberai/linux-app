import PackagePlugin

@main struct Plugin: CommandPlugin {
    func performCommand(
        context: PluginContext,
        arguments: [String]
    ) async throws {
        try await packageManager.build(
            .product("MyApp"),
            parameters: .init()
        )
    }
}
