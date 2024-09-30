// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Study/MingChao/Char_Hair_B"
{
	Properties
	{
		_Hair_Albedo("Hair_Albedo", 2D) = "white" {}
		_Hair_HA_Repaired("Hair_HA_Repaired", 2D) = "white" {}
		[Header(Tint Diffusion)]_TintSSSColor("Tint SSS Color", Color) = (1,1,1,1)
		_TintDiffuseInt("Tint Diffuse Int", Float) = 1
		[Header(Out Line)]_OutLineInt("Out Line Int", Float) = 1
		_OutLineColor("Out Line Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		
		
		
		Pass
		{
			CGINCLUDE
			#pragma target 3.0
			ENDCG
			Blend Off
			AlphaToMask Off
			Cull Off
			ColorMask RGBA
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			
			Name "Unlit"

			CGPROGRAM

			#pragma multi_compile_fwdbase


			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityStandardBRDF.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_lmap : TEXCOORD3;
				float4 ase_sh : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			//This is a late directive
			
			uniform sampler2D _Hair_Albedo;
			uniform float4 _Hair_Albedo_ST;
			uniform float4 RampColor_G;
			uniform float SoftEdge_G;
			uniform sampler2D _Hair_HA_Repaired;
			uniform float4 _Hair_HA_Repaired_ST;
			uniform float LightSpecness_G;
			uniform float LightThreshold_G;
			uniform float4 HairTintDiffuseLightColor_G;
			uniform float4 LightColor_G;
			uniform float LightInt_G;
			uniform float4 _TintSSSColor;
			uniform float _TintDiffuseInt;
			uniform float HairLightLerp_G;
			uniform float4 HightLightTintColor_G;
			uniform float HightLightTintInt_G;
			uniform float HightLightShadowLerp_G;
			uniform float AnisoSpecShininess_G;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				#ifdef DYNAMICLIGHTMAP_ON //dynlm
				o.ase_lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif //dynlm
				#ifdef LIGHTMAP_ON //stalm
				o.ase_lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif //stalm
				float3 ase_worldPos = mul(unity_ObjectToWorld, float4( (v.vertex).xyz, 1 )).xyz;
				#ifndef LIGHTMAP_ON //nstalm
				#if UNITY_SHOULD_SAMPLE_SH //sh
				o.ase_sh.xyz = 0;
				#ifdef VERTEXLIGHT_ON //vl
				o.ase_sh.xyz += Shade4PointLights (
				unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
				unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
				unity_4LightAtten0, ase_worldPos, ase_worldNormal);
				#endif //vl
				o.ase_sh.xyz = ShadeSHPerVertex (ase_worldNormal, o.ase_sh.xyz);
				#endif //sh
				#endif //nstalm
				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord5.xyz = ase_worldTangent;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord6.xyz = ase_worldBitangent;
				float3 ase_vertexBitangent = cross( v.ase_normal, v.ase_tangent.xyz ) * v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				o.ase_texcoord7.xyz = ase_vertexBitangent;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				o.ase_tangent = v.ase_tangent;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_sh.w = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_Hair_Albedo = i.ase_texcoord1.xy * _Hair_Albedo_ST.xy + _Hair_Albedo_ST.zw;
				float4 tex2DNode2 = tex2D( _Hair_Albedo, uv_Hair_Albedo );
				float2 texCoord202 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float RampHair_Mask206 = saturate( ( texCoord202.y * ( i.ase_color.r - i.ase_color.b ) ) );
				float4 RampHair_Color209 = ( RampHair_Mask206 * RampColor_G * RampColor_G.a );
				float4 SampleBaseColor97 = ( tex2DNode2 + ( tex2DNode2 * RampHair_Color209 ) );
				float temp_output_79_0 = ( SoftEdge_G * 0.01 );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = Unity_SafeNormalize( ase_worldViewDir );
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				float3 WS_Normal68 = -normalizedWorldNormal;
				float dotResult73 = dot( ase_worldViewDir , WS_Normal68 );
				float NdotV114 = dotResult73;
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(WorldPosition);
				float dotResult38 = dot( WS_Normal68 , worldSpaceLightDir );
				float2 uv_Hair_HA_Repaired = i.ase_texcoord1.xy * _Hair_HA_Repaired_ST.xy + _Hair_HA_Repaired_ST.zw;
				float4 tex2DNode4 = tex2D( _Hair_HA_Repaired, uv_Hair_HA_Repaired );
				float SampleAO92 = tex2DNode4.g;
				float HalfLambertTerm44 = ( (dotResult38*0.5 + 0.5) * SampleAO92 );
				float lerpResult81 = lerp( (NdotV114*0.5 + 0.5) , HalfLambertTerm44 , 0.9);
				float saferPower84 = abs( lerpResult81 );
				float smoothstepResult70 = smoothstep( ( 0.5 - temp_output_79_0 ) , ( 0.5 + temp_output_79_0 ) , saturate( ( saturate( pow( saferPower84 , ( LightSpecness_G * 0.1 ) ) ) - ( LightThreshold_G * 0.97 ) ) ));
				float DiffuseTint_Mask299 = ( 1.0 - smoothstepResult70 );
				float4 DiffuseTine_Color298 = ( DiffuseTint_Mask299 * HairTintDiffuseLightColor_G * HairTintDiffuseLightColor_G.a );
				float LightTint_Mask89 = smoothstepResult70;
				#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
				float4 ase_lightColor = 0;
				#else //aselc
				float4 ase_lightColor = _LightColor0;
				#endif //aselc
				float4 LightTint_Color13 = ( LightTint_Mask89 * LightColor_G * LightInt_G * float4( ase_lightColor.rgb , 0.0 ) );
				float3 ase_worldTangent = i.ase_texcoord5.xyz;
				float3 ase_worldBitangent = i.ase_texcoord6.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal55 = WS_Normal68;
				UnityGIInput data55;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data55 );
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON) //dylm55
				data55.lightmapUV = i.ase_lmap;
				#endif //dylm55
				#if UNITY_SHOULD_SAMPLE_SH //fsh55
				data55.ambient = i.ase_sh;
				#endif //fsh55
				UnityGI gi55 = UnityGI_Base(data55, 1, float3(dot(tanToWorld0,tanNormal55), dot(tanToWorld1,tanNormal55), dot(tanToWorld2,tanNormal55)));
				float4 SSS_Light46 = ( ( float4( gi55.indirect.diffuse , 0.0 ) + ( ( _TintSSSColor * _TintSSSColor.a * ase_lightColor ) * HalfLambertTerm44 ) ) * ( 1.0 - LightTint_Mask89 ) * max( _TintDiffuseInt , 0.0 ) );
				float4 lerpResult304 = lerp( SampleBaseColor97 , ( SampleBaseColor97 * ( DiffuseTine_Color298 + LightTint_Color13 + SSS_Light46 ) ) , HairLightLerp_G);
				float SampleHightLight93 = tex2DNode4.r;
				float lerpResult112 = lerp( ( 1.0 - LightTint_Mask89 ) , LightTint_Mask89 , HightLightShadowLerp_G);
				float3 ase_vertexBitangent = i.ase_texcoord7.xyz;
				float3 normalizeResult138 = normalize( ase_vertexBitangent );
				float3 normalizeResult132 = normalize( ( ase_worldViewDir + worldSpaceLightDir ) );
				float3 HalfDir147 = normalizeResult132;
				float dotResult152 = dot( normalizeResult138 , HalfDir147 );
				float temp_output_166_0 = ( dotResult152 / AnisoSpecShininess_G );
				float3 normalizeResult151 = normalize( i.ase_tangent.xyz );
				float dotResult148 = dot( HalfDir147 , normalizeResult151 );
				float3 normalizeResult164 = normalize( i.ase_normal );
				float dotResult162 = dot( HalfDir147 , normalizeResult164 );
				float AnisoKKplus_Mask178 = exp( ( -( ( temp_output_166_0 * temp_output_166_0 ) + ( dotResult148 * dotResult148 ) ) / ( dotResult162 + 1.0 ) ) );
				float4 HighLightTint_Color107 = ( ( SampleHightLight93 * HightLightTintColor_G * HightLightTintInt_G * lerpResult112 ) * AnisoKKplus_Mask178 );
				float4 CustomLight306 = ( lerpResult304 + HighLightTint_Color107 );
				
				
				finalColor = CustomLight306;
				return finalColor;
			}
			ENDCG
		}

		
		Pass
		{
			CGINCLUDE
			#pragma target 3.0
			ENDCG
			Blend Off
			AlphaToMask Off
			Cull Front
			ColorMask RGBA
			ZWrite On
			ZTest LEqual
			
			Name "SecondUnlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#define ASE_NEEDS_VERT_COLOR
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _OutLineInt;
			uniform sampler2D _Hair_Albedo;
			uniform float4 _Hair_Albedo_ST;
			uniform float4 RampColor_G;
			uniform float4 _OutLineColor;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( normalizedWorldNormal * ( _OutLineInt * 0.001 ) * ( 1.0 - v.color.a ) );
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_Hair_Albedo = i.ase_texcoord1.xy * _Hair_Albedo_ST.xy + _Hair_Albedo_ST.zw;
				float4 tex2DNode2 = tex2D( _Hair_Albedo, uv_Hair_Albedo );
				float2 texCoord202 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float RampHair_Mask206 = saturate( ( texCoord202.y * ( i.ase_color.r - i.ase_color.b ) ) );
				float4 RampHair_Color209 = ( RampHair_Mask206 * RampColor_G * RampColor_G.a );
				float4 SampleBaseColor97 = ( tex2DNode2 + ( tex2DNode2 * RampHair_Color209 ) );
				float4 break225 = SampleBaseColor97;
				float4 temp_cast_0 = (( max( max( break225.r , break225.g ) , break225.b ) - 0.004 )).xxxx;
				float4 lerpResult232 = lerp( SampleBaseColor97 , ( step( temp_cast_0 , SampleBaseColor97 ) * SampleBaseColor97 ) , 0.6);
				float4 OutLine_Color235 = ( ( ( lerpResult232 * 0.8 ) * SampleBaseColor97 ) * _OutLineColor );
				
				
				finalColor = OutLine_Color235;
				return finalColor;
			}
			ENDCG
		}

		

	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback "Legacy Shaders/Diffuse"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;267;-1985.966,-795.8691;Inherit;False;2481.966;466.5473;Comment;18;225;226;227;228;229;224;231;232;230;233;234;239;240;241;242;235;243;237;Out Line Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;189;-3600.506,-859.0095;Inherit;False;1472.38;1131.546;Comment;8;97;93;4;92;2;211;315;316;Sample;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;182;-5615.604,311.92;Inherit;False;2157.786;1651.004;Comment;43;172;171;170;169;173;174;177;149;161;163;162;164;167;168;154;153;166;152;150;148;151;141;160;159;158;165;178;138;121;131;130;132;128;134;136;147;133;135;179;180;181;269;276;Anisotropy  Calculation;0.8442824,0.990566,0.5466803,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;109;-7187.424,307.9053;Inherit;False;1518.255;942.0326;Comment;11;184;183;107;113;111;110;112;105;106;104;102;Hight Light Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;-6256,-368;Inherit;False;611.7162;209.5667;Comment;3;68;196;58;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;7;-7440.926,-753.8511;Inherit;False;983.7997;596.2368;Comment;6;25;13;12;26;11;286;Light Tint Color;0.9433962,0.9355134,0.7075472,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;8;-7333.402,-1979.418;Inherit;False;2693.962;973.6895;Comment;25;89;81;77;101;317;83;79;87;88;78;278;71;84;75;69;114;299;282;270;72;73;85;80;74;70;Specular Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;9;-3580.867,-2065.634;Inherit;False;2275.367;1074.366;Comment;21;56;55;54;53;52;51;49;48;47;46;45;44;42;41;40;39;38;37;98;99;277;SSS Light Tint Color;0.5772662,0.5311054,0.7264151,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1828.949,-1757.047;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-2029.818,-1772.746;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;70;-5543.401,-1760.938;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;74;-6064.814,-1789.092;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-6970.276,-1629.774;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;85;-6225.016,-1770.59;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;55;-2399.387,-1889.005;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;54;-1970.515,-1569.436;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;58;-6192,-304;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;48;-2025.175,-1672.991;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-2252.665,-1652.105;Inherit;False;89;LightTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2274.317,-1759.892;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2157.004,-1556.906;Inherit;False;Property;_TintDiffuseInt;Tint Diffuse Int;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;73;-7080.493,-1745.422;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;72;-6773.096,-1756.296;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;152;-5101.582,950.4095;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;132;-4886.379,483.7231;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;128;-4253.072,570.0798;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;134;-4104.38,560.7231;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-4719.218,490.2122;Inherit;False;HalfDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;133;-4409.376,543.2224;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;135;-3923.38,573.7231;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;180;-4676.533,603.3726;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BitangentVertexDataNode;181;-4887.552,606.3347;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;172;-4922.875,1691.434;Inherit;False;114;NdotV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;171;-4708.959,1599.904;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;170;-4527.696,1599.008;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-4924.572,1592.415;Inherit;False;44;HalfLambertTerm;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;173;-4379.353,1616.896;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;174;-4233.032,1603.536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-6985.159,344.6033;Inherit;True;93;SampleHightLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-6354.913,368.0313;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;112;-6798.807,900.2743;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-7144.625,882.4002;Inherit;False;89;LightTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;111;-6966.787,846.1402;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-3550.506,-100.8225;Inherit;True;Property;_Hair_HA_Repaired;Hair_HA_Repaired;1;0;Create;True;0;0;0;False;0;False;-1;c9ec608d9ac67ef4291706ab5a0b6e35;a953f9a2da440a1478d7be7eaec08e7b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;196;-6000,-304;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;200;-1074.26,-273.0216;Inherit;False;780.0088;346;Comment;4;210;209;208;207;Ramp Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;201;-1982.376,-299.5602;Inherit;False;897.0435;464.5674;Comment;6;281;205;204;203;202;206;Ramp;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-3244.422,-251.632;Inherit;True;SampleHightLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;225;-1711.544,-732.0792;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMaxOpNode;226;-1513.544,-725.0792;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;227;-1361.544,-699.0792;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;228;-1181.544,-698.0792;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.004;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;229;-961.5441,-660.0792;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;224;-1935.966,-745.8691;Inherit;False;97;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;-774.1143,-631.801;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;232;-594.1143,-668.801;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;230;-1212.114,-579.8011;Inherit;False;97;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;233;-862.1144,-732.801;Inherit;False;97;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;234;-776.1143,-521.8011;Inherit;False;Constant;_Float4;Float 4;19;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;239;-355.6924,-670.6497;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;240;-603.6921,-518.6498;Inherit;False;Constant;_Float5;Float 5;19;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-383.6923,-536.6497;Inherit;False;97;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;-170.6923,-669.6497;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;235;262.9996,-691.0853;Inherit;False;OutLine_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;237;-173.148,-541.3219;Inherit;False;Property;_OutLineColor;Out Line Color;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;270;-7250.188,-1804.097;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;72.58781,-628.425;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-2567.494,-1946.018;Inherit;False;68;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-4135.38,694.7231;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;179;-3774.674,806.531;Inherit;False;AnisoKKBase_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;177;-3713.387,1262.33;Inherit;False;AnisoAttenuation_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;161;-5347.909,1410.735;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;163;-5342.55,1315.738;Inherit;False;147;HalfDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;162;-4968.55,1339.738;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;164;-5116.55,1418.738;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;168;-4191.806,1127.545;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;-4366.385,1084.254;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-4601.743,984.2584;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;166;-4749.985,995.8464;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-4942.136,1194.705;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;148;-5142.278,1181.865;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;151;-5355.696,1226.313;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TangentVertexDataNode;141;-5565.604,1233.124;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;160;-4697.677,1329.967;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-4973.885,1455.644;Inherit;False;Constant;_Float3;Float 3;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;158;-4055.105,1132.47;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BitangentVertexDataNode;121;-5553.616,939.6857;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-5990.909,362.6613;Inherit;False;HighLightTint_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ExpOpNode;165;-3922.274,1127.636;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;138;-5322.5,921.9838;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-5544.095,1079.083;Inherit;False;147;HalfDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;131;-5047.379,459.7231;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;269;-5293.361,413.1667;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;130;-5373.354,567.6959;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;178;-3680.818,1123.826;Inherit;False;AnisoKKplus_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;276;-3811.901,1033.235;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;184;-6410.61,592.2192;Inherit;False;178;AnisoKKplus_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-748.2509,-223.0217;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-3355.235,-696.2981;Inherit;True;Property;_Hair_Albedo;Hair_Albedo;0;0;Create;True;0;0;0;False;0;False;-1;9d1a5ae9391cc3e48a85100cb6e2aa46;75c0396b38cb94547978c60a9de43062;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;209;-509.251,-222.0217;Inherit;False;RampHair_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;206;-1314.332,-187.8851;Inherit;False;RampHair_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-2662.858,-1851.162;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;277;-2854.417,-1729.225;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;294;-6420.997,-811.9545;Inherit;False;797.6331;422.3277;Comment;4;295;298;297;296;Diffuse Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-7056.926,-689.8511;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;286;-7328.926,-369.8511;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-6912.926,-689.8511;Inherit;False;LightTint_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;296;-6052.997,-715.9545;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;298;-5892.997,-715.9545;Inherit;False;DiffuseTine_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;300;-5612.967,-800.5173;Inherit;False;1933.246;759.4327;Comment;11;319;318;306;307;304;301;303;302;308;313;309;Light Calculation;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-5856,-304;Inherit;False;WS_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-6963.794,-1753.46;Inherit;False;NdotV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-5689.401,-1556.938;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;295;-6324.997,-748.9545;Inherit;False;299;DiffuseTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;-7376.926,-705.8511;Inherit;False;89;LightTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;75;-5922.252,-1786.932;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;84;-6415.452,-1756.412;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;313;-5419.677,-305.1559;Inherit;False;46;SSS_Light;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;302;-5155.228,-488.9756;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;-4982.413,-532.1024;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-5428.525,-620.2034;Inherit;False;97;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;315;-2904.232,-508.8875;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;207;-1022.26,-227.1874;Inherit;False;206;RampHair_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-2735.925,-633.3162;Inherit;False;SampleBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-3256.543,-430.0856;Inherit;False;209;RampHair_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;-3032.257,-419.6097;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;304;-4640.314,-599.1671;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-7424.926,-455.8511;Inherit;False;Global;LightInt_G;Light Int_G;5;1;[Header];Create;True;1;Tint Light;0;0;True;0;False;0.2;2.22;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-1674.641,-1758.382;Inherit;False;SSS_Light;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;26;-7376.926,-625.8511;Inherit;False;Global;LightColor_G;Light Color_G;7;0;Create;True;0;0;0;True;0;False;1,1,1,1;0.990566,0.9601143,0.9578586,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-5960.4,-1668.938;Inherit;False;Constant;_Float2;Float 2;12;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;278;-5707.574,-1696.974;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-6884.479,-1491.292;Inherit;False;Global;LightSpecness_G;Light Specness_G;7;0;Create;True;0;0;0;True;0;False;1;0.193;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-6583.54,-1489.678;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-5921.175,-1544.589;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;317;-6116.725,-1669.65;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.97;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-6812.843,-1573.422;Inherit;False;44;HalfLambertTerm;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;41;-2884.621,-1557.842;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-2846.196,-1417.32;Inherit;False;92;SampleAO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-2669.992,-1578.92;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-2528.58,-1595.374;Inherit;False;HalfLambertTerm;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;38;-3130.735,-1562.896;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-3356.593,-1593.818;Inherit;False;68;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;37;-3386.735,-1508.896;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;39;-3188.521,-1349.429;Float;False;Constant;_RemapValue;Remap Value;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;306;-4158.593,-597.1381;Inherit;False;CustomLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;318;-4352.354,-601.8657;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;319;-4632.354,-400.8657;Inherit;False;107;HighLightTint_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-6172.265,378.1503;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;52;-2931.217,-1908.82;Inherit;False;Property;_TintSSSColor;Tint SSS Color;2;1;[Header];Create;True;1;Tint Diffusion;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;113;-7071.126,1095.242;Inherit;False;Global;HightLightShadowLerp_G;Hight Light Shadow Lerp_G;7;0;Create;True;0;0;0;True;0;False;1;0.791;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-6968.851,718.8559;Inherit;False;Global;HightLightTintInt_G;Hight Light Tint Int_G;6;0;Create;True;0;0;0;True;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;105;-7007.07,546.4094;Inherit;False;Global;HightLightTintColor_G;Hight Light Tint Color_G;5;1;[Header];Create;True;1;Hight Light Tint;0;0;True;0;False;1,1,1,1;0.8773585,0.7656195,0.7656195,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;167;-5038.237,1081.254;Inherit;False;Global;AnisoSpecShininess_G;Aniso Spec Shininess_G;8;0;Create;True;0;0;0;True;0;False;0;1.34;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;210;-1023.851,-139.0217;Inherit;False;Global;RampColor_G;Ramp Color_G;4;0;Create;True;0;0;0;True;0;False;1,1,1,1;0.2924528,0.06759523,0.1581223,0.6745098;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;-2400,960;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-2608,992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;223;-2720,832;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;1;-2704,1104;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;220;-2784,976;Inherit;False;Property;_OutLineInt;Out Line Int;4;1;[Header];Create;True;1;Out Line;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;248;-2544,1200;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;217;-2096,928;Float;False;False;-1;2;ASEMaterialInspector;100;12;New Amplify Shader;cb0a069cd65065f4691e7feda7c4b316;True;SecondUnlit;0;1;SecondUnlit;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;False;False;0;True;True;0;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;1;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;1;False;;True;3;False;;True;False;100;False;_OutLineInt;100;False;;False;True;2;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-7273.491,-1630.733;Inherit;False;68;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;81;-6574.429,-1770.896;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-3245.596,-25.18786;Inherit;True;SampleAO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;202;-1914.71,-249.5602;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;-1621.897,-205.7164;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;204;-1932.376,-115.993;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;205;-1723.637,-49.73199;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;281;-1464.693,-186.5004;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;307;-4970.08,-386.8717;Inherit;False;Global;HairLightLerp_G;Hair Light Lerp_G;6;0;Create;True;0;0;0;True;0;False;0.34;0.395;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;236;-2420,863;Inherit;False;235;OutLine_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;216;-2078,744;Float;False;True;-1;2;ASEMaterialInspector;100;12;Study/MingChao/Char_Hair_B;cb0a069cd65065f4691e7feda7c4b316;True;Unlit;0;0;Unlit;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;False;False;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;2;False;0;Legacy Shaders/Diffuse;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;638630341852239612;0;2;True;True;False;;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-2415,686;Inherit;False;306;CustomLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;308;-5460.794,-509.3105;Inherit;False;298;DiffuseTine_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-5147.64,-1753.653;Inherit;False;LightTint_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-6221.801,-1524.765;Inherit;False;Global;SoftEdge_G;Soft Edge_G;6;1;[Header];Create;True;0;0;0;True;0;False;3;0.05;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-6400.734,-1628.156;Inherit;False;Global;LightThreshold_G;Light Threshold_G;5;0;Create;True;1;Tint Light 1;0;0;True;0;False;0;0.479;0;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;282;-5315.967,-1619.207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;299;-5133.978,-1627.476;Inherit;False;DiffuseTint_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;326;-2412.096,584.4556;Inherit;False;327;D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;297;-6372.997,-667.9545;Inherit;False;Global;HairTintDiffuseLightColor_G;Hair Tint Diffuse Light Color_G;10;0;Create;True;0;0;0;True;0;False;1,1,1,1;0.7215686,0.6941177,0.7647059,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;309;-5452.5,-411.7125;Inherit;False;13;LightTint_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;327;-2445.816,494.8136;Inherit;False;D;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
