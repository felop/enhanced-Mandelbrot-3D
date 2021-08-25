#define PI 3.141592653589793238462643
#define Iterations 6
#define Bailout 10.

float DE(vec3 pos, float time) {
    float Power = cos(time/PI)/2.+3.5;
	vec3 z = pos;
	float dr = 1.7;
	float r = 0.0;
	for (int i = 0; i < Iterations ; i++) {
		r = length(z);
		if (r>Bailout) break;

		// convert to polar coordinates
		float theta = acos(z.z/r) * Power;
		float phi = atan(z.y,z.x) * Power;
		dr =  pow( r, Power-1.)*Power*dr + 1.;

		// scale and rotate the point
		float zr = pow( r,Power);
		theta = theta*Power;
		phi = phi*Power;

		// convert back to cartesian coordinates
		z = zr*vec3(sin(theta)*cos(phi), sin(phi)*sin(theta), cos(theta));
		z+=pos;
	}
	return 0.5*log(r)*r/dr;
}
