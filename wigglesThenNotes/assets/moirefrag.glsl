#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

uniform float r;
uniform float n;

float circle(in vec2 _st, in float _radius){
    vec2 dist = _st-vec2(.75, .5);
    float retVal = sin(n*(sqrt(dot(dist, dist))+_radius));
//		(1.-smoothstep(_radius-.1-(_radius*0.01),
//                         _radius-.1+(_radius*0.01),
//                        (dot(dist,dist))*4.0));
   dist = _st-vec2(.25, .25);
   retVal += cos(n*(sqrt(dot(dist,dist))+_radius));
   dist = _st-vec2(.5, .75);
   retVal += sin(n*(sqrt(dot(dist,dist))+_radius));
   retVal *= .25;
   retVal += .5;
   return retVal;
}

void main(){
     vec2 st = gl_FragCoord.xy/u_resolution.xy;
     
     vec3 color = vec3(circle(st,r));
     
     gl_FragColor = vec4( color, 1.0 );
}