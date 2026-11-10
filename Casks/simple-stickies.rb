cask "simple-stickies" do
  version "1.1.0"
  sha256 "e12dbbafa09d6bbe6cdff9fe0896fa631773cd035b20ceebbdb12f8399b1e602"

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
