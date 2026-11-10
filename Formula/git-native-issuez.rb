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
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.4.0/git-native-issuez-0.4.0-full-aarch64-macos.tar.gz"
      sha256 "94b811295632f8e289e2eb8f669828021ded8efe0016a74da793a1121f447635"
    end
    on_intel do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.4.0/git-native-issuez-0.4.0-full-x86_64-macos.tar.gz"
      sha256 "0ef8312deb8835f08a8f172e508460ce182cc420b030556999d3cee964a4c771"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.4.0/git-native-issuez-0.4.0-full-aarch64-linux.tar.gz"
      sha256 "8c6f152f6097bb4c201327ab7c1fdd4f4d47395c731314694bb617c378764bf2"
    end
    on_intel do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.4.0/git-native-issuez-0.4.0-full-x86_64-linux.tar.gz"
      sha256 "b7df7c7ce8ce4ba7a350b00f091b733c2291b414d51384fbbcf49005da4ad5f5"
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
