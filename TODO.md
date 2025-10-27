
### Testing
- BoundingBoxes
- Fonts
- Keybinds
- Localizations
- Meshes
- Options
- Shaders
- Textures
- Yaml

### Full features
- UI
  - Look through and use richtext standard if it exists.
  - Input fields
  - Hover over
  - Containers
    - Vertical
    - Horizontal
    - Square
    - They all have the ability to scroll if turned on
    - Culls anything not in rect
      - Don't know how I'm going to do this smoothly
- Bulk
- Meshes
  - Render pipeline improvements
    - Have pipeline remove duplicates
    - Fix not changing textures
  - Culling?
  - Plane generation
- Debug logging system
- Screenshot
- Ability to take a screenshot and compare it to another for testing.
- Audio
- Documentation

### Additions
- Vector2
  - Min/Max

### Fixes
- Move over to using proper OpenGL bindings.
- Move Yaml to it's own library.
- Tapping shift while holding direction keeps it down when you let go.
- mesh::new doesn't use input vertices and instead just returns a triangle.
- Add inputs to mesh generation.

