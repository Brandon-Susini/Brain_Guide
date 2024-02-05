shader_type canvas_item;
render_mode unshaded;

uniform float max_z = 1.0;
uniform float max_distance = 0.3;
uniform vec3 worley_point_01 = vec3(0.2,0.5,0.1);
uniform vec3 worley_points[10];

float worley_distance(vec3 point, vec3 worley_point, float p_max){
	float value = p_max;
	for(float z = -1.0; z < 1.1; z += 1.0){
		for(float y = -1.0; y < 1.1; y += 1.0){
			for(float x = -1.0; x < 1.1; x += 1.0){
				vec3 delta = worley_point - point + vec3(x,y,z);
				float distance = length(delta);
				if(distance < value){
					value = distance;
				}
			}
		}
	}
	return value;
}

float worley_value(vec3 pos){
	float value = max_distance;
	vec3 fpos = mod(pos,1.0);
	
	value = worley_distance(pos,worley_point_01,value);
	for(int i = 0;i<worley_points.length();i+=1){
		value = worley_distance(pos,worley_points[i],value);
	}
	
	return clamp(value/max_distance, 0.0,1.0);
}

void fragment() {
	float z = floor(UV.y * max_z);
	float y = (UV.y * max_z)-z;
	vec3 pos = vec3(UV.x,y,z/max_z);
	vec4 result = vec4(0.0,0.0,0.0,1.0);
	result.x = worley_value(pos);
	
	COLOR = result;
}
