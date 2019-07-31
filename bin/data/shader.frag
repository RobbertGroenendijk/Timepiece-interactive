#ifdef GL_ES
// define default precision for float, vec, mat.
precision highp float;
#endif

varying vec4 colorVarying;
varying vec2 texCoordVarying;

uniform vec2 resolution;

uniform sampler2D maskTex;
uniform sampler2D videoTex;

void main(){
    
    vec2 position = (gl_FragCoord.xy / resolution.xy);
    
    vec4 maskTexel = texture2D(maskTex, position);
    vec4 videoTexel = texture2D(videoTex, position);
    
    gl_FragColor = vec4(videoTexel.rgb,maskTexel.a);
}
