
module ennoia::render;
import ennoia;
import std::io;
import std::collections;


RenderPipeline2D rp2;
RenderPipeline3D rp3;

alias RenderPipeline2D = List{TextureRenderInfo};
alias RenderPipeline3D = List{MeshRenderInfo};

//alias RenderInstance = HashMap{String,List{Matrix}};
alias RenderInstance = HashMap{String, Matrix[]};

struct TextureRenderInfo {
  String nameTexture;
  Rectangle dst;
  Rectangle src;
  Vector3 rotation;
  Color tint;
}
struct MeshRenderInfo {
  String nameMesh, nameTexture;
  Vector3 position;
  Vector3 scale;
  Vector3 rotation;
}

<* Sends model info to renderpipline for rendering *>
fn void draw_mesh(
  String nameMesh = "cube",
  String nameTexture = "",
  Vector3 position = {},
  Vector3 scale = {1,1,1},
  Vector3 rotation = {},
) @export("render_mesh") {
  rp3.push({nameMesh, nameTexture, position, scale, rotation});
}
<* Sends texture info to renderpipeline for rendering *>
fn void draw_texture(
  String nameTexture = "default",
  Rectangle dst = {0,0,-1,-1},
  Rectangle src = {0,0,-1,-1},
  Vector3 rotation = {},
  Color tint = color::WHITE,
) @export("render_texture") {
  rp2.push({nameTexture, dst, src, rotation, tint});
}

<* Renders all meshes and textures in pipelines *>
fn void render_all() {
  // Make a list for each different mesh and render them in batches.
  //List{Pair{String, int}} renderPairs;
  //for (int i; i < )

  // 3D
  List{String} allEntries;
  for (int i; i < rp3.len(); i++) {
    if (!allEntries.contains(rp3[i].nameMesh)) allEntries.push(rp3[i].nameMesh.tcopy());
  }

  RenderInstance entries;
  

  //io::printfn("%d",entries[allEntries[0]]!!.len());

  //for (int i; i < allEntries.len(); i++) { entries.get_ref(allEntries[i])!!.free(); }
  //io::printfn("%d",entries[allEntries[0]]!!.len());
  //unreachable();
  allEntries.clear();
  entries.clear();
  rp3.clear();
  /*
  RenderInstance entries;
  for (int i; i < rp3.len(); i++) {
    MeshRenderInfo info = rp3[i];
    if (entries.has_key(info.nameMesh)) {
      List{Matrix}* ref = entries.get_ref(info.nameMesh)!!;
      //ref.push(matrix::create(info.position, info.scale, info.rotation));
    } else {
      List{Matrix} ref;
      ref.push(matrix::create(info.position, info.scale, info.rotation));
      entries.set(info.nameMesh, ref);
    }
  }
  String[] keys = entries.tkeys();
  for (int i; i < keys.len; i++) {
    List{Matrix}* mat = entries.get_ref(keys[i])!!;
    ennoia::models[keys[i]]!!.draw_instanced(mat.to_tarray());
    (*mat).clear();
  }
  //entries.@each(; String key, List{Matrix}* mats) {  

    //Matrix[] arr = mats.to_array(mem);
    //ennoia::models[key]!!.draw_instanced(arr);
    //free(arr);
    //List{Matrix}* ref = entries.get_ref(key)!!;
    //ref.free();
    //mats.clear();
    //free(mats);
  //};
  entries.free();
  rp3.clear();
  */
  /*
  for (int i; i < rp3.len(); i++) {
    MeshRenderInfo info = rp3[i];
    ennoia::models[info.nameMesh]!!.draw(
      position:info.position,
      scale:info.scale,
      rotation:info.rotation,
      texture:(info.nameTexture == "" ? null : ennoia::textures.get_ref(info.nameTexture)!!),
    );
  }
  rp3.clear();
  */

  // 2D
  for (int i; i < rp2.len(); i++) {
    TextureRenderInfo info = rp2[i];
    ennoia::textures[info.nameTexture]!!.draw(
      dst:  info.dst,
      src:  info.src,
      tint: info.tint,
    );
  }
  rp2.clear();
}

