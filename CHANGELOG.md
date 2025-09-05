
## v0.1.0

#### [6/30/25]
- Migrated over Vectors 2-4, Quaternion, and Matrixes from Pleroma.
- Moved VAO, VBO, and EBO into Trio structure that isn't kept in mesh and made it so that the mesh is uploaded when drawing and deleted after.
- Fixed: Flipped loaded texture.
- Fixed: Not saving vertices and indices to mesh structure.

#### [7/1/25]
- Migrated ennoia.c3 to gl.c3 and started on base Ennoia functions.
- Started on camera.

#### [7/2/25]
- Moved shader compilation to seperate function to allow both loading from file and raw data.
- Re-added default shaders.
- Changed how rendering models works. It doesn't fully work yet.

#### [7/3/25]
- Meshes now render properly.
- Camera now works properly.
- Re-added framebuffer size callback and it now updates properly.
- Fixed: Matrixes were using "row-major" instead of "column-major".
  - Need to look to see if I need to fix any matrix functions. look_at and perspective didn't, so possibly not.

#### [7/4/25]
- Added wrappers to end drawing and clearing bg.
- Added scrollwheel handling.
- Changed camera to function off of target and distance to target instead of target-position.
  - Rotation is almost done, something went wrong and it crashes.
- Minor functions added to vector3 and floats.

#### [7/5/25]
- Finished camera rotation.
- Experimenting with mesh generation.

#### [7/6/26]
- Moved everything hap-hazardly from GLFW to SDL3. It draws, but i still need to properly handle input.

#### [7/7/25]
- Added mutliple SDL3 constants.

#### [7/8/25]
- Added keybinding system.
- Re-added mousewheel controls.

#### [7/9/25]
- Changed Vertexes from an array of floats to an actual structure.
- Made a wrapper for vertex_attrib_pointer to simmplify code.
- Removed "Trio" and replaced with a tuple.

#### [7/10/25]
- Minor changes

#### [7/11/25]
- Started on adding rendering to a texture
  - Something is wrong, but i don't know what yet...
- Added int shader uniforms

#### [7/12/25]
- Mesh:
  - Removed Matrix and draw_at
  - Added VAO/VBO, position, scale, and rotation to draw
- Fixed Matrix rotation
- Started changing how shader uniforms are changed and set.
- Render texture quad is being rendered and a *different* texture can be drawn on it, but for some reason the render texture cant...

#### [7/13/25]
- Finally fixed render texture. The problem was I was using glTextureParameteri instead of glTexParameteri. So stupid.
- Added rendering at a lower or higher resolution than screen.
- Added shader cleanup and rendertexture shader changing.
- Changed over from using add_loc and set_loc to just using set_X where X is the data type.

#### [7/14/25]
- Moved drawing functions from wrappers to ennoia, but might still move them to render.
- Created render.c3 and moved rendertexture initialization over.

#### [7/15/25]
- Created mesh generation functions.
- Started working on texture drawing.

#### [7/16/26]
- Renamed basic shaders and added 2d shader.
- Added clean functions for Mesh, Render texture, texture, and ennoia in general.
- Fully added drawing a texture to screen.

#### [7/17/25]
- Minor changes

#### [7/18/25]
- Started work on Bulk v2 and then restarted because I wanted to go in a different direction.

#### [7/19/25]
- Minor md changes

#### [7/20/25]
- Worked on adding more functionality to Bulk and started making bulk_packer to make bulk files

#### [7/21/25]
- Continued on Bulk loading and almost finished the packer

#### [7/22/25]
- Bulk:
  - Basic Bulk packer finished and able to add and remove entries from bulk files.
  - Functions for getting entry length or pointer.
  - Function for getting textures.
- Function for loading texture from array (memory).

#### [7/23/25]
- Added keybinds loading from bulk
- Added saving Keybinds to file
- Added Options system as well as saving and loading from bulk. Still needs to be tested.

#### [7/24/25]
- Added Rectangles
- Texture Draw
  - Moved Position + Size into a rectangle dest.
  - Added Rectangle src to draw a specific portion of the texture.

#### [7/25/25]
- Font loading, both from file and data
- Font drawing with scaling and spacing

#### [7/26/25]
- Moved wrapper.c3 funtions to ennoia.c3
- Added function to meshes to update texcoords

#### [7/27/25]
- Renamed TODO and CHANGELOG.
- Created bounds.c3 for bounding box checking.
- Made tests for Bulk and fixed memory leaks in loading, read_entries, and get_entry_len/ptr.

#### [7/28/25]
- Moved SDL3 bindings to their own project.

#### [7/29/25]
- Minor

#### [7/30/25]
- Added more error handling to bulk functions.
- Tests for Camera.
- Contracts for ennoia::init, and font funcs.

