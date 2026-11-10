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
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.5.0/git-native-issuez-0.5.0-full-aarch64-macos.tar.gz"
      sha256 "3665a21e01fdb0784111cb8147cf68b60f37572079de69e7dd12b02b8b0fecdc"
    end
    on_intel do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.5.0/git-native-issuez-0.5.0-full-x86_64-macos.tar.gz"
      sha256 "4e024d456d337b91b54c1967665081a397a743cfc26ce801d6f3847a9aa71cc7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.5.0/git-native-issuez-0.5.0-full-aarch64-linux.tar.gz"
      sha256 "12b8290c8be3dbaef9da50debaa591165dc50a8431a689c991c7352ed180dd35"
    end
    on_intel do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.5.0/git-native-issuez-0.5.0-full-x86_64-linux.tar.gz"
      sha256 "4bbdb34d667e0f7163619bd0b9800aae81a74f5a0370e761205560bdce7ef5c4"
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
