shader_type canvas_item;

uniform float height = 7.0;
uniform float frequency = 2.0;
uniform float speed = 3.0;
uniform float addedx = 160;

void vertex() {
	
	VERTEX.y += height * sin((UV.x / 16.0) + (speed * TIME));
	
	//VERTEX.y += height * sin((frequency * UV.x + addedx) + (speed * TIME));
	//UV.x += TIME * movespeed;
}

