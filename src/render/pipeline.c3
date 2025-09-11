
module ennoia::render;
import ennoia;
import std::io;
import std::collections;


RenderPipeline2D rp2;
RenderPipeline3D rp3;

alias RenderPipeline2D = List{TextureRenderInfo};
alias RenderPipeline3D = List{MeshRenderInfo};

struct TextureRenderInfo {
  String nameTexture;
  Vector2 position;
  Vector2 scale;
  Vector3 rotation;
}
struct MeshRenderInfo {
  String nameMesh, nameTexture;
  Vector3 position;
  Vector3 scale;
  Vector3 rotation;
}

<* Sends model info to renderpipline for rendering *>
fn void draw_mesh(
  String nameMesh = "default",
  String nameTexture = "",
  Vector3 position = {},
  Vector3 scale = {1,1,1},
  Vector3 rotation = {},
) @export("render_mesh") {
  rp3.push({nameMesh, nameTexture, position, scale, rotation});
}

<* Renders all meshes and textures in pipelines *>
fn void render_all() {
  // Make a list for each different mesh and render them in batches.
  //List{Pair{String, int}} renderPairs;
  //for (int i; i < )

  for (int i; i < rp2.len(); i++) {
    
  }
  rp2.free();
  for (int i; i < rp3.len(); i++) {
    MeshRenderInfo info = rp3[i];
    ennoia::models[info.nameMesh]!!.draw(
      position:info.position,
      scale:info.scale,
      rotation:info.rotation,
      texture:(info.nameTexture == "" ? null : ennoia::textures.get_ref(info.nameTexture)!!),
    );
  }
  rp3.free();
}

