# VaporUI Build Script
# Builds modular Lua files into single output file

param(
    [switch]$Help
)

if ($Help) {
    Write-Host "VaporUI Build Script" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: ./build.ps1" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This script builds all modular source files into a single vaporui.lua file."
    Write-Host ""
    exit
}

Write-Host "Building VaporUI..." -ForegroundColor Cyan

# Create build directory
if (-not (Test-Path "build")) {
    New-Item -ItemType Directory -Path "build" | Out-Null
}

# Output file
$outputFile = "build/vaporui.lua"

# Start building
$output = @"
-- VaporUI v1.0.0
-- Vaporwave Tech Dark UI Library
-- Built: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
-- Author: EnowHub Development

local VaporUI = {}

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
    @{Path="src/components/notification.lua"; Name="Notification"},
    @{Path="src/components/tab.lua"; Name="Tab"},
    @{Path="src/components/window.lua"; Name="Window"}
)

foreach ($module in $modules) {
    $output += Get-LuaContent -path $module.Path -moduleName $module.Name
}

# Add main init
Write-Host "Adding main initialization..." -ForegroundColor Yellow

$output += @"

-- Initialize VaporUI
VaporUI.Version = "1.0.0"
VaporUI.Author = "EnowHub Development"

-- Initialize notification system
Notification.Initialize(Theme, Utils)

-- Create window
function VaporUI:CreateWindow(config)
    local window = Window.new(config, Theme, Utils)
    return window
end

-- Show notification
function VaporUI:Notify(config)
    config.Theme = Theme
    config.Utils = Utils
    return Notification.Show(config)
end

-- Get theme
function VaporUI:GetTheme()
    return Theme
end

-- Get utils
function VaporUI:GetUtils()
    return Utils
end

return VaporUI
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
