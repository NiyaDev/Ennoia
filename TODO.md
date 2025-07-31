
== v0.1.0

=== High prio
- Write tests
  - There IS a leak in the test program. I need to find it.
  - If I wait too long the debt is going to be insane...
- Move ~SDL3~ and OpenGL binds to seperate projects for simplicity

=== Mid prio
- Bulk
  - Loading different file types
    - Meshes
    - Fonts
    - etc
  - V3.0 of Bulk
    - Expand data in table to have the type of data and encryption algo.
- Meshes
  - Functions to edit specific vertex things and have it update the mesh internally
  - Blending
  - Culling
- Textures
  - Draw tiled
- Import YAML code

=== Low prio
- UI
- Localization
- Rectangle overloads for mul/div and assignment for add/sub/mul/div

=== Future
- Re-write files from Pleroma:
  - vector.c3
  - matrix.c3
- Confirm all matrix.c3 functions work
- Confirm YAML module works fully
- Improve YAML module
- Copy over compatible tests from Pleroma
- Loading fonts from bulk
- Save all textures to ennoia hashmap.
- Mesh generation: Plane, etc
