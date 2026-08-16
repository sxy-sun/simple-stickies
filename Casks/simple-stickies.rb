cask "simple-stickies" do
  version "1.0.0"
  sha256 "2b8f2950def35430021efc7403d132aebe20522df4b8e896d97f77a0c62f06c4"

  url "https://github.com/sxy-sun/simple-stickies/releases/download/v#{version}/SimpleStickies.zip"
  name "Simple Stickies"
  desc "Menu bar sticky notes that vanish when you close them"
  homepage "https://github.com/sxy-sun/simple-stickies"

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "Simple Stickies.app"

  # The app is not signed with a paid Apple certificate, so macOS would refuse
  # to launch it. Homebrew flags every download with com.apple.quarantine;
  # clearing it here is what makes the install warning free.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Simple Stickies.app"]
  end
end
