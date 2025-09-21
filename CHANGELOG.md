
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

