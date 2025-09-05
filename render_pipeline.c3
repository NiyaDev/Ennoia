

module ennoia::render;
import std::collections;
import ennoia::vector;


alias RenderPipeline = List{ModelRenderInfo};
RenderPipeline rp;


struct ModelRenderInfo {
  String modelName;
  Vector3 position;
  Vector3 scale;
  Vector3 rotation;
}

<**>
fn void draw_model(
    String modelName,
    Vector3 position = {},
    Vector3 scale = {1,1,1},
    Vector3 rotation = {},
) {
  rp.push({modelName, position, scale, rotation});
}

<**>
fn void render_all() {
  // Make a list for each different model and render them in batches.
  //List{Pair{String, int}} renderPairs;
  //for (int i; i < )
}

