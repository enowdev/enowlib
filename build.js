// EnowLib Build Script
// Node.js version for proper module handling

const fs = require('fs');
const path = require('path');

console.log('\x1b[36m%s\x1b[0m', 'Building EnowLib...');

// Build configuration
const config = {
    outputFile: 'build/enowlib.lua',
    modules: [
        { path: 'src/core/theme.lua', name: 'Theme' },
        { path: 'src/core/utils.lua', name: 'Utils' },
        { path: 'src/components/section.lua', name: 'Section' },
        { path: 'src/components/label.lua', name: 'Label' },
        { path: 'src/components/button.lua', name: 'Button' },
        { path: 'src/components/toggle.lua', name: 'Toggle' },
        { path: 'src/components/slider.lua', name: 'Slider' },
        { path: 'src/components/input.lua', name: 'Input' },
        { path: 'src/components/dropdown.lua', name: 'Dropdown' },
        { path: 'src/components/keybind.lua', name: 'Keybind' },
        { path: 'src/components/colorpicker.lua', name: 'ColorPicker' },
        { path: 'src/components/multidropdown.lua', name: 'MultiDropdown' },
        { path: 'src/components/progressbar.lua', name: 'ProgressBar' },
        { path: 'src/components/notification.lua', name: 'Notification' },
        { path: 'src/components/tab.lua', name: 'Tab' },
        { path: 'src/components/window.lua', name: 'Window' },
        { path: 'src/managers/savemanager.lua', name: 'SaveManager' },
        { path: 'src/managers/interfacemanager.lua', name: 'InterfaceManager' }
    ]
};

// Create build directory if not exists
if (!fs.existsSync('build')) {
    fs.mkdirSync('build');
}

// Read and process module
function processModule(modulePath, moduleName) {
    if (!fs.existsSync(modulePath)) {
        console.log(`  \x1b[31m[SKIP]\x1b[0m ${modulePath} (not found)`);
        return '';
    }
    
    console.log(`  \x1b[32m[OK]\x1b[0m ${moduleName}`);
    
    let content = fs.readFileSync(modulePath, 'utf8');
    
    // Remove require statements
    content = content.replace(/local\s+\w+\s*=\s*require\([^)]+\)/g, '');
    
    // Find the last return statement (should be return ModuleName)
    const lines = content.split('\n');
    let returnedVar = moduleName;
    
    // Find and remove the last return statement
    for (let i = lines.length - 1; i >= 0; i--) {
        const line = lines[i].trim();
        if (line.startsWith('return ')) {
            const match = line.match(/return\s+(\w+)/);
            if (match) {
                returnedVar = match[1];
                lines[i] = ''; // Remove this line
                break;
            }
        }
    }
    
    content = lines.join('\n').trimEnd();
    
    // Wrap in module block with proper assignment
    return `
-- Module: ${moduleName}
local ${moduleName}
do
${content}
${moduleName} = ${returnedVar}
end

`;
}

// Build header
const header = `-- EnowLib v2.0.0
-- Vaporwave Tech Dark UI Library
-- Built: ${new Date().toISOString().replace('T', ' ').substring(0, 19)}
-- Author: EnowHub Development

local EnowLib = {}

`;

// Build footer
const footer = `
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
`;

// Build process
console.log('\x1b[33m%s\x1b[0m', 'Reading source files...');

let output = header;

// Process all modules
for (const module of config.modules) {
    output += processModule(module.path, module.name);
}

output += footer;

// Write output
console.log('\x1b[33m%s\x1b[0m', 'Writing output file...');
fs.writeFileSync(config.outputFile, output, 'utf8');

const stats = fs.statSync(config.outputFile);
const fileSizeKB = (stats.size / 1024).toFixed(2);

console.log('');
console.log('\x1b[32m%s\x1b[0m', 'Build complete!');
console.log('\x1b[36m%s\x1b[0m', `Output: ${config.outputFile} (${fileSizeKB} KB)`);
console.log('');