#### [7/31/25]
- Finished simple box bounds checking.
- Operator overloads for addition/subtraction for rectangles.
- Grabbed YAML from Pleroma and slapped it in.
- Added loading localization from bulk.
- Edited bulks::loading_keybinds/options test to include load_all_keybinds/options and fixed all leaks.
- Added loading all textures in a bulk.
- Moved localization, Keybinds, and options to storage fill in main ennoia module.

#### [8/1/25]
- Started re-writing Bulk for v3.0, but need to redo YAML.
- Started on re-doing YAML.

#### [8/2/25]
- Re-did most of the yaml functions.

#### [8/3/25]
- Finished re-doing YAML functions.
- Finished updating Bulk packer to use a manifest. Still need to re-write readme.
- Need to fix bulk tests.

#### [8/4/25]
- Added String to valid option types.
- Updated bulk functiuon to work with v3.

#### [8/5/25]
- Changed Bulk_packer README.

#### [8/6/25]
- Added Font loading.

#### [8/7/25]
- Started adding Shader saving and loading to bulks, but for some reason it's not working.

#### [8/8/25]
- Fixed problem with Shader not loading from bulk.
- Added Texture saving/loading from bulk.

#### [8/9/25]
- Minor changes.

#### [8/10/25]
- Added numerals to font atlas.
- Changed default shader variable names to fit new system.
- Added blending for transparent textures.
- Minor fixes.

#### [8/11/25]
- Fixed Textures drawing position being hlaved seemingly.
- Started on tiled Texture drawing.

#### [8/12/25]
- Finished tiled texture drawing.
- Finished overloads for Rectangle math both with rectangles and with Vector2s.

#### [8/13/25]
- Started Mesh loading.

#### [8/14/25]
- Meshes load completely.
  - Textures are a little off.

#### [8/15/25]
- Made mesh textures into an array.
- Moved things to make mesh::load and mesh::load_from_file.
- Made mesh::load and mesh::load_from_file return hashmaps instead of just an array.

#### [8/16/25]
- Gone through and Checked and wrote tests for all Vector2 functions and most Vector3 functions.
- Changed Quaternion to it's own struct and started on its test functions.

#### [8/17/25]
- Finished Vector3 and Vector4 tests and checks.
- Found out the "Memory leak" is seemingly coming from shaders setting uniform values.
  - The c3 test system  doesn't recognize it as a leak and I don't know how to fix it.

#### [8/18/25]
- Reverted Meshes having texture arrays. For now atleast...
- Added loading material from file with meshes.
- Changed HashMap{String,Mesh} into an aliased version just called Model and added cleanup and drawing functions.
- Added loading Meshes and Materials from bulk.
- Fixed memory leak. Apparently glGetUniformLocation allocates the name every time it's called. So I added back the location map.

#### [8/19/25]
- Started working on localization

#### [8/20/25]
- Loading localization from bulk is done.
- Minor changes to Matrices.
- Started on UI.

#### [8/21/25]
- Continued on UI work.
- Started slight re-work of Bulk Packer.
- Added default font and texture.
- When drawing fonts '\n' will be read the same as a newline.

#### [8/22/25]
- Minor work.

#### [8/23/25]
- Started button, but need to figure out 2d drawing being weird.

#### [8/24/25]
- Fixed textures rendering in reverse order without transparency.
- Completely re-did tiled texture drawing.
- Added functions for getting mouse buttons down or up and mouse position.
- Basic Button functionality done.
- Re-did event structure to better handle mouse inputs. Still needs work, though.

#### [8/25/25]
- More fixes to mouse input handler.
- Meshes now have colors inbuilt and textures can be tinted colors.
- Almost finished buttons, but need to fix mouse input.

#### [8/26/25]
- Fixed Mouse controls and Button interaction.
- Added ability to change screen resolution and borderless/ fullscreen and it also changes the render resolution.

#### [8/27/25]
- Changed width/height input in init to be overrides rather than the only values. loads to original from options.

#### [8/28/25]
- Updated to using 0.7.5* of C3.
  - Fixed all errors/warnings that came from that.
- Updated SDL3 events from constants to a const enum.
  - Created handlers for events 0x202, 0x204, 0x205, 0x207, 0x209, 0x20B, 0x20C, 0x20D, 0x20E, 0x20F, 0x215, 0x216, and 0x1100.

#### [8/29/25]
- Minor changes.

#### [8/30/25]
- removed build.sh.

#### [8/31/25]
- Added storage for Models and Shaders.
- Fixed non-comprehensive load_all in bulk.
- Bulk loading for loading all Fonts, Models, and Shaders.

#### [9/1/25]
- Added function for converting int[3] to Vector3.
- Added texture overrides for model drawing.

#### [9/2/25]
- Added function for making a model out of a single mesh.

#### [9/5/25]
- Simplified shader use and texture use in mesh drawing.
- Added mesh.draw_instanced.
- Added model.draw_instanced.
- Started RenderPipeline

