class ReflectionLinux < Formula
  desc "Collaborative, local-first GTK text editor"
  homepage "https://modal.cx/reflection"
  url "https://github.com/p2panda/reflection/archive/refs/tags/0.3.tar.gz"
  sha256 "e54907f7395f879fb1eda268fd059517b2bc3688c5010a04bcec120aaf76bed2"
  license "GPL-3.0-or-later"

  # Upstream publishes everything as a pre-release and not every release has
  # DMGs. Keep in step with the macOS cask, which installs the same tag's DMG.
  livecheck do
    url :stable
    strategy :github_releases do |json|
      json.filter_map do |release|
        next if release["draft"]
        next if release["assets"].none? { |asset| asset["name"].end_with?(".dmg") }

        release["tag_name"]
      end
    end
  end

  depends_on "blueprint-compiler" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "libadwaita"
  depends_on "libspelling"
  depends_on :linux # macOS uses the upstream DMG: see Casks/reflection.rb
  depends_on "openssl@3"
  depends_on "pango"

  def install
    # The locked openssl-sys rejects the OpenSSL 4 that pkg-config finds.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    # Skip meson's post-install steps: the caches belong in HOMEBREW_PREFIX.
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # GLib doesn't search HOMEBREW_PREFIX for GSettings schemas and icons.
    libexec.install bin/"reflection"
    (bin/"reflection").write_env_script libexec/"reflection",
      XDG_DATA_DIRS: "#{HOMEBREW_PREFIX}/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
  end

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    # The app aborts at startup without its schema in the compiled cache.
    system formula_opt_bin("glib")/"gsettings", "--schemadir", HOMEBREW_PREFIX/"share/glib-2.0/schemas",
           "list-keys", "cx.modal.Reflection"
    assert_match "#{HOMEBREW_PREFIX}/share", (bin/"reflection").read

    # GTK can't start without a display, which happens after the binary has
    # linked and loaded its resources.
    ENV.delete "DISPLAY"
    assert_match "Could not start GTK4", shell_output("#{bin}/reflection 2>&1", 101)
  end
end
