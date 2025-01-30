event_inherited();

part_type_direction(quakeTrail, 0, 0, 0, 0);
part_particles_create(sys, x + irandom_range(-8, 8), y + irandom_range(-8, 8), quakeTrail, 1);

if(duration % 9 == 0 || irandom(13) == 0) {
	var _rock = instance_create_layer(x + irandom_range(-8, 8), y + irandom_range(-8, 8), "Instances", obj_quakeVisual);
}