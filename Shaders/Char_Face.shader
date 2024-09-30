// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Study/MingChao/Char_Face"
{
	Properties
	{
		[Header(Sample)][NoScaleOffset]_Face_BaseColor("Face_BaseColor", 2D) = "white" {}
		[NoScaleOffset]_Face_SDF("Face_SDF", 2D) = "white" {}
		[NoScaleOffset]_Face_Mask("Face_Mask", 2D) = "white" {}
		[NoScaleOffset]_Face_Skin("Face_Skin", 2D) = "white" {}
		[Header(Light)]_LightInt("Light Int", Range( 0 , 3)) = 1
		_LightDurationTime("LightDurationTime", Range( 0 , 5)) = 1
		_LightBoundarySoft("Light Boundary Soft", Range( 0 , 1)) = 0
		_LightTintSoft("Light Tint Soft", Range( 0 , 0.5)) = 0.5
		_SSSInt("SSS Int", Range( 0 , 2)) = 1
		[Header(Brow)]_TintDiffusionBrowColor("Tint Diffusion Brow Color", Color) = (1,1,1,0)
		_TintDiffusionBrowInt("Tint Diffusion Brow Int", Float) = 0
		[Header(Out Line)]_OutLineInt("Out Line Int", Float) = 1
		_OutLineColor("Out Line Color", Color) = (1,1,1,1)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "Queue"="Geometry-20" }
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
			
			Name "Unlit"

			CGPROGRAM

			

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
			#include "UnityStandardBRDF.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			//This is a late directive
			
			uniform sampler2D _Face_BaseColor;
			uniform float _LightTintSoft;
			uniform float _SSSInt;
			uniform sampler2D _Face_Skin;
			uniform float4 ForwardVec_G;
			uniform float _LightDurationTime;
			uniform float _LightBoundarySoft;
			uniform sampler2D _Face_SDF;
			uniform float4 RightVec_G;
			uniform sampler2D _Face_Mask;
			uniform float4 SkinTintDiffuseColor_G;
			uniform float SkinTintDiffuseInt_G;
			uniform float4 _TintDiffusionBrowColor;
			uniform float _TintDiffusionBrowInt;
			uniform float LightInt_G;
			uniform float4 LightColor_G;
			uniform float _LightInt;
			uniform float LightLerp_G;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
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
				float2 texCoord6 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 SampleBaseColor11 = tex2D( _Face_BaseColor, texCoord6 );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				float3 WS_Normal267 = -normalizedWorldNormal;
				float dotResult332 = dot( ase_worldViewDir , WS_Normal267 );
				float3 worldSpaceLightDir = Unity_SafeNormalize(UnityWorldSpaceLightDir(WorldPosition));
				float dotResult5_g10 = dot( WS_Normal267 , worldSpaceLightDir );
				float lerpResult336 = lerp( (dotResult332*0.5 + 0.5) , (dotResult5_g10*0.5 + 0.5) , 1.0);
				float saferPower338 = abs( lerpResult336 );
				float LightTint_Mask2598 = pow( saferPower338 , _SSSInt );
				float smoothstepResult304 = smoothstep( ( 0.5 - _LightTintSoft ) , ( 0.5 + _LightTintSoft ) , LightTint_Mask2598);
				float2 texCoord9 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode4 = tex2D( _Face_Skin, texCoord9 );
				float SampleBrowMouse_Mask14 = tex2DNode4.r;
				float3 ForwardVec_G635 = (ForwardVec_G).xyz;
				float dotResult132 = dot( ForwardVec_G635 , worldSpaceLightDir );
				float Dir_Mask_F134 = pow( ( 1.0 - saturate( dotResult132 ) ) , ( _LightDurationTime * 10.0 ) );
				float temp_output_675_0 = ( _LightBoundarySoft * 0.1 );
				float2 texCoord8 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult87 = (float2(( 1.0 - texCoord8.x ) , texCoord8.y));
				float4 tex2DNode85 = tex2D( _Face_SDF, appendResult87 );
				float SampleShadowMap2_L89 = tex2DNode85.a;
				float3 RightVec_G643 = (RightVec_G).xyz;
				float dotResult81 = dot( RightVec_G643 , worldSpaceLightDir );
				float smoothstepResult321 = smoothstep( 0.0 , ( 0.0 + 0.4 ) , max( dotResult81 , 0.0 ));
				float Dir_Mask_R94 = smoothstepResult321;
				float4 tex2DNode3 = tex2D( _Face_SDF, texCoord8 );
				float SampleShadowMap2_R17 = tex2DNode3.a;
				float Mask657 = saturate( ( saturate( ( SampleShadowMap2_L89 * ( 1.0 - Dir_Mask_R94 ) ) ) + saturate( ( SampleShadowMap2_R17 * Dir_Mask_R94 ) ) ) );
				float smoothstepResult669 = smoothstep( ( Dir_Mask_F134 - temp_output_675_0 ) , ( Dir_Mask_F134 + temp_output_675_0 ) , Mask657);
				float2 texCoord7 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float SampleBrowMask12 = tex2D( _Face_Mask, texCoord7 ).r;
				float luminance696 = Luminance(SampleBaseColor11.rgb);
				float Mandible_Mask751 = step( 0.004 , ( ( 1.0 - step( 0.88 , pow( luminance696 , 0.108 ) ) ) * pow( ase_worldNormal.y , 16.39 ) ) );
				float ShadowMask115 = ( ( smoothstepResult669 * ( 1.0 - SampleBrowMask12 ) ) * ( 1.0 - Mandible_Mask751 ) );
				float LightTint_Mask279 = saturate( ( saturate( smoothstepResult304 ) * SampleBrowMouse_Mask14 * ShadowMask115 ) );
				float SampleDiffuse_Mask15 = tex2DNode4.g;
				float saferPower694 = abs( SampleDiffuse_Mask15 );
				float DiffuseTint_Mask522 = ( ( 1.0 - LightTint_Mask279 ) * ( 1.0 - SampleBrowMask12 ) * pow( saferPower694 , 1.0 ) );
				float4 BrowDiffusionColor282 = ( SampleBrowMask12 * _TintDiffusionBrowColor * _TintDiffusionBrowInt );
				float4 DiffuseTine_Color528 = ( ( DiffuseTint_Mask522 * SkinTintDiffuseColor_G * SkinTintDiffuseColor_G.a * SkinTintDiffuseInt_G * ( 1.0 - Mandible_Mask751 ) ) + BrowDiffusionColor282 );
				#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
				float4 ase_lightColor = 0;
				#else //aselc
				float4 ase_lightColor = _LightColor0;
				#endif //aselc
				float4 LightTint_Color76 = ( float4( ase_lightColor.rgb , 0.0 ) * LightInt_G * LightColor_G * LightTint_Mask279 * _LightInt );
				float4 lerpResult553 = lerp( SampleBaseColor11 , ( SampleBaseColor11 * ( DiffuseTine_Color528 + LightTint_Color76 ) ) , LightLerp_G);
				float4 D265 = lerpResult553;
				
				
				finalColor = D265;
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
			uniform sampler2D _Face_BaseColor;
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
				vertexValue = ( normalizedWorldNormal * ( _OutLineInt * 0.001 ) * ( 1.0 - v.color.r ) );
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
				float2 texCoord6 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 SampleBaseColor11 = tex2D( _Face_BaseColor, texCoord6 );
				float4 break487 = SampleBaseColor11;
				float4 temp_cast_0 = (( max( max( break487.r , break487.g ) , break487.b ) - 0.004 )).xxxx;
				float4 lerpResult494 = lerp( SampleBaseColor11 , ( step( temp_cast_0 , SampleBaseColor11 ) * SampleBaseColor11 ) , 0.6);
				float4 OutLine_Color502 = ( ( ( lerpResult494 * 0.8 ) * SampleBaseColor11 ) * _OutLineColor );
				
				
				finalColor = OutLine_Color502;
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
Node;AmplifyShaderEditor.CommentaryNode;752;-2683.878,2588.378;Inherit;False;1658.348;549.7278;Comment;14;747;696;697;739;725;748;749;742;750;708;709;741;740;751;Mandible Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;562;-4073.514,2282.471;Inherit;False;995.4475;693.7881;Comment;7;561;39;544;76;159;292;680;Light Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;529;-2576.28,1723.611;Inherit;False;1323.411;609.2388;Comment;9;756;755;684;528;686;525;527;526;757;Diffuse Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;283;-1424.588,-609.5779;Inherit;False;944.1622;414.8096;Comment;5;213;214;211;282;207;Brow Diffusion Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;276;-1379.491,-1063.808;Inherit;False;644.8852;236.8455;Comment;3;19;273;267;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;215;-1239.164,1742.149;Inherit;False;1847.623;754.6759;Comment;9;535;300;72;546;552;554;553;551;265;Light Calculation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;153;-3894.761,-1704.826;Inherit;False;2386.626;2167.314;Comment;53;672;675;106;658;481;480;108;673;670;105;663;665;664;669;660;671;668;610;667;134;115;657;107;581;580;113;109;84;482;110;579;132;635;567;568;131;643;565;81;566;82;324;94;321;577;322;102;678;677;679;737;753;754;SDF Mask Calculate;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;77;-5065.651,553.1586;Inherit;False;1726.505;1581.14;Comment;19;89;88;17;13;85;86;87;8;3;11;1;6;12;2;7;14;15;4;9;Sample;0.7548789,0.8679245,0.6345674,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;73;-3256.626,610.3541;Inherit;False;3258.612;991.913;Comment;29;522;521;279;45;338;336;333;275;335;334;332;331;305;306;307;308;295;185;424;126;182;304;598;682;683;692;695;694;746;Light Color;0.9622642,0.9515709,0.7216982,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-5008.646,1761.064;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-5012.492,902.2397;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-4955.329,620.7857;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-4552.504,1134.804;Inherit;True;Property;_Face_SDF;Face_SDF;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;08a87f7b43338184bb3c9f3380b2f7e6;4f35391efdff6154fb337849800dbffc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;85;-4548.274,1382.017;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;08a87f7b43338184bb3c9f3380b2f7e6;08a87f7b43338184bb3c9f3380b2f7e6;True;0;False;white;Auto;False;Instance;3;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-5028.469,1257.038;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;87;-4664.073,1387.417;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-4633.164,862.6127;Inherit;True;Property;_Face_Mask;Face_Mask;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;38da8814b1341ff4b849597b6795741b;38da8814b1341ff4b849597b6795741b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-4782.497,1718.438;Inherit;True;Property;_Face_Skin;Face_Skin;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;e37a235ee9a5b1d4693398687eef701b;e37a235ee9a5b1d4693398687eef701b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-4732.181,603.1587;Inherit;True;Property;_Face_BaseColor;Face_BaseColor;0;2;[Header];[NoScaleOffset];Create;True;1;Sample;0;0;False;0;False;-1;43de6fe210512df4d8b0569745ea146c;43de6fe210512df4d8b0569745ea146c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-4451.837,1728.981;Inherit;True;SampleBrowMouse_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;19;-1329.491,-1009.963;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;273;-1140.155,-1012.013;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;267;-967.6064,-1013.808;Inherit;False;WS_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;86;-4802.572,1296.978;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-4045.716,1168.732;Inherit;True;SampleShadowMap2_R;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-4049.946,1098.013;Inherit;False;SampleShadowMap1_R;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;-4001.708,1369.143;Inherit;False;SampleShadowMap1_L;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-4232.465,843.2234;Inherit;True;SampleBrowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-4005.219,1454.003;Inherit;True;SampleShadowMap2_L;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;486;-1437.861,43.95887;Inherit;False;2481.966;466.5473;Comment;18;504;503;502;501;499;498;497;494;493;492;491;490;489;488;487;518;519;520;Out Line Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;488;-965.4397,114.7489;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;489;-813.4397,140.7489;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;490;-633.4398,141.7489;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.004;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;491;-413.4402,179.7489;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;493;-226.0095,208.027;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;494;-46.00951,171.027;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;497;-228.0095,318.0269;Inherit;False;Constant;_Float11;Float 11;19;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;498;192.4122,169.1779;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;499;-55.58764,321.1778;Inherit;False;Constant;_Float12;Float 12;19;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;501;377.4117,170.1779;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;502;811.1035,148.7418;Inherit;False;OutLine_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;503;611.6825,181.37;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;504;374.9557,298.5059;Inherit;False;Property;_OutLineColor;Out Line Color;13;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.6415094,0.481132,0.481132,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;487;-1131.44,109.7489;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;492;-1384.861,101.9589;Inherit;False;11;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;518;-703.6536,291.1119;Inherit;False;11;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;519;-299.6541,91.11194;Inherit;False;11;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;520;140.3458,313.1119;Inherit;False;11;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;207;-1339.858,-573.5479;Inherit;False;12;SampleBrowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;-1024.506,-558.5938;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;214;-1362.574,-296.5309;Inherit;False;Property;_TintDiffusionBrowInt;Tint Diffusion Brow Int;10;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;213;-1386.574,-480.462;Inherit;False;Property;_TintDiffusionBrowColor;Tint Diffusion Brow Color;9;1;[Header];Create;True;1;Brow;0;0;False;0;False;1,1,1,0;0.9245283,0.9245283,0.9245283,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;505;1328,1936;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;508;1104,1968;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;509;992,1808;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;511;1008,2080;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;507;944,1952;Inherit;False;Property;_OutLineInt;Out Line Int;12;1;[Header];Create;True;1;Out Line;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;510;1168,2096;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;485;1536,1888;Float;False;False;-1;2;ASEMaterialInspector;100;12;New Amplify Shader;cb0a069cd65065f4691e7feda7c4b316;True;SecondUnlit;0;1;SecondUnlit;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;False;False;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;1;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;1;False;;True;3;False;;True;False;0;False;;0;False;;False;True;2;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;506;1296,1808;Inherit;False;502;OutLine_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;-3511.514,2396.472;Inherit;False;5;5;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;159;-4023.514,2332.471;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;-3351.514,2460.472;Inherit;False;LightTint_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;535;-1054.722,1922.463;Inherit;False;11;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;552;-499.7711,2051.564;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;553;-180.1087,1930.793;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;247.7378,1922.428;Inherit;False;CustomLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;554;-1084.696,2141.954;Inherit;False;76;LightTint_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;561;-3994.289,2752.376;Inherit;False;279;LightTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;424;-1408,800;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;308;-2080,896;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;306;-2064,1008;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;304;-1872,752;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;182;-1664,768;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;305;-2256,960;Inherit;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;295;-1264,800;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;335;-2880,944;Inherit;False;Half Lambert Term;-1;;10;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;-3136,944;Inherit;False;267;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;334;-2912,848;Inherit;False;Constant;_Float6;Float 6;14;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;102;-2834.075,-1506.477;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;322;-2733.64,-1434.818;Inherit;False;Constant;_Float4;Float 4;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;577;-2559.733,-1366.933;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;321;-2413.751,-1530.901;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-1986.23,-1532.567;Inherit;False;Dir_Mask_R;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;324;-2863.062,-1345.416;Inherit;False;Constant;_ShadowMaskSwitchSensitivity;ShadowMaskSwitchSensitivity;15;0;Create;True;0;0;0;False;0;False;0.4;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;82;-3512.387,-1337.09;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;566;-3483.391,-1542.494;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;81;-3144.13,-1535.362;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;131;-3652.115,-891.4278;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;568;-3545.025,-1082.26;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;610;-2268.385,-1059.236;Inherit;False;Dir_Mask_B;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;668;-2425.954,-1049.135;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;658;-3625.296,52.34354;Inherit;False;657;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;132;-3193.018,-1080.404;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;579;-3068.501,-1070.495;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;667;-2942.072,-1083.095;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-2630.345,-1074.068;Inherit;False;Dir_Mask_F;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;660;-3677.183,149.8952;Inherit;False;134;Dir_Mask_F;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;677;-2783.23,-1084.852;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-3481.241,-604.2067;Inherit;False;89;SampleShadowMap2_L;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;482;-3737.241,-492.2061;Inherit;False;Property;_ShadowSen;Shadow Sen;11;0;Create;True;0;0;0;False;0;False;0;0.082;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-3593.241,-396.2062;Inherit;False;17;SampleShadowMap2_R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-3081.24,-540.2063;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;113;-3241.24,-476.2061;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;580;-2953.239,-508.2061;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;581;-2953.239,-412.2062;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-2793.24,-444.2062;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;657;-2508.754,-461.516;Inherit;False;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-3077.123,-386.7802;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;673;-2650.827,-445.6597;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-3418.394,-305.985;Inherit;False;94;Dir_Mask_R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;480;-3262.24,-212.2064;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;481;-3209.24,-695.2067;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-3417.24,-492.2061;Inherit;False;94;Dir_Mask_R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;669;-3230.383,61.1396;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;670;-3397.184,150.5733;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;663;-2806.123,70.93445;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;679;-2839.125,-906.5568;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;678;-3123.081,-908.4658;Inherit;False;Property;_LightDurationTime;LightDurationTime;5;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2590.535,906.3502;Float;False;Property;_SSSInt;SSS Int;8;0;Create;True;0;0;0;False;0;False;1;0.228;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;307;-2369,1044;Inherit;False;Property;_LightTintSoft;Light Tint Soft;7;0;Create;True;0;0;0;False;0;False;0.5;0.114;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-4007.514,2562.472;Inherit;False;Global;LightColor_G;Light Color_G;4;1;[Header];Create;True;1;Specular Tint;0;0;True;0;False;1,1,1,1;0.990566,0.9601143,0.9578586,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;544;-4023.514,2460.472;Inherit;False;Global;LightInt_G;Light Int_G;5;0;Create;True;0;0;0;True;0;False;0;5.62;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;680;-4038.897,2864.194;Inherit;False;Property;_LightInt;Light Int;4;1;[Header];Create;True;1;Light;0;0;False;0;False;1;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;282;-716.3236,-548.9879;Inherit;False;BrowDiffusionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;546;-508.8538,2165.01;Inherit;False;Global;LightLerp_G;Light Lerp_G;6;0;Create;True;0;0;0;True;0;False;0.34;0.335;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;300;-1085.991,2074.356;Inherit;False;528;DiffuseTine_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;551;-792.4243,2083.691;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;567;-3717.446,-1085.104;Inherit;False;Global;ForwardVec_G;Forward Vec_G;14;0;Create;True;0;0;0;True;0;False;0,0,0,0;0,0,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;565;-3667.168,-1538.845;Inherit;False;Global;RightVec_G;Right Vec_G;14;0;Create;True;0;0;0;True;0;False;0,0,0,0;1,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;643;-3348.771,-1540.693;Inherit;False;RightVec_G;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;635;-3401.874,-1086.064;Inherit;False;ForwardVec_G;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;527;-1994.164,1822.174;Inherit;False;5;5;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;331;-3136,688;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;332;-2896,752;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;336;-2528,768;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;333;-2736,768;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;671;-3368.012,276.2199;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;675;-3553.885,279.6861;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;665;-3002.283,268.7263;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;664;-3202.877,260.1811;Inherit;False;12;SampleBrowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;672;-3835.012,285.2199;Inherit;False;Property;_LightBoundarySoft;Light Boundary Soft;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;521;-861.6,806.9999;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;279;-1099.6,798.9999;Inherit;False;LightTint_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;682;-1099.804,916.0842;Inherit;False;12;SampleBrowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;683;-880.3268,920.4163;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;746;-628.5082,818.4063;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;525;-2295.102,1765.946;Inherit;False;522;DiffuseTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;694;-873.5864,1022.388;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1796,1004;Inherit;False;115;ShadowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;-1847,920;Inherit;False;14;SampleBrowMouse_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;522;-449.6001,810.9999;Inherit;False;DiffuseTint_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;338;-2333,778;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;598;-2148,763;Inherit;False;LightTint_Mask2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-3896.58,635.0195;Inherit;False;SampleBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;747;-2633.878,2714.967;Inherit;False;11;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LuminanceNode;696;-2430.076,2731.92;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;697;-2172.076,2750.92;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;739;-2422.219,2834.127;Inherit;False;Constant;_Float2;Float 2;16;0;Create;True;0;0;0;False;0;False;0.108;0.108;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;725;-2001.619,2702.514;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;748;-1851.683,2662.463;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;749;-1618.842,2781.9;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;742;-1622.831,2690.72;Inherit;False;Constant;_07;0. 7;18;0;Create;True;0;0;0;False;0;False;0.004;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;750;-1399.047,2772.203;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;708;-2083.141,2882.416;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;709;-1817.141,2896.416;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;741;-2059.063,3022.106;Inherit;False;Constant;_Float5;Float 5;17;0;Create;True;0;0;0;False;0;False;16.39;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;740;-2423.957,2638.378;Inherit;False;Constant;_Float3;Float 3;15;0;Create;True;0;0;0;False;0;False;0.88;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;751;-1258.53,2781.438;Inherit;False;Mandible_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;737;-2464.113,116.1488;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;484;1552,1728;Float;False;True;-1;2;ASEMaterialInspector;100;12;Study/MingChao/Char_Face;cb0a069cd65065f4691e7feda7c4b316;True;Unlit;0;0;Unlit;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;RenderType=Opaque=RenderType;Queue=Geometry=Queue=-20;False;False;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;1;False;;True;3;False;;True;False;0;False;;0;False;;False;True;2;False;0;Legacy Shaders/Diffuse;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;2;True;True;False;;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;1305,1696;Inherit;False;72;CustomLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;513;1313.752,1604.093;Inherit;False;265;D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-2241.906,115.7901;Inherit;False;ShadowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-14.62103,2166.176;Inherit;False;D;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;686;-1690.14,1914.135;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;528;-1575.413,1910.193;Inherit;False;DiffuseTine_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;684;-2011.785,2096.453;Inherit;False;282;BrowDiffusionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;753;-2737.707,331.3008;Inherit;False;751;Mandible_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;754;-2546.707,239.3008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;695;-1064.939,1091.674;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;692;-1183.842,1007.388;Inherit;False;15;SampleDiffuse_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-4440.203,1921.441;Inherit;True;SampleDiffuse_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;755;-2397.041,2161.963;Inherit;False;751;Mandible_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;756;-2212.041,2164.963;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;757;-2344.224,2066.971;Inherit;False;Global;SkinTintDiffuseInt_G;Skin Tint Diffuse Int_G;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;526;-2336.08,1858.437;Inherit;False;Global;SkinTintDiffuseColor_G;Skin Tint Diffuse Color_G;10;0;Create;True;0;0;0;True;0;False;1,1,1,1;0.9150943,0.3064703,0.3064703,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;3;1;8;0
WireConnection;85;1;87;0
WireConnection;87;0;86;0
WireConnection;87;1;8;2
WireConnection;2;1;7;0
WireConnection;4;1;9;0
WireConnection;1;1;6;0
WireConnection;14;0;4;1
WireConnection;273;0;19;0
WireConnection;267;0;273;0
WireConnection;86;0;8;1
WireConnection;17;0;3;4
WireConnection;13;0;3;3
WireConnection;88;0;85;3
WireConnection;12;0;2;1
WireConnection;89;0;85;4
WireConnection;488;0;487;0
WireConnection;488;1;487;1
WireConnection;489;0;488;0
WireConnection;489;1;487;2
WireConnection;490;0;489;0
WireConnection;491;0;490;0
WireConnection;491;1;518;0
WireConnection;493;0;491;0
WireConnection;493;1;518;0
WireConnection;494;0;519;0
WireConnection;494;1;493;0
WireConnection;494;2;497;0
WireConnection;498;0;494;0
WireConnection;498;1;499;0
WireConnection;501;0;498;0
WireConnection;501;1;520;0
WireConnection;502;0;503;0
WireConnection;503;0;501;0
WireConnection;503;1;504;0
WireConnection;487;0;492;0
WireConnection;211;0;207;0
WireConnection;211;1;213;0
WireConnection;211;2;214;0
WireConnection;505;0;509;0
WireConnection;505;1;508;0
WireConnection;505;2;510;0
WireConnection;508;0;507;0
WireConnection;510;0;511;1
WireConnection;485;0;506;0
WireConnection;485;1;505;0
WireConnection;292;0;159;1
WireConnection;292;1;544;0
WireConnection;292;2;39;0
WireConnection;292;3;561;0
WireConnection;292;4;680;0
WireConnection;76;0;292;0
WireConnection;552;0;535;0
WireConnection;552;1;551;0
WireConnection;553;0;535;0
WireConnection;553;1;552;0
WireConnection;553;2;546;0
WireConnection;72;0;553;0
WireConnection;424;0;182;0
WireConnection;424;1;185;0
WireConnection;424;2;126;0
WireConnection;308;0;305;0
WireConnection;308;1;307;0
WireConnection;306;0;305;0
WireConnection;306;1;307;0
WireConnection;304;0;598;0
WireConnection;304;1;308;0
WireConnection;304;2;306;0
WireConnection;182;0;304;0
WireConnection;295;0;424;0
WireConnection;335;3;275;0
WireConnection;102;0;81;0
WireConnection;577;0;322;0
WireConnection;577;1;324;0
WireConnection;321;0;102;0
WireConnection;321;1;322;0
WireConnection;321;2;577;0
WireConnection;94;0;321;0
WireConnection;566;0;565;0
WireConnection;81;0;643;0
WireConnection;81;1;82;0
WireConnection;568;0;567;0
WireConnection;610;0;668;0
WireConnection;668;0;134;0
WireConnection;132;0;635;0
WireConnection;132;1;131;0
WireConnection;579;0;132;0
WireConnection;667;0;579;0
WireConnection;134;0;677;0
WireConnection;677;0;667;0
WireConnection;677;1;679;0
WireConnection;109;0;110;0
WireConnection;109;1;113;0
WireConnection;113;0;106;0
WireConnection;580;0;109;0
WireConnection;581;0;105;0
WireConnection;107;0;580;0
WireConnection;107;1;581;0
WireConnection;657;0;673;0
WireConnection;105;0;84;0
WireConnection;105;1;108;0
WireConnection;673;0;107;0
WireConnection;480;1;482;0
WireConnection;481;1;482;0
WireConnection;669;0;658;0
WireConnection;669;1;670;0
WireConnection;669;2;671;0
WireConnection;670;0;660;0
WireConnection;670;1;675;0
WireConnection;663;0;669;0
WireConnection;663;1;665;0
WireConnection;679;0;678;0
WireConnection;282;0;211;0
WireConnection;551;0;300;0
WireConnection;551;1;554;0
WireConnection;643;0;566;0
WireConnection;635;0;568;0
WireConnection;527;0;525;0
WireConnection;527;1;526;0
WireConnection;527;2;526;4
WireConnection;527;3;757;0
WireConnection;527;4;756;0
WireConnection;332;0;331;0
WireConnection;332;1;275;0
WireConnection;336;0;333;0
WireConnection;336;1;335;0
WireConnection;333;0;332;0
WireConnection;333;1;334;0
WireConnection;333;2;334;0
WireConnection;671;0;660;0
WireConnection;671;1;675;0
WireConnection;675;0;672;0
WireConnection;665;0;664;0
WireConnection;521;0;279;0
WireConnection;279;0;295;0
WireConnection;683;0;682;0
WireConnection;746;0;521;0
WireConnection;746;1;683;0
WireConnection;746;2;694;0
WireConnection;694;0;692;0
WireConnection;694;1;695;0
WireConnection;522;0;746;0
WireConnection;338;0;336;0
WireConnection;338;1;45;0
WireConnection;598;0;338;0
WireConnection;11;0;1;0
WireConnection;696;0;747;0
WireConnection;697;0;696;0
WireConnection;697;1;739;0
WireConnection;725;0;740;0
WireConnection;725;1;697;0
WireConnection;748;0;725;0
WireConnection;749;0;748;0
WireConnection;749;1;709;0
WireConnection;750;0;742;0
WireConnection;750;1;749;0
WireConnection;709;0;708;2
WireConnection;709;1;741;0
WireConnection;751;0;750;0
WireConnection;737;0;663;0
WireConnection;737;1;754;0
WireConnection;484;0;513;0
WireConnection;115;0;737;0
WireConnection;265;0;553;0
WireConnection;686;0;527;0
WireConnection;686;1;684;0
WireConnection;528;0;686;0
WireConnection;754;0;753;0
WireConnection;15;0;4;2
WireConnection;756;0;755;0
ASEEND*/
//CHKSM=265A3C9CAB985FF34F3FE0518EDFB5D1828BEE9E