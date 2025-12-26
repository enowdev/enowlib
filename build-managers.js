// EnowLib Managers Build Script
// Builds InterfaceManager and SaveManager as separate modules

const fs = require('fs');
const path = require('path');

console.log('Building EnowLib Managers...\n');

// Ensure build/managers directory exists
const buildDir = path.join(__dirname, 'build', 'managers');
if (!fs.existsSync(buildDir)) {
    fs.mkdirSync(buildDir, { recursive: true });
}

// Manager files to build
const managers = [
    {
        name: 'InterfaceManager',
        source: 'src/managers/interfacemanager.lua',
        output: 'build/managers/interfacemanager.lua'
    },
    {
        name: 'SaveManager',
        source: 'src/managers/savemanager.lua',
        output: 'build/managers/savemanager.lua'
    }
];

// Build each manager
managers.forEach(manager => {
    try {
        console.log(`Building ${manager.name}...`);
        
        // Read source file
        const sourcePath = path.join(__dirname, manager.source);
        const content = fs.readFileSync(sourcePath, 'utf8');
        
        // Write to build directory
        const outputPath = path.join(__dirname, manager.output);
        fs.writeFileSync(outputPath, content, 'utf8');
        
        // Get file size
        const stats = fs.statSync(outputPath);
        const sizeKB = (stats.size / 1024).toFixed(2);
        
        console.log(`  [OK] ${manager.name} (${sizeKB} KB)`);
        
    } catch (error) {
        console.error(`  [ERROR] Failed to build ${manager.name}:`, error.message);
        process.exit(1);
    }
});

console.log('\nBuild complete!');
console.log(`Output: build/managers/`);
