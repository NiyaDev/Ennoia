
module ennoia::ui::old;
import ennoia;


<**>
fn void draw() {
  ennoia::uiElements.@each(; String key, Element* e) {
    switch (e.type) {
      case LABEL:
        e.label.draw();
      case BUTTON:
        Font* font = ennoia::fonts.get_ref(e.button.font)!!;
        Texture* texture = ennoia::textures.get_ref(e.button.texture)!!;
        // Check bounds size
        Rectangle tileBounds = {
          e.button.bounds.x,
          e.button.bounds.y,
          (e.button.bounds.w <= 0 ? (font.dim.x + e.button.spacing.x) * e.button.text.len + (e.button.textPadding.x + e.button.textPadding.z) : e.button.bounds.w),
          (e.button.bounds.h <= 0 ? (font.dim.y + e.button.spacing.y) * ((float)e.button.text.count("\n") + 1) + (e.button.textPadding.y + e.button.textPadding.w) : e.button.bounds.h),
        };

        // Change color
        Color col;
        if (e.button.active) {
          col = e.button.textureTint[0];
          if (tileBounds.within(ennoia::mousePosition)) {
            col *= (keybinds::mouse_down(1) ? e.button.textureTint[2] : e.button.textureTint[1]);
          }
        } else { col = e.button.textureTint[1]; }

        // Draw bg texture
        render::draw_texture_tiled(e.button.texture, e.button.bounds, e.button.scale);
        //texture.draw_tiled(dest:tileBounds*e.button.scale, layout:THREE_ONE, tint:col);

        // Caluclate text position
        Vec2f textPosition;
        switch (e.button.alignHori) {
          case RIGHT:
            break; // TODO:
            //textPosition = (tileBounds.v2() + e.button.textPadding.xy) * e.button.scale;
          case CENTER:
            textPosition.x = ((tileBounds.x + (tileBounds.w / 2)) - (((font.dim.x + e.button.spacing.x) * e.button.text.len) / 2)) * e.button.scale.x;
            textPosition.y = ((tileBounds.y + (tileBounds.h / 2)) - (((font.dim.y + e.button.spacing.y) * ((float)e.button.text.count("\n") + 1)) / 2)) * e.button.scale.y;
          case LEFT:
            textPosition.x = (tileBounds.x + tileBounds.w - e.button.textPadding.z - ((font.dim.x + e.button.spacing.x) * e.button.text.len)) * e.button.scale.x;
            textPosition.y = (tileBounds.y + e.button.textPadding.y) * e.button.scale.y;
        }

        // Draw text
        //font.draw(e.button.text, textPosition, e.button.scale, e.button.spacing, e.button.textTint);
        render::draw_font(e.button.font, e.button.text, textPosition, e.button.scale, e.button.spacing);

        // Activate when let go of
        if (e.button.active) {
          if (tileBounds.within(ennoia::mousePosition) && e.button.hover != null) e.button.hover();
          if (tileBounds.within(ennoia::mousePosition) && keybinds::mouse_up(1) && e.button.click != null) e.button.click();
        }
      case BAR:
        e.bar.draw();
      default:
    }
    
    if (e.temporary) {
      e.duration--;
      if (e.duration <= 0) {
        free(e);
        ennoia::uiElements.remove(key);
      }
    }
  };
}

<* Draw label *>
fn void ElementLabel.draw(&self, Vec2f positionOffset = {0,0}, Vec2f scaleOffset = {1,1}) {
  render::draw_font(
    self.font,
    self.text,
    self.position + positionOffset,
    self.scale * scaleOffset,
    self.spacing,
  );
}
<* Draw Bar *>
fn void ElementBar.draw(&self, Vec2f positionOffset = {0,0}, Vec2f scaleOffset = {1,1}) {
  // Draw text

  // Background
  render::draw_texture_tiled(
    self.textureBg,
    self.bounds,
    self.scale
  );

  // Foreground
  float percentage = *(self.value) / *(self.valueMax);
  render::draw_texture_tiled(
    self.textureFg,
    self.bounds * (Rectangle){1,1,percentage,1},
    self.scale
  );
  
}

