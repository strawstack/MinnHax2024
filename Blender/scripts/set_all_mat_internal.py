import bpy

for mat in bpy.data.materials:
    mat.use_nodes = False
