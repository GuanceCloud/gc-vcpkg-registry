# GuanceCloud vcpkg Registry

Git-based vcpkg registry for GuanceCloud C and C++ SDK packages. Multiple SDKs share this repository under independent port names and version histories.

## Available ports

| Port | Description | Source |
| --- | --- | --- |
| `datakit-sdk-cpp` | Guance C++ SDK for collecting RUM, log, and trace data. | [GuanceCloud/datakit-cpp](https://github.com/GuanceCloud/datakit-cpp) |
| `guance-windows-native` | Guance Windows native observability SDK for RUM, distributed tracing, and logging. | [GuanceCloud/datakit-windows-desktop](https://github.com/GuanceCloud/datakit-windows-desktop) |

## Use this registry

Add a `vcpkg-configuration.json` file to the project. Pin both baselines to commits that are compatible with the project; the custom registry baseline must be a commit from this repository that contains the requested port version.

```json
{
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/microsoft/vcpkg",
    "baseline": "<microsoft-vcpkg-commit>"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/GuanceCloud/gc-vcpkg-registry.git",
      "baseline": "<gc-vcpkg-registry-commit>",
      "packages": [
        "datakit-sdk-cpp",
        "guance-windows-native"
      ]
    }
  ]
}
```

Declare the required port in the project's `vcpkg.json` manifest. For example:

```json
{
  "dependencies": [
    "guance-windows-native"
  ]
}
```

Then run vcpkg in manifest mode:

```console
vcpkg install
```

See Microsoft's [Git registry tutorial](https://learn.microsoft.com/vcpkg/consume/git-registries) for more information about baselines and registry configuration.

## Repository layout

- `ports/<port-name>/` contains the current port files.
- `versions/<initial>-/<port-name>.json` records every published version and its Git tree.
- `versions/baseline.json` records the default version of every port.

Adding another SDK does not create another top-level registry. It adds a new directory under `ports/`, a matching version file under `versions/`, and an entry in `versions/baseline.json`.
