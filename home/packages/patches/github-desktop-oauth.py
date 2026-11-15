from pathlib import Path

path = Path("app/src/main-process/main.ts")
source = path.read_text()

needle = "  if (__WIN32__ && args['protocol-launcher'] === true) {"

replacement = """  const isWindowsProtocolLaunch =
    __WIN32__ && args['protocol-launcher'] === true

  // On Linux the protocol handler is registered through a .desktop file
  // (`Exec=... %u`), so the URL is passed as a plain argument without
  // --protocol-launcher. macOS receives URLs through the `open-url` event
  // instead, which Electron doesn't emit on Linux.
  const linuxProtocolPrefixes = Array.from(
    possibleProtocols,
    p => p + '://'
  )
  const isLinuxProtocolLaunch =
    __LINUX__ &&
    argv.some(arg =>
      linuxProtocolPrefixes.some(prefix => arg.startsWith(prefix))
    )

  if (isWindowsProtocolLaunch || isLinuxProtocolLaunch) {"""

if source.count(needle) != 1:
    raise SystemExit(
        "OAuth patch failed: expected source fragment not found exactly once"
    )

path.write_text(source.replace(needle, replacement, 1))
