cask "reflection" do
  arch arm: "arm64", intel: "x86_64"

  version "0.3"
  sha256 arm:   "0deddff14e619cb1c83ebaed8663e8f97709e275945f57795e776870ed601d1d",
         intel: "dacdb6b1bcb57dd996b68fc3e0182748774e6db015f94adc0a8262e84aca341e"

  url "https://github.com/p2panda/reflection/releases/download/#{version}/reflection-#{arch}.dmg"
  name "Reflection"
  desc "Collaborative, local-first GTK text editor"
  homepage "https://modal.cx/reflection"

  # Upstream publishes everything as a pre-release and not every release has
  # DMGs. Keep in step with the Linux formula, which builds the same tag.
  livecheck do
    url :url
    strategy :github_releases do |json|
      json.filter_map do |release|
        next if release["draft"]
        next if release["assets"].none? { |asset| asset["name"].end_with?(".dmg") }

        release["tag_name"]
      end
    end
  end

  # Info.plist claims 10.15, but the bundled libraries are built for macOS 15.
  depends_on macos: :sequoia

  # The app loads its resources from this path, whatever --appdir says.
  app "Reflection.app", target: "/Applications/Reflection.app"

  # The private identity key lives in the login keychain.
  zap script: {
        executable:   "/usr/bin/security",
        args:         ["delete-generic-password", "-s", "Reflection Identity", "-a", "default user"],
        must_succeed: false,
      },
      trash:  [
        "~/.local/share/Reflection",
        "~/Library/Saved Application State/cx.modal.Reflection.savedState",
      ]

  caveats <<~EOS
    Reflection is ad-hoc signed and not notarized, so macOS blocks its first
    launch. To allow it, open Reflection once, then choose Open Anyway under
    System Settings > Privacy & Security.
  EOS
end
