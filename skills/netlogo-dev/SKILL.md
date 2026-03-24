---
name: netlogo-dev
description: >
  Use when building NetLogo extensions with SBT, installing extension
  JARs to NetLogo 7.x, creating or editing .nlogox model files,
  running models in NetLogo GUI, testing extensions via Command
  Center, or working with NetLogo config and template conventions
---

# NetLogo 7.x Development Skill

## 1. Building Extensions

Requires Java 17:

```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
```

- **Build fat JAR:** `sbt clean assembly` → `target/scala-<ver>/<name>.jar`
- **Run tests:** `sbt test`
- **If `build.sh` exists, use it** — typically wraps build + install

## 2. Installing to NetLogo

Copy the JAR into the NetLogo extensions directory. Folder name MUST match extension name:

```bash
cp target/scala-<ver>/<name>.jar "$NETLOGO_DIR/extensions/<name>/"
```

- macOS default path: `~/Developer/CCL/NetLogo 7.0.3/extensions/<name>/`
- Or use: `NETLOGO_DIR="path" ./build.sh`

## 3. Opening & Running Models

```bash
# macOS — open with NetLogo app
open -a "NetLogo 7.0.3" path/to/model.nlogox

# Or use the shell launcher
"$NETLOGO_DIR/netlogo-gui.sh" --open path/to/model.nlogox
```

Other flags: `--launch` (open + run), `--color-theme {system|classic|light|dark}`

**IMPORTANT:** NetLogo headless and GUI-from-source are currently BROKEN on main. Do not attempt them.

## 4. Testing After Rebuild (Hot Reload)

1. Rebuild JAR → copy to extensions dir
2. In NetLogo Command Center: `reload-extensions` → reloads all JARs without restart
3. `reload` → reloads model file from disk (if you edited the .nlogox externally)
4. Test primitives directly: `show extension:some-primitive "args"`

## 5. .nlogox File Format (NetLogo 7.x Standard)

XML format replacing legacy .nlogo (plain text with `@#$#@#$#@` separators). NetLogo 7.x reads both, but .nlogox is the standard for new models. To convert: open .nlogo in GUI → Save As → saves as .nlogox.

### Minimal .nlogox structure:

```xml
<?xml version="1.0" encoding="utf-8"?>
<model version="NetLogo 7.0.3" snapToGrid="false">
  <code><![CDATA[
extensions [extension-name]
to setup
  clear-all
end
  ]]></code>
  <widgets>
    <view x="355" y="10" width="514" height="514"
          minPxcor="-16" maxPxcor="16" minPycor="-16" maxPycor="16"
          patchSize="10.0" frameRate="30.0"
          wrappingAllowedX="true" wrappingAllowedY="true"/>
    <button x="40" y="140" width="69" height="33"
            kind="Observer" display="setup" forever="false">setup</button>
  </widgets>
  <info><![CDATA[## About
Description here.
  ]]></info>
  <turtleShapes>
    <shape name="default" rotatable="true" editableColorIndex="0">
      <polygon color="-1920102913" filled="true" marked="true">
        <point x="150" y="5"/><point x="40" y="250"/>
        <point x="150" y="205"/><point x="260" y="250"/>
      </polygon>
    </shape>
  </turtleShapes>
  <linkShapes/>
</model>
```

### Key XML elements:

- `<code>` — NetLogo code in CDATA wrapper
- `<widgets>` — UI elements (view is required)
- `<info>` — Markdown documentation in CDATA
- `<turtleShapes>`, `<linkShapes>` — shape definitions

### Widget types and key attributes:

| Widget | Key Attributes |
|--------|---------------|
| `<view>` | patchSize, min/maxPxcor, min/maxPycor, wrappingAllowedX/Y, frameRate |
| `<slider>` | variable, min, max, default, step, direction |
| `<button>` | kind (Observer/Turtle/Patch/Link), display, forever (boolean) |
| `<switch>` | variable, on (boolean) |
| `<chooser>` | variable, `<choice>` children, current (index) |
| `<monitor>` | source (reporter as text content), display, precision |
| `<plot>` | display, xAxis, yAxis, nested `<pen>` elements with `<update>` |
| `<note>` | fontSize, markdown (boolean), text content |

**Reference file:** `test/fileformat/Wolf Sheep Predation.nlogox` (full working example)

## 6. Config & Template Conventions

- **Config files:** `key=value` per line, `#` comments
- Place config file next to .nlogox model (same directory)
- **Templates:** YAML with `system:` and `template:` fields, `{variable}` substitution
- Config search order: model directory → exact path → working directory

## 7. Development Guidelines

- Develop for latest NetLogo version (currently 7.0.3)
- Use .nlogox format for all new models
- Declare extensions at top of code: `extensions [name1 name2]`
- Include at minimum: `<view>` widget, `<code>` section, `<turtleShapes>` with default shape
- Keep config files alongside model, not hardcoded paths
- Use `reload-extensions` during development, not full app restart
