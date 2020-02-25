uniform sampler2D texture;

uniform vec2 screenSize;
uniform float scanlineDensity;
uniform float blurDistance = 0.0012f;

vec4 blur5(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
  vec4 color = vec4(0.0);
  vec2 off1 = vec2(1.3333333333333333) * direction;

  color += texture2D(image, uv) * 0.29411764705882354;
  color += texture2D(image, uv + (off1 / resolution)) * 0.35294117647058826;
  color += texture2D(image, uv - (off1 / resolution)) * 0.35294117647058826;
  return color; 
}

void main()
{
    vec4 finalColor;
    vec2 coords = gl_TexCoord[0].xy;

    finalColor = blur5(texture, coords, screenSize, vec2(blurDistance, 0));
    finalColor += blur5(texture, coords, screenSize, vec2(-blurDistance, 0));

    int actualPixelY = coords.y * screenSize.y;
    int modulus = mod(actualPixelY, scanlineDensity);

    if(modulus == 0 && actualPixelY != 0)
        finalColor /= 1.9f;

    finalColor /= 2.15f;

    gl_FragColor = finalColor * 1.3f;
}