WireConnection;45;0;47;0
WireConnection;45;1;48;0
WireConnection;45;2;54;0
WireConnection;47;0;55;0
WireConnection;47;1;40;0
WireConnection;70;0;75;0
WireConnection;70;1;278;0
WireConnection;70;2;69;0
WireConnection;74;0;85;0
WireConnection;74;1;317;0
WireConnection;85;0;84;0
WireConnection;55;0;49;0
WireConnection;54;0;53;0
WireConnection;48;0;42;0
WireConnection;40;0;51;0
WireConnection;40;1;44;0
WireConnection;73;0;270;0
WireConnection;73;1;77;0
WireConnection;72;0;114;0
WireConnection;72;1;80;0
WireConnection;72;2;80;0
WireConnection;152;0;138;0
WireConnection;152;1;149;0
WireConnection;132;0;131;0
WireConnection;128;0;133;0
WireConnection;134;0;128;0
WireConnection;147;0;132;0
WireConnection;133;0;147;0
WireConnection;133;1;180;0
WireConnection;135;0;134;0
WireConnection;135;1;136;0
WireConnection;180;0;181;0
WireConnection;171;0;169;0
WireConnection;171;1;172;0
WireConnection;170;0;171;0
WireConnection;173;0;170;0
WireConnection;174;0;173;0
WireConnection;104;0;102;0
WireConnection;104;1;105;0
WireConnection;104;2;106;0
WireConnection;104;3;112;0
WireConnection;112;0;111;0
WireConnection;112;1;110;0
WireConnection;112;2;113;0
WireConnection;111;0;110;0
WireConnection;196;0;58;0
WireConnection;93;0;4;1
WireConnection;225;0;224;0
WireConnection;226;0;225;0
WireConnection;226;1;225;1
WireConnection;227;0;226;0
WireConnection;227;1;225;2
WireConnection;228;0;227;0
WireConnection;229;0;228;0
WireConnection;229;1;230;0
WireConnection;231;0;229;0
WireConnection;231;1;230;0
WireConnection;232;0;233;0
WireConnection;232;1;231;0
WireConnection;232;2;234;0
WireConnection;239;0;232;0
WireConnection;239;1;240;0
WireConnection;242;0;239;0
WireConnection;242;1;241;0
WireConnection;235;0;243;0
WireConnection;243;0;242;0
WireConnection;243;1;237;0
WireConnection;179;0;135;0
WireConnection;177;0;174;0
WireConnection;162;0;163;0
WireConnection;162;1;164;0
WireConnection;164;0;161;0
WireConnection;168;0;154;0
WireConnection;154;0;153;0
WireConnection;154;1;150;0
WireConnection;153;0;166;0
WireConnection;153;1;166;0
WireConnection;166;0;152;0
WireConnection;166;1;167;0
WireConnection;150;0;148;0
WireConnection;150;1;148;0
WireConnection;148;0;149;0
WireConnection;148;1;151;0
WireConnection;151;0;141;0
WireConnection;160;0;162;0
WireConnection;160;1;159;0
WireConnection;158;0;168;0
WireConnection;158;1;160;0
WireConnection;107;0;183;0
WireConnection;165;0;158;0
WireConnection;138;0;121;0
WireConnection;131;0;269;0
WireConnection;131;1;130;0
WireConnection;178;0;165;0
WireConnection;208;0;207;0
WireConnection;208;1;210;0
WireConnection;208;2;210;4
WireConnection;209;0;208;0
WireConnection;206;0;281;0
WireConnection;51;0;52;0
WireConnection;51;1;52;4
WireConnection;51;2;277;0
WireConnection;12;0;11;0
WireConnection;12;1;26;0
WireConnection;12;2;25;0
WireConnection;12;3;286;1
WireConnection;13;0;12;0
WireConnection;296;0;295;0
WireConnection;296;1;297;0
WireConnection;296;2;297;4
WireConnection;298;0;296;0
WireConnection;68;0;196;0
WireConnection;114;0;73;0
WireConnection;69;0;71;0
WireConnection;69;1;79;0
WireConnection;75;0;74;0
WireConnection;84;0;81;0
WireConnection;84;1;87;0
WireConnection;302;0;308;0
WireConnection;302;1;309;0
WireConnection;302;2;313;0
WireConnection;303;0;301;0
WireConnection;303;1;302;0
WireConnection;315;0;2;0
WireConnection;315;1;316;0
WireConnection;97;0;315;0
WireConnection;316;0;2;0
WireConnection;316;1;211;0
WireConnection;304;0;301;0
WireConnection;304;1;303;0
WireConnection;304;2;307;0
WireConnection;46;0;45;0
WireConnection;278;0;71;0
WireConnection;278;1;79;0
WireConnection;87;0;88;0
WireConnection;79;0;78;0
WireConnection;317;0;83;0
WireConnection;41;0;38;0
WireConnection;41;1;39;0
WireConnection;41;2;39;0
WireConnection;98;0;41;0
WireConnection;98;1;99;0
WireConnection;44;0;98;0
WireConnection;38;0;56;0
WireConnection;38;1;37;0
WireConnection;306;0;318;0
WireConnection;318;0;304;0
WireConnection;318;1;319;0
WireConnection;183;0;104;0
WireConnection;183;1;184;0
WireConnection;219;0;223;0
WireConnection;219;1;221;0
WireConnection;219;2;248;0
WireConnection;221;0;220;0
WireConnection;248;0;1;4
WireConnection;217;0;236;0
WireConnection;217;1;219;0
WireConnection;81;0;72;0
WireConnection;81;1;101;0
WireConnection;92;0;4;2
WireConnection;203;0;202;2
WireConnection;203;1;205;0
WireConnection;205;0;204;1
WireConnection;205;1;204;3
WireConnection;281;0;203;0
WireConnection;216;0;198;0
WireConnection;89;0;70;0
WireConnection;282;0;70;0
WireConnection;299;0;282;0
ASEEND*/
//CHKSM=6265D95A37A222D61792962DA4418117D6BAD3C7