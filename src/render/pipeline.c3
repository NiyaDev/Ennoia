
module ennoia::render;
import ennoia;
import std::io;
import std::collections;
import std::math;


RenderPipeline2D rp2;
RenderPipeline2D rpf;
RenderPipeline3D rp3;

//RenderInstance entries;

alias RenderPipeline2D = List{TextureRenderInfo};
alias RenderPipeline3D = List{MeshRenderInfo};

//alias RenderInstance = HashMap{String,List{Matrix}};
alias RenderInstance = HashMap{String, Matrix4f[]};
alias Render2DList = List{Pair{String, int}};

struct TextureRenderInfo {
  String nameTexture;
  Rectangle dst;
  Rectangle src;
  //Vec3f rotation;
  Color tint;
  int priority;
}
struct MeshRenderInfo {
  String nameMesh, nameTexture;
  Vec3f position;
  Vec3f scale;
  Vec3f rotation;
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
    Matrix4f[] arr = mem::new_array(Matrix4f, count);
    usz index;
    for (int j; j < rp3.len(); j++) {
      if (entries[i] == rp3[j].nameMesh) {
        //arr[index] = matrix::create(rp3[j].position, rp3[j].scale, rp3[j].rotation);
        arr[index] = MATRIX4F_IDENTITY
          .translate(rp3[j].position)
          //.rotatem(rp3[j].rotation)
          .rotate_x(rp3[j].rotation.x)
          .rotate_y(rp3[j].rotation.y)
          .rotate_z(rp3[j].rotation.z)
          .scale(rp3[j].scale)
          .transpose();
        io::printfn("%s",arr[index].m);
        //unreachable();
        index++;
      }
    }
    ennoia::meshes[entries[i]]!!.draw_instanced(arr, (rp3[i].nameTexture != "" ? ennoia::textures.get_ref(rp3[i].nameTexture)!! : null));
    free(arr);
  }
  free(entries.entries);
  rp3.clear();

  // 2D
  Render2DList entries2;
  entries2.init(mem);
  for (int i; i < rp2.len(); i++) {
    if (!entries2.contains({rp2[i].nameTexture,rp2[i].priority})) entries2.push({rp2[i].nameTexture,rp2[i].priority});
  }
  
  for (int p = 5; p > 0; p--) {
    for (int i; i < entries2.len(); i++) {
      if (entries2[i].second == p) {
        usz count;
        for (int j; j < rp2.len(); j++) {
          if (entries2[i].first == rp2[j].nameTexture) count++;
        }
        Rectangle[] dst = mem::new_array(Rectangle, count);
        Rectangle[] src = mem::new_array(Rectangle, count);
        Color[] tint    = mem::new_array(Color,     count);
        usz index;
        for (int j; j < rp2.len(); j++) {
          if (entries2[i].first == rp2[j].nameTexture) {
            dst[index]  = rp2[j].dst;
            src[index]  = rp2[j].src;
            tint[index] = rp2[j].tint;
            index++;
          }
        }
        ennoia::textures[entries2[i].first]!!.draw_instanced(dst, src, tint);
        free(dst);
        free(src);
        free(tint);
      }
    }
  }
  free(entries2.entries);
  rp2.clear();
}

