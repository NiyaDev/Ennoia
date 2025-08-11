
== v0.1.0

=== High prio
- Write tests
  - There IS a leak in the test program. I need to find it.
  - If I wait too long the debt is going to be insane...
- Move ~SDL3~ and OpenGL binds to seperate projects for simplicity
- 2D rendering seems to be in reverse order.

=== Mid prio
- Bulk
  - Loading different file types
    - Meshes
    - Fonts
    - Localization
    - etc
- Meshes
  - Functions to edit specific vertex things and have it update the mesh internally
  - Culling
- Textures
  - Draw tiled

=== Low prio
- UI
- Rectangle overloads for mul/div and assignment for add/sub/mul/div
- If you tap shift while holding a direction it keeps going even after you let go

=== Future
- Re-write files from Pleroma:
  - vector.c3
  - matrix.c3
- Confirm all matrix.c3 functions work
- Copy over compatible tests from Pleroma
- Loading fonts from bulk
- Save all textures to ennoia hashmap.
- Mesh generation: Plane, etc
