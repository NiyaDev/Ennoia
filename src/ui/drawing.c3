
module ennoia::ui;
import ennoia;


<**>
fn void draw() {
  ennoia::uiElements.@each(; String key, Element* e) {
    switch (e.type) {
      case LABEL:
        e.draw_label();
        //ennoia::fonts[e.label.font]!!.draw(
        //  e.label.text,
        //  e.label.position,
        //  e.label.scale,
        //  e.label.spacing,
        //  e.label.tint,
        //);
      case BUTTON:
        Font* font = ennoia::fonts.get_ref(e.button.font)!!;
        Texture* texture = ennoia::textures.get_ref(e.button.texture)!!;
        // Check bounds size
        Rectangle tileBounds = {
          e.button.bounds.x,
          e.button.bounds.y,
          (e.button.bounds.w <= 0 ? (font.dim.x + e.button.spacing) * e.button.text.len + (e.button.textPadding.x + e.button.textPadding.z) : e.button.bounds.w),
          (e.button.bounds.h <= 0 ? (font.dim.y + e.button.spacing) * ((float)e.button.text.count("\n") + 1) + (e.button.textPadding.y + e.button.textPadding.w) : e.button.bounds.h),
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
        texture.draw_tiled(dest:tileBounds*e.button.scale, layout:THREE_ONE, tint:col);

        // Caluclate text position
        Vector2 textPosition;
        switch (e.button.alignHori) {
          case RIGHT:
            textPosition = (tileBounds.v2() + e.button.textPadding.v2()) * e.button.scale;
          case CENTER:
            textPosition.x = ((tileBounds.x + (tileBounds.w / 2)) - (((font.dim.x + e.button.spacing) * e.button.text.len) / 2)) * e.button.scale.x;
            textPosition.y = ((tileBounds.y + (tileBounds.h / 2)) - (((font.dim.y + e.button.spacing) * ((float)e.button.text.count("\n") + 1)) / 2)) * e.button.scale.y;
          case LEFT:
            textPosition.x = (tileBounds.x + tileBounds.w - e.button.textPadding.z - ((font.dim.x + e.button.spacing) * e.button.text.len)) * e.button.scale.x;
            textPosition.y = (tileBounds.y + e.button.textPadding.y) * e.button.scale.y;
        }

        // Draw text
        font.draw(e.button.text, textPosition, e.button.scale, e.button.spacing, e.button.textTint);

        // Activate when let go of
        if (e.button.active) {
          if (tileBounds.within(ennoia::mousePosition) && e.button.hover != null) e.button.hover();
          if (tileBounds.within(ennoia::mousePosition) && keybinds::mouse_up(1) && e.button.click != null) e.button.click();
        }
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
fn void Element.draw_label(&self, Vector2 positionOffset = {0,0}, Vector2 scaleOffset = {1,1}) {
  ennoia::fonts[self.label.font]!!.draw(
    self.label.text,
    self.label.position + positionOffset,
    self.label.scale * scaleOffset,
    self.label.spacing,
    self.label.tint,
  );
}

