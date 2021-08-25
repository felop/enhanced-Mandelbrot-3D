#define MAX_STEP 100
#define MAX_DIST 100.
#define SURFACE_DIST .01
#define PI 3.141592653589793238462643

vec3 RayMarch(vec3 ro, vec3 rd) {
    float dO = 0.;
    float minDist = MAX_DIST;
    float nbSteps = 0.;

    for (int i=0;i<MAX_STEP;i++) {
        nbSteps += 1.;
        vec3 p = ro + rd * dO;
        float dS = DE(p,iTime);
        dO += dS;
        if (dS<minDist) minDist = dS;
        if (dS<=SURFACE_DIST) minDist = 1.;
        if (i>=MAX_STEP || dS<=SURFACE_DIST ) break;
    }
    return vec3(dO,minDist,nbSteps);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;

    vec3 ro = vec3(1,0,-3.);
    vec3 rd = normalize(vec3(uv.x-0.65, uv.y, 1.));

    vec3 col = vec3(0.);

    vec3 RM = RayMarch(ro,rd);
    vec2 dif = vec2(1.-(RM.x/10.), RM.y);

    vec3 glowmap = vec3(0.,0.,pow(1.-dif.y,5.));

    vec3 difMap = vec3(dif.x*10.-7.,0.,dif.x*10.-8.);  //MANDELBULB RÉGLAGES
    float ambiantOccl = (1.-(1.-RM.z/15.))*(max(RM.y, .99)-.99)*100.;

    col = max(difMap*ambiantOccl,glowmap);
    //vec3(RM.z/10.)
    fragColor = vec4(col,1.0);
}
