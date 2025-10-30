# ============================================
# Android SDK + Emulator Setup for Flutter (No Android Studio)
# Fixed and tested version
# ============================================

# --- CONFIGURATION ---
$SdkRoot = "C:\Android"
$ToolsUrl = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
$ToolsZip = "$env:TEMP\cmdline-tools.zip"
$ToolsDir = "$SdkRoot\cmdline-tools\latest"
$AvdName = "Pixel_Emu"
$ApiLevel = "34"
$SystemImage = "system-images;android-$ApiLevel;google_apis;x86_64"

Write-Host "=== Setting up Android SDK at $SdkRoot ===`n"

# --- CREATE FOLDERS ---
New-Item -ItemType Directory -Force -Path $ToolsDir | Out-Null

# --- DOWNLOAD CMDLINE TOOLS ---
if (-Not (Test-Path "$ToolsDir\bin\sdkmanager.bat")) {
    Write-Host "Downloading Android command-line tools..."
    Invoke-WebRequest -Uri $ToolsUrl -OutFile $ToolsZip
    Expand-Archive -Force $ToolsZip -DestinationPath "$SdkRoot\cmdline-tools"
    Move-Item "$SdkRoot\cmdline-tools\cmdline-tools\*" $ToolsDir -Force
    Remove-Item "$SdkRoot\cmdline-tools\cmdline-tools" -Recurse -Force
    Remove-Item $ToolsZip -Force
} else {
    Write-Host "Command-line tools already installed."
}

# --- SET ENVIRONMENT VARIABLES ---
[Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $SdkRoot, "Machine")
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $SdkRoot, "Machine")
$env:ANDROID_SDK_ROOT = $SdkRoot
$env:ANDROID_HOME = $SdkRoot
$env:Path += ";$ToolsDir\bin;$SdkRoot\platform-tools;$SdkRoot\emulator"

Write-Host "Environment variables configured."
Write-Host "SDK Root: $env:ANDROID_SDK_ROOT`n"

# --- INSTALL REQUIRED PACKAGES ---
Write-Host "Installing SDK components..."
& "$ToolsDir\bin\sdkmanager.bat" --sdk_root="$SdkRoot" `
    "platform-tools" `
    "emulator" `
    "platforms;android-$ApiLevel" `
    "build-tools;34.0.0" `
    "$SystemImage"

# --- ACCEPT LICENSES ---
Write-Host "`nAccepting all SDK licenses..."
yes | & "$ToolsDir\bin\sdkmanager.bat" --sdk_root="$SdkRoot" --licenses

# --- CREATE AVD ---
Write-Host "`nCreating Android Virtual Device..."
try {
    & "$ToolsDir\bin\avdmanager.bat" create avd -n $AvdName -k "$SystemImage" -d pixel --force
    Write-Host "AVD '$AvdName' created successfully."
} catch {
    Write-Host "⚠️  AVD creation failed. Try manually with:"
    Write-Host "   avdmanager list devices"
}

# --- VERIFY android.jar ---
$JarPath = "$SdkRoot\platforms\android-$ApiLevel\android.jar"
if (-Not (Test-Path $JarPath)) {
    Write-Host "❌ android.jar missing, reinstalling platform..."
    & "$ToolsDir\bin\sdkmanager.bat" --sdk_root="$SdkRoot" "platforms;android-$ApiLevel"
}

# --- DONE ---
Write-Host "`n✅ Setup complete!"
Write-Host "To start your emulator, run:"
Write-Host "  emulator -avd $AvdName"
Write-Host "`nThen check Flutter with:"
Write-Host "  flutter doctor"
Write-Host "  flutter run"
