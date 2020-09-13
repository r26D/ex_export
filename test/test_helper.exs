ExUnit.configure(exclude: [:pending])
ExUnit.configure(seed: 0)
ExUnit.configure(formatters: [ExUnit.CLIFormatter, ExUnitNotifier])
ExUnit.start()
