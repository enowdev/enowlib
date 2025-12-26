# EnowLib Build Script
# Builds modular Lua files into single output file

param(
    [switch]$Help
)

if ($Help) {
    Write-Host "EnowLib Build Script" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: ./build.ps1" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This script builds all modular source files into a single enowlib.lua file."
    Write-Host ""
    exit
}

Write-Host "Building EnowLib..." -ForegroundColor Cyan

# Create build directory
if (-not (Test-Path "build")) {
    New-Item -ItemType Directory -Path "build" | Out-Null
}

# Output file
$outputFile = "build/enowlib.lua"

# Start building
$output = @"
-- EnowLib v2.0.0
-- Vaporwave Tech Dark UI Library
-- Built: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
-- Author: EnowHub Development

local EnowLib = {}

"@

Write-Host "Reading source files..." -ForegroundColor Yellow

# Function to read and process Lua file
function Get-LuaContent {
    param($path, $moduleName)
    
    if (-not (Test-Path $path)) {
        Write-Host "  [SKIP] $path (not found)" -ForegroundColor Red
        return ""
    }
    
    Write-Host "  [OK] $moduleName" -ForegroundColor Green
    
    $content = Get-Content $path -Raw
    
    # Remove require statements
    $content = $content -replace 'local\s+\w+\s*=\s*require\([^)]+\)', ''
    
    # Remove return statement at end
    $content = $content -replace 'return\s+\w+\s*$', ''
    
    return @"

-- Module: $moduleName
do
$content
end

"@
}

# Build order (dependencies first)
$modules = @(
    @{Path="src/core/theme.lua"; Name="Theme"},
    @{Path="src/core/utils.lua"; Name="Utils"},
    @{Path="src/components/section.lua"; Name="Section"},
    @{Path="src/components/label.lua"; Name="Label"},
    @{Path="src/components/button.lua"; Name="Button"},
    @{Path="src/components/toggle.lua"; Name="Toggle"},
    @{Path="src/components/slider.lua"; Name="Slider"},
    @{Path="src/components/input.lua"; Name="Input"},
    @{Path="src/components/dropdown.lua"; Name="Dropdown"},
    @{Path="src/components/keybind.lua"; Name="Keybind"},
    @{Path="src/components/colorpicker.lua"; Name="ColorPicker"},
    @{Path="src/components/multidropdown.lua"; Name="MultiDropdown"},
    @{Path="src/components/progressbar.lua"; Name="ProgressBar"},
    @{Path="src/components/notification.lua"; Name="Notification"},
    @{Path="src/components/tab.lua"; Name="Tab"},
    @{Path="src/components/window.lua"; Name="Window"},
    @{Path="src/managers/savemanager.lua"; Name="SaveManager"},
    @{Path="src/managers/interfacemanager.lua"; Name="InterfaceManager"}
)

foreach ($module in $modules) {
    $output += Get-LuaContent -path $module.Path -moduleName $module.Name
}

# Add main init
Write-Host "Adding main initialization..." -ForegroundColor Yellow

$output += @"

-- Initialize EnowLib
EnowLib.Version = "2.0.0"
EnowLib.Author = "EnowHub Development"

-- Initialize notification system
Notification.Initialize(Theme, Utils)

-- Create window
function EnowLib:CreateWindow(config)
    local window = Window.new(config, Theme, Utils, EnowLib)
    
    -- Initialize managers
    SaveManager.Initialize(window)
    InterfaceManager.Initialize(window)
    
    -- Load saved interface settings
    InterfaceManager.LoadSettings()
    
    window.SaveManager = SaveManager
    window.InterfaceManager = InterfaceManager
    
    return window
end

-- Show notification
function EnowLib:Notify(config)
    config.Theme = Theme
    config.Utils = Utils
    return Notification.Show(config)
end

-- Get theme
function EnowLib:GetTheme()
    return Theme
end

-- Get utils
function EnowLib:GetUtils()
    return Utils
end

-- Get SaveManager
function EnowLib:GetSaveManager()
    return SaveManager
end

-- Get InterfaceManager
function EnowLib:GetInterfaceManager()
    return InterfaceManager
end

return EnowLib
"@

# Write output
Write-Host "Writing output file..." -ForegroundColor Yellow
$output | Out-File -FilePath $outputFile -Encoding UTF8

$fileSize = (Get-Item $outputFile).Length
$fileSizeKB = [math]::Round($fileSize / 1KB, 2)

Write-Host ""
Write-Host "Build complete!" -ForegroundColor Green
Write-Host "Output: $outputFile ($fileSizeKB KB)" -ForegroundColor Cyan
Write-Host ""
