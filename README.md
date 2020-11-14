# suckless

A collection of [suckless](https://suckless.org) tools I use that I adapted to
my needs.

## How to Build?

To build a tool, simply use:

```shell
make TOOL
```

Where `TOOL` is one of the tools for which a directory exists. If you want to
build all tools, simply run `make` with no other commands.

By default, all output is suppressed. To enable the output for diagnostic
reasons, simply add the variable `verbose` to the command, like:

```shell
make verbose=1 TOOL
```

The builded tools will be automatically installed (this requires sudo).
