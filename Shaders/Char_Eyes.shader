// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Study/MingChao/Char_Eyes"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		[Header(Specular Light)]_MainColor("Main Color", Color) = (0.3921569,0.3921569,0.3921569,1)
		_SpecularColor("Specular Color", Color) = (0.3921569,0.3921569,0.3921569,1)
		_Shininess("Shininess", Range( 0.01 , 1)) = 0.1
		_SpecularEdgeSoft_Int("SpecularEdgeSoft_Int", Range( 0 , 5)) = 1
		[Header(Indirect Specular Light)]_IndirectSpecular_Smoothness("IndirectSpecular_Smoothness", Range( 0 , 1)) = 1
		_IndirectSpecular_Int("IndirectSpecular_Int", Range( 0 , 1)) = 1
		[Header(Base Color)][NoScaleOffset]_Eyes_BaseColor("Eyes_BaseColor", 2D) = "white" {}
		[NoScaleOffset]_Eyes_UpDark("Eyes_UpDark", 2D) = "white" {}
		[Header(Eyes Ball)][NoScaleOffset]_Eyes_BallMask("Eyes_BallMask", 2D) = "white" {}
		[NoScaleOffset]_Eyes_HDDMask("Eyes_HDDMask", 2D) = "white" {}
		_EyesBall_BallPow("EyesBall_BallPow", Float) = 1
		_EyesBall_BallScale("EyesBall_BallScale", Float) = 1
		_EyesBall_Int("EyesBall_Int", Float) = 1
		_EyesBall_Color("EyesBall_Color", Color) = (1,1,1,0)
		_EyesBallTransLight("Eyes Ball Trans Light", Range( 0.8 , 1.3)) = 1
		_EyesBallDepth("Eyes Ball Depth", Float) = 1
		[Header(Decal Color)]_Decal_Int("Decal_Int", Range( 0 , 1)) = 1
		_Decal_Color("Decal_Color", Color) = (1,1,1,0)
		_DecalSpecular_Color("DecalSpecular_Color", Color) = (1,1,1,0)
		[Header(Eyes Ball White)]_EyesBallWhite_Int("EyesBallWhite_Int", Float) = 1
		_EyesBallWhite_Color("EyesBallWhite_Color", Color) = (1,1,1,0)
		[Header(Hight Light Point)]_HightLightPointNoise_Tilling("HightLightPointNoise_Tilling", Vector) = (1,1,0,0)
		_HightLight__PoingColor("HightLight__PoingColor", Color) = (1,1,1,0)
		_HightLightPointNoise_Threshold("HightLightPointNoise_Threshold", Range( 0 , 1)) = 1
		_HightLight__PoingInt("HightLight__PoingInt", Float) = 1
		_NoiseScale("NoiseScale", Float) = 1
		[Header(Lift Illuminance Color)][NoScaleOffset]_Eyes_LiftLightMask("Eyes_LiftLightMask", 2D) = "white" {}
		_LifeEyesBallLight_Int("LifeEyesBallLight_Int", Range( 0 , 1)) = 1
		_LifeEyesBallLight_Color("LifeEyesBallLight_Color", Color) = (0.8499113,1,0.8443396,0)
		[Header(Eyes Up Dark)]_EyesUpDarkNoise_Scale("EyesUpDarkNoise_Scale", Range( 0 , 1)) = 0.5
		_EyesUpDarkNoise_Tilling("EyesUpDarkNoise_Tilling", Vector) = (1,1,0,0)
		_EyesUpDark_Color("EyesUpDark_Color", Color) = (1,1,1,0)
		_EyesUpDark_Int("EyesUpDark_Int", Range( 0 , 1.5)) = 1
		[Header(Eyes Inner Line)]_EyesLine_Color("EyesLine_Color", Color) = (1,1,1,0)
		_EyesLine_Int("EyesLine_Int", Float) = 1
		_EyesLine_Range("EyesLine_Range", Range( 0 , 1)) = 0
		[Header(Iris Color)]_Iris_Int("Iris_Int", Float) = 5
		_Iris_Color("Iris_Color", Color) = (1,1,1,0)
		[Header(Fresnel)]_FresnelScale("Fresnel Scale", Float) = 1
		_FresnelPower("Fresnel Power", Float) = 5
		_FresnelColor("Fresnel Color", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _Eyes_BallMask;
		uniform sampler2D _Eyes_HDDMask;
		uniform sampler2D _Eyes_BaseColor;
		uniform float4 _Eyes_BaseColor_ST;
		uniform float _EyesBall_BallPow;
		uniform float _EyesBall_BallScale;
		uniform float _EyesBallDepth;
		uniform float4 _EyesBall_Color;
		uniform float _EyesBall_Int;
		uniform float _EyesBallTransLight;
		uniform float4 _EyesUpDarkNoise_Tilling;
		uniform float _EyesUpDarkNoise_Scale;
		uniform float4 _EyesUpDark_Color;
		uniform float _EyesUpDark_Int;
		uniform float _Decal_Int;
		uniform float4 _Decal_Color;
		uniform float4 _Iris_Color;
		uniform float _Iris_Int;
		uniform float4 _EyesLine_Color;
		uniform float _EyesLine_Int;
		uniform float _EyesLine_Range;
		uniform sampler2D _Eyes_UpDark;
		uniform sampler2D _Eyes_LiftLightMask;
		uniform float4 _LifeEyesBallLight_Color;
		uniform float _LifeEyesBallLight_Int;
		uniform float4 _EyesBallWhite_Color;
		uniform float _EyesBallWhite_Int;
		uniform float4 _HightLightPointNoise_Tilling;
		uniform float _NoiseScale;
		uniform float _HightLightPointNoise_Threshold;
		uniform float4 _HightLight__PoingColor;
		uniform float _HightLight__PoingInt;
		uniform float _IndirectSpecular_Smoothness;
		uniform float _IndirectSpecular_Int;
		uniform float _SpecularEdgeSoft_Int;
		uniform float4 _SpecularColor;
		uniform float _Shininess;
		uniform float4 _MainColor;
		uniform float4 _DecalSpecular_Color;
		uniform float _FresnelPower;
		uniform float _FresnelScale;
		uniform float4 _FresnelColor;
		uniform float _EdgeLength;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			Unity_GlossyEnvironmentData g43 = UnityGlossyEnvironmentSetup( _IndirectSpecular_Smoothness, data.worldViewDir, ase_normWorldNormal, float3(0,0,0));
			float3 indirectSpecular43 = UnityGI_IndirectSpecular( data, 1.0, ase_normWorldNormal, g43 );
			float2 uv_Eyes_BaseColor = i.uv_texcoord * _Eyes_BaseColor_ST.xy + _Eyes_BaseColor_ST.zw;
			float4 tex2DNode8 = tex2D( _Eyes_HDDMask, uv_Eyes_BaseColor );
			float smoothstepResult73 = smoothstep( 0.0 , _SpecularEdgeSoft_Int , tex2DNode8.r);
			float HightLight_Mask14 = smoothstepResult73;
			float4 temp_output_43_0_g10 = _SpecularColor;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult4_g11 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float3 normalizeResult64_g10 = normalize( (WorldNormalVector( i , float3(0,0,1) )) );
			float dotResult19_g10 = dot( normalizeResult4_g11 , normalizeResult64_g10 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_output_40_0_g10 = ( ase_lightColor * ase_lightAtten );
			float dotResult14_g10 = dot( normalizeResult64_g10 , ase_worldlightDir );
			UnityGI gi34_g10 = gi;
			float3 diffNorm34_g10 = normalizeResult64_g10;
			gi34_g10 = UnityGI_Base( data, 1, diffNorm34_g10 );
			float3 indirectDiffuse34_g10 = gi34_g10.indirect.diffuse + diffNorm34_g10 * 0.0001;
			float4 temp_output_42_0_g10 = _MainColor;
			float DetailDecal_Mask16 = ( tex2DNode8.b * _Decal_Int );
			float4 temp_output_43_0_g8 = _SpecularColor;
			float3 normalizeResult4_g9 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float3 normalizeResult64_g8 = normalize( (WorldNormalVector( i , float3(0,0,1) )) );
			float dotResult19_g8 = dot( normalizeResult4_g9 , normalizeResult64_g8 );
			float4 temp_output_40_0_g8 = ( ase_lightColor * ase_lightAtten );
			float dotResult14_g8 = dot( normalizeResult64_g8 , ase_worldlightDir );
			UnityGI gi34_g8 = gi;
			float3 diffNorm34_g8 = normalizeResult64_g8;
			gi34_g8 = UnityGI_Base( data, 1, diffNorm34_g8 );
			float3 indirectDiffuse34_g8 = gi34_g8.indirect.diffuse + diffNorm34_g8 * 0.0001;
			float4 temp_output_42_0_g8 = _MainColor;
			Unity_GlossyEnvironmentData g385 = UnityGlossyEnvironmentSetup( 1.0, data.worldViewDir, ase_normWorldNormal, float3(0,0,0));
			float3 indirectSpecular385 = UnityGI_IndirectSpecular( data, 1.0, ase_normWorldNormal, g385 );
			float dotResult380 = dot( ase_normWorldNormal , ase_worldViewDir );
			float saferPower382 = abs( dotResult380 );
			float4 Fresnel_Color374 = ( float4( indirectSpecular385 , 0.0 ) * ( ( 1.0 - saturate( pow( saferPower382 , _FresnelPower ) ) ) * _FresnelScale ) * _FresnelColor );
			float4 CustomLight361 = ( ( float4( ( indirectSpecular43 * _IndirectSpecular_Int ) , 0.0 ) + ( HightLight_Mask14 * ( ( float4( (temp_output_43_0_g10).rgb , 0.0 ) * (temp_output_43_0_g10).a * pow( max( dotResult19_g10 , 0.0 ) , ( _Shininess * 128.0 ) ) * temp_output_40_0_g10 ) + ( ( ( temp_output_40_0_g10 * max( dotResult14_g10 , 0.0 ) ) + float4( indirectDiffuse34_g10 , 0.0 ) ) * float4( (temp_output_42_0_g10).rgb , 0.0 ) ) ) ) + ( DetailDecal_Mask16 * ( ( float4( (temp_output_43_0_g8).rgb , 0.0 ) * (temp_output_43_0_g8).a * pow( max( dotResult19_g8 , 0.0 ) , ( _Shininess * 128.0 ) ) * temp_output_40_0_g8 ) + ( ( ( temp_output_40_0_g8 * max( dotResult14_g8 , 0.0 ) ) + float4( indirectDiffuse34_g8 , 0.0 ) ) * float4( (temp_output_42_0_g8).rgb , 0.0 ) ) ) * _DecalSpecular_Color ) ) + Fresnel_Color374 );
			c.rgb = CustomLight361.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float4 tex2DNode7 = tex2D( _Eyes_BallMask, i.uv_texcoord );
			float EyesBall_Mask21 = tex2DNode7.r;
			float EyesWhitePiple_Mask41 = ( 1.0 - EyesBall_Mask21 );
			float2 uv_Eyes_BaseColor = i.uv_texcoord * _Eyes_BaseColor_ST.xy + _Eyes_BaseColor_ST.zw;
			float4 tex2DNode8 = tex2D( _Eyes_HDDMask, uv_Eyes_BaseColor );
			float VirtualEyesball_Mask_S15 = tex2DNode8.g;
			float temp_output_85_0 = ( 1.0 - VirtualEyesball_Mask_S15 );
			float Iris_Mask92 = temp_output_85_0;
			float saferPower172 = abs( Iris_Mask92 );
			float temp_output_178_0 = saturate( ( saturate( ( EyesWhitePiple_Mask41 + Iris_Mask92 ) ) - saturate( pow( saferPower172 , 1E-05 ) ) ) );
			float saferPower206 = abs( saturate( ( saturate( ( 1.0 - saturate( ( EyesWhitePiple_Mask41 - Iris_Mask92 ) ) ) ) - temp_output_178_0 ) ) );
			float temp_output_241_0 = saturate( ( pow( saferPower206 , _EyesBall_BallPow ) / _EyesBall_BallScale ) );
			float EyesWhite_Mask177 = temp_output_178_0;
			float EyesBall_BallMask155 = saturate( ( temp_output_241_0 - saturate( ( ( 1.0 - max( EyesWhite_Mask177 , EyesWhitePiple_Mask41 ) ) - ( 1.0 - saturate( step( Iris_Mask92 , 0.68 ) ) ) ) ) ) );
			float EyesBallUpDark_Mask323 = ( ( 1.0 - i.uv_texcoord.y ) * EyesBall_BallMask155 );
			float saferPower420 = abs( EyesBallUpDark_Mask323 );
			float EyesBallDepth_Mask425 = pow( saferPower420 , max( _EyesBallDepth , 0.1 ) );
			float4 Base_Color19 = tex2D( _Eyes_BaseColor, uv_Eyes_BaseColor );
			float4 temp_cast_0 = (_EyesBallTransLight).xxxx;
			float4 EyesBall_Color48 = pow( ( Base_Color19 * temp_output_85_0 * _EyesBall_Color * _EyesBall_Int ) , temp_cast_0 );
			float simplePerlin2D270 = snoise( (i.uv_texcoord*(_EyesUpDarkNoise_Tilling).xy + (_EyesUpDarkNoise_Tilling).zw)*_EyesUpDarkNoise_Scale );
			simplePerlin2D270 = simplePerlin2D270*0.5 + 0.5;
			float EyesUpDark_Mask303 = saturate( ( saturate( simplePerlin2D270 ) * ( ( i.uv_texcoord.y - 0.5 ) * EyesBall_BallMask155 ) ) );
			float4 EyesUpDark_Color307 = ( EyesUpDark_Mask303 * _EyesUpDark_Color * _EyesUpDark_Int );
			float4 temp_output_313_0 = ( EyesBall_Color48 + ( ( EyesUpDark_Color307 + EyesUpDark_Color307 ) * EyesBall_BallMask155 ) );
			float DetailDecal_Mask16 = ( tex2DNode8.b * _Decal_Int );
			float4 temp_output_49_0 = ( Base_Color19 * DetailDecal_Mask16 );
			float4 Decal_Color50 = ( temp_output_49_0 * temp_output_49_0 * _Decal_Color );
			float4 temp_output_97_0 = ( temp_output_313_0 + Decal_Color50 );
			float4 Iris_Color31 = ( Base_Color19 * saturate( EyesBall_Mask21 ) * _Iris_Color * _Iris_Int );
			float luminance109 = Luminance(( EyesWhitePiple_Mask41 * Base_Color19 ).rgb);
			float4 EyesWhitePipleDark_Color107 = ( saturate( ( luminance109 / 1.0 ) ) * Base_Color19 );
			float EyesBallLine_Mask331 = ( temp_output_241_0 - EyesBall_BallMask155 );
			float4 EyesBallLine_Color358 = ( ( EyesBallLine_Mask331 * _EyesLine_Color * _EyesLine_Int ) * saturate( ( ( ( 1.0 - i.uv_texcoord.y ) - _EyesLine_Range ) * step( saturate( ( EyesWhite_Mask177 - 0.4 ) ) , 0.0 ) ) ) );
			float4 UpDark_Color423 = ( ( Base_Color19 * EyesWhitePiple_Mask41 * EyesBall_BallMask155 ) + ( ( EyesUpDark_Color307 + EyesUpDark_Color307 ) * EyesBall_BallMask155 ) );
			float EyesUpLight_Mask18 = tex2D( _Eyes_UpDark, i.uv_texcoord ).r;
			float4 temp_output_140_0 = ( ( ( ( ( EyesBallDepth_Mask425 * ( temp_output_97_0 + ( temp_output_97_0 * Iris_Color31 ) ) ) + EyesWhitePipleDark_Color107 + EyesBallLine_Color358 ) / 2.0 ) + ( UpDark_Color423 * EyesBallDepth_Mask425 ) ) * EyesUpLight_Mask18 );
			float HightLight_RB_Mask20 = tex2D( _Eyes_LiftLightMask, i.uv_texcoord ).r;
			float4 EyesBasllWhite_Color188 = ( Base_Color19 * EyesWhite_Mask177 * _EyesBallWhite_Color * _EyesBallWhite_Int );
			float simplePerlin2D195 = snoise( (i.uv_texcoord*(_HightLightPointNoise_Tilling).xy + (_HightLightPointNoise_Tilling).zw)*_NoiseScale );
			simplePerlin2D195 = simplePerlin2D195*0.5 + 0.5;
			float HightLight__PoingMask244 = ( 1.0 - saturate( step( ( simplePerlin2D195 * EyesBall_BallMask155 ) , _HightLightPointNoise_Threshold ) ) );
			float4 HightLight__PoingColor248 = ( HightLight__PoingMask244 * _HightLight__PoingColor * _HightLight__PoingInt );
			float4 FinalColor365 = ( ( ( temp_output_140_0 + ( temp_output_140_0 * HightLight_RB_Mask20 * _LifeEyesBallLight_Color * _LifeEyesBallLight_Int ) ) + EyesBasllWhite_Color188 ) + HightLight__PoingColor248 );
			o.Emission = FinalColor365.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;395;-2002.67,2228.306;Inherit;False;1459.747;551.2966;Comment;14;377;380;382;383;381;384;375;385;387;388;374;372;373;391;Fresnel_Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;364;-2841.503,580.4777;Inherit;False;3676.417;1379.979;Comment;49;365;183;393;189;249;140;359;120;33;98;99;60;329;325;328;326;327;55;158;126;125;311;315;316;314;324;255;141;91;313;97;148;257;256;253;252;124;123;122;121;367;420;421;422;423;424;425;427;429;All;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;363;-2359.354,4165.804;Inherit;False;1641.734;1109.401;Comment;17;332;338;343;345;346;347;349;351;344;352;353;342;335;354;358;336;334;EyesBallInnerLineColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;360;-412.873,3081.974;Inherit;False;1492.112;978.7341;Comment;15;390;361;68;94;69;129;131;128;127;96;43;77;95;76;394;LightCalculate;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;304;-2467.608,3041.624;Inherit;False;2045.641;1030.246;Comment;24;310;306;307;305;303;299;261;272;308;295;298;297;259;288;269;294;290;289;287;270;321;317;322;323;EyesUpDark;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;245;-5513.336,4220.141;Inherit;False;2720.502;623.332;Comment;18;219;212;213;214;248;244;246;247;243;199;218;215;198;195;210;197;196;250;HightLightPointMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;193;-2762.751,2229.26;Inherit;False;749.1277;535.1165;Comment;6;185;187;186;190;192;188;EyesWhite;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;184;-5584.39,2837.197;Inherit;False;3107.258;1298.889;Comment;37;238;236;235;237;233;229;142;228;227;226;144;155;172;201;207;208;203;206;209;177;153;167;178;136;173;171;174;170;145;143;151;149;239;240;241;330;331;MaskCalculate;0.7806547,0.9150943,0.7640174,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;133;-5568,256;Inherit;False;1400.213;981.998;Comment;11;10;8;73;17;14;75;74;15;16;84;130;Eyes_HDD_Sampler;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;132;-4448,2128;Inherit;False;1620.654;387.0764;Comment;10;105;109;104;112;115;114;103;111;107;113;EyesWhitePipleDark;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;101;-5536,2096;Inherit;False;1050.241;583.6392;Comment;6;51;52;49;82;50;100;Decal;0.8773585,0.8674192,0.3848789,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;90;-4540,1312;Inherit;False;1690.006;775.7261;Comment;10;48;59;39;92;87;58;85;86;38;40;IrisColor;0.5385814,0.8584906,0.6480305,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;89;-5504,1312;Inherit;False;880.7432;712;Comment;9;24;30;28;26;31;53;25;102;41;EyesBallsLight;0.9811321,0.7847817,0.6710573,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;22;-4096,96;Inherit;False;1031.123;1143.082;Comment;14;18;5;13;46;9;3;21;45;7;20;19;4;12;11;Sampler;0.8246084,0.9528302,0.6876557,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;149;-5037.91,3188.452;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;151;-4819.909,3189.452;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;143;-5240.814,3033.919;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;145;-5050.745,2887.197;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;170;-5060.746,3430.229;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;174;-4760.345,3436.905;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;171;-4599.05,3422.261;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;173;-4791.763,3646.46;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;-2688.151,2279.26;Inherit;False;19;Base_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-2691.151,2391.26;Inherit;False;177;EyesWhite_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-2410.151,2333.26;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;190;-2712.751,2475.376;Inherit;False;Property;_EyesBallWhite_Color;EyesBallWhite_Color;26;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;192;-2691.751,2648.377;Inherit;False;Property;_EyesBallWhite_Int;EyesBallWhite_Int;25;1;[Header];Create;True;1;Eyes Ball White;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;188;-2267.623,2325.091;Inherit;False;EyesBasllWhite_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;178;-4407.16,3418.59;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;167;-4408.925,3197.281;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;153;-4601.619,3195.836;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;-3770.543,3306.896;Inherit;False;Property;_EyesBall_BallScale;EyesBall_BallScale;17;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;206;-3796.543,3184.896;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;203;-3953.129,3184.152;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;208;-3590.543,3182.896;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;201;-4224.75,3198.218;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;172;-5038.028,3651.372;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;1E-05;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;-5501.452,2929.336;Inherit;True;41;EyesWhitePiple_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;227;-3772.245,3529.162;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-5534.39,3153.278;Inherit;True;92;Iris_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;228;-3584.251,3525.157;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;233;-3428.896,3640.543;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;237;-3299.867,3639.066;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;238;-3176.039,3514.208;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;240;-3041.076,3436.791;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;241;-3224.376,3202.79;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;242;-2819.087,3210.707;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;239;-2974.777,3196.29;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-2671.975,2926.002;Inherit;True;SingleIris_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;177;-4175.658,3398.933;Inherit;True;EyesWhite_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;-4189.479,3610.085;Inherit;True;41;EyesWhitePiple_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;196;-5411.907,4270.141;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;197;-4969.087,4450.528;Inherit;False;Property;_NoiseScale;NoiseScale;31;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;210;-4996.907,4300.458;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;195;-4755.326,4323.872;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;-4525.085,4324.528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;215;-4173.739,4333.474;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;218;-4334.737,4336.474;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;-4751.086,4441.528;Inherit;False;155;EyesBall_BallMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;243;-4011.18,4324.048;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;247;-3525.148,4315.981;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;244;-3843.87,4315.094;Inherit;True;HightLight__PoingMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;248;-3336.272,4323.804;Inherit;False;HightLight__PoingColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;214;-5173.738,4481.474;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;213;-5160.908,4364.458;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;212;-5468.727,4417.071;Inherit;False;Property;_HightLightPointNoise_Tilling;HightLightPointNoise_Tilling;27;1;[Header];Create;True;1;Hight Light Point;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;219;-4683.738,4556.474;Inherit;False;Property;_HightLightPointNoise_Threshold;HightLightPointNoise_Threshold;29;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;250;-3788.133,4677.452;Inherit;False;Property;_HightLight__PoingInt;HightLight__PoingInt;30;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;246;-3839.967,4499.74;Inherit;False;Property;_HightLight__PoingColor;HightLight__PoingColor;28;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-4032,800;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-4032,1040;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-3440,832;Inherit;False;HightLight_RB_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;45;-3488,1120;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-3408,992;Inherit;False;EyesBall_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-5456,1360;Inherit;True;19;Base_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-5040,1456;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;53;-5216,1520;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-5456,1552;Inherit;True;21;EyesBall_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-4076,1440;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-4444,1360;Inherit;True;19;Base_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;85;-4268,1536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-5472,2144;Inherit;True;19;Base_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-5488,2352;Inherit;True;16;DetailDecal_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-5184,2240;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-4880,2224;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;102;-5072,1728;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-5456,1728;Inherit;False;Property;_Iris_Color;Iris_Color;43;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-5392,1904;Inherit;False;Property;_Iris_Int;Iris_Int;42;1;[Header];Create;True;1;Iris Color;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;58;-4444,1776;Inherit;False;Property;_EyesBall_Color;EyesBall_Color;19;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-4864,1488;Inherit;True;Iris_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-4720,2224;Inherit;True;Decal_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;100;-5232,2336;Inherit;False;Property;_Decal_Color;Decal_Color;23;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-4016,2208;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LuminanceNode;109;-3840,2208;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-4336,2368;Inherit;False;19;Base_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;112;-3648,2192;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;115;-3472,2224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-3296,2208;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-3104,2224;Inherit;False;EyesWhitePipleDark_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-4880,1728;Inherit;True;EyesWhitePiple_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;-4400,2176;Inherit;True;41;EyesWhitePiple_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-4012,1712;Inherit;True;Iris_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-3312,1104;Inherit;False;EyesWhiteAndPiple_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-4476,1568;Inherit;True;15;VirtualEyesball_Mask_S;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-4736,336;Inherit;False;Constant;_Float2;Float 2;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-4832,416;Inherit;False;Property;_SpecularEdgeSoft_Int;SpecularEdgeSoft_Int;9;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-4784,512;Inherit;True;VirtualEyesball_Mask_S;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-5520,608;Inherit;False;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-4384,736;Inherit;True;DetailDecal_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-4544,736;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-4928,784;Inherit;False;Property;_Decal_Int;Decal_Int;22;1;[Header];Create;True;1;Decal Color;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-4912,912;Inherit;True;VirtualEyesball_Mask_B;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;73;-4576,304;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-4048,576;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;207;-3999.562,3293.052;Inherit;True;Property;_EyesBall_BallPow;EyesBall_BallPow;16;0;Create;True;1;Eyes Ball Mask;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-4039.069,275.4613;Inherit;False;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-3488,544;Inherit;False;EyesUpLight_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-4369,319;Inherit;True;HightLight_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;270;-1801.32,3208.607;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;287;-2005.785,3167.514;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;289;-2173.785,3215.514;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;290;-2171.785,3303.514;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;294;-1597.401,3214.349;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;269;-2256.525,3091.624;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;288;-2431.784,3206.514;Inherit;False;Property;_EyesUpDarkNoise_Tilling;EyesUpDarkNoise_Tilling;36;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;297;-1903.314,3482.367;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;-1723.314,3476.367;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;-1451.342,3226.305;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;308;-1309.51,3245.021;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;261;-2222.38,3608.344;Inherit;False;Constant;_Float0;Float 0;32;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;303;-1170.297,3237.394;Inherit;False;EyesUpDark_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;-950.7042,3267.471;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-802.7042,3259.471;Inherit;False;EyesUpDark_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-4396,1952;Inherit;False;Property;_EyesBall_Int;EyesBall_Int;18;0;Create;True;1;Eyes Ball;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;259;-2195.994,3469.24;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;320;-1721.115,3775.734;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;299;-1937.437,3619.626;Inherit;False;155;EyesBall_BallMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;317;-2310.271,3741.617;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;272;-2216.984,3387.924;Inherit;False;Property;_EyesUpDarkNoise_Scale;EyesUpDarkNoise_Scale;35;1;[Header];Create;True;1;Eyes Up Dark;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-3948,2316;Inherit;False;Constant;_EyesWhitePipleDark_Int;EyesWhitePipleDark_Int;18;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;310;-1240.545,3504.673;Inherit;False;Property;_EyesUpDark_Int;EyesUpDark_Int;38;0;Create;True;0;0;0;False;0;False;1;1;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;235;-3683.423,3776.316;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;229;-3980.32,3708.122;Inherit;True;92;Iris_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;-3954.918,3898.408;Inherit;False;Constant;_Float3;Float 3;27;0;Create;True;0;0;0;False;0;False;0.68;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;-2685.383,3193.564;Inherit;True;EyesBall_BallMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;330;-2865.633,3532.201;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;322;-2032.115,3784.734;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;321;-1938.115,3944.734;Inherit;False;155;EyesBall_BallMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;331;-2695.268,3536.325;Inherit;True;EyesBallLine_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;373.1272,3179.974;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;213.1273,3147.974;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-362.873,3163.974;Inherit;False;Property;_IndirectSpecular_Smoothness;IndirectSpecular_Smoothness;10;1;[Header];Create;True;1;Indirect Specular Light;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectSpecularLight;43;-74.87297,3131.974;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-106.8727,3259.974;Inherit;False;Property;_IndirectSpecular_Int;IndirectSpecular_Int;11;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;210.8482,3630.076;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;128;-33.15226,3688.076;Inherit;False;Blinn-Phong Light;5;;8;cf814dba44d007a4e958d2ddd5813da6;0;3;42;COLOR;0,0,0,0;False;52;FLOAT3;0,0,0;False;43;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;57
Node;AmplifyShaderEditor.ColorNode;131;-39.87296,3802.565;Inherit;False;Property;_DecalSpecular_Color;DecalSpecular_Color;24;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;129;-26.15226,3616.076;Inherit;False;16;DetailDecal_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;121.2715,3357.919;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-89.72844,3332.919;Inherit;False;14;HightLight_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;332;-2204.848,4215.804;Inherit;True;331;EyesBallLine_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;338;-2269.992,4697.104;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;343;-2276.226,4842.253;Inherit;False;Property;_EyesLine_Range;EyesLine_Range;41;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;345;-2309.354,4949.205;Inherit;True;177;EyesWhite_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;346;-2015.354,4938.205;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;347;-2266.354,5159.205;Inherit;False;Constant;_Float4;Float 4;37;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;349;-1808.354,4936.205;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;351;-1648.676,4952.289;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;344;-1501.234,4757.571;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;352;-1354.768,4766.626;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;353;-2036.392,4740.521;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;342;-1858.564,4747.392;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-1355.453,4607.219;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;354;-1129.665,4681.826;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;358;-957.6196,4678.405;Inherit;False;EyesBallLine_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;336;-2250.969,4604.087;Inherit;False;Property;_EyesLine_Int;EyesLine_Int;40;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;334;-2206.111,4424.238;Inherit;False;Property;_EyesLine_Color;EyesLine_Color;39;1;[Header];Create;True;1;Eyes Inner Line;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;122;-716.4359,1058.478;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-875.4358,1160.477;Inherit;False;Constant;_Float1;Float 1;18;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-580.4359,1056.478;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;256;-619.9839,1363.575;Inherit;False;Property;_LifeEyesBallLight_Color;LifeEyesBallLight_Color;34;0;Create;True;0;0;0;False;0;False;0.8499113,1,0.8443396,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;257;-652.9357,1533.797;Inherit;False;Property;_LifeEyesBallLight_Int;LifeEyesBallLight_Int;33;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;255;-102.9225,1098.428;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;314;-2392.065,946.1375;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;316;-2557.065,915.1376;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;-2646.065,1055.138;Inherit;False;155;EyesBall_BallMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-2791.503,916.0737;Inherit;False;307;EyesUpDark_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1286.761,919.9518;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-1516.261,977.5517;Inherit;False;31;Iris_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-1233.436,1036.477;Inherit;False;107;EyesWhitePipleDark_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;359;-1241.782,1131.409;Inherit;False;358;EyesBallLine_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-423.149,1122.2;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;366;64.9482,2306.753;Inherit;False;365;FinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;7;-3808,1008;Inherit;True;Property;_Eyes_BallMask;Eyes_BallMask;14;2;[Header];[NoScaleOffset];Create;True;1;Eyes Ball;0;0;False;0;False;-1;f747f378a137aed4aa7d68bcfe97cb0a;f747f378a137aed4aa7d68bcfe97cb0a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-3808,800;Inherit;True;Property;_Eyes_LiftLightMask;Eyes_LiftLightMask;32;2;[Header];[NoScaleOffset];Create;True;1;Lift Illuminance Color;0;0;False;0;False;-1;92ea1ceaf7069f045990d3ee22a0707a;92ea1ceaf7069f045990d3ee22a0707a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-3808,544;Inherit;True;Property;_Eyes_UpDark;Eyes_UpDark;13;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;08a87f7b43338184bb3c9f3380b2f7e6;08a87f7b43338184bb3c9f3380b2f7e6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-5281,557;Inherit;True;Property;_Eyes_HDDMask;Eyes_HDDMask;15;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;298cf333cfac0bd47bbd5b5a89ccbb80;1f3514697e1701d41b0a08c2a6094039;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;393;27.4729,1120.314;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;183;167.6299,1131.398;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;365;536.5689,1290.116;Inherit;False;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;362;65.27493,2503.615;Inherit;False;361;CustomLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;390;454.8209,3545.615;Inherit;False;374;Fresnel_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;361;704.6233,3185.735;Inherit;False;CustomLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;394;582.5627,3181.321;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;306;-1192.704,3312.471;Inherit;False;Property;_EyesUpDark_Color;EyesUpDark_Color;37;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;377;-1936.294,2497.953;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;380;-1718.608,2430.23;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;382;-1525.179,2427.545;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;383;-1348.179,2421.545;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;381;-1208.179,2417.545;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;384;-1048.936,2423.973;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;375;-1952.67,2360.227;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.IndirectSpecularLight;385;-1175.137,2281.387;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;387;-1294.389,2278.306;Inherit;False;Constant;_Float5;Float 5;39;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;388;-907.3887,2393.306;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;374;-775.9232,2391.559;Inherit;False;Fresnel_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;372;-1329.609,2556.467;Inherit;False;Property;_FresnelScale;Fresnel Scale;44;1;[Header];Create;True;1;Fresnel;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;373;-1670.365,2600.705;Inherit;False;Property;_FresnelPower;Fresnel Power;45;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;391;-1106.075,2567.603;Inherit;False;Property;_FresnelColor;Fresnel Color;46;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;94;-94.7284,3411.919;Inherit;False;Blinn-Phong Light;5;;10;cf814dba44d007a4e958d2ddd5813da6;0;3;42;COLOR;0,0,0,0;False;52;FLOAT3;0,0,0;False;43;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;57
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-3479.069,275.4613;Inherit;False;Base_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-3473.591,2296.986;Inherit;False;19;Base_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-3799.069,259.4613;Inherit;True;Property;_Eyes_BaseColor;Eyes_BaseColor;12;2;[Header];[NoScaleOffset];Create;True;1;Base Color;0;0;False;0;False;-1;fd19814ce4f70c940901695a75559427;fd19814ce4f70c940901695a75559427;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;91;-2383.186,863.2134;Inherit;False;48;EyesBall_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;313;-2174.165,892.5374;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-1871.299,1013.068;Inherit;False;50;Decal_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-1433.199,851.1674;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;266.9759,2264.251;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;Study/MingChao/Char_Eyes;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;368;80.68858,2609.877;Inherit;False;367;D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;323;-1547.115,3773.934;Inherit;True;EyesBallUpDark_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-1818.832,735.3752;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;422;-986.3782,871.517;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-1155.325,896.5376;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;-871.4358,1010.478;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-2585.564,1458.474;Inherit;False;41;EyesWhitePiple_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;-2580.176,1548.406;Inherit;False;155;EyesBall_BallMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;327;-2605.696,1836.951;Inherit;False;155;EyesBall_BallMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;326;-2516.696,1696.951;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;328;-2751.134,1697.887;Inherit;False;307;EyesUpDark_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;325;-2377.631,1702.019;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;329;-2160.734,1377.449;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-2327.564,1376.474;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-2547.366,1374.566;Inherit;False;19;Base_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;423;-2015.376,1361.834;Inherit;False;UpDark_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;252;-322.528,1251.93;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;253;-614.6572,1283.313;Inherit;False;20;HightLight_RB_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;425;-1171.45,706.0673;Inherit;False;EyesBallDepth_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-636.1002,1195.474;Inherit;False;18;EyesUpLight_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;424;-1110.832,1291.819;Inherit;False;423;UpDark_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;427;-1137.982,1379.997;Inherit;False;425;EyesBallDepth_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;428;-888.9817,1343.997;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;420;-1357.316,689.6727;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;421;-1656.703,802.4467;Inherit;False;Property;_EyesBallDepth;Eyes Ball Depth;21;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;-1625.912,652.3575;Inherit;False;323;EyesBallUpDark_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;-181.2814,1278.576;Inherit;False;188;EyesBasllWhite_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;249;-142.186,1373.139;Inherit;False;248;HightLight__PoingColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;367;324.9087,1015.613;Inherit;False;D;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;86;-3486,1447;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-3326,1447;Inherit;True;EyesBall_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-4025,1616;Inherit;False;Property;_EyesBallTransLight;Eyes Ball Trans Light;20;0;Create;True;0;0;0;False;0;False;1;1;0.8;1.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;429;-1468.053,756.7524;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
WireConnection;149;0;144;0
WireConnection;149;1;142;0
WireConnection;151;0;149;0
WireConnection;143;0;142;0
WireConnection;145;0;144;0
WireConnection;145;1;143;0
WireConnection;170;0;144;0
WireConnection;170;1;142;0
WireConnection;174;0;170;0
WireConnection;171;0;174;0
WireConnection;171;1;173;0
WireConnection;173;0;172;0
WireConnection;186;0;185;0
WireConnection;186;1;187;0
WireConnection;186;2;190;0
WireConnection;186;3;192;0
WireConnection;188;0;186;0
WireConnection;178;0;171;0
WireConnection;167;0;153;0
WireConnection;153;0;151;0
WireConnection;206;0;203;0
WireConnection;206;1;207;0
WireConnection;203;0;201;0
WireConnection;208;0;206;0
WireConnection;208;1;209;0
WireConnection;201;0;167;0
WireConnection;201;1;178;0
WireConnection;172;0;142;0
WireConnection;227;0;177;0
WireConnection;227;1;226;0
WireConnection;228;0;227;0
WireConnection;233;0;235;0
WireConnection;237;0;233;0
WireConnection;238;0;228;0
WireConnection;238;1;237;0
WireConnection;240;0;238;0
WireConnection;241;0;208;0
WireConnection;242;0;239;0
WireConnection;239;0;241;0
WireConnection;239;1;240;0
WireConnection;136;0;145;0
WireConnection;177;0;178;0
WireConnection;210;0;196;0
WireConnection;210;1;213;0
WireConnection;210;2;214;0
WireConnection;195;0;210;0
WireConnection;195;1;197;0
WireConnection;198;0;195;0
WireConnection;198;1;199;0
WireConnection;215;0;218;0
WireConnection;218;0;198;0
WireConnection;218;1;219;0
WireConnection;243;0;215;0
WireConnection;247;0;244;0
WireConnection;247;1;246;0
WireConnection;247;2;250;0
WireConnection;244;0;243;0
WireConnection;248;0;247;0
WireConnection;214;0;212;0
WireConnection;213;0;212;0
WireConnection;20;0;9;1
WireConnection;45;0;7;1
WireConnection;21;0;7;1
WireConnection;26;0;24;0
WireConnection;26;1;53;0
WireConnection;26;2;28;0
WireConnection;26;3;30;0
WireConnection;53;0;25;0
WireConnection;40;0;38;0
WireConnection;40;1;85;0
WireConnection;40;2;58;0
WireConnection;40;3;59;0
WireConnection;85;0;39;0
WireConnection;49;0;51;0
WireConnection;49;1;52;0
WireConnection;82;0;49;0
WireConnection;82;1;49;0
WireConnection;82;2;100;0
WireConnection;102;0;25;0
WireConnection;31;0;26;0
WireConnection;50;0;82;0
WireConnection;105;0;103;0
WireConnection;105;1;104;0
WireConnection;109;0;105;0
WireConnection;112;0;109;0
WireConnection;112;1;111;0
WireConnection;115;0;112;0
WireConnection;114;0;115;0
WireConnection;114;1;113;0
WireConnection;107;0;114;0
WireConnection;41;0;102;0
WireConnection;92;0;85;0
WireConnection;46;0;45;0
WireConnection;15;0;8;2
WireConnection;16;0;130;0
WireConnection;130;0;8;3
WireConnection;130;1;84;0
WireConnection;17;0;8;4
WireConnection;73;0;8;1
WireConnection;73;1;75;0
WireConnection;73;2;74;0
WireConnection;18;0;5;1
WireConnection;14;0;73;0
WireConnection;270;0;287;0
WireConnection;270;1;272;0
WireConnection;287;0;269;0
WireConnection;287;1;289;0
WireConnection;287;2;290;0
WireConnection;289;0;288;0
WireConnection;290;0;288;0
WireConnection;294;0;270;0
WireConnection;297;0;259;2
WireConnection;297;1;261;0
WireConnection;298;0;297;0
WireConnection;298;1;299;0
WireConnection;295;0;294;0
WireConnection;295;1;298;0
WireConnection;308;0;295;0
WireConnection;303;0;308;0
WireConnection;305;0;303;0
WireConnection;305;1;306;0
WireConnection;305;2;310;0
WireConnection;307;0;305;0
WireConnection;320;0;322;0
WireConnection;320;1;321;0
WireConnection;235;0;229;0
WireConnection;235;1;236;0
WireConnection;155;0;242;0
WireConnection;330;0;241;0
WireConnection;330;1;155;0
WireConnection;322;0;317;2
WireConnection;331;0;330;0
WireConnection;76;0;95;0
WireConnection;76;1;69;0
WireConnection;76;2;127;0
WireConnection;95;0;43;0
WireConnection;95;1;96;0
WireConnection;43;1;77;0
WireConnection;127;0;129;0
WireConnection;127;1;128;0
WireConnection;127;2;131;0
WireConnection;69;0;68;0
WireConnection;69;1;94;0
WireConnection;346;0;345;0
WireConnection;346;1;347;0
WireConnection;349;0;346;0
WireConnection;351;0;349;0
WireConnection;344;0;342;0
WireConnection;344;1;351;0
WireConnection;352;0;344;0
WireConnection;353;0;338;2
WireConnection;342;0;353;0
WireConnection;342;1;343;0
WireConnection;335;0;332;0
WireConnection;335;1;334;0
WireConnection;335;2;336;0
WireConnection;354;0;335;0
WireConnection;354;1;352;0
WireConnection;358;0;354;0
WireConnection;122;0;121;0
WireConnection;122;1;123;0
WireConnection;124;0;122;0
WireConnection;124;1;428;0
WireConnection;255;0;140;0
WireConnection;255;1;252;0
WireConnection;314;0;316;0
WireConnection;314;1;315;0
WireConnection;316;0;311;0
WireConnection;316;1;311;0
WireConnection;98;0;97;0
WireConnection;98;1;33;0
WireConnection;140;0;124;0
WireConnection;140;1;141;0
WireConnection;7;1;12;0
WireConnection;9;1;11;0
WireConnection;5;1;13;0
WireConnection;8;1;10;0
WireConnection;393;0;255;0
WireConnection;393;1;189;0
WireConnection;183;0;393;0
WireConnection;183;1;249;0
WireConnection;365;0;183;0
WireConnection;361;0;394;0
WireConnection;394;0;76;0
WireConnection;394;1;390;0
WireConnection;380;0;375;0
WireConnection;380;1;377;0
WireConnection;382;0;380;0
WireConnection;382;1;373;0
WireConnection;383;0;382;0
WireConnection;381;0;383;0
WireConnection;384;0;381;0
WireConnection;384;1;372;0
WireConnection;385;1;387;0
WireConnection;388;0;385;0
WireConnection;388;1;384;0
WireConnection;388;2;391;0
WireConnection;374;0;388;0
WireConnection;19;0;3;0
WireConnection;3;1;4;0
WireConnection;313;0;91;0
WireConnection;313;1;314;0
WireConnection;97;0;313;0
WireConnection;97;1;60;0
WireConnection;2;2;366;0
WireConnection;2;13;362;0
WireConnection;323;0;320;0
WireConnection;148;1;313;0
WireConnection;422;0;425;0
WireConnection;422;1;99;0
WireConnection;99;0;97;0
WireConnection;99;1;98;0
WireConnection;121;0;422;0
WireConnection;121;1;120;0
WireConnection;121;2;359;0
WireConnection;326;0;328;0
WireConnection;326;1;328;0
WireConnection;325;0;326;0
WireConnection;325;1;327;0
WireConnection;329;0;126;0
WireConnection;329;1;325;0
WireConnection;126;0;55;0
WireConnection;126;1;125;0
WireConnection;126;2;158;0
WireConnection;423;0;329;0
WireConnection;252;0;140;0
WireConnection;252;1;253;0
WireConnection;252;2;256;0
WireConnection;252;3;257;0
WireConnection;425;0;420;0
WireConnection;428;0;424;0
WireConnection;428;1;427;0
WireConnection;420;0;324;0
WireConnection;420;1;429;0
WireConnection;86;0;40;0
WireConnection;86;1;87;0
WireConnection;48;0;86;0
WireConnection;429;0;421;0
ASEEND*/
//CHKSM=23E851F84F750BABE352211B49EE1597BF58C9D8