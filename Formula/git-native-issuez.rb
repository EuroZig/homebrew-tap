class GitNativeIssuez < Formula
  desc "Distributed issue tracking embedded in Git, rewritten in Zig"
  homepage "https://github.com/EuroZig/git-native-issuez"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "git"

  on_macos do
    on_arm do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.1.0/git-native-issuez-0.1.0-full-aarch64-macos.tar.gz"
      sha256 "d9822a9eb5c8198a3a2f30e066d4ab6056d607f3b42c357eeb40b891061ffa07"
    end
    on_intel do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.1.0/git-native-issuez-0.1.0-full-x86_64-macos.tar.gz"
      sha256 "dde59c9c3a3a352090c8ed175b1a376952d49dd34daf81fc0862aa1fce855578"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.1.0/git-native-issuez-0.1.0-full-aarch64-linux.tar.gz"
      sha256 "c3686beae5bf12620d01fa5ae4d4449f00a83c0e2f975505dc7d5d11736bcd46"
    end
    on_intel do
      url "https://github.com/EuroZig/git-native-issuez/releases/download/v0.1.0/git-native-issuez-0.1.0-full-x86_64-linux.tar.gz"
      sha256 "226eda8111269ef00d3f8706f8d681d8e724b40a06db0410357ecdac7be90980"
    end
  end

  def install
    bin.install Dir["bin/*"]
    man1.install Dir["share/man/man1/*"]
    bash_completion.install Dir["share/bash-completion/completions/*"]
    zsh_completion.install Dir["share/zsh/site-functions/*"]
    fish_completion.install Dir["share/fish/vendor_completions.d/*"]
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
