ExUnit.configure(exclude: [:pending])
ExUnit.configure(seed: 0)
ExUnit.configure(formatters: [ExUnit.CLIFormatter, ExUnitNotifier])
# Code.put_compiler_option(:warnings_as_errors, true)
ExUnit.start()
