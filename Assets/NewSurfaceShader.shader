Shader "my_dotlight_dir"
{
	Properties
	{
	_Color("Color", Color) = (1,1,1,1)
	_RampTex("Ramp Texture", 2D) = "white"{}
	_Colormap("Texture", 2D) = "white"{}
	_lightMult("Light_Mult",Range(0,2)) = 1
	}
		SubShader
	{

	CGPROGRAM

	#pragma surface surf ToonRamp

	float _lightMult;
	float4 _Color;
	sampler2D _RampTex;
	sampler2D _Colormap;
	float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten)
	{
	float diff = dot(s.Normal, lightDir);
	float h = diff * 0.5 + 0.5;
	float2 rh = h;
	float3 ramp = tex2D(_RampTex, rh).rgb;
	float4 c;
	c.rgb = s.Albedo * (_LightColor0.rgb* _lightMult) * (ramp);
	c.a = s.Alpha;
	return c;
	}
	
	struct Input
	{
	float2 uv_MainTex;
	float2 uv_Colormap;
	float3 viewDir;
	};
	
	void surf(Input IN, inout SurfaceOutput o)
	{
	float diff = dot(o.Normal, IN.viewDir);
	float h = diff * 0.5 + 0.5;
	float2 rh = h;
	float4 pr = tex2D(_RampTex, rh);
	float4 tex = tex2D(_Colormap, IN.uv_Colormap);
	o.Albedo = pr.rgb+tex.rgb;
	}
	ENDCG
	}
		FallBack "Diffuse"
}
