// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Study/MingChao/Char_Top"
{
	Properties
	{
		_Clothes_Albedo_T("Clothes_Albedo_T", 2D) = "white" {}
		_Clothes_Normal_T("Clothes_Normal_T", 2D) = "bump" {}
		[NoScaleOffset]_Clothes_Decal_T("Clothes_Decal_T", 2D) = "white" {}
		[Header(Tint SSS)]_TintSSSColor_G("Tint SSS Color_G", Color) = (1,1,1,1)
		_TintSSSInt("Tint SSS Int", Float) = 1
		[Header(Metalic Speculat Light)]_MetalicSmoothness("Metalic Smoothness", Range( 0 , 1)) = 0.5
		_MetalicLightInt("Metalic Light Int", Float) = 2
		_MetalicLightColor("Metalic Light Color", Color) = (1,1,1,0)
		[Header(Out Line )]_OutLineInt("Out Line Int", Float) = 1
		_OutLineColor("Out Line Color", Color) = (1,1,1,1)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
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
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_NORMAL


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float3 ase_normal : NORMAL;
				float4 ase_lmap : TEXCOORD5;
				float4 ase_sh : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			//This is a late directive
			
			uniform sampler2D _Clothes_Albedo_T;
			uniform sampler2D _Clothes_Normal_T;
			uniform float _MetalicSmoothness;
			uniform sampler2D _Clothes_Decal_T;
			uniform float _MetalicLightInt;
			uniform float4 _MetalicLightColor;
			uniform float SoftEdge_G;
			uniform float LightSpecness_G;
			uniform float LightThreshold_G;
			uniform float4 LightColor_G;
			uniform float LightInt_G;
			uniform float4 TintDiffuseLightColor_G;
			uniform float LightLerp_G;
			uniform float4 _TintSSSColor_G;
			uniform float _TintSSSInt;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord4.xyz = ase_worldBitangent;
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
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				o.ase_sh.w = 0;
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
				float2 texCoord4 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 SampleBaseColor200 = tex2D( _Clothes_Albedo_T, texCoord4 );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 Sample_Normal6 = UnpackNormal( tex2D( _Clothes_Normal_T, texCoord4 ) );
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal34 = Sample_Normal6;
				float3 worldNormal34 = float3(dot(tanToWorld0,tanNormal34), dot(tanToWorld1,tanNormal34), dot(tanToWorld2,tanNormal34));
				float3 appendResult308 = (float3(i.ase_normal.x , -i.ase_normal.y , -i.ase_normal.z));
				float3 break310 = appendResult308;
				float3 appendResult320 = (float3(break310.x , break310.z , break310.y));
				float3 lerpResult304 = lerp( -worldNormal34 , appendResult320 , 0.3764706);
				float3 WS_Normal206 = lerpResult304;
				float3 tanNormal204 = WS_Normal206;
				float4 tex2DNode138 = tex2D( _Clothes_Decal_T, texCoord4 );
				float SampleMetalic_Mask139 = tex2DNode138.b;
				UnityGIInput data;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data );
				data.worldPos = WorldPosition;
				data.worldViewDir = ase_worldViewDir;
				data.probeHDR[0] = unity_SpecCube0_HDR;
				data.probeHDR[1] = unity_SpecCube1_HDR;
				#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION //specdataif0
				data.boxMin[0] = unity_SpecCube0_BoxMin;
				#endif //specdataif0
				#if UNITY_SPECCUBE_BOX_PROJECTION //specdataif1
				data.boxMax[0] = unity_SpecCube0_BoxMax;
				data.probePosition[0] = unity_SpecCube0_ProbePosition;
				data.boxMax[1] = unity_SpecCube1_BoxMax;
				data.boxMin[1] = unity_SpecCube1_BoxMin;
				data.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif //specdataif1
				Unity_GlossyEnvironmentData g204 = UnityGlossyEnvironmentSetup( ( _MetalicSmoothness * SampleMetalic_Mask139 ), ase_worldViewDir, float3(dot(tanToWorld0,tanNormal204), dot(tanToWorld1,tanNormal204), dot(tanToWorld2,tanNormal204)), float3(0,0,0));
				float3 indirectSpecular204 = UnityGI_IndirectSpecular( data, _MetalicLightInt, float3(dot(tanToWorld0,tanNormal204), dot(tanToWorld1,tanNormal204), dot(tanToWorld2,tanNormal204)), g204 );
				float4 C_Metalic_Color218 = ( float4( indirectSpecular204 , 0.0 ) * SampleMetalic_Mask139 * _MetalicLightColor );
				float temp_output_116_0 = ( SoftEdge_G * 0.01 );
				float dotResult96 = dot( ase_worldViewDir , WS_Normal206 );
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(WorldPosition);
				float dotResult5_g8 = dot( WS_Normal206 , worldSpaceLightDir );
				float lerpResult104 = lerp( (dotResult96*0.5 + 0.5) , (dotResult5_g8*0.5 + 0.5) , 0.9);
				float smoothstepResult111 = smoothstep( ( 0.5 - temp_output_116_0 ) , ( 0.5 + temp_output_116_0 ) , saturate( ( saturate( pow( lerpResult104 , ( LightSpecness_G * 0.1 ) ) ) - ( LightThreshold_G * 1.03 ) ) ));
				float LightTint_Mask118 = smoothstepResult111;
				#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
				float4 ase_lightColor = 0;
				#else //aselc
				float4 ase_lightColor = _LightColor0;
				#endif //aselc
				float4 LightTint_Color155 = ( LightTint_Mask118 * LightColor_G * LightInt_G * float4( ase_lightColor.rgb , 0.0 ) );
				float DiffuseTint_Mask361 = ( 1.0 - smoothstepResult111 );
				float4 DiffuseTint_Color366 = ( DiffuseTint_Mask361 * TintDiffuseLightColor_G * TintDiffuseLightColor_G.a );
				float4 temp_output_412_0 = ( LightTint_Color155 + DiffuseTint_Color366 );
				float4 lerpResult383 = lerp( SampleBaseColor200 , ( SampleBaseColor200 * ( C_Metalic_Color218 + temp_output_412_0 ) ) , LightLerp_G);
				float3 tanNormal396 = Sample_Normal6;
				UnityGIInput data396;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data396 );
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON) //dylm396
				data396.lightmapUV = i.ase_lmap;
				#endif //dylm396
				#if UNITY_SHOULD_SAMPLE_SH //fsh396
				data396.ambient = i.ase_sh;
				#endif //fsh396
				UnityGI gi396 = UnityGI_Base(data396, 1, float3(dot(tanToWorld0,tanNormal396), dot(tanToWorld1,tanNormal396), dot(tanToWorld2,tanNormal396)));
				float dotResult389 = dot( WS_Normal206 , worldSpaceLightDir );
				float temp_output_391_0 = (dotResult389*0.5 + 0.5);
				float4 SSS_Light407 = ( ( float4( gi396.indirect.diffuse , 0.0 ) + ( ( _TintSSSColor_G * _TintSSSColor_G.a * ase_lightColor ) * max( temp_output_391_0 , 0.0 ) ) ) * ( 1.0 - LightTint_Mask118 ) * max( _TintSSSInt , 0.0 ) );
				float4 CustomLight66 = ( lerpResult383 + SSS_Light407 );
				
				
				finalColor = CustomLight66;
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
			Offset 0 , 0
			
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _OutLineInt;
			uniform sampler2D _Clothes_Albedo_T;
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
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( normalizedWorldNormal * ( _OutLineInt * 0.001 ) * v.color.b );
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
				float2 texCoord4 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 SampleBaseColor200 = tex2D( _Clothes_Albedo_T, texCoord4 );
				float4 break332 = SampleBaseColor200;
				float4 temp_cast_0 = (( max( max( break332.r , break332.g ) , break332.b ) - 0.004 )).xxxx;
				float4 lerpResult339 = lerp( SampleBaseColor200 , ( step( temp_cast_0 , SampleBaseColor200 ) * SampleBaseColor200 ) , 0.6);
				float4 OutLine_Color347 = ( ( ( lerpResult339 * 0.8 ) * SampleBaseColor200 ) * _OutLineColor );
				
				
				finalColor = OutLine_Color347;
				return finalColor;
			}
			ENDCG
		}

		

	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;367;-1168.844,-1052.843;Inherit;False;760.292;360.0281;Comment;4;363;364;362;366;Duffuse Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;324;-487.3042,494.7982;Inherit;False;1318.265;487.2473;Comment;12;86;34;318;302;308;310;319;322;320;305;304;206;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;220;-521.4903,1298.854;Inherit;False;1343.923;509.5015;Comment;9;211;209;212;204;215;210;214;219;218;Indirect  Specular Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;217;-2381.725,120.0731;Inherit;False;1781.29;1700.843;Comment;26;244;245;243;242;241;198;5;193;199;197;196;203;195;191;190;192;201;187;194;188;246;248;250;249;251;253;Base Color;0.9834596,0.990566,0.7989943,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;158;-360.7143,-1023.135;Inherit;False;774.0535;618.4277;Comment;6;152;154;359;155;153;149;Light Tint;0.9433962,0.9355134,0.7075472,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;133;-1223.647,-1751.655;Inherit;False;2555.084;653.8349;Comment;23;118;326;327;176;325;105;100;104;99;116;113;208;108;106;96;98;114;111;112;361;385;386;411;Specular Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;72;-2428.393,-1713.512;Inherit;False;1160.974;1706.556;Comment;16;137;138;139;6;7;9;2;4;3;93;92;91;90;89;1;200;Sample;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;451.4688,-1062.766;Inherit;False;1684.491;717.0733;Comment;12;368;156;66;382;379;383;384;233;409;410;74;412;Light Calculation;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;3;-2217.069,-734.5132;Inherit;True;Property;_Clothes_SkinMask_T;Clothes_SkinMask_T;3;0;Create;True;0;0;0;False;0;False;-1;a09578bcf1006b14c9a2ba8be801430f;a09578bcf1006b14c9a2ba8be801430f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2401.793,-1424.683;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;89;-2373.873,-319.3885;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;149;-296.7143,-975.1348;Inherit;False;118;LightTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-8.714397,-975.1348;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;167.2856,-959.1348;Inherit;False;LightTint_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-1813.682,-1442.437;Inherit;True;Sample_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-2181.374,-102.0312;Inherit;False;VertexColorA_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-2181.374,-171.0314;Inherit;False;VertexColorB_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-1840.896,-1129.622;Inherit;True;SampleMetalic_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-1861.458,-1654.985;Inherit;False;SampleBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;-163.4903,1367.286;Inherit;False;206;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-190.0901,1466.355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;436.4281,1354.059;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-458.09,1576.355;Inherit;True;139;SampleMetalic_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;138;-2172.478,-1042.179;Inherit;True;Property;_Clothes_Decal_T;Clothes_Decal_T;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;6f59d052d0b1d9b40a544a2cbde55b99;64bc4c5ad0086494b9b1fb8e9d166bb8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;242;-2078.219,1380.895;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-1898.218,1386.895;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-1750.622,1355.68;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-2304.323,1377.598;Inherit;False;137;SampleDecal_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;246;-1951.945,1300.413;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;244;-2166.219,1460.895;Inherit;False;Property;_CDecalLightColor;C Decal Light Color;11;1;[Header];Create;True;1;Decal Color;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-1846.417,-925.2949;Inherit;True;SampleDecal_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-2172.374,-250.0314;Inherit;False;VertexColorG_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-2180.374,-326.0313;Inherit;False;SSSma_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-439.3042,542.7982;Inherit;False;6;Sample_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;34;-263.304,542.7982;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;318;8.695939,558.7982;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;302;-439.3042,670.7982;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;308;-87.30409,686.7981;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;310;40.69598,686.7981;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NegateNode;319;-231.3041,798.7981;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;322;-231.3041,718.7982;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;320;184.6961,670.7982;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;206;584.696,574.7982;Inherit;False;WS_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-2141.979,-1659.069;Inherit;True;Property;_Clothes_Albedo_T;Clothes_Albedo_T;0;0;Create;True;0;0;0;False;0;False;-1;6eb9816a894a70543a7de9f87b0a3d6a;6eb9816a894a70543a7de9f87b0a3d6a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-2139.442,-1446.081;Inherit;True;Property;_Clothes_Normal_T;Clothes_Normal_T;1;0;Create;True;0;0;0;False;0;False;-1;64bc4c5ad0086494b9b1fb8e9d166bb8;64bc4c5ad0086494b9b1fb8e9d166bb8;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-1829.623,-652.5297;Inherit;True;SampleSkin_Mask_H;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;331;-464,-144;Inherit;False;2481.966;466.5473;Comment;18;349;348;347;346;345;344;343;342;341;340;339;338;337;336;335;334;333;332;Out Line Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;332;-192,-80;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMaxOpNode;333;0,-64;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;334;160,-32;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;335;336,-32;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.004;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;336;560,0;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;337;-416,-80;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;338;752,32;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;339;928,-16;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;340;304,80;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;341;656,-80;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;342;736,144;Inherit;False;Constant;_Float4;Float 4;19;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;343;1168,-16;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;344;912,144;Inherit;False;Constant;_Float5;Float 5;19;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;345;1136,128;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;346;1344,-16;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;347;1776,-32;Inherit;False;OutLine_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;348;1584,0;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;349;1344,112;Inherit;False;Property;_OutLineColor;Out Line Color;14;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;359;-216.7143,-591.1346;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;364;-826.8435,-967.8152;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;362;-1107.908,-1002.843;Inherit;False;361;DiffuseTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;366;-641.5515,-975.8978;Inherit;False;DiffuseTint_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-2266.687,196.0731;Inherit;True;7;SampleSkin_Mask_H;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;-2244.047,392.3648;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;198;-2240.878,460.584;Inherit;False;Property;_SkinTintColor;Skin Tint Color;4;1;[Header];Create;True;1;Base Color;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;383;1333.497,-863.7621;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;245;-2219.219,1670.895;Inherit;False;Property;_CDecalLightInt;C Decal Light Int;12;0;Create;True;0;0;0;False;0;False;1;0;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;152;-312.7143,-879.1344;Inherit;False;Global;LightColor_G;Light Color_G;8;0;Create;True;0;0;0;True;0;False;1,1,1,1;0.9622642,0.8392183,0.8306337,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;363;-1135.844,-896.8152;Inherit;False;Global;TintDiffuseLightColor_G;Tint Diffuse Light Color_G;19;0;Create;True;0;0;0;True;0;False;1,1,1,1;0.7230598,0.6956658,0.764151,0.8941177;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;-1824.753,324.251;Inherit;False;C_SkinArea_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-1960.42,334.2219;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-1779.615,890.7723;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;-2306.926,863.0342;Inherit;True;7;SampleSkin_Mask_H;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;191;-2061.552,849.7712;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;-2086.54,778.3682;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;199;-2092.282,1064.658;Inherit;False;Property;_ClothesTintColor;Clothes Tint Color;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectSpecularLight;204;65.53643,1348.854;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;582.0002,1352.423;Inherit;False;C_Metalic_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-231.8603,1630.822;Inherit;False;Property;_MetalicLightInt;Metalic Light Int;9;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;219;75.97059,1557.979;Inherit;False;Property;_MetalicLightColor;Metalic Light Color;10;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;210;-471.4904,1501.286;Inherit;False;Property;_MetalicSmoothness;Metalic Smoothness;8;1;[Header];Create;True;1;Metalic Speculat Light;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;350;1968,1184;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;351;1968,1088;Inherit;False;347;OutLine_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;329;2240,976;Float;False;True;-1;2;ASEMaterialInspector;100;12;Study/MingChao/Char_Top;cb0a069cd65065f4691e7feda7c4b316;True;Unlit;0;0;Unlit;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;False;False;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;1;False;;True;0;False;;True;True;0;False;;0;False;;False;True;2;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;2;True;True;False;;False;0
