
#### [9/7/25]
- Transferred over Vectors.
- Transferred over Quaternion.
- Transferred over Matrix.
- Transferred over Color.
- Transferred over BoundingBox.
- Transferred over Camera.
- Transferred over Rectangle.

#### [9/8/25]
- Transferred over Bulk.

#### [9/9/25]
- Transferred over Texture.
- Transferred over Font.
- Transferred over Mesh.

#### [9/10/25]
- Transferred over Keybinds.
- Transferred over Localization.
- Transferred over Options.
- Transferred over Shaders.
- Transferred over Core functions.
- Transferred over Yaml.
- Transferred over Bulk Packer and made it work.

#### [9/11/25]
- Added Color tests.
- Updated color functions to my standard.
- Added conversions from Rectangle to Vector2 and Vector 4.
- UI
  - Added Label.
  - Added Button.
- Transferred over Vector3 math functions that were missed.
- Continued on render pipeline.

#### [9/12/25]
- Added new create function to matrices.
- Started more work on render pipeline, but ran into issues with lists in general.

#### [9/13/25]
- Got the 3D part of the pipeline working without any leaks!!
- Added texture instancing. It doesn't work and i'm going to rehaul the entire thing. But I added it.

#### [9/15/25]
- Fixed texture instancing. Turns out I never put in color, so they were just invisible.
- Changed ennoia::clean to clear instead of free to allow tests to go sequencially.
- Fully changed over from immediate mode UI to new system.
  - Label + Button finished.

#### [9/16/25]
- Started on Containers.

#### [9/17/25]
- Added bar UI element.
- Started trying to redo Texture tiling.

#### [9/18/25]
- Minor changes.

#### [9/20/25]
- Finished Texture tiling.
- Next session *HAS* to be me cleaning everything up...

#### [9/21/25]
- Cleaned up mesh.c3
  - Seperated mesh constants into file.
  - Removed Models completely and changed all references to meshes.
- Cleaned up texture.c3
  - Seperated draing functions into new file.
  - Removed draw_tiled.
- Fixed the magic number issue in drawing textures.
  - Turns out it was the percentage the section was of the total texture height.
- Fixed memory leak with UI elements being added over each other.

#### [9/24/25]
- Re-added immediate mode UI.
  - Label
  - Button
  - Bar
- Moved default shader definitions to own file and removed unused uniform enum.
- Added ability to set vector4 uniform.
- Re-added color to texture drawing.
- Added color to texture render pipeline.

#### [9/25/25]
- Fixed library functions.
- Fixed generateing cube mesh too small.
- Started merging start_drawing and end_drawing.
- Immediate-mode UI:
  - Added Texture.
  - Added Tiled Texture.
- Added priority system 5->0 for pipeline textures. Higher is drawn first.
  - Still need to do something similar for 3D transparency.

#### [9/26/25]
-  Moved basic structures into seperate directory.

#### [9/27/25]
- Added dubiously working imm::container_drag.
- Added ennoia::mouseDelta to see change in mouse position since last frame.
- Fixed library error with ennoia::mousePosition being used as ennoia::mousPosition.
- Fixed library error with keybinds::mouse(down, up, pressed) having a String input instead of uint.

#### [9/30/25]
- Started on Debug utilities. Didn't get far.

#### [10/1/25]
- Fixed print_color.
- Added debug Error, Warning, and Info.
  - Error closes program.

#### [10/2/25]
- Converted Vector2 (float x,y)     to Vec2f (float[<2>]) and Vec2i.
- Converted Vector3 (float x,y,z)   to Vec3f (float[<3>]) and Vec3i.
- Converted Vector4 (float x,y,z,w) to Vec4f (float[<4>]) and Vec4i.
- Removed my version of Quaternion and started using maths Quaternionf.
- Converted Color (char r,g,b,a) to (char[<4>]).
- Started working on using Matrix4f from std::math instead of my own, but maybe i need to use my own?
  - It seems like it may be a different layout from OpenGL. Which is weird...
  - Changed: matrix.c3, uniforms.c3, mesh.c3, pipeline.c3, camera.c3, system/drawing.c3, and system/core.c3.

#### [10/3/25]
- Still trying to figure out matrix nonsense.
  - Got an idea to try tomorrow.

#### [10/4/25]
- FIXED MATRIXES!! It was stupid too!
  - I never transposed the perspective matrix in system/core.c3.
- Removed all references to matrix.

#### [10/5/25]
- Started working on Screenshots, but realized the stb bindings are just not enough.
  - so I started on making my own bindings for spng.

#### [10/7/25]
- Removed stb dependency and replaced it and all uses of it with spng.
- Added ability to take screenshots.

#### [10/12/25]
- Added <c=X,X,X,X></c> tag to font drawing where the Xs define the color to draw inbetween tags.
- Added new hybrid UI elements for Labels and Textures.
  - Need to do Buttons and Bars to catch up.
- Changed all UI functions to use Vec2f for spacing instead of just a single float.

#### [10/13/25]
- Added Button HUI element.
- Added Bar HUI element.

#### [10/14/25]
- Started on HUI Containers.

#### [10/15/25]
- Mostly finished drawing for Vertical containers.
- Fixed errors with Buttons and Bars.

#### [10/16/25]
- Continued on containers, but I have a new idea for them...

#### [10/17/25]
- Got basic vertical containers working.

#### [10/18/25]
- Added bindings for new UI elements.
- Fixed debuging for:
  - Keybinds
  - Localization
  - Bulk Loading and Table
  - Pipeline

#### [10/20/25]
- Added offset for BoundingBox.

#### [11/16/25]
- Added first version of immediate mode input box.

#### [11/17/25]
- Fixed up input box to allow capitals, non-letter input, and blocking specific characters from entry.

#### [11/22/25]
- Removed conditions from debug messages.
- Added debug::fatal to end runtime and made error keep program running.

#### [11/24/25]
- Made debug info functions wait untill no printing is being done to print themselves.
  - Makes it so that printing on seperate threads wont overlap text.

#### [11/30/25]
- Started on having debug functions draw an alert on screen when they occur.
  - Doesn't work yet?

#### [12/4/25]
- Reorganized options.
- Added error checking to options.

#### [12/5/25]
- Moved file functions from bulk to utilities.
- Added faults to file functions.
- Added 'recent_error' to debug.
- Added error-checking to bulk loading.
- Added documentation for Debug, Bulk, and Options.
- Changed structure of Options to remove OptionType data to just inline the union.

