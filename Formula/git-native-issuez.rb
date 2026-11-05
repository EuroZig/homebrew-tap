class GitNativeIssuez < Formula
  desc "Distributed issue tracking embedded in Git, rewritten in Zig"
  homepage "https://github.com/EuroZig/git-native-issuez"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.3.0/git-native-issuez-0.3.0-full-aarch64-macos.tar.gz"
      sha256 "1835bcc35ef9d4f64dabb99cde818bdab8a76d5223d498140351d0e33283974a"
    end
    on_intel do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.3.0/git-native-issuez-0.3.0-full-x86_64-macos.tar.gz"
      sha256 "0b623387ffbd3e640589675e3ba65b575612adbdb0be9a48d6db0658ce56b921"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.3.0/git-native-issuez-0.3.0-full-aarch64-linux.tar.gz"
      sha256 "df091555efb9f3eef0e244b9805f41d8050705aaf729258141a7230453e9c534"
    end
    on_intel do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.3.0/git-native-issuez-0.3.0-full-x86_64-linux.tar.gz"
      sha256 "58aec769fc7815ecf463e01a743c496304f5279e06da378c5d284a58cca4a009"
    end
  end

  def install
    bin.install Dir["bin/*"]
    man1.install Dir["share/man/man1/*"]
    zsh_completion.install Dir["share/zsh/site-functions/*"]

    # Shells load completions by command name, so every git-issue-<command>
    # entry point needs its own file. The release ships identical copies;
    # install one and link the rest to it.
    bash_completion.install "share/bash-completion/completions/git-issue"
    Dir["share/bash-completion/completions/git-issue-*"].each do |f|
      bash_completion.install_symlink bash_completion/"git-issue" => File.basename(f)
    end
    fish_completion.install "share/fish/vendor_completions.d/git-issue.fish"
    Dir["share/fish/vendor_completions.d/git-issue-*.fish"].each do |f|
      fish_completion.install_symlink fish_completion/"git-issue.fish" => File.basename(f)
    end
    doc.install Dir["share/doc/git-native-issuez/*"]
  end

  test do
    assert_match "git-issue version #{version}", shell_output("#{bin}/git-issue version")

    system "git", "init", "--quiet"
    system "git", "config", "user.name", "Homebrew"
    system "git", "config", "user.email", "test@brew.sh"
    system bin/"git-issue", "create", "Test issue"
    assert_match "Test issue", shell_output("#{bin}/git-issue ls")
  end
end