Node;AmplifyShaderEditor.VertexColorNode;356;1632,1360;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;355;1824,1456;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;352;1600,1248;Inherit;False;Property;_OutLineInt;Out Line Int;13;1;[Header];Create;True;1;Out Line ;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;353;1776,1248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;354;1696,1104;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;330;2256,1168;Float;False;False;-1;2;ASEMaterialInspector;100;12;New Amplify Shader;cb0a069cd65065f4691e7feda7c4b316;True;SecondUnlit;0;1;SecondUnlit;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;False;False;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;1;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;2;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.CommentaryNode;387;-2459.135,-2954.458;Inherit;False;1706.543;999.4827;Comment;20;407;401;394;395;408;406;405;403;402;400;399;398;397;396;393;392;391;390;389;388;SSS Light;0.5772662,0.5311054,0.7264151,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;388;-2363.135,-2330.458;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;389;-2107.135,-2394.458;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;390;-1659.135,-2698.458;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;391;-1979.135,-2410.458;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;392;-1131.136,-2698.458;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;393;-1323.136,-2714.458;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;396;-1680.135,-2824.458;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;397;-2253.135,-2639.458;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;398;-2045.135,-2729.458;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;399;-1774.135,-2244.458;Inherit;False;HalfLambert;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;400;-1791.268,-2520.479;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;402;-1307.136,-2602.458;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;403;-1291.661,-2502.657;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;405;-1563.661,-2454.657;Inherit;False;Property;_TintSSSInt;Tint SSS Int;7;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;406;-2187.135,-2154.458;Float;False;Constant;_RemapValue;Remap Value;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;408;-2300.135,-2815.458;Inherit;False;Property;_TintSSSColor_G;Tint SSS Color_G;6;1;[Header];Create;True;1;Tint SSS;0;0;False;0;False;1,1,1,1;0.8679245,0.6086169,0.5526876,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;395;-1888.135,-2824.458;Inherit;False;6;Sample_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;394;-2347.135,-2426.458;Inherit;False;206;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;401;-1578.135,-2570.458;Inherit;False;118;LightTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;407;-970.1355,-2698.458;Inherit;False;SSS_Light;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;1728.172,-880.5438;Inherit;False;CustomLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;409;1546.385,-864.1136;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;98;-587.674,-1560.366;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;96;-790.071,-1561.493;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;208;-1004.572,-1411.104;Inherit;False;206;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-740.853,-1461.844;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;385;492.5837,-1516.952;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;255.9066,-1438.151;Inherit;False;Constant;_Float2;Float 2;12;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-9.379343,-1328.835;Inherit;False;Global;SoftEdge_G;Soft Edge_G;7;1;[Header];Create;True;0;0;0;True;0;False;0.001;0.05;0;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;326;-563.5537,-1308.903;Inherit;False;Global;LightSpecness_G;Light Specness_G;8;0;Create;True;0;0;0;True;0;False;1;0.193;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;327.2474,-1343.659;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;112;509.2427,-1356.041;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;108;322.964,-1581.768;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;325;-149.7581,-1565.827;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;176;11.20212,-1563.585;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;111;660.5383,-1570.983;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;360;823.98,-1403.662;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;361;979.9798,-1404.662;Inherit;False;DiffuseTint_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;980.8435,-1571.233;Inherit;False;LightTint_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;1967,960;Inherit;False;74;D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;411;-994.9344,-1566.388;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;100;-626.0637,-1388.823;Inherit;False;Half Lambert Term;-1;;8;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;104;-355.4694,-1545.89;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;327;-294.2847,-1320.123;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-140.8412,-1452.488;Inherit;False;Global;LightThreshold_G;Light Threshold_G;6;0;Create;True;1;Tint Light 1;0;0;True;0;False;0;0.479;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;386;115.9709,-1461.68;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;106;175.1794,-1569.502;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-1828.462,-437.595;Inherit;True;SampleSkin_Mask_L_FlorLine;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;379;521.5941,-869.0419;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-344.7143,-699.1335;Inherit;False;Global;LightInt_G;Light Int_G;6;1;[Header];Create;True;1;Tint Light;0;0;True;0;False;0.2;1.3;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;368;510.4412,-496.0555;Inherit;False;366;DiffuseTint_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;156;516.9742,-579.248;Inherit;False;155;LightTint_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;384;1071.356,-680.6282;Inherit;False;Global;LightLerp_G;Light Lerp_G;7;0;Create;True;0;0;0;True;0;False;0.34;0.683;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;939.4601,-577.7374;Inherit;False;D;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;233;506.7174,-760.5038;Inherit;False;218;C_Metalic_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;413;894.6498,-713.863;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;412;723.6498,-568.863;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;382;1016.998,-775.8624;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;410;1357.385,-740.1136;Inherit;False;407;SSS_Light;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;304;410.696,584.7982;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;305;65.69598,826.798;Inherit;False;Constant;_Normal;Normal;18;0;Create;True;0;0;0;False;0;False;0.3764706;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;-1099.779,345.2695;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-872.7668,320.9496;Inherit;True;C_Base_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;-1542.418,429.3158;Inherit;False;195;C_ClothesArea_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;250;-1536.106,530.6559;Inherit;False;137;SampleDecal_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;249;-1301.975,433.4329;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;253;-1325.384,577.5939;Inherit;False;251;C_Decal_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-1343.085,316.1176;Inherit;False;194;C_SkinArea_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;195;-1643.54,887.8934;Inherit;False;C_ClothesArea_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;251;-1592.926,1352.12;Inherit;False;C_Decal_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;1957,848;Inherit;False;66;CustomLight;1;0;OBJECT;;False;1;COLOR;0
WireConnection;3;1;4;0
WireConnection;153;0;149;0
WireConnection;153;1;152;0
WireConnection;153;2;154;0
WireConnection;153;3;359;1
WireConnection;155;0;153;0
WireConnection;6;0;2;0
WireConnection;93;0;89;4
WireConnection;92;0;89;3
WireConnection;139;0;138;3
WireConnection;200;0;1;0
WireConnection;212;0;210;0
WireConnection;212;1;211;0
WireConnection;214;0;204;0
WireConnection;214;1;211;0
WireConnection;214;2;219;0
WireConnection;138;1;4;0
WireConnection;242;0;241;0
WireConnection;243;0;242;0
WireConnection;243;1;244;0
WireConnection;243;2;245;0
WireConnection;248;0;246;0
WireConnection;248;1;243;0
WireConnection;137;0;138;4
WireConnection;91;0;89;2
WireConnection;90;0;89;1
WireConnection;34;0;86;0
WireConnection;318;0;34;0
WireConnection;308;0;302;1
WireConnection;308;1;322;0
WireConnection;308;2;319;0
WireConnection;310;0;308;0
WireConnection;319;0;302;3
WireConnection;322;0;302;2
WireConnection;320;0;310;0
WireConnection;320;1;310;2
WireConnection;320;2;310;1
WireConnection;206;0;304;0
WireConnection;1;1;4;0
WireConnection;2;1;4;0
WireConnection;7;0;3;1
WireConnection;332;0;337;0
WireConnection;333;0;332;0
WireConnection;333;1;332;1
WireConnection;334;0;333;0
WireConnection;334;1;332;2
WireConnection;335;0;334;0
WireConnection;336;0;335;0
WireConnection;336;1;340;0
WireConnection;338;0;336;0
WireConnection;338;1;340;0
WireConnection;339;0;341;0
WireConnection;339;1;338;0
WireConnection;339;2;342;0
WireConnection;343;0;339;0
WireConnection;343;1;344;0
WireConnection;346;0;343;0
WireConnection;346;1;345;0
WireConnection;347;0;348;0
WireConnection;348;0;346;0
WireConnection;348;1;349;0
WireConnection;364;0;362;0
WireConnection;364;1;363;0
WireConnection;364;2;363;4
WireConnection;366;0;364;0
WireConnection;383;0;379;0
WireConnection;383;1;382;0
WireConnection;383;2;384;0
WireConnection;194;0;188;0
WireConnection;188;0;187;0
WireConnection;188;1;201;0
WireConnection;188;2;198;0
WireConnection;188;3;198;4
WireConnection;192;0;203;0
WireConnection;192;1;191;0
WireConnection;192;2;199;0
WireConnection;192;3;199;4
WireConnection;191;0;190;0
WireConnection;204;0;209;0
WireConnection;204;1;212;0
WireConnection;204;2;215;0
WireConnection;218;0;214;0
WireConnection;350;0;354;0
WireConnection;350;1;353;0
WireConnection;350;2;356;3
WireConnection;329;0;289;0
WireConnection;355;0;356;4
WireConnection;353;0;352;0
WireConnection;330;0;351;0
WireConnection;330;1;350;0
WireConnection;389;0;394;0
WireConnection;389;1;388;0
WireConnection;390;0;398;0
WireConnection;390;1;400;0
WireConnection;391;0;389;0
WireConnection;391;1;406;0
WireConnection;391;2;406;0
WireConnection;392;0;393;0
WireConnection;392;1;402;0
WireConnection;392;2;403;0
WireConnection;393;0;396;0
WireConnection;393;1;390;0
WireConnection;396;0;395;0
WireConnection;398;0;408;0
WireConnection;398;1;408;4
WireConnection;398;2;397;0
WireConnection;399;0;391;0
WireConnection;400;0;391;0
WireConnection;402;0;401;0
WireConnection;403;0;405;0
WireConnection;407;0;392;0
WireConnection;66;0;409;0
WireConnection;409;0;383;0
WireConnection;409;1;410;0
WireConnection;98;0;96;0
WireConnection;98;1;99;0
WireConnection;98;2;99;0
WireConnection;96;0;411;0
WireConnection;96;1;208;0
WireConnection;385;0;114;0
WireConnection;385;1;116;0
WireConnection;116;0;113;0
WireConnection;112;0;114;0
WireConnection;112;1;116;0
WireConnection;108;0;106;0
WireConnection;325;0;104;0
WireConnection;325;1;327;0
WireConnection;176;0;325;0
WireConnection;111;0;108;0
WireConnection;111;1;385;0
WireConnection;111;2;112;0
WireConnection;360;0;111;0
WireConnection;361;0;360;0
WireConnection;118;0;111;0
WireConnection;100;3;208;0
WireConnection;104;0;98;0
WireConnection;104;1;100;0
WireConnection;327;0;326;0
WireConnection;386;0;105;0
WireConnection;106;0;176;0
WireConnection;106;1;386;0
WireConnection;9;0;3;2
WireConnection;74;0;412;0
WireConnection;413;0;233;0
WireConnection;413;1;412;0
WireConnection;412;0;156;0
WireConnection;412;1;368;0
WireConnection;382;0;379;0
WireConnection;382;1;413;0
WireConnection;304;0;318;0
WireConnection;304;1;320;0
WireConnection;304;2;305;0
WireConnection;193;0;196;0
WireConnection;193;1;249;0
WireConnection;193;2;253;0
WireConnection;5;0;193;0
WireConnection;249;0;197;0
WireConnection;249;1;250;0
WireConnection;195;0;192;0
WireConnection;251;0;248;0
ASEEND*/
//CHKSM=BE077C1062F397853E0102EDFE7113BAE3F08895