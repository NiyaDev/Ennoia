
### Testing
- Colors
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
  - Render pipeline
  - 2D instanced rendering --High Priority
  - Culling?
  - Plane generation
- Debug logging system

### Additions
- Vector2
  - Min/Max

### Fixes
- Go over Color functions and make them modern standard.
- Move over to using proper OpenGL bindings.
- Texture tiling issues.
- Tapping shift while holding direction keeps it down when you let go.
- Confirm matrix functions work
- mesh::new doesn't use input vertices and instead just returns a triangle.
- Add inputs to mesh generation.

### Transfer
- Yaml

