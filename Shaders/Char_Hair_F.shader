// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Study/MingChao/Char_Hair_F"
{
	Properties
	{
		_Hair_Albedo("Hair_Albedo", 2D) = "white" {}
		_Hair_HA_Repaired("Hair_HA_Repaired", 2D) = "white" {}
		_HairBangTransparency("Hair Bang Transparency", Range( 1 , 2)) = 1
		_EarlockTransparency("Earlock Transparency", Range( 0 , 0.1)) = 0.1
		_LightThreshold("Light Threshold", Range( 0.9 , 1.1)) = 0.93
		_HightLightShadowAnisoInt("Hight Light Shadow Aniso Int", Range( 0 , 1)) = 0.3
		[Header(Out Line )]_OutLineInt("Out Line Int", Float) = 1
		_OutLineColor("Out Line Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "Queue"="Geometry+10" }
	LOD 100

		
		
		
		Pass
		{
			CGINCLUDE
			#pragma target 3.0
			ENDCG
			Blend Off
			AlphaToMask Off
			Cull Back
			ColorMask RGBA
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			
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
			#include "UnityStandardBRDF.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
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
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
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
			uniform float _LightThreshold;
			uniform float4 HairTintDiffuseLightColor_G;
			uniform float4 LightColor_G;
			uniform float LightInt_G;
			uniform float HairLightLerp_G;
			uniform float4 HightLightTintColor_G;
			uniform float HightLightTintInt_G;
			uniform float HightLightShadowLerp_G;
			uniform float AnisoSpecShininess_G;
			uniform float _HightLightShadowAnisoInt;
			uniform float _EarlockTransparency;
			uniform float _HairBangTransparency;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float3 ase_vertexBitangent = cross( v.ase_normal, v.ase_tangent.xyz ) * v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				o.ase_texcoord3.xyz = ase_vertexBitangent;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_tangent = v.ase_tangent;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
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
				float SampleTransparency368 = tex2DNode2.a;
				float RampHair_Mask258 = SampleTransparency368;
				float4 RampHair_Color263 = ( RampHair_Mask258 * RampColor_G * RampColor_G.a );
				float4 SampleBaseColor97 = ( tex2DNode2 + ( tex2DNode2 * RampHair_Color263 ) );
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = Unity_SafeNormalize( ase_worldViewDir );
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				float3 WS_Normal68 = normalizedWorldNormal;
				float dotResult73 = dot( ase_worldViewDir , WS_Normal68 );
				float NdotV114 = dotResult73;
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(WorldPosition);
				float dotResult361 = dot( WS_Normal68 , worldSpaceLightDir );
				float2 uv_Hair_HA_Repaired = i.ase_texcoord1.xy * _Hair_HA_Repaired_ST.xy + _Hair_HA_Repaired_ST.zw;
				float4 tex2DNode4 = tex2D( _Hair_HA_Repaired, uv_Hair_HA_Repaired );
				float SampleAO92 = tex2DNode4.g;
				float HalfLambertTerm360 = ( (dotResult361*0.5 + 0.5) * SampleAO92 );
				float lerpResult81 = lerp( (NdotV114*0.5 + 0.5) , HalfLambertTerm360 , 0.9);
				float saferPower84 = abs( lerpResult81 );
				float smoothstepResult70 = smoothstep( 0.5 , ( 0.5 + ( SoftEdge_G * 0.012 ) ) , saturate( ( saturate( pow( saferPower84 , ( LightSpecness_G * 0.1 ) ) ) - ( LightThreshold_G * _LightThreshold ) ) ));
				float LightTint_Mask89 = smoothstepResult70;
				float DiffuseTint_Mask332 = ( 1.0 - LightTint_Mask89 );
				float4 DiffuseTine_Color337 = ( DiffuseTint_Mask332 * HairTintDiffuseLightColor_G * HairTintDiffuseLightColor_G.a );
				#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
				float4 ase_lightColor = 0;
				#else //aselc
				float4 ase_lightColor = _LightColor0;
				#endif //aselc
				float4 LightTint_Color13 = ( LightTint_Mask89 * LightColor_G * LightInt_G * float4( ase_lightColor.rgb , 0.0 ) );
				float4 lerpResult342 = lerp( SampleBaseColor97 , ( SampleBaseColor97 * ( DiffuseTine_Color337 + LightTint_Color13 ) ) , HairLightLerp_G);
				float SampleHightLight93 = tex2DNode4.r;
				float lerpResult112 = lerp( ( 1.0 - LightTint_Mask89 ) , LightTint_Mask89 , HightLightShadowLerp_G);
				float3 ase_vertexBitangent = i.ase_texcoord3.xyz;
				float3 normalizeResult138 = normalize( ase_vertexBitangent );
				float3 worldSpaceViewDir129 = WorldSpaceViewDir( float4( 0,0,0,1 ) );
				float3 objToWorldDir139 = normalize( mul( unity_ObjectToWorld, float4( worldSpaceViewDir129, 0 ) ).xyz );
				float3 objToWorldDir140 = normalize( mul( unity_ObjectToWorld, float4( worldSpaceLightDir, 0 ) ).xyz );
				float3 normalizeResult132 = normalize( ( objToWorldDir139 + objToWorldDir140 ) );
				float3 HalfDir147 = normalizeResult132;
				float dotResult152 = dot( normalizeResult138 , HalfDir147 );
				float temp_output_166_0 = ( dotResult152 / AnisoSpecShininess_G );
				float3 normalizeResult151 = normalize( i.ase_tangent.xyz );
				float dotResult148 = dot( HalfDir147 , normalizeResult151 );
				float3 normalizeResult164 = normalize( i.ase_normal );
				float dotResult162 = dot( HalfDir147 , normalizeResult164 );
				float AnisoKKplus_Mask178 = exp( ( -( ( temp_output_166_0 * temp_output_166_0 ) + ( dotResult148 * dotResult148 ) ) / ( dotResult162 + 1.0 ) ) );
				float4 HighLightTint_Color107 = ( ( SampleHightLight93 * HightLightTintColor_G * HightLightTintInt_G * lerpResult112 ) * max( AnisoKKplus_Mask178 , ( SampleHightLight93 * _HightLightShadowAnisoInt ) ) );
				float4 CustomLight36 = ( lerpResult342 + HighLightTint_Color107 );
				float3 objToWorld307 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
				float smoothstepResult323 = smoothstep( 0.0 , _EarlockTransparency , saturate( distance( ( WorldPosition - objToWorld307 ).y , 1.0 ) ));
				float2 texCoord301 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float3 objToWorld214 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
				float temp_output_304_0 = ( texCoord301.y + ( saturate( ( WorldPosition - objToWorld214 ).y ) - _HairBangTransparency ) );
				float HairTransparency217 = saturate( ( smoothstepResult323 + temp_output_304_0 ) );
				float4 appendResult271 = (float4(CustomLight36.rgb , max( HairTransparency217 , SampleTransparency368 )));
				
				
				finalColor = appendResult271;
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
			Offset 1 , 1
			
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
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( normalizedWorldNormal * ( _OutLineInt * 0.001 ) * v.color.r );
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
				float SampleTransparency368 = tex2DNode2.a;
				float RampHair_Mask258 = SampleTransparency368;
				float4 RampHair_Color263 = ( RampHair_Mask258 * RampColor_G * RampColor_G.a );
				float4 SampleBaseColor97 = ( tex2DNode2 + ( tex2DNode2 * RampHair_Color263 ) );
				float4 break275 = SampleBaseColor97;
				float4 temp_cast_0 = (( max( max( break275.r , break275.g ) , break275.b ) - 0.004 )).xxxx;
				float4 lerpResult282 = lerp( SampleBaseColor97 , ( step( temp_cast_0 , SampleBaseColor97 ) * SampleBaseColor97 ) , 0.6);
				float4 OutLine_Color290 = ( ( ( lerpResult282 * 0.8 ) * SampleBaseColor97 ) * _OutLineColor );
				
				
				finalColor = OutLine_Color290;
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
Node;AmplifyShaderEditor.CommentaryNode;365;-6114,-2674;Inherit;False;1132;406;Comment;8;357;358;359;360;361;362;363;364;Half Lambert Term;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;267;-6368,352;Inherit;False;780.0088;346;Comment;4;260;262;263;261;Ramp Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;259;-7491.08,253.328;Inherit;False;1078.077;443.2162;Comment;2;258;374;Ramp;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;230;-3093.477,315.281;Inherit;False;2191.679;1076.53;Comment;27;326;309;307;217;301;213;215;214;221;304;222;229;1;219;216;312;325;324;323;313;319;310;308;327;328;329;330;Hair Transparency;0.7122365,0.9339623,0.6123621,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;189;-3691.669,-1309.63;Inherit;False;1200.74;1092.176;Comment;9;97;265;266;264;2;93;4;92;368;Sample;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;182;-5367.196,309.7385;Inherit;False;2157.786;1651.004;Comment;44;172;171;170;169;173;174;177;149;161;163;162;164;167;168;154;153;166;152;150;148;151;141;160;159;158;165;178;138;121;129;131;139;140;130;132;128;134;136;147;133;135;179;180;181;Anisotropy  Calculation;0.8442824,0.990566,0.5466803,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;109;-7222.52,1138.312;Inherit;False;1718.147;938.9574;Comment;15;107;199;198;197;184;200;183;113;111;110;102;112;104;105;106;Hight Light Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;-6816,816;Inherit;False;974.7162;224.5667;Comment;2;68;58;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;7;-6848,-912;Inherit;False;946.4652;559.1513;Comment;6;25;13;12;26;11;333;Light Tint Color;0.9433962,0.9355134,0.7075472,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;8;-7036.922,-1936;Inherit;False;3225.871;937.9424;Comment;25;353;77;88;81;72;354;83;348;78;74;79;71;331;332;89;69;70;114;73;87;84;75;85;80;366;Specular Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;10;-5824,-880;Inherit;False;1994.268;579.5577;Comment;9;36;347;346;345;342;341;340;339;349;Light Calculation;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;-6784,-864;Inherit;False;89;LightTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-6480,-1584;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;85;-5728,-1728;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;58;-6752,864;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-6416,-848;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;75;-5408,-1744;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;84;-5920,-1744;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;73;-6592,-1696;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-6480,-1712;Inherit;False;NdotV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-5295.688,1076.902;Inherit;False;147;HalfDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;161;-5099.501,1408.554;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;163;-5094.143,1313.557;Inherit;False;147;HalfDir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;162;-4720.143,1337.557;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;164;-4868.143,1416.557;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;168;-3943.399,1125.364;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;-4117.977,1082.073;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-4353.335,982.0766;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;166;-4501.578,993.6646;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;152;-4853.174,948.2277;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-4693.729,1192.524;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;148;-4893.871,1179.683;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;151;-5107.289,1224.131;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TangentVertexDataNode;141;-5317.196,1230.943;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;160;-4449.27,1327.786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-4725.478,1453.463;Inherit;False;Constant;_Float3;Float 3;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;158;-3806.698,1130.289;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;165;-3672.527,1124.115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;138;-5094.189,934.5416;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BitangentVertexDataNode;121;-5305.208,937.504;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceViewDirHlpNode;129;-5237.946,401.5143;Inherit;False;1;0;FLOAT4;0,0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;131;-4752.972,485.5415;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformDirectionNode;139;-5020.083,359.7384;Inherit;False;Object;World;True;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformDirectionNode;140;-5009.614,573.7476;Inherit;False;Object;World;True;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;130;-5244.946,565.5144;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;132;-4637.972,481.5415;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;128;-4004.665,567.8984;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;134;-3855.973,558.5416;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-4470.811,488.0306;Inherit;False;HalfDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;133;-4160.969,541.0409;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;135;-3674.973,571.5417;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;180;-4428.125,601.1912;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BitangentVertexDataNode;181;-4639.145,604.1532;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;172;-4674.468,1689.253;Inherit;False;114;NdotV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;171;-4460.552,1597.723;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;170;-4279.289,1596.827;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-4676.165,1590.234;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;173;-4130.944,1614.715;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;174;-3984.625,1601.355;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;177;-3518.995,1226.477;Inherit;False;AnisoAttenuation_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;178;-3539.411,1126.645;Inherit;False;AnisoKKplus_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;179;-3497.91,1047.888;Inherit;False;AnisoKKBase_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-6390.008,1198.438;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;112;-6833.901,1730.681;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-3641.669,-551.4433;Inherit;True;Property;_Hair_HA_Repaired;Hair_HA_Repaired;1;0;Create;True;0;0;0;False;0;False;-1;a953f9a2da440a1478d7be7eaec08e7b;a953f9a2da440a1478d7be7eaec08e7b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-3345.585,-714.2529;Inherit;True;SampleHightLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-7020.254,1175.01;Inherit;True;93;SampleHightLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-3886.973,692.5416;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-7213.72,1753.807;Inherit;False;89;LightTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;111;-6988.882,1729.547;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-6032,400;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;263;-5808,400;Inherit;False;RampHair_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;274;-3791.354,-1840.75;Inherit;False;2481.966;466.5473;Comment;18;292;291;290;289;288;287;286;285;284;283;282;281;280;279;278;277;276;275;Out Line Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;275;-3516.933,-1776.96;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMaxOpNode;276;-3318.932,-1769.96;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;277;-3166.934,-1743.96;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;278;-2986.934,-1742.96;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.004;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;279;-2766.934,-1704.96;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;-3741.354,-1790.75;Inherit;False;97;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;-2579.504,-1676.682;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;282;-2399.504,-1713.682;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;283;-3017.503,-1624.682;Inherit;False;97;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;284;-2667.503,-1777.682;Inherit;False;97;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-2581.504,-1566.682;Inherit;False;Constant;_Float4;Float 4;19;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;286;-2161.082,-1715.531;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;287;-2409.082,-1563.531;Inherit;False;Constant;_Float5;Float 5;19;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;288;-2189.082,-1581.531;Inherit;False;97;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-1976.082,-1714.531;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;290;-1542.39,-1735.966;Inherit;False;OutLine_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-1741.811,-1703.339;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;292;-1978.538,-1586.203;Inherit;False;Property;_OutLineColor;Out Line Color;7;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-6064,864;Inherit;False;WS_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;216;-2598.539,956.6968;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;219;-2466.72,994.0729;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;222;-2316.161,1052.86;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;304;-2189.542,939.1078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-2627.492,1079.123;Inherit;False;Property;_HairBangTransparency;Hair Bang Transparency;2;0;Create;True;0;0;0;False;0;False;1;0;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;214;-3053.218,1077.659;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;215;-2741.218,948.6589;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;213;-3001.977,900.582;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;301;-2451.977,879.3446;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;308;-2694.033,404.2556;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;310;-2548.585,389.4695;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DistanceOpNode;319;-2385.351,448.5935;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;312;-2539.585,513.4695;Inherit;False;Constant;_Float6;Float 6;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;307;-3050.458,639.7919;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;309;-3030.284,419.3645;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;313;-2228.027,449.0905;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;323;-2092.447,453.3333;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;324;-2288.447,529.334;Inherit;False;Constant;_Float8;Float 8;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;326;-1938.774,477.8686;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;327;-1812.804,496.4464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;217;-1101.485,1051.759;Inherit;False;HairTransparency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;328;-1517.954,1055.294;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;329;-1652.879,1055.294;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;330;-1280.821,1066.282;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1;-1746.623,1151.598;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;229;-1529.378,1206.766;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;325;-2393.447,616.334;Inherit;False;Property;_EarlockTransparency;Earlock Transparency;3;0;Create;True;0;0;0;False;0;False;0.1;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-3336.759,-475.8086;Inherit;True;SampleAO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;70;-5120,-1760;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-5232,-1616;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;333;-6696.853,-512.5635;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-6224,-851;Inherit;False;LightTint_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;334;-6822.542,-307.493;Inherit;False;792.4666;357.2258;Comment;4;338;337;336;335;Diffuse Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-6451.425,-208.9301;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;337;-6265.074,-201.2111;Inherit;False;DiffuseTine_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;339;-5664,-800;Inherit;False;97;SampleBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;341;-5120,-672;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;342;-4800,-784;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;347;-5696,-576;Inherit;False;13;LightTint_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;-3286.624,-908.9893;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;265;-3135.624,-921.9891;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-2972.103,-920.5328;Inherit;False;SampleBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;260;-6320,416;Inherit;False;258;RampHair_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;340;-5398,-645;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;346;-5696,-688;Inherit;False;337;DiffuseTine_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;338;-6772.423,-257.493;Inherit;False;332;DiffuseTint_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-6816,-608;Inherit;False;Global;LightInt_G;Light Int_G;5;1;[Header];Create;True;1;Tint Light;0;0;True;0;False;0.2;2.22;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-6784,-784;Inherit;False;Global;LightColor_G;Light Color_G;6;0;Create;True;0;0;0;True;0;False;1,1,1,1;0.990566,0.9601143,0.9578586,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;297;-2304,-304;Inherit;False;Property;_OutLineInt;Out Line Int;6;1;[Header];Create;True;1;Out Line ;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;-2128,-288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;-1920,-336;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;293;-1936,-416;Inherit;False;290;OutLine_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;296;-2128,-160;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-5411,-1648;Inherit;False;Constant;_Float2;Float 2;12;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-5378,-1505;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.012;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;74;-5557,-1735;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;269;-1616,-368;Float;False;False;-1;2;ASEMaterialInspector;100;12;New Amplify Shader;cb0a069cd65065f4691e7feda7c4b316;True;SecondUnlit;0;1;SecondUnlit;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;False;False;0;True;True;0;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;1;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;1;False;;True;3;False;;True;True;1;False;;1;False;;False;True;2;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;200;-6248.854,1770.427;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;184;-6590.715,1751.511;Inherit;False;178;AnisoKKplus_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;-6638.691,1851.245;Inherit;False;93;SampleHightLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;-6397.691,1854.245;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-5965.153,1211.9;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-5824.764,1207.192;Inherit;False;HighLightTint_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;350;-4609.777,-754.3302;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-4394.027,-762.1782;Inherit;False;CustomLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;-4839.439,-599.8525;Inherit;False;107;HighLightTint_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-5700,-1392;Inherit;False;Global;SoftEdge_G;Soft Edge_G;6;1;[Header];Create;True;0;0;0;True;0;False;0.4;0.05;0;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;348;-5601.647,-1603.912;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.94;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-5917,-1648;Inherit;False;Global;LightThreshold_G;Light Threshold_G;5;0;Create;True;1;Tint Light 1;0;0;True;0;False;1;0.479;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;354;-6763.226,-1775.632;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;72;-6292.156,-1720.313;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;81;-6096,-1712;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-6772,-1615;Inherit;False;68;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;353;-5901.134,-1539.862;Inherit;False;Property;_LightThreshold;Light Threshold;4;0;Create;True;0;0;0;False;0;False;0.93;0.93;0.9;1.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-6398.285,-1236.746;Inherit;False;Global;LightSpecness_G;Light Specness_G;7;0;Create;True;0;0;0;True;0;False;1;0.193;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-6055,-1235;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;357;-5568,-2592;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;358;-5520,-2448;Inherit;False;92;SampleAO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;359;-5344,-2608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;361;-5808,-2592;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;362;-6032,-2624;Inherit;False;68;WS_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;363;-6064,-2544;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;364;-5872,-2384;Float;False;Constant;_RemapValue;Remap Value;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;360;-5216,-2624;Inherit;False;HalfLambertTerm;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;366;-6343.554,-1505.047;Inherit;False;360;HalfLambertTerm;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-7141.221,1858.648;Inherit;False;Global;HightLightShadowLerp_G;Hight Light Shadow Lerp_G;8;0;Create;True;0;0;0;True;0;False;1;0.791;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-7038.945,1565.263;Inherit;False;Global;HightLightTintInt_G;Hight Light Tint Int_G;7;0;Create;True;0;0;0;True;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;105;-7042.166,1376.816;Inherit;False;Global;HightLightTintColor_G;Hight Light Tint Color_G;6;1;[Header];Create;True;1;Hight Light Tint;0;0;True;0;False;1,1,1,0;0.8773585,0.7656195,0.7656195,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;261;-6323,497;Inherit;False;Global;RampColor_G;Ramp Color_G;2;1;[Header];Create;True;1;Parameter;0;0;True;0;False;1,1,1,1;0.2924528,0.06759523,0.1581223,0.6745098;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;199;-6707.691,1944.245;Inherit;False;Property;_HightLightShadowAnisoInt;Hight Light Shadow Aniso Int;5;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-4789.83,1079.073;Inherit;False;Global;AnisoSpecShininess_G;Aniso Spec Shininess_G;10;0;Create;True;0;0;0;True;0;False;0;1.34;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-4642.068,-1757.6;Inherit;False;LightTint_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;332;-4162.927,-1738.006;Inherit;False;DiffuseTint_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;331;-4395.424,-1755.829;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-3631.185,-1120.713;Inherit;True;Property;_Hair_Albedo;Hair_Albedo;0;0;Create;True;0;0;0;False;0;False;-1;75c0396b38cb94547978c60a9de43062;75c0396b38cb94547978c60a9de43062;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;264;-3513.624,-896.9893;Inherit;False;263;RampHair_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;271;-1827,-829;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;-2058,-897;Inherit;False;36;CustomLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;370;-2273.096,-729.2241;Inherit;False;368;SampleTransparency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;-2261,-814;Inherit;False;217;HairTransparency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;373;-1990.995,-775.3315;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;368;-2972.333,-1132.065;Inherit;True;SampleTransparency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;268;-1621,-617;Float;False;True;-1;2;ASEMaterialInspector;100;12;Study/MingChao/Char_Hair_F;cb0a069cd65065f4691e7feda7c4b316;True;Unlit;0;0;Unlit;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;RenderType=Opaque=RenderType;Queue=Geometry=Queue=10;False;False;0;True;True;0;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;1;False;;True;0;False;;True;True;0;False;;0;False;;False;True;2;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;2;True;True;False;;False;0
Node;AmplifyShaderEditor.WorldNormalVector;295;-2300,-454;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;231;-1934,-573;Inherit;False;232;D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;258;-6786.976,365.5401;Inherit;False;RampHair_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;374;-7302.626,339.7225;Inherit;False;368;SampleTransparency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;232;-2472.955,-52.3105;Inherit;False;D;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;345;-5188.901,-459.5;Inherit;False;Global;HairLightLerp_G;Hair Light Lerp_G;5;0;Create;True;0;0;0;True;0;False;0.34;0.395;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;336;-6772.542,-162.2672;Inherit;False;Global;HairTintDiffuseLightColor_G;Hair Tint Diffuse Light Color_G;9;0;Create;True;0;0;0;True;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;85;0;84;0
WireConnection;12;0;11;0
WireConnection;12;1;26;0
WireConnection;12;2;25;0
WireConnection;12;3;333;1
WireConnection;75;0;74;0
WireConnection;84;0;81;0
WireConnection;84;1;87;0
WireConnection;73;0;354;0
WireConnection;73;1;77;0
WireConnection;114;0;73;0
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
WireConnection;152;0;138;0
WireConnection;152;1;149;0
WireConnection;150;0;148;0
WireConnection;150;1;148;0
WireConnection;148;0;149;0
WireConnection;148;1;151;0
WireConnection;151;0;141;0
WireConnection;160;0;162;0
WireConnection;160;1;159;0
WireConnection;158;0;168;0
WireConnection;158;1;160;0
WireConnection;165;0;158;0
WireConnection;138;0;121;0
WireConnection;131;0;139;0
WireConnection;131;1;140;0
WireConnection;139;0;129;0
WireConnection;140;0;130;0
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
WireConnection;177;0;174;0
WireConnection;178;0;165;0
WireConnection;179;0;135;0
WireConnection;104;0;102;0
WireConnection;104;1;105;0
WireConnection;104;2;106;0
WireConnection;104;3;112;0
WireConnection;112;0;111;0
WireConnection;112;1;110;0
WireConnection;112;2;113;0
WireConnection;93;0;4;1
WireConnection;111;0;110;0
WireConnection;262;0;260;0
WireConnection;262;1;261;0
WireConnection;262;2;261;4
WireConnection;263;0;262;0
WireConnection;275;0;280;0
WireConnection;276;0;275;0
WireConnection;276;1;275;1
WireConnection;277;0;276;0
WireConnection;277;1;275;2
WireConnection;278;0;277;0
WireConnection;279;0;278;0
WireConnection;279;1;283;0
WireConnection;281;0;279;0
WireConnection;281;1;283;0
WireConnection;282;0;284;0
WireConnection;282;1;281;0
WireConnection;282;2;285;0
WireConnection;286;0;282;0
WireConnection;286;1;287;0
WireConnection;289;0;286;0
WireConnection;289;1;288;0
WireConnection;290;0;291;0
WireConnection;291;0;289;0
WireConnection;291;1;292;0
WireConnection;68;0;58;0
WireConnection;216;0;215;0
WireConnection;219;0;216;1
WireConnection;222;0;219;0
WireConnection;222;1;221;0
WireConnection;304;0;301;2
WireConnection;304;1;222;0
WireConnection;215;0;213;0
WireConnection;215;1;214;0
WireConnection;308;0;309;0
WireConnection;308;1;307;0
WireConnection;310;0;308;0
WireConnection;319;0;310;1
WireConnection;319;1;312;0
WireConnection;313;0;319;0
WireConnection;323;0;313;0
WireConnection;323;1;324;0
WireConnection;323;2;325;0
WireConnection;326;0;323;0
WireConnection;326;1;304;0
WireConnection;327;0;326;0
WireConnection;217;0;327;0
WireConnection;328;0;329;0
WireConnection;329;0;304;0
WireConnection;330;0;328;0
WireConnection;330;1;229;0
WireConnection;229;0;1;3
WireConnection;92;0;4;2
WireConnection;70;0;75;0
WireConnection;70;1;71;0
WireConnection;70;2;69;0
WireConnection;69;0;71;0
WireConnection;69;1;79;0
WireConnection;13;0;12;0
WireConnection;335;0;338;0
WireConnection;335;1;336;0
WireConnection;335;2;336;4
WireConnection;337;0;335;0
WireConnection;341;0;339;0
WireConnection;341;1;340;0
WireConnection;342;0;339;0
WireConnection;342;1;341;0
WireConnection;342;2;345;0
WireConnection;266;0;2;0
WireConnection;266;1;264;0
WireConnection;265;0;2;0
WireConnection;265;1;266;0
WireConnection;97;0;265;0
WireConnection;340;0;346;0
WireConnection;340;1;347;0
WireConnection;294;0;297;0
WireConnection;299;0;295;0
WireConnection;299;1;294;0
WireConnection;299;2;296;1
WireConnection;79;0;78;0
WireConnection;74;0;85;0
WireConnection;74;1;348;0
WireConnection;269;0;293;0
WireConnection;269;1;299;0
WireConnection;200;0;184;0
WireConnection;200;1;198;0
WireConnection;198;0;197;0
WireConnection;198;1;199;0
WireConnection;183;0;104;0
WireConnection;183;1;200;0
WireConnection;107;0;183;0
WireConnection;350;0;342;0
WireConnection;350;1;349;0
WireConnection;36;0;350;0
WireConnection;348;0;83;0
WireConnection;348;1;353;0
WireConnection;72;0;114;0
WireConnection;72;1;80;0
WireConnection;72;2;80;0
WireConnection;81;0;72;0
WireConnection;81;1;366;0
WireConnection;87;0;88;0
WireConnection;357;0;361;0
WireConnection;357;1;364;0
WireConnection;357;2;364;0
WireConnection;359;0;357;0
WireConnection;359;1;358;0
WireConnection;361;0;362;0
WireConnection;361;1;363;0
WireConnection;360;0;359;0
WireConnection;89;0;70;0
WireConnection;332;0;331;0
WireConnection;331;0;89;0
WireConnection;271;0;90;0
WireConnection;271;3;373;0
WireConnection;373;0;218;0
WireConnection;373;1;370;0
WireConnection;368;0;2;4
WireConnection;268;0;271;0
WireConnection;258;0;374;0
ASEEND*/
//CHKSM=0364BB1D258F8C40BFC410A3612B598AB8E397D9