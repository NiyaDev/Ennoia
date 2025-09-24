
module ennoia::render;
import ennoia;
import std::io;
import std::collections;


RenderPipeline2D rp2;
RenderPipeline2D rpf;
RenderPipeline3D rp3;

//RenderInstance entries;

alias RenderPipeline2D = List{TextureRenderInfo};
alias RenderPipeline3D = List{MeshRenderInfo};

//alias RenderInstance = HashMap{String,List{Matrix}};
alias RenderInstance = HashMap{String, Matrix[]};

struct TextureRenderInfo {
  String nameTexture;
  Rectangle dst;
  Rectangle src;
  //Vector3 rotation;
  Color tint;
}
struct MeshRenderInfo {
  String nameMesh, nameTexture;
  Vector3 position;
  Vector3 scale;
  Vector3 rotation;
}


<* Renders all meshes and textures in pipelines *>
fn void render_all() {
  // 3D
  List{String} entries;
  entries.init(mem);
  for (int i; i < rp3.len(); i++) {
    if (!entries.contains(rp3[i].nameMesh)) entries.push(rp3[i].nameMesh);
  }
  
  for (int i; i < entries.len(); i++) {
    usz count;
    for (int j; j < rp3.len(); j++) {
      if (entries[i] == rp3[j].nameMesh) count++;
    }
    Matrix[] arr = mem::new_array(Matrix, count);
    usz index;
    for (int j; j < rp3.len(); j++) {
      if (entries[i] == rp3[j].nameMesh) {
        arr[index] = matrix::create(rp3[j].position, rp3[j].scale, rp3[j].rotation);
        index++;
      }
    }
    ennoia::meshes[entries[i]]!!.draw_instanced(arr, (rp3[i].nameTexture != "" ? ennoia::textures.get_ref(rp3[i].nameTexture)!! : null));
    free(arr);
  }
  free(entries.entries);
  rp3.clear();

  // 2D
  List{String} entries2;
  entries2.init(mem);
  for (int i; i < rp2.len(); i++) {
    if (!entries2.contains(rp2[i].nameTexture)) entries2.push(rp2[i].nameTexture);
  }
  
  for (int i; i < entries2.len(); i++) {
    usz count;
    for (int j; j < rp2.len(); j++) {
      if (entries2[i] == rp2[j].nameTexture) count++;
    }
    Rectangle[] dst = mem::new_array(Rectangle, count);
    Rectangle[] src = mem::new_array(Rectangle, count);
    Color[] tint    = mem::new_array(Color,     count);
    usz index;
    for (int j; j < rp2.len(); j++) {
      if (entries2[i] == rp2[j].nameTexture) {
        dst[index]  = rp2[j].dst;
        src[index]  = rp2[j].src;
        tint[index] = rp2[j].tint;
        index++;
      }
    }
    ennoia::textures[entries2[i]]!!.draw_instanced(dst, src, tint);
    free(dst);
    free(src);
    free(tint);
  }
  free(entries2.entries);
  rp2.clear();
}

