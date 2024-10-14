import bpy

sel = bpy.context.selected_objects

for ob in sel:
 ob.rotation_euler.y = -45