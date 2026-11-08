# homebrew-tap
Official Homebrew tap for EuroZig projects.

## Usage

```sh
brew tap eurozig/tap
brew trust eurozig/tap
brew install git-native-issuez
```

`brew trust` is needed once: Homebrew refuses to load formulae from a tap you
haven't trusted. To trust only this formula instead of the whole tap, use
`brew trust --formula eurozig/tap/git-native-issuez`.

## Formulae

| Formula | Description |
| --- | --- |
| [`git-native-issuez`](Formula/git-native-issuez.rb) | [Distributed issue tracking embedded in Git](https://github.com/EuroZig/git-native-issuez), rewritten in Zig. macOS 13+ and Linux. |
| [`reflection-linux`](Formula/reflection-linux.rb) | [Collaborative, local-first GTK text editor](https://github.com/p2panda/reflection). Linux; builds from source. |

## Casks

| Cask | Description |
| --- | --- |
| [`reflection`](Casks/reflection.rb) | [Collaborative, local-first GTK text editor](https://github.com/p2panda/reflection). macOS 15+. |

## Reflection

Upstream ships DMGs only for macOS, so Linux builds the same release from
source. Installing by full name trusts only that package.

```sh
# macOS
brew install --cask eurozig/tap/reflection

# Linux
brew install eurozig/tap/reflection-linux
```

On macOS, Reflection isn't notarized, so its first launch is blocked: open it
once, then choose Open Anyway under System Settings > Privacy & Security.
