
== v0.1.0
==== [6/30/25]
- Migrated over Vectors 2-4, Quaternion, and Matrixes from Pleroma.
- Moved VAO, VBO, and EBO into Trio structure that isn't kept in mesh and made it so that the mesh is uploaded when drawing and deleted after.
- Fixed: Flipped loaded texture.
- Fixed: Not saving vertices and indices to mesh structure.
==== [7/1/25]
- Migrated ennoia.c3 to gl.c3 and started on base Ennoia functions.
- Started on camera.
==== [7/2/25]
- Moved shader compilation to seperate function to allow both loading from file and raw data.
- Re-added default shaders.
- Changed how rendering models works. It doesn't fully work yet.
==== [7/3/25]
- Meshes now render properly.
- Camera now works properly.
- Re-added framebuffer size callback and it now updates properly.
- Fixed: Matrixes were using "row-major" instead of "column-major".
  - Need to look to see if I need to fix any matrix functions. look_at and perspective didn't, so possibly not.
==== [7/4/25]
- Added wrappers to end drawing and clearing bg.
- Added scrollwheel handling.
- Changed camera to function off of target and distance to target instead of target-position.
  - Rotation is almost done, something went wrong and it crashes.
- Minor functions added to vector3 and floats.
==== [7/5/25]
- Finished camera rotation.
- Experimenting with mesh generation.
==== [7/6/26]
- Moved everything hap-hazardly from GLFW to SDL3. It draws, but i still need to properly handle input.
==== [7/7/25]
- Added mutliple SDL3 constants.
==== [7/8/25]
- Added keybinding system.
- Re-added mousewheel controls.
==== [7/9/25]
- Changed Vertexes from an array of floats to an actual structure.
- Made a wrapper for vertex_attrib_pointer to simmplify code.
- Removed "Trio" and replaced with a tuple.

