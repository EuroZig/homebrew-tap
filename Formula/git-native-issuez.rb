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
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.2.0/git-native-issuez-0.2.0-full-aarch64-macos.tar.gz"
      sha256 "37654375b4ea41fe96b5a8b758dab15b62594461f3cc4507ca6563b655c8a5ee"
    end
    on_intel do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.2.0/git-native-issuez-0.2.0-full-x86_64-macos.tar.gz"
      sha256 "be18d13499bf648e497ccc1af2258c1f7a09fa8bd0779f0cbde7bdb5dad50f2a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.2.0/git-native-issuez-0.2.0-full-aarch64-linux.tar.gz"
      sha256 "e0b6569b991ff41f15eea0e948099d29249ab6b267897515dfc611612484ad31"
    end
    on_intel do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.2.0/git-native-issuez-0.2.0-full-x86_64-linux.tar.gz"
      sha256 "120dcbe54e2e7060759201ae4e0a75baa65fcf6314f8d18c0e5851f51cb7dcbd"
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
