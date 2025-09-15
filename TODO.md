
### Testing
- Quaternion overloads
- BoundingBoxes
- Matrices
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
- Bulk
- Meshes
  - Render pipeline improvements
  - Culling?
  - Plane generation
- Debug logging system
- Screenshot
- Ability to take a screenshot and compare it to another for testing.

### Additions
- Vector2
  - Min/Max

### Fixes
- Remove models from framework. Replace with just pure meshes.
- Move over to using proper OpenGL bindings.
- Texture tiling issues.
- Tapping shift while holding direction keeps it down when you let go.
- Confirm matrix functions work
- mesh::new doesn't use input vertices and instead just returns a triangle.
- Add inputs to mesh generation.

