#!/bin/bash
set -e
cd "$(dirname "$0")"

APP="build/Simple Stickies.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

# Build AppIcon.icns from icon.png. sips and iconutil ship with macOS.
ICONSET="build/AppIcon.iconset"
rm -rf "$ICONSET" && mkdir -p "$ICONSET"
# .icns needs a square source; square it to whatever icon.png's width is.
SIDE=$(sips -g pixelWidth icon.png | awk 'END{print $2}')
sips -c "$SIDE" "$SIDE" icon.png --out build/_square.png >/dev/null
for size in 16 32 128 256; do
	sips -z $size $size build/_square.png --out "$ICONSET/icon_${size}x${size}.png" >/dev/null
	sips -z $((size * 2)) $((size * 2)) build/_square.png \
		--out "$ICONSET/icon_${size}x${size}@2x.png" >/dev/null
done
# Stop at 512. The 1024 layer costs 1.4 MB and only ever shows in the Dock,
# which this app never appears in.
sips -z 512 512 build/_square.png --out "$ICONSET/icon_512x512.png" >/dev/null
iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/AppIcon.icns"
rm -rf "$ICONSET" build/_square.png

# Pin the deployment target, otherwise swiftc stamps the build machine's OS
# version and the app refuses to launch on anything older.
swiftc -O -target arm64-apple-macos13.0 Sources/*.swift \
	-o "$APP/Contents/MacOS/SimpleStickies" -framework AppKit

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleName</key><string>Simple Stickies</string>
	<key>CFBundleExecutable</key><string>SimpleStickies</string>
	<key>CFBundleIconFile</key><string>AppIcon</string>
	<key>CFBundleIdentifier</key><string>com.simplestickies.app</string>
	<key>CFBundleShortVersionString</key><string>1.0.0</string>
	<key>CFBundleVersion</key><string>1</string>
	<key>CFBundlePackageType</key><string>APPL</string>
	<key>NSPrincipalClass</key><string>NSApplication</string>
	<key>LSUIElement</key><true/>
	<key>LSMinimumSystemVersion</key><string>13.0</string>
</dict>
</plist>
PLIST

codesign --force --sign - "$APP" 2>/dev/null || true
echo "Built $APP"
