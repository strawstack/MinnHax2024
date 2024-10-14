import bpy

sel = bpy.context.selected_objects
for ob in sel:
    mat = ob.active_material
    if mat:
        ob.active_material = mat.copy()
        
        for ts in mat.texture_slots:
            try:
                ts.texture = ts.texture.copy()
                
                if ts.texture.image:
                    ts.texture.image = ts.texture.image.copy() 
            except:
                pass