// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Study/MingChao/Char_Bottom"
{
	Properties
	{
		_Clothes_Albedo_B("Clothes_Albedo_B", 2D) = "white" {}
		_Clothes_Normal_B("Clothes_Normal_B", 2D) = "bump" {}
		[Header(Tint SSS)]_TintSSSColor_G("Tint SSS Color_G", Color) = (1,1,1,1)
		_TintSSSInt("Tint SSS Int", Float) = 1
		[Header(Out Line )]_OutLineInt("Out Line Int", Float) = 1
		_OutLineColor("Out Line Color", Color) = (1,1,1,1)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "Queue"="Geometry" }
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
				float4 ase_lmap : TEXCOORD5;
				float4 ase_sh : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			//This is a late directive
			
			uniform sampler2D _Clothes_Albedo_B;
			uniform float SoftEdge_G;
			uniform sampler2D _Clothes_Normal_B;
			uniform float LightSpecness_G;
			uniform float LightThreshold_G;
			uniform float4 TintDiffuseLightColor_G;
			uniform float4 LightColor_G;
			uniform float LightInt_G;
			uniform float4 _TintSSSColor_G;
			uniform float _TintSSSInt;
			uniform float LightLerp_G;

			
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
				float4 SampleBaseColor200 = tex2D( _Clothes_Albedo_B, texCoord4 );
				float temp_output_334_0 = ( SoftEdge_G * 0.01 );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 Sample_Normal6 = UnpackNormal( tex2D( _Clothes_Normal_B, texCoord4 ) );
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal34 = Sample_Normal6;
				float3 worldNormal34 = float3(dot(tanToWorld0,tanNormal34), dot(tanToWorld1,tanNormal34), dot(tanToWorld2,tanNormal34));
				float3 WS_Normal206 = -worldNormal34;
				float dotResult327 = dot( ase_worldViewDir , WS_Normal206 );
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(WorldPosition);
				float dotResult5_g9 = dot( WS_Normal206 , worldSpaceLightDir );
				float lerpResult336 = lerp( (dotResult327*0.5 + 0.5) , (dotResult5_g9*0.5 + 0.5) , 0.9);
				float smoothstepResult324 = smoothstep( ( 0.5 - temp_output_334_0 ) , ( 0.5 + temp_output_334_0 ) , saturate( ( saturate( pow( lerpResult336 , ( LightSpecness_G * 0.1 ) ) ) - ( LightThreshold_G * 1.03 ) ) ));
				float DiffuseTint_Mask383 = ( 1.0 - smoothstepResult324 );
				float4 DiffuseTine_Color387 = ( DiffuseTint_Mask383 * TintDiffuseLightColor_G * TintDiffuseLightColor_G.a );
				float LightTint_Mask345 = smoothstepResult324;
				#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
				float4 ase_lightColor = 0;
				#else //aselc
				float4 ase_lightColor = _LightColor0;
				#endif //aselc
				float4 LightTint_Color155 = ( LightTint_Mask345 * LightColor_G * ase_lightColor * LightInt_G );
				float3 tanNormal45 = Sample_Normal6;
				UnityGIInput data45;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data45 );
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON) //dylm45
				data45.lightmapUV = i.ase_lmap;
				#endif //dylm45
				#if UNITY_SHOULD_SAMPLE_SH //fsh45
				data45.ambient = i.ase_sh;
				#endif //fsh45
				UnityGI gi45 = UnityGI_Base(data45, 1, float3(dot(tanToWorld0,tanNormal45), dot(tanToWorld1,tanNormal45), dot(tanToWorld2,tanNormal45)));
				float dotResult33 = dot( WS_Normal206 , worldSpaceLightDir );
				float temp_output_36_0 = (dotResult33*0.5 + 0.5);
				float4 SSS_Light69 = ( ( float4( gi45.indirect.diffuse , 0.0 ) + ( ( _TintSSSColor_G * _TintSSSColor_G.a * ase_lightColor ) * max( temp_output_36_0 , 0.0 ) ) ) * ( 1.0 - LightTint_Mask345 ) * max( _TintSSSInt , 0.0 ) );
				float4 lerpResult392 = lerp( SampleBaseColor200 , ( SampleBaseColor200 * ( DiffuseTine_Color387 + LightTint_Color155 + SSS_Light69 ) ) , LightLerp_G);
				float4 CustomLight66 = lerpResult392;
				
				
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
			uniform sampler2D _Clothes_Albedo_B;
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
				vertexValue = ( normalizedWorldNormal * ( _OutLineInt * 0.001 ) * v.color.g );
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
				float4 SampleBaseColor200 = tex2D( _Clothes_Albedo_B, texCoord4 );
				float4 break350 = SampleBaseColor200;
				float4 temp_cast_0 = (( max( max( break350.r , break350.g ) , break350.b ) - 0.004 )).xxxx;
				float4 lerpResult357 = lerp( SampleBaseColor200 , ( step( temp_cast_0 , SampleBaseColor200 ) * SampleBaseColor200 ) , 0.6);
				float4 OutLine_Color365 = ( ( ( lerpResult357 * 0.8 ) * SampleBaseColor200 ) * _OutLineColor );
				
				
				finalColor = OutLine_Color365;
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
Node;AmplifyShaderEditor.CommentaryNode;388;690.2574,-1079.372;Inherit;False;901.1921;362.6375;Comment;4;384;386;385;387;Diffuse Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;346;-2505.038,2559.282;Inherit;False;1318.265;487.2479;Comment;12;86;34;318;302;308;310;319;322;320;305;206;304;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;220;-2488.129,1897.207;Inherit;False;1343.923;509.5015;Comment;9;211;209;212;204;215;210;214;219;218;Indirect  Specular Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;217;-2447.905,29.36264;Inherit;False;1781.29;1700.843;Comment;26;244;245;243;242;241;198;5;193;199;197;196;203;195;191;190;192;201;187;194;188;246;248;250;249;251;253;Base Color;0.9834596,0.990566,0.7989943,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;158;-523,-1090;Inherit;False;1057.71;517.6267;Comment;6;381;380;152;149;155;153;Light Tint;0.9433962,0.9355134,0.7075472,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;133;-546.8038,-1715.665;Inherit;False;2498.885;534.6643;Comment;24;345;379;333;338;343;337;331;342;340;339;336;335;334;329;328;327;326;325;324;323;383;382;398;400;Light Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;72;-1825.048,-1719.848;Inherit;False;1160.974;1706.556;Comment;18;137;138;139;6;7;9;2;4;3;93;92;91;90;89;1;200;288;238;Sample;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;13;-512,544;Inherit;False;2389.923;1009.837;Comment;21;69;303;45;232;231;40;42;41;88;147;46;144;148;43;145;36;143;37;33;32;74;SSS Light;0.5772662,0.5311054,0.7264151,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;-497.5473,-436.1541;Inherit;False;1655.757;597.3461;Comment;8;66;395;397;396;392;391;390;389;Light Calculation;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1798.448,-1431.018;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;89;-1770.528,-325.7231;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-187,-1026;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;5,-1026;Inherit;False;LightTint_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-1210.336,-1448.772;Inherit;True;Sample_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-1578.028,-108.3659;Inherit;False;VertexColorA_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-1578.028,-177.366;Inherit;False;VertexColorB_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-1237.55,-1135.957;Inherit;True;SampleMetalic_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-1226.277,-658.8643;Inherit;True;SampleSkin_Mask_H;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-1258.112,-1661.321;Inherit;False;SampleBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-1818.621,110.1684;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;-1690.954,116.1974;Inherit;False;C_SkinArea_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-2390.867,79.36265;Inherit;True;7;SampleSkin_Mask_H;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;-2108.227,174.6543;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-1870.594,688.467;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;-2397.905,660.7291;Inherit;True;7;SampleSkin_Mask_H;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;191;-2152.531,647.4661;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;-2177.519,576.0632;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;199;-2183.261,862.3529;Inherit;False;Property;_ClothesTintColor;Clothes Tint Color;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;198;-2105.058,242.8736;Inherit;False;Property;_SkinTintColor;Skin Tint Color;4;1;[Header];Create;True;1;Base Color;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;242;-2144.399,1290.185;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-1964.398,1296.185;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-1816.802,1264.97;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;251;-1659.106,1261.41;Inherit;False;C_Decal_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;-2370.503,1286.888;Inherit;False;137;SampleDecal_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;246;-2018.125,1209.703;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;244;-2232.399,1370.185;Inherit;False;Property;_CDecalLightColor;C Decal Light Color;11;1;[Header];Create;True;1;Decal Color;0;0;False;0;False;1,1,1,0;1,0.9910136,0.7311321,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-1569.028,-256.366;Inherit;False;VertexColorG_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-1577.028,-332.3658;Inherit;False;SSSma_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;-960.9855,-620.0505;Inherit;True;9;SampleSkin_Mask_L_FlorLine;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;288;-821.8199,-791.5066;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-1199.285,-443.9297;Inherit;True;SampleSkin_Mask_L_FlorLine;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;195;-1734.519,685.5881;Inherit;False;C_ClothesArea_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;245;-2181.399,1571.185;Inherit;False;Property;_CDecalLightInt;C Decal Light Int;12;0;Create;True;0;0;0;False;0;False;1;1.5;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1538.633,-1665.404;Inherit;True;Property;_Clothes_Albedo_B;Clothes_Albedo_B;0;0;Create;True;0;0;0;False;0;False;-1;6eb9816a894a70543a7de9f87b0a3d6a;5bbfb06a4a13b80418bc4071d0b0ecba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1536.096,-1452.416;Inherit;True;Property;_Clothes_Normal_B;Clothes_Normal_B;1;0;Create;True;0;0;0;False;0;False;-1;64bc4c5ad0086494b9b1fb8e9d166bb8;e8b8f2ca04e5cf04d91820cf97ce45b7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1613.724,-740.8477;Inherit;True;Property;_Clothes_SkinMask_B;Clothes_SkinMask_B;3;0;Create;True;0;0;0;False;0;False;-1;a09578bcf1006b14c9a2ba8be801430f;46805cec821826e4ba4d5cc8b565be7d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;349;-512,1664;Inherit;False;2481.966;466.5473;Comment;18;367;366;365;364;363;362;361;360;359;358;357;356;355;354;353;352;351;350;Out Line Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;326;-27.72819,-1555.953;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;327;-230.1255,-1557.08;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;328;724.5543,-1616.748;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;335;-180.9074,-1457.431;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;336;198.9393,-1580.553;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;339;403.3918,-1600.49;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;340;564.3525,-1598.248;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;379;-439.7156,-1589.848;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;138;-1568.132,-1061.513;Inherit;True;Property;_Clothes_Decal_B;Clothes_Decal_B;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;6f59d052d0b1d9b40a544a2cbde55b99;fa057f6f68915b341bdf1b7e41c781fb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-1212.071,-939.6293;Inherit;True;SampleDecal_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-477,-1047;Inherit;False;345;LightTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;380;-426.2894,-820.9882;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;382;1462.966,-1470.563;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;383;1665.966,-1472.563;Inherit;False;DiffuseTint_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;-2130.129,1965.639;Inherit;False;206;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-2156.729,2064.708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectSpecularLight;204;-1901.102,1947.207;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-1530.211,1952.413;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-2424.729,2174.707;Inherit;True;139;SampleMetalic_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-2438.129,2099.638;Inherit;False;Property;_IndLightLigSmoothness;Ind Light Lig Smoothness;8;1;[Header];Create;True;1;Indirec Speculat Light;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;219;-1890.668,2156.332;Inherit;False;Property;_IndLightLigColor;Ind Light Lig Color;10;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.95283,0.635686,0.3640527,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;-1387.271,1950.776;Inherit;False;C_Metalic_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-2198.499,2229.174;Inherit;False;Property;_IndLightLigInt;Ind Light Lig Int;9;0;Create;True;0;0;0;False;0;False;2;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-2455.038,2618.25;Inherit;False;6;Sample_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;34;-2274.657,2609.282;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;318;-1997.38,2628.959;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;302;-2451.375,2736.844;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;308;-2105.031,2760.307;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;310;-1969.03,2761.307;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NegateNode;319;-2243.031,2859.307;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;322;-2244.031,2794.307;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;320;-1833.03,2744.307;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;305;-1952.765,2930.529;Inherit;False;Property;_Normal;Normal;13;0;Create;True;0;0;0;False;0;False;0.6091024;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;206;-1419.773,2647.056;Inherit;False;WS_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;384;771.4923,-1029.372;Inherit;False;383;DiffuseTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;386;1170.257,-1014.735;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;387;1358.449,-1016.434;Inherit;False;DiffuseTine_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;32;-416,1168;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;33;-160,1104;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;288,800;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;36;-32,1088;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;816,800;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;624,784;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;303;-400,1072;Inherit;False;206;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;350;-240,1728;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMaxOpNode;351;-48,1728;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;352;112,1760;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;353;288,1760;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.004;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;354;512,1792;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;355;-464,1712;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;356;688,1824;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;357;880,1792;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;358;256,1872;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;359;608,1728;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;361;1104,1792;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;362;864,1936;Inherit;False;Constant;_Float5;Float 5;19;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;363;1088,1920;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;364;1296,1792;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;365;1728,1760;Inherit;False;OutLine_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;366;1536,1792;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;367;1296,1920;Inherit;False;Property;_OutLineColor;Out Line Color;15;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.2264149,0.2264149,0.2264149,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;389;-401.5473,-308.1541;Inherit;False;200;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;390;-33.54728,-148.1541;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;391;142.4527,-164.1541;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;392;462.4528,-292.1541;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;396;-433.5473,-180.1541;Inherit;False;387;DiffuseTine_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;397;-433.5473,-84.15408;Inherit;False;155;LightTint_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;814.4529,-276.1541;Inherit;False;CustomLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;360;688,1936;Inherit;False;Constant;_Float4;Float 4;19;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;253;-1341.407,499.2278;Inherit;False;251;C_Decal_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;-1558.441,350.9498;Inherit;False;195;C_ClothesArea_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;249;-1317.998,355.0668;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;250;-1552.129,452.2899;Inherit;False;137;SampleDecal_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-1359.108,237.7514;Inherit;False;194;C_SkinArea_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;-1115.802,266.9034;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-888.7902,242.5835;Inherit;True;C_Base_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;2496,48;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;370;2464,-48;Inherit;False;365;OutLine_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;347;2736,-96;Float;False;True;-1;2;ASEMaterialInspector;100;13;Study/MingChao/Char_Bottom;cb0a069cd65065f4691e7feda7c4b316;True;Unlit;0;0;Unlit;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;False;False;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;2;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;2;True;True;False;;False;0
Node;AmplifyShaderEditor.ColorNode;152;-484,-980;Inherit;False;Global;LightColor_G;Light Color_G;10;0;Create;True;0;0;0;True;0;False;1,1,1,1;0.8867924,0.8330112,0.7822179,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;381;-492.2894,-702.9882;Inherit;False;Global;LightInt_G;Light Int_G;5;0;Create;True;0;0;0;True;0;False;0;1.58;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;385;740.2574,-928.7346;Inherit;False;Global;TintDiffuseLightColor_G;Tint Diffuse Light Color_G;22;0;Create;True;0;0;0;True;0;False;1,1,1,1;0.7830189,0.6685208,0.71661,0.5686275;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;395;30.4527,-21.15408;Inherit;False;Global;LightLerp_G;Light Lerp_G;8;0;Create;True;0;0;0;True;0;False;0.34;0.429;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;345;1438.934,-1572.267;Inherit;False;LightTint_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;324;1221.967,-1609.595;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;398;1044.679,-1533.99;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;323;1070.967,-1427.595;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;331;-440.6256,-1364.691;Inherit;False;206;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;337;-94.62645,-1373.186;Inherit;False;Half Lambert Term;-1;;9;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;329;881.1139,-1601.43;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;2471,-249;Inherit;False;66;CustomLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;334;873.1928,-1333.246;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;325;758.9681,-1434.595;Inherit;False;Constant;_Float2;Float 2;12;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;343;-2.607948,-1305.49;Inherit;False;Global;LightSpecness_G;Light Specness_G;14;0;Create;True;0;0;0;True;0;False;1;0.193;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;342;301.1289,-1297.735;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;333;549.5664,-1256.422;Inherit;False;Global;SoftEdge_G;Soft Edge_G;9;1;[Header];Create;True;0;0;0;True;0;False;0.4;0.045;0;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;261.5542,-1472.749;Inherit;False;Global;LightThreshold_G;Light Threshold_G;8;0;Create;True;1;Tint Light 1;0;0;True;0;False;0;0.479;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;400;553.092,-1490.751;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;372;2227,-66;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;377;2448,-160;Inherit;False;74;D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;59,674;Inherit;False;6;Sample_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;45;267,674;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;41;-306,859;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-98,769;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;148;173,1254;Inherit;False;HalfLambert;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;43;155.8672,977.9796;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;368,928;Inherit;False;345;LightTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;147;640,896;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;232;655.4745,995.8013;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;304;-1585.496,2701.247;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;1203.898,812.8357;Inherit;False;D;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;403;-406.6536,52.78683;Inherit;False;69;SSS_Light;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;231;383.474,1043.801;Inherit;False;Property;_TintSSSInt;Tint SSS Int;7;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-240,1344;Float;False;Constant;_RemapValue;Remap Value;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;976,800;Inherit;False;SSS_Light;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;40;-353,683;Inherit;False;Property;_TintSSSColor_G;Tint SSS Color_G;6;1;[Header];Create;True;1;Tint SSS;0;0;False;0;False;1,1,1,1;0.8679245,0.6086169,0.5526876,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;348;2721,32;Float;False;False;-1;2;ASEMaterialInspector;100;13;New Amplify Shader;cb0a069cd65065f4691e7feda7c4b316;True;SecondUnlit;0;1;SecondUnlit;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;False;False;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;1;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;2;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;371;2273,85;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;375;2111,85;Inherit;False;Property;_OutLineInt;Out Line Int;14;1;[Header];Create;True;1;Out Line ;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;373;2232,185;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;153;0;149;0
WireConnection;153;1;152;0
WireConnection;153;2;380;0
WireConnection;153;3;381;0
WireConnection;155;0;153;0
WireConnection;6;0;2;0
WireConnection;93;0;89;4
WireConnection;92;0;89;3
WireConnection;139;0;138;3
WireConnection;7;0;3;1
WireConnection;200;0;1;0
WireConnection;188;0;187;0
WireConnection;188;1;201;0
WireConnection;188;2;198;0
WireConnection;188;3;198;4
WireConnection;194;0;188;0
WireConnection;192;0;203;0
WireConnection;192;1;191;0
WireConnection;192;2;199;0
WireConnection;192;3;199;4
WireConnection;191;0;190;0
WireConnection;242;0;241;0
WireConnection;243;0;242;0
WireConnection;243;1;244;0
WireConnection;243;2;245;0
WireConnection;248;0;246;0
WireConnection;248;1;243;0
WireConnection;251;0;248;0
WireConnection;91;0;89;2
WireConnection;90;0;89;1
WireConnection;288;2;238;0
WireConnection;9;0;3;2
WireConnection;195;0;192;0
WireConnection;1;1;4;0
WireConnection;2;1;4;0
WireConnection;3;1;4;0
WireConnection;326;0;327;0
WireConnection;326;1;335;0
WireConnection;326;2;335;0
WireConnection;327;0;379;0
WireConnection;327;1;331;0
WireConnection;328;0;340;0
WireConnection;328;1;400;0
WireConnection;336;0;326;0
WireConnection;336;1;337;0
WireConnection;339;0;336;0
WireConnection;339;1;342;0
WireConnection;340;0;339;0
WireConnection;138;1;4;0
WireConnection;137;0;138;4
WireConnection;382;0;324;0
WireConnection;383;0;382;0
WireConnection;212;0;210;0
WireConnection;212;1;211;0
WireConnection;204;0;209;0
WireConnection;204;1;212;0
WireConnection;204;2;215;0
WireConnection;214;0;204;0
WireConnection;214;1;211;0
WireConnection;214;2;219;0
WireConnection;218;0;214;0
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
WireConnection;206;0;318;0
WireConnection;386;0;384;0
WireConnection;386;1;385;0
WireConnection;386;2;385;4
WireConnection;387;0;386;0
WireConnection;33;0;303;0
WireConnection;33;1;32;0
WireConnection;143;0;42;0
WireConnection;143;1;43;0
WireConnection;36;0;33;0
WireConnection;36;1;37;0
WireConnection;36;2;37;0
WireConnection;144;0;46;0
WireConnection;144;1;147;0
WireConnection;144;2;232;0
WireConnection;46;0;45;0
WireConnection;46;1;143;0
WireConnection;350;0;355;0
WireConnection;351;0;350;0
WireConnection;351;1;350;1
WireConnection;352;0;351;0
WireConnection;352;1;350;2
WireConnection;353;0;352;0
WireConnection;354;0;353;0
WireConnection;354;1;358;0
WireConnection;356;0;354;0
WireConnection;356;1;358;0
WireConnection;357;0;359;0
WireConnection;357;1;356;0
WireConnection;357;2;360;0
WireConnection;361;0;357;0
WireConnection;361;1;362;0
WireConnection;364;0;361;0
WireConnection;364;1;363;0
WireConnection;365;0;366;0
WireConnection;366;0;364;0
WireConnection;366;1;367;0
WireConnection;390;0;396;0
WireConnection;390;1;397;0
WireConnection;390;2;403;0
WireConnection;391;0;389;0
WireConnection;391;1;390;0
WireConnection;392;0;389;0
WireConnection;392;1;391;0
WireConnection;392;2;395;0
WireConnection;66;0;392;0
WireConnection;249;0;197;0
WireConnection;249;1;250;0
WireConnection;193;0;196;0
WireConnection;193;1;249;0
WireConnection;193;2;253;0
WireConnection;5;0;193;0
WireConnection;369;0;372;0
WireConnection;369;1;371;0
WireConnection;369;2;373;2
WireConnection;347;0;289;0
WireConnection;345;0;324;0
WireConnection;324;0;329;0
WireConnection;324;1;398;0
WireConnection;324;2;323;0
WireConnection;398;0;325;0
WireConnection;398;1;334;0
WireConnection;323;0;325;0
WireConnection;323;1;334;0
WireConnection;337;3;331;0
WireConnection;329;0;328;0
WireConnection;334;0;333;0
WireConnection;342;0;343;0
WireConnection;400;0;338;0
WireConnection;45;0;88;0
WireConnection;42;0;40;0
WireConnection;42;1;40;4
WireConnection;42;2;41;0
WireConnection;148;0;36;0
WireConnection;43;0;36;0
WireConnection;147;0;145;0
WireConnection;232;0;231;0
WireConnection;304;0;318;0
WireConnection;304;1;320;0
WireConnection;304;2;305;0
WireConnection;74;0;69;0
WireConnection;69;0;144;0
WireConnection;348;0;370;0
WireConnection;348;1;369;0
WireConnection;371;0;375;0
ASEEND*/
//CHKSM=9B7AD304926113445E27A79E39F13B28845E88D3