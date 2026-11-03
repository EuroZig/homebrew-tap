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
