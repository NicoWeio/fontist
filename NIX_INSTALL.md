# Installing Fontist with Nix

This document explains how to install and use Fontist with the Nix package manager.

## Prerequisites

You need to have Nix installed on your system. If you don't have it yet, install it following the instructions at [nixos.org](https://nixos.org/download.html):

```bash
sh <(curl -L https://nixos.org/nix/install)
```

## Installation

### Option 1: Build from source

Clone this repository and build the package:

```bash
git clone https://github.com/fontist/fontist.git
cd fontist
nix-build
```

This will create a `result` symlink containing the built package. You can then run:

```bash
./result/bin/fontist --help
```

Or install it to your profile:

```bash
nix-env -i ./result
```

### Option 2: Development environment

If you want to work on fontist development, use the provided `shell.nix`:

```bash
nix-shell
# Inside the nix-shell
bundle install
bundle exec fontist --help
```

## Usage

After installation, you can use fontist as usual:

```bash
# Update formulas
fontist update

# Install a font
fontist install "Arial"

# Search for fonts
fontist search "Courier"

# List installed fonts
fontist list
```

## Package Structure

The Nix package includes:

- `default.nix` - Main package definition using `bundlerApp`
- `gemset.nix` - Generated from `Gemfile.lock`, contains gem metadata and SHA256 hashes
- `shell.nix` - Development shell environment
- `Gemfile` - Ruby dependencies
- `Gemfile.lock` - Lock file with exact versions

## Updating the Package

If you update the Ruby dependencies, you'll need to regenerate `gemset.nix`:

```bash
# Update Gemfile.lock
bundle lock --update

# Regenerate gemset.nix
bundix
```

Note: `bundix` is a tool to convert `Gemfile.lock` to `gemset.nix`. You can install it with:

```bash
gem install bundix
```

## System Dependencies

Fontist requires the following system libraries (automatically included in the Nix package):

- zlib
- expat
- openssl

These are managed by Nix and don't need to be installed separately.

## Troubleshooting

### Build fails with missing dependencies

Make sure you have the latest version of nixpkgs:

```bash
nix-channel --update
```

### Permission denied errors

If you get permission errors when running fontist, it might be trying to write to protected directories. Fontist stores fonts in `~/.fontist/` by default.

### Network issues

If you're behind a proxy or firewall, you may need to set proxy environment variables:

```bash
export http_proxy=http://proxy:port
export https_proxy=http://proxy:port
```

For SOCKS proxy support, fontist respects the `SOCKS_PROXY` environment variable:

```bash
export SOCKS_PROXY=socks5://proxy:port
```

## Contributing

If you improve the Nix packaging, please submit a pull request!

## License

This Nix package follows the same BSD-2-Clause license as Fontist itself.
