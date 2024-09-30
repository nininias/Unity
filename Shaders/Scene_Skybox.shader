// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Study/MingChao/Scene_Skybox"
{
	Properties
	{
		[Header(Textures)]_Stars1("Stars1", 2D) = "white" {}
		_Size("Size", Range( 0 , 10)) = 1
		_Stars2("Stars2", 2D) = "white" {}
		[Header(Gradient Color)]_StarsColor_LUT("StarsColor_LUT", 2D) = "white" {}
		_DisortStartsNoise_1("DisortStartsNoise_1", 2D) = "white" {}
		_DisortStartsNoise_2("DisortStartsNoise_2", 2D) = "white" {}
		_StarsNoiseMask("StarsNoiseMask", 2D) = "white" {}
		_NightSky_Int("NightSky_Int", Range( 0 , 1)) = 1
		[Header(Fog1)]_FogStart1("FogStart1", Float) = 0
		_FogEnd1("FogEnd1", Float) = 0
		_FogInt1("FogInt1", Range( 0 , 1)) = 1
		[Header(Fog2)]_FogStart2("FogStart2", Float) = 0
		_FogEnd2("FogEnd2", Float) = 0
		_FogPow("FogPow", Range( 0 , 1.5)) = 1
		_FogSharp("FogSharp", Range( 0 , 1)) = 1
		_FogLerp("FogLerp", Range( 0 , 1)) = 0
		_ScreenCoordUV_Tilling("ScreenCoordUV_Tilling", Vector) = (1,1,0,0)
		_DisortNoise2_Speed("DisortNoise2_Speed", Vector) = (1,1,0,0)
		_DisortNoise2_Tilling("DisortNoise2_Tilling", Vector) = (1,1,0,0)
		_DisortNoise2_Int("DisortNoise2_Int", Range( 0 , 2)) = 0
		[Header(Stars 1)]_Stars1_Threshold("Stars1_Threshold", Range( 0 , 1)) = 1
		_Stars1_Int("Stars1_Int", Range( 0 , 2)) = 2
		_Stars1_Tilling("Stars1_Tilling", Vector) = (1,1,0,0)
		_StarsNoiseTilling1("StarsNoiseTilling1", Vector) = (0,0,0,0)
		_StarsBGColor_Int1("StarsBGColor_Int1", Float) = 1
		_StarsBG1_Color("StarsBG1_Color", Color) = (1,1,1,0)
		_StarsColor_LUT_X1("StarsColor_LUT_X1", Range( 0 , 1)) = 0
		_StarsColor_LUT_Y1("StarsColor_LUT_Y1", Range( 0 , 8)) = 0
		[Header(Stars 2)]_Stars2_Threshold("Stars2_Threshold", Range( 0 , 1)) = 0
		_Stars2_Int("Stars2_Int", Range( 0 , 2)) = 2
		_Stars2_Tilling("Stars2_Tilling", Vector) = (1,1,0,0)
		_StarsBGColor_Int2("StarsBGColor_Int2", Float) = 1
		_StarsBG2_Color("StarsBG2_Color", Color) = (1,1,1,0)
		_StarsColor_LUT_X2("StarsColor_LUT_X2", Range( 0 , 1)) = 0
		_StarsColor_LUT_Y2("StarsColor_LUT_Y2", Range( 0 , 8)) = 0
		[Header(DisortNoise1Panner)]_DisortNoise1_Speed("DisortNoise1_Speed", Vector) = (1,1,0,0)
		_DisortNoise1_Tilling("DisortNoise1_Tilling", Vector) = (1,1,0,0)
		_DisortNoise1_Int("DisortNoise1_Int", Range( 0 , 1)) = 1
		[Header(Nebula)]_BG_Nebula("BG_Nebula", 2D) = "white" {}
		_Nebula_Tilling("Nebula_Tilling", Vector) = (1,1,0,0)
		_NebulaDesignateNoise("NebulaDesignateNoise", 2D) = "white" {}
		_NebulaLuminance_Threshold("NebulaLuminance_Threshold", Range( 0 , 1)) = 0.6705883
		_NebulaDisort_Lerp("NebulaDisort_Lerp", Range( 0 , 1)) = 0
		_Nebula_Color("Nebula_Color", Color) = (1,1,1,0)
		_Nebula_Int("Nebula_Int", Float) = 1
		[Header(DisortDirt)]_DisortDirt_Map("DisortDirt_Map", 2D) = "white" {}
		_DisortDirt_Speed("DisortDirt_Speed", Float) = 1
		_DisortDirt_Color("DisortDirt_Color", Color) = (1,1,1,0)
		_DisortDirt_Tilling("DisortDirt_Tilling", Vector) = (1,1,0,0)
		_DisortDirt_Int("DisortDirt_Int", Float) = 1
		[Header(Disort Cloud)]_DisortNoise_Dirt4("DisortNoise_Dirt4", 2D) = "white" {}
		_DisortDirt_Flowmap("DisortDirt_Flowmap", 2D) = "white" {}
		_DisortNoise_Dirt6("DisortNoise_Dirt6", 2D) = "white" {}
		_DisortDirtNoise_Tilling("DisortDirtNoise_Tilling", Vector) = (1,1,0,0)
		_DisortGradualMask_Tilling("DisortGradualMask _Tilling", Vector) = (1,1,0,0)
		_DisortCloudNoise_Dirt5("DisortCloudNoise_Dirt5", 2D) = "white" {}
		_DisortCloudFlowmap_Int("DisortCloudFlowmap_Int", Range( 0 , 1)) = 0.2723568
		_DisortCloudFlowmap_DirStr("DisortCloudFlowmap_DirStr", Vector) = (1,1,0,0)
		_DisortCloud_Speed("DisortCloud_Speed", Vector) = (1,0,0,0)
		_Cloud_Int("Cloud_Int", Range( 0 , 1)) = 0
		_CloudColor("CloudColor", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _StarsColor_LUT;
		uniform float _StarsColor_LUT_X1;
		uniform float _StarsColor_LUT_Y1;
		uniform float4 _StarsBG1_Color;
		uniform float _StarsBGColor_Int1;
		uniform sampler2D _StarsNoiseMask;
		uniform float2 _StarsNoiseTilling1;
		uniform float _FogEnd1;
		uniform float _FogStart1;
		uniform float _FogInt1;
		uniform float _FogSharp;
		uniform float _FogEnd2;
		uniform float _FogStart2;
		uniform float _FogPow;
		uniform float _FogLerp;
		uniform float _NightSky_Int;
		uniform sampler2D _Stars1;
		uniform float4 _ScreenCoordUV_Tilling;
		uniform float4 _Stars1_Tilling;
		uniform float _Stars1_Threshold;
		uniform float _Stars1_Int;
		uniform sampler2D _DisortStartsNoise_2;
		uniform float2 _DisortNoise2_Speed;
		uniform float4 _DisortNoise2_Tilling;
		uniform float _DisortNoise2_Int;
		uniform sampler2D _Stars2;
		uniform float4 _Stars2_Tilling;
		uniform float _Stars2_Threshold;
		uniform float _Stars2_Int;
		uniform float _StarsColor_LUT_X2;
		uniform float _StarsColor_LUT_Y2;
		uniform float4 _StarsBG2_Color;
		uniform float _StarsBGColor_Int2;
		uniform sampler2D _BG_Nebula;
		uniform float4 _Nebula_Tilling;
		uniform float4 _Nebula_Color;
		uniform float _Nebula_Int;
		uniform float _NebulaLuminance_Threshold;
		uniform sampler2D _NebulaDesignateNoise;
		uniform sampler2D _DisortStartsNoise_1;
		uniform float2 _DisortNoise1_Speed;
		uniform float4 _DisortNoise1_Tilling;
		uniform float _DisortNoise1_Int;
		uniform float _NebulaDisort_Lerp;
		uniform sampler2D _DisortDirt_Map;
		uniform float4 _DisortDirt_Tilling;
		uniform sampler2D _DisortDirt_Flowmap;
		uniform float _Size;
		uniform float _DisortDirt_Speed;
		uniform float4 _DisortDirt_Color;
		uniform float _DisortDirt_Int;
		uniform sampler2D _DisortNoise_Dirt4;
		uniform float2 _DisortCloud_Speed;
		uniform float4 _DisortDirtNoise_Tilling;
		uniform sampler2D _DisortCloudNoise_Dirt5;
		uniform float4 _DisortCloudFlowmap_DirStr;
		uniform float _DisortCloudFlowmap_Int;
		uniform sampler2D _DisortNoise_Dirt6;
		uniform float4 _DisortGradualMask_Tilling;
		uniform float _Cloud_Int;
		uniform float4 _CloudColor;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 _Vector4 = float2(1,8);
			float2 temp_output_92_0 = ( ( (ase_screenPosNorm).xy / float2( 128,128 ) ) * _Vector4 );
			float2 appendResult82 = (float2((1.0 + (_StarsColor_LUT_X1 - 0.0) * (128.8 - 1.0) / (1.0 - 0.0)) , (0.985 + (_StarsColor_LUT_Y1 - 0.0) * (1.032 - 0.985) / (8.0 - 0.0))));
			float4 StarsColor_LUT1183 = ( tex2D( _StarsColor_LUT, ( ( temp_output_92_0 + ( appendResult82 * float2( 0.0078125,0.0078125 ) * float2( 1,980 ) ) ) / _Vector4 ) ) * _StarsBG1_Color * _StarsBGColor_Int1 );
			float StarsNoise1_Mask134 = tex2D( _StarsNoiseMask, ( (ase_screenPosNorm).xy + ( _StarsNoiseTilling1 * 0.1 ) ) ).r;
			float3 ase_worldPos = i.worldPos;
			float FogFactor1180 = ( StarsNoise1_Mask134 * ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - _FogEnd1 ) / ( _FogStart1 - _FogEnd1 ) ) * _FogInt1 );
			float4 temp_output_194_0 = ( StarsColor_LUT1183 * FogFactor1180 );
			float smoothstepResult213 = smoothstep( 0.0 , _FogSharp , pow( saturate( ( StarsNoise1_Mask134 * ( ( distance( ase_worldPos , _WorldSpaceCameraPos ) - _FogEnd2 ) / ( _FogStart2 - _FogEnd2 ) ) ) ) , _FogPow ));
			float FogFactor2203 = smoothstepResult213;
			float4 lerpResult216 = lerp( temp_output_194_0 , ( temp_output_194_0 + FogFactor2203 ) , _FogLerp);
			float4 NightSkybox_BG218 = ( lerpResult216 * _NightSky_Int );
			float2 appendResult5 = (float2(0.5 , 0.5));
			float2 temp_output_6_0 = ( appendResult5 * 0.5 );
			float2 ScreenCoords_UV18 = ( ( ( ( ( i.uv_texcoord - temp_output_6_0 ) * float2( 1,1 ) ) + temp_output_6_0 ) * 10.0 * ( (_ScreenCoordUV_Tilling).xy + float2( 0.5,0 ) ) ) + (_ScreenCoordUV_Tilling).zw );
			float4 temp_cast_0 = (_Stars1_Threshold).xxxx;
			float4 Stars1_Num45 = ( saturate( ( tex2D( _Stars1, (ScreenCoords_UV18*(_Stars1_Tilling).xy + (_Stars1_Tilling).zw) ) - temp_cast_0 ) ) * _Stars1_Int * 100.0 );
			float2 panner235 = ( 1.0 * _Time.y * _DisortNoise2_Speed + (ScreenCoords_UV18*(_DisortNoise2_Tilling).xy + (_DisortNoise2_Tilling).zw));
			float4 temp_cast_1 = (_DisortNoise2_Int).xxxx;
			float4 break250 = pow( tex2D( _DisortStartsNoise_2, panner235 ) , temp_cast_1 );
			float DisortStartsNoise_2_R44 = saturate( break250.r );
			float4 Stars1_Color265 = ( Stars1_Num45 * DisortStartsNoise_2_R44 * StarsColor_LUT1183 );
			float4 temp_cast_2 = (_Stars2_Threshold).xxxx;
			float4 Stars2_Num273 = ( saturate( ( tex2D( _Stars2, (ScreenCoords_UV18*(_Stars2_Tilling).xy + (_Stars2_Tilling).zw) ) - temp_cast_2 ) ) * _Stars2_Int * 100.0 );
			float DisortStartsNoise_2_G241 = saturate( break250.g );
			float2 appendResult108 = (float2((1.0 + (_StarsColor_LUT_X2 - 0.0) * (128.8 - 1.0) / (1.0 - 0.0)) , (0.985 + (_StarsColor_LUT_Y2 - 0.0) * (1.032 - 0.985) / (8.0 - 0.0))));
			float4 StarsColor_LUT2184 = ( tex2D( _StarsColor_LUT, ( ( temp_output_92_0 + ( appendResult108 * float2( 0.0078125,0.0078125 ) * float2( 1,980 ) ) ) / _Vector4 ) ) * _StarsBG2_Color * _StarsBGColor_Int2 );
			float4 Stars2_Color277 = ( Stars2_Num273 * DisortStartsNoise_2_G241 * StarsColor_LUT2184 );
			float4 temp_output_317_0 = ( _Nebula_Tilling * 0.1 );
			float4 temp_output_358_0 = ( tex2D( _BG_Nebula, ( (ScreenCoords_UV18*(temp_output_317_0).xy + (temp_output_317_0).zw) + (half4(0,0,0,0)).rg ) ) * _Nebula_Color * _Nebula_Int );
			float luminance336 = Luminance(temp_output_358_0.rgb);
			float4 _DesignateNebulaNoise_Tilling = float4(1,1,-7.15,-4.47);
			float DesignateNebulaNoise_Mask334 = tex2D( _NebulaDesignateNoise, (ScreenCoords_UV18*(_DesignateNebulaNoise_Tilling).xy + (_DesignateNebulaNoise_Tilling).zw) ).r;
			float2 panner293 = ( 1.0 * _Time.y * _DisortNoise1_Speed + (ScreenCoords_UV18*(_DisortNoise1_Tilling).xy + (( _DisortNoise1_Tilling * 0.1 )).zw));
			float4 tex2DNode33 = tex2D( _DisortStartsNoise_1, panner293 );
			float DisortStartsNoise_2_B242 = saturate( break250.b );
			float DisortStartsNoise_1_Big43 = ( min( ( tex2DNode33.r * _DisortNoise1_Int ) , DisortStartsNoise_2_B242 ) * tex2DNode33.r );
			float4 temp_output_323_0 = ( temp_output_358_0 * DesignateNebulaNoise_Mask334 * DisortStartsNoise_1_Big43 );
			float4 temp_output_342_0 = ( ( saturate( luminance336 ) - _NebulaLuminance_Threshold ) * temp_output_323_0 );
			float4 lerpResult349 = lerp( ( ( temp_output_358_0 + temp_output_342_0 ) * 2.0 ) , ( temp_output_342_0 + temp_output_323_0 ) , _NebulaDisort_Lerp);
			float4 Nebula_Color319 = lerpResult349;
			float2 temp_output_4_0_g2 = (( ScreenCoords_UV18 / _Size )).xy;
			float2 temp_output_17_0_g2 = float2( 1,1 );
			float mulTime22_g2 = _Time.y * ( _DisortDirt_Speed * 0.01 );
			float temp_output_27_0_g2 = frac( mulTime22_g2 );
			float2 temp_output_11_0_g2 = ( temp_output_4_0_g2 + ( -(-(i.vertexColor).rg*2.0 + -1.0) * temp_output_17_0_g2 * temp_output_27_0_g2 ) );
			float2 temp_output_12_0_g2 = ( temp_output_4_0_g2 + ( -(-(i.vertexColor).rg*2.0 + -1.0) * temp_output_17_0_g2 * frac( ( mulTime22_g2 + 0.5 ) ) ) );
			float4 lerpResult9_g2 = lerp( tex2D( _DisortDirt_Flowmap, temp_output_11_0_g2 ) , tex2D( _DisortDirt_Flowmap, temp_output_12_0_g2 ) , ( abs( ( temp_output_27_0_g2 - 0.5 ) ) / 0.5 ));
			float4 DisortDirt_Color397 = ( tex2D( _DisortDirt_Map, ( (ScreenCoords_UV18*(_DisortDirt_Tilling).xy + (_DisortDirt_Tilling).zw) + (lerpResult9_g2).rg ) ) * _DisortDirt_Color * _DisortDirt_Int );
			float2 temp_output_4_0_g4 = (( ScreenCoords_UV18 / _Size )).xy;
			float2 temp_output_17_0_g4 = (_DisortCloudFlowmap_DirStr).zw;
			float mulTime22_g4 = _Time.y * 0.2;
			float temp_output_27_0_g4 = frac( mulTime22_g4 );
			float2 temp_output_11_0_g4 = ( temp_output_4_0_g4 + ( -((_DisortCloudFlowmap_DirStr).xy*2.0 + -1.0) * temp_output_17_0_g4 * temp_output_27_0_g4 ) );
			float2 temp_output_12_0_g4 = ( temp_output_4_0_g4 + ( -((_DisortCloudFlowmap_DirStr).xy*2.0 + -1.0) * temp_output_17_0_g4 * frac( ( mulTime22_g4 + 0.5 ) ) ) );
			float4 lerpResult9_g4 = lerp( tex2D( _DisortCloudNoise_Dirt5, temp_output_11_0_g4 ) , tex2D( _DisortCloudNoise_Dirt5, temp_output_12_0_g4 ) , ( abs( ( temp_output_27_0_g4 - 0.5 ) ) / 0.5 ));
			float4 DisortCloudNoise_Flowmap435 = ( lerpResult9_g4 * _DisortCloudFlowmap_Int );
			float2 panner450 = ( 1.0 * _Time.y * ( _DisortCloud_Speed * float2( 0.1,0.1 ) ) + ( (ScreenCoords_UV18*(_DisortDirtNoise_Tilling).xy + (_DisortDirtNoise_Tilling).zw) + (DisortCloudNoise_Flowmap435).rg ));
			float4 temp_output_429_0 = ( _DisortGradualMask_Tilling * 0.01 );
			float4 Cloud_Color431 = ( tex2D( _DisortNoise_Dirt4, panner450 ) * tex2D( _DisortNoise_Dirt6, (ScreenCoords_UV18*(temp_output_429_0).xy + (temp_output_429_0).zw) ) * StarsNoise1_Mask134 * _Cloud_Int * _CloudColor );
			float4 FinalColor312 = ( ( NightSkybox_BG218 + ( ( Stars1_Color265 + Stars2_Color277 ) * DisortStartsNoise_2_R44 ) ) + Nebula_Color319 + DisortDirt_Color397 + Cloud_Color431 );
			o.Emission = FinalColor312.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;456;-688.926,5731.173;Inherit;False;2147.353;1389.059;Comment;26;455;419;420;417;421;429;418;430;385;450;410;411;413;414;412;437;451;452;438;436;431;415;386;416;449;453;Cloud;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;455;-587.7335,6569.939;Inherit;False;1449.17;550.292;Comment;9;435;434;433;443;444;432;442;440;441;CloudFlowmap;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;409;-740.4959,4912.195;Inherit;False;2174.26;697.7021;Comment;18;390;389;391;394;392;393;399;401;402;400;404;388;405;406;407;408;395;397;DisortDirt;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;361;-765.4086,3770.504;Inherit;False;3990.497;1035.635;Comment;36;319;328;322;311;325;338;334;329;331;332;327;339;337;336;351;360;359;358;342;310;335;318;315;316;317;314;313;357;355;349;350;323;344;374;375;376;Nebula;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;301;-3373.922,3854.088;Inherit;False;2497.78;656.8691;Comment;16;346;43;305;306;294;296;299;33;38;300;298;297;295;293;347;348;DisortNoise1Panner_Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;281;-1138.922,2908.236;Inherit;False;1721.273;700.1787;Comment;18;275;279;268;271;277;276;274;273;270;272;269;267;41;36;289;290;291;292;Stars 2;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;258;-3380.313,2868.45;Inherit;False;2044.005;696.917;Comment;18;35;261;257;45;265;264;256;259;238;222;240;40;262;260;285;286;287;288;Stars 1;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;239;-3355.479,4728.408;Inherit;False;2252.715;424.9072;Comment;17;248;254;34;252;253;251;250;242;241;44;235;244;237;246;245;243;39;DisortNoise2Panner_Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;221;720.7816,2956.604;Inherit;False;1354.129;463.8418;Comment;10;193;194;208;195;216;190;217;218;219;220;BGNightSky;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;189;-1169.026,1513.132;Inherit;False;2127.021;1145.312;Comment;36;57;76;72;92;91;79;82;86;99;100;96;107;108;109;110;111;112;113;114;98;85;115;116;94;97;56;106;117;118;119;103;104;102;37;183;184;ScreenStarsColor_BG;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;181;-3378,1439;Inherit;False;2077.207;983.2432;Comment;29;182;179;180;178;177;175;176;173;172;171;170;196;197;198;199;200;201;202;203;204;205;206;207;209;210;212;213;214;174;LinearFog;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;136;-1521.602,579.2175;Inherit;False;2125.806;683.2581;Comment;23;162;157;160;159;152;156;158;144;151;149;134;150;148;147;146;140;142;141;132;133;139;130;164;Mask1;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;135;-3363.182,520.7119;Inherit;False;1746.469;672.5911;Comment;18;5;6;9;10;15;7;3;4;17;16;27;18;126;227;229;232;231;233;ScreenCoord_UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-3162.182,714.32;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-2987.182,739.3201;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-3070.607,570.7119;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;10;-2802.501,663.4597;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3159.182,806.3198;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-3310.182,649.32;Inherit;False;Constant;_Float5;Float 5;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3313.182,729.3201;Inherit;False;Constant;_Float6;Float 6;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2606.047,673.5562;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;139;-965.4452,655.9946;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;133;-1249.84,610.4257;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;132;-1517.602,617.2175;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-1118.445,706.9946;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-1266.445,808.9946;Inherit;False;Constant;_Float3;Float 3;19;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;140;-1317.445,682.9946;Inherit;False;Property;_StarsNoiseTilling1;StarsNoiseTilling1;25;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;146;-938.5707,958.1486;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;147;-1222.965,912.5798;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;148;-1490.727,919.3718;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;150;-1239.57,1111.148;Inherit;False;Constant;_Float4;Float 4;19;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-1089.57,999.1485;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;151;-1288.57,983.1486;Inherit;False;Property;_StarsNoiseTilling2;StarsNoiseTilling2;33;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;144;-796.0058,926.7967;Inherit;True;Property;_StarsNoiseMask2;StarsNoiseMask2;5;0;Create;True;0;0;0;False;0;False;-1;2bfb8742fdc10c44fb510ff6db8dd65c;2bfb8742fdc10c44fb510ff6db8dd65c;True;0;False;white;Auto;False;Instance;130;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;156;-283.0504,964.4527;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;162;-374.0507,1121.452;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-229.0505,1095.452;Inherit;False;Property;_StarsNoise2_Int;StarsNoise2_Int;34;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;164;56.73724,1083.713;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;15;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-521.3906,1013.773;Inherit;False;Constant;_Float7;Float 7;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-531.5759,1102.562;Inherit;False;Constant;_StarsNoise;StarsNoise;20;0;Create;True;0;0;0;False;0;False;0.23;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;159;209.9501,957.4527;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;57;-752.8745,1573.129;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;76;-579.0547,1571.578;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;72;-813.73,1662.773;Inherit;False;Constant;_Vector1;Vector 1;9;0;Create;True;0;0;0;False;0;False;128,128;128,8;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-412.5756,1595.411;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;91;-634.5756,1688.412;Inherit;False;Constant;_Vector4;Vector 4;11;0;Create;True;0;0;0;False;0;False;1,8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-376.0089,1839.121;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;-570.6084,1843.721;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;86;-593.8754,1934.596;Inherit;False;Constant;_Vector3;Vector 3;11;0;Create;True;0;0;0;False;0;False;0.0078125,0.0078125;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode;99;-831.8271,1852.867;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;128.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;100;-830.8271,2025.067;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;8;False;3;FLOAT;0.985;False;4;FLOAT;1.032;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;96;-571.1694,2060.607;Inherit;False;Constant;_Vector5;Vector 5;11;0;Create;True;0;0;0;False;0;False;1,980;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-359.6635,2265.5;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;108;-554.2632,2270.1;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;109;-577.5303,2360.975;Inherit;False;Constant;_Vector2;Vector 2;11;0;Create;True;0;0;0;False;0;False;0.0078125,0.0078125;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode;110;-815.4819,2279.246;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;128.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;111;-814.4819,2451.445;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;8;False;3;FLOAT;0.985;False;4;FLOAT;1.032;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;112;-554.8242,2486.985;Inherit;False;Constant;_Vector6;Vector 6;11;0;Create;True;0;0;0;False;0;False;1,980;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-203.519,1596.149;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-142.6672,2234.263;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;116;20.97014,2233.472;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;94;-4.750805,1606.147;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;56;-994.9189,1578.483;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;106;159.976,2137.727;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;32975360a084d2541abd84770d1f2241;32975360a084d2541abd84770d1f2241;True;0;False;white;Auto;False;Instance;37;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;585.6804,2136.01;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;119;265.5256,2505.17;Inherit;False;Property;_StarsBGColor_Int2;StarsBGColor_Int2;35;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;531.6205,1601.052;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;184;723.9949,2137.687;Inherit;False;StarsColor_LUT2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;770.7815,3006.604;Inherit;False;183;StarsColor_LUT1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;1059.779,3078.604;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;208;1036.666,3213.183;Inherit;False;203;FogFactor2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;1241.779,3141.604;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;216;1441.574,3084.445;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;790.6759,3113.056;Inherit;False;180;FogFactor1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;217;1028.573,3304.445;Inherit;False;Property;_FogLerp;FogLerp;17;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;1683.909,3098.282;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;682.8921,1593.536;Inherit;False;StarsColor_LUT1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-2374.046,686.5562;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2146.613,683.3032;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;227;-1979.569,705.0142;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-2394.485,774.2507;Inherit;False;Constant;_Float1;Float 1;17;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;231;-2495.569,851.0142;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-3303.963,4778.408;Inherit;False;18;ScreenCoords_UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;243;-2909.264,4778.473;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;245;-3125.339,4831.497;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;246;-3131.339,4918.497;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;235;-2616.387,4810.801;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;250;-1849.675,4799.498;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;34;-2414.1,4790.092;Inherit;True;Property;_DisortStartsNoise_2;DisortStartsNoise_2;7;0;Create;True;0;0;0;False;0;False;-1;5a0ee83140399fe4ea78cca8450a1c15;5a0ee83140399fe4ea78cca8450a1c15;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;254;-2050.675,4795.498;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;130;-792.6747,674.973;Inherit;True;Property;_StarsNoiseMask;StarsNoiseMask;8;0;Create;True;0;0;0;False;0;False;-1;2bfb8742fdc10c44fb510ff6db8dd65c;2bfb8742fdc10c44fb510ff6db8dd65c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;40;-3330.313,2942.415;Inherit;False;18;ScreenCoords_UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;-2994.114,3272.373;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;222;-3316.665,3336.098;Inherit;False;44;DisortStartsNoise_2_R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;-3272.321,3255.469;Inherit;False;45;Stars1_Num;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;259;-3287.167,3414.361;Inherit;False;183;StarsColor_LUT1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-2819.538,3272.413;Inherit;False;Stars1_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-1416.889,4806.828;Inherit;False;DisortStartsNoise_2_R;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;241;-1419.404,4884.193;Inherit;False;DisortStartsNoise_2_G;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;251;-1669.675,4800.498;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;253;-1654.675,4956.497;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;252;-1669.675,4881.498;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;242;-1403.404,4970.193;Inherit;False;DisortStartsNoise_2_B;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;156.7504,1569.132;Inherit;True;Property;_StarsColor_LUT;StarsColor_LUT;5;1;[Header];Create;True;1;Gradient Color;0;0;False;0;False;-1;32975360a084d2541abd84770d1f2241;32975360a084d2541abd84770d1f2241;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;118;260.6196,2334.37;Inherit;False;Property;_StarsBG2_Color;StarsBG2_Color;36;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;41;-1088.922,2982.791;Inherit;False;18;ScreenCoords_UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;274;-657.8068,3336.576;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;276;-914.0492,3326.213;Inherit;False;273;Stars2_Num;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;277;-456.7121,3347.399;Inherit;False;Stars2_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;279;-950.2726,3403.722;Inherit;False;241;DisortStartsNoise_2_G;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;-944.0492,3503.213;Inherit;False;184;StarsColor_LUT2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;103;235.2864,1755.026;Inherit;False;Property;_StarsBG1_Color;StarsBG1_Color;27;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;260;-2515.445,2933.214;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;262;-2311.445,2960.214;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;-1972.696,2952.792;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;261;-2800.446,3115.214;Inherit;False;Property;_Stars1_Threshold;Stars1_Threshold;22;1;[Header];Create;True;1;Stars 1;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-2817.014,2932.686;Inherit;True;Property;_Stars1;Stars1;0;1;[Header];Create;True;1;Textures;0;0;False;0;False;-1;8cbe79c7ab2227240b99a8fc1bb6b066;8cbe79c7ab2227240b99a8fc1bb6b066;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;-621.1705,2951.118;Inherit;True;Property;_Stars2;Stars2;4;0;Create;True;0;0;0;False;0;False;-1;3d2ce3c2b96432243ab626da02b296c7;3d2ce3c2b96432243ab626da02b296c7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;267;-268.7667,2953.681;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;269;-101.3789,2960.601;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;270;187.23,2959.395;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;268;-598.3517,3144.669;Inherit;False;Property;_Stars2_Threshold;Stars2_Threshold;30;1;[Header];Create;True;1;Stars 2;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;285;-3070.764,2965.538;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;286;-3336.764,3058.538;Inherit;False;Property;_Stars1_Tilling;Stars1_Tilling;24;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;287;-3176.764,3062.538;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;288;-3172.764,3150.538;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;289;-829.9376,3020.288;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;290;-1112.937,3126.288;Inherit;False;Property;_Stars2_Tilling;Stars2_Tilling;32;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;291;-952.9376,3130.288;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;292;-948.9376,3218.288;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;272;-82.71091,3113.872;Inherit;False;Constant;_Float8;Float 8;32;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-1119.026,1844.967;Inherit;False;Property;_StarsColor_LUT_X1;StarsColor_LUT_X1;28;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-1112.026,2028.968;Inherit;False;Property;_StarsColor_LUT_Y1;StarsColor_LUT_Y1;29;0;Create;True;0;0;0;False;0;False;0;0;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1102.681,2271.346;Inherit;False;Property;_StarsColor_LUT_X2;StarsColor_LUT_X2;37;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-1095.681,2455.345;Inherit;False;Property;_StarsColor_LUT_Y2;StarsColor_LUT_Y2;38;0;Create;True;0;0;0;False;0;False;0;0;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;271;-190.8129,3039.992;Inherit;False;Property;_Stars2_Int;Stars2_Int;31;0;Create;True;0;0;0;False;0;False;2;4;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;257;-2365.453,3050.197;Inherit;False;Property;_Stars1_Int;Stars1_Int;23;0;Create;True;0;0;0;False;0;False;2;4;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;264;-2236.809,3133.327;Inherit;False;Constant;_Float2;Float 2;32;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;231.1927,1929.826;Inherit;False;Property;_StarsBGColor_Int1;StarsBGColor_Int1;26;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;293;-2120.53,3925.608;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;295;-2484.922,3905.847;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;297;-2761.922,3996.847;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;298;-2762.922,4091.848;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;300;-3201.922,4164.848;Inherit;False;Constant;_Float9;Float 9;38;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-3231.818,3905.277;Inherit;False;18;ScreenCoords_UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;33;-1924.455,3904.368;Inherit;True;Property;_DisortStartsNoise_1;DisortStartsNoise_1;6;0;Create;True;0;0;0;False;0;False;-1;70e3e3256cbb5f740b1957db13f7c462;70e3e3256cbb5f740b1957db13f7c462;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;-2967.922,4071.848;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;220;1414.409,3235.682;Inherit;False;Property;_NightSky_Int;NightSky_Int;9;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;1839.246,3099.234;Inherit;False;NightSkybox_BG;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-1853.713,706.8742;Inherit;False;ScreenCoords_UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-1637.258,2948.436;Inherit;False;Stars1_Num;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;273;369.9556,2959.529;Inherit;False;Stars2_Num;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;378.1497,944.0177;Inherit;False;StarsNoise2_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;-1617.82,3908.72;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;347;-1480.033,3910.893;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;348;-1314.784,3919.333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;314;-715.4086,4237.687;Inherit;False;Property;_Nebula_Tilling;Nebula_Tilling;43;0;Create;True;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;317;-523.4087,4266.687;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;316;-330.4086,4348.687;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;315;-332.4086,4273.687;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;318;-599.3087,4412.089;Inherit;False;Constant;_Float10;Float 10;41;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;327;-185.3387,3820.504;Inherit;False;18;ScreenCoords_UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;332;208.7077,3941.312;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;334;888.8654,3866.947;Inherit;False;DesignateNebulaNoise_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;325;577.252,3837.527;Inherit;True;Property;_NebulaDesignateNoise;NebulaDesignateNoise;44;0;Create;True;0;0;0;False;0;False;-1;0ea7944d8f9c3214b95d49a23e5ac954;0ea7944d8f9c3214b95d49a23e5ac954;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;311;-469.5158,4174.439;Inherit;False;18;ScreenCoords_UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;244;-3327.339,4850.497;Inherit;False;Property;_DisortNoise2_Tilling;DisortNoise2_Tilling;20;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;237;-2899.479,4893.976;Inherit;False;Property;_DisortNoise2_Speed;DisortNoise2_Speed;19;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;248;-2389.582,4982.829;Inherit;False;Property;_DisortNoise2_Int;DisortNoise2_Int;21;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;296;-3323.922,3991.847;Inherit;False;Property;_DisortNoise1_Tilling;DisortNoise1_Tilling;40;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;294;-2498.53,4033.608;Inherit;False;Property;_DisortNoise1_Speed;DisortNoise1_Speed;39;1;[Header];Create;True;1;DisortNoise1Panner;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;306;-1871.82,4096.72;Inherit;False;Property;_DisortNoise1_Int;DisortNoise1_Int;41;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;346;-1807.353,4182.744;Inherit;False;242;DisortStartsNoise_2_B;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-1165.193,3902.969;Inherit;False;DisortStartsNoise_1_Big;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;328;359.7872,3852.235;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;170;-3330,1631;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;171;-3266,1487;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;172;-3010,1567;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;173;-2786,1551;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;175;-2770,1727;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;177;-2530,1631;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-2562,1551;Inherit;False;134;StarsNoise1_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-2290,1599;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;196;-3282,2127;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;197;-3234,1967;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;198;-2962,2047;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;199;-2738,2047;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;200;-2722,2207;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-2930,1823;Inherit;False;Property;_FogEnd2;FogEnd2;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;201;-2594,2127;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-2898,2159;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;300;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;-2594,2031;Inherit;False;134;StarsNoise1_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;-2370,2063;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;214;-2242,2079;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;210;-2082,2095;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;213;-1922,2095;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;203;-1602,2095;Inherit;False;FogFactor2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;206;-3010,2095;Inherit;False;Property;_FogStart2;FogStart2;13;1;[Header];Create;True;1;Fog2;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;207;-2338,2031;Inherit;False;Property;_FogPow;FogPow;15;0;Create;True;0;0;0;False;0;False;1;1;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;212;-2338,2127;Inherit;False;Property;_FogSharp;FogSharp;16;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-2946,1583;Inherit;False;Property;_FogStart1;FogStart1;10;1;[Header];Create;True;1;Fog1;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-2530,1615;Inherit;False;Property;_FogInt1;FogInt1;12;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-1618,1615;Inherit;False;FogFactor1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;174;-2971,1512;Inherit;False;Property;_FogEnd1;FogEnd1;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;350;2149.096,4102.031;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LuminanceNode;336;1437.039,4034.983;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;337;1742.312,4042.598;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;339;1591.312,4037.598;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;331;212.7076,4017.311;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;329;-242.5681,3910.139;Inherit;False;Constant;_DesignateNebulaNoise_Tilling;DesignateNebulaNoise_Tilling;41;0;Create;True;0;0;0;False;0;False;1,1,-7.15,-4.47;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;344;2215.583,4355.4;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;323;1594.294,4371.361;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;349;2792.745,4324.358;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;355;2587.809,4134.188;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;357;2471.136,4244.438;Inherit;False;Constant;_Float12;Float 12;44;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;335;1320.421,4478.214;Inherit;False;334;DesignateNebulaNoise_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;310;736.0926,4181.715;Inherit;True;Property;_BG_Nebula;BG_Nebula;42;1;[Header];Create;True;1;Nebula;0;0;False;0;False;-1;54997d379d47de24a982561cabfd3d81;54997d379d47de24a982561cabfd3d81;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;342;1968.6,4181.105;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;358;1101.475,4150.398;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;359;831.7758,4393.697;Inherit;False;Property;_Nebula_Color;Nebula_Color;47;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;360;860.6749,4579.484;Inherit;False;Property;_Nebula_Int;Nebula_Int;48;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;351;2480.884,4472.692;Inherit;False;Property;_NebulaDisort_Lerp;NebulaDisort_Lerp;46;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;1492.289,4238.688;Inherit;False;Property;_NebulaLuminance_Threshold;NebulaLuminance_Threshold;45;0;Create;True;0;0;0;False;0;False;0.6705883;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;322;1330.955,4561.157;Inherit;False;43;DisortStartsNoise_1_Big;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;319;2978.559,4313.393;Inherit;False;Nebula_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;313;-105.7125,4215.038;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;375;-15.40138,4362.598;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;376;217.5986,4366.598;Inherit;False;FLOAT2;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;374;385.6469,4213.456;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;390;-601.763,5037.126;Inherit;True;Property;_DisortDirt_Flowmap;DisortDirt_Flowmap;55;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;389;-286.5823,5248.045;Inherit;False;Flow;1;;2;acad10cc8145e1f4eb8042bebe2d9a42;2,50,0,51,0;6;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;55;FLOAT;1;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.2;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;391;-588.763,5236.126;Inherit;False;18;ScreenCoords_UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;394;-35.06431,5243.195;Inherit;False;FLOAT2;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;392;-215.0643,4962.195;Inherit;False;18;ScreenCoords_UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;393;491.2063,5145.664;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;399;188.886,4976.025;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;401;13.88601,5036.025;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;402;11.88601,5111.025;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;400;-221.114,5045.025;Inherit;False;Property;_DisortDirt_Tilling;DisortDirt_Tilling;52;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;404;1028.599,5119.897;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;405;703.5983,5312.897;Inherit;False;Property;_DisortDirt_Color;DisortDirt_Color;51;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;406;763.5983,5493.897;Inherit;False;Property;_DisortDirt_Int;DisortDirt_Int;53;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;407;-458.439,5355.607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;408;-653.4389,5430.607;Inherit;False;Constant;_Float13;Float 13;56;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;395;-690.4959,5348.961;Inherit;False;Property;_DisortDirt_Speed;DisortDirt_Speed;50;0;Create;True;0;0;0;False;0;False;1;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;397;1200.765,5128.101;Inherit;False;DisortDirt_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;388;620.9813,5122.9;Inherit;True;Property;_DisortDirt_Map;DisortDirt_Map;49;1;[Header];Create;True;1;DisortDirt;0;0;False;0;False;-1;3eccb9b9da1df174f90b8ddbb37792a0;3eccb9b9da1df174f90b8ddbb37792a0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;380.9708,684.2548;Inherit;False;StarsNoise1_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;15;-2821.647,789.6564;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;233;-2330.569,845.0142;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;232;-2340.569,953.0142;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;229;-2882.209,913.714;Inherit;False;Property;_ScreenCoordUV_Tilling;ScreenCoordUV_Tilling;18;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;419;-167.3371,6205.193;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;420;-167.3371,6276.193;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;417;-232.4786,6117.834;Inherit;False;18;ScreenCoords_UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;421;-591.6663,6206.134;Inherit;False;Property;_DisortGradualMask_Tilling;DisortGradualMask _Tilling;58;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;429;-319.9821,6225.95;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;418;94.20903,6152.929;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;430;-480.9819,6389.95;Inherit;False;Constant;_Float11;Float 11;58;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;410;-638.926,5789.912;Inherit;False;18;ScreenCoords_UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;411;-238.2581,5799.603;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;413;-398.7043,5868.367;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;414;-389.7043,5944.367;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;412;-638.0594,5878.788;Inherit;False;Property;_DisortDirtNoise_Tilling;DisortDirtNoise_Tilling;57;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;437;-218.951,5929.581;Inherit;False;435;DisortCloudNoise_Flowmap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;451;-71.8118,6002.173;Inherit;False;Property;_DisortCloud_Speed;DisortCloud_Speed;62;0;Create;True;0;0;0;False;0;False;1,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;452;145.2902,6012.82;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;438;27.04902,5928.581;Inherit;False;FLOAT2;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;436;207.0491,5794.581;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;415;1044.351,5883.575;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;386;586.0663,6033.995;Inherit;True;Property;_DisortNoise_Dirt6;DisortNoise_Dirt6;56;0;Create;True;0;0;0;False;0;False;-1;b570ba6e0b0a33349980ba6ee8db8a28;b570ba6e0b0a33349980ba6ee8db8a28;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;416;671.6456,6222.688;Inherit;False;134;StarsNoise1_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;449;623.616,6304.383;Inherit;False;Property;_Cloud_Int;Cloud_Int;63;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;435;573.4362,6803.558;Inherit;False;DisortCloudNoise_Flowmap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;434;-308.0664,6799.164;Inherit;False;18;ScreenCoords_UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;433;-333.9676,6619.939;Inherit;True;Property;_DisortCloudNoise_Dirt5;DisortCloudNoise_Dirt5;59;0;Create;True;0;0;0;False;0;False;5fb5a5086e739ba49adbbd38a775b388;5fb5a5086e739ba49adbbd38a775b388;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;453;694.0726,6386.078;Inherit;False;Property;_CloudColor;CloudColor;64;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;431;1197.638,5890.016;Inherit;False;Cloud_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;385;585.5096,5819.397;Inherit;True;Property;_DisortNoise_Dirt4;DisortNoise_Dirt4;54;1;[Header];Create;True;1;Disort Cloud;0;0;False;0;False;-1;260173573a981fe4f822043b056301a1;260173573a981fe4f822043b056301a1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;450;364.0883,5839.673;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;443;-264.7336,6869.231;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;444;-264.7336,6965.231;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;432;27.03258,6825.939;Inherit;False;Flow;1;;4;acad10cc8145e1f4eb8042bebe2d9a42;2,50,0,51,0;6;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;55;FLOAT;1;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.2;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;442;-537.7335,6886.231;Inherit;False;Property;_DisortCloudFlowmap_DirStr;DisortCloudFlowmap_DirStr;61;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;440;25.26632,7004.231;Inherit;False;Property;_DisortCloudFlowmap_Int;DisortCloudFlowmap_Int;60;0;Create;True;0;0;0;False;0;False;0.2723568;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;441;348.2663,6831.231;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;458;4347.239,4513.743;Inherit;True;Property;_DisortStartsNoise_4;DisortStartsNoise_4;65;1;[Header];Create;True;1;Dissociative Stars;0;0;False;0;False;-1;6df8192abdc98274187083b4d21d7479;6df8192abdc98274187083b4d21d7479;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;462;4062.629,4513.436;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;463;3867.629,4525.436;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;466;3838.629,4710.436;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;283;4128,4064;Inherit;False;277;Stars2_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;284;4352,4000;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;282;4112,3904;Inherit;False;265;Stars1_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;302;4592,4032;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;307;4480,3936;Inherit;False;218;NightSkybox_BG;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;308;4736,3984;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;320;4976,3984;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;304;4304,4160;Inherit;False;44;DisortStartsNoise_2_R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;5088,3968;Inherit;False;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;457;4752,4224;Inherit;False;431;Cloud_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;398;4720,4144;Inherit;False;397;DisortDirt_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;321;4720,4064;Inherit;False;319;Nebula_Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;5478.736,4117.395;Inherit;False;62;D;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;5324.202,4035.067;Inherit;False;D;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5656.261,3778.544;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Study/MingChao/Scene_Skybox;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;10;0;9;0
WireConnection;10;1;6;0
WireConnection;16;0;10;0
WireConnection;16;1;15;0
WireConnection;139;0;133;0
WireConnection;139;1;141;0
WireConnection;133;0;132;0
WireConnection;141;0;140;0
WireConnection;141;1;142;0
WireConnection;146;0;147;0
WireConnection;146;1;149;0
WireConnection;147;0;148;0
WireConnection;149;0;151;0
WireConnection;149;1;150;0
WireConnection;144;1;146;0
WireConnection;156;0;144;1
WireConnection;156;1;157;0
WireConnection;156;2;162;0
WireConnection;162;0;157;0
WireConnection;162;1;158;0
WireConnection;164;0;160;0
WireConnection;159;0;156;0
WireConnection;159;1;164;0
WireConnection;57;0;56;0
WireConnection;76;0;57;0
WireConnection;76;1;72;0
WireConnection;92;0;76;0
WireConnection;92;1;91;0
WireConnection;79;0;82;0
WireConnection;79;1;86;0
WireConnection;79;2;96;0
WireConnection;82;0;99;0
WireConnection;82;1;100;0
WireConnection;99;0;97;0
WireConnection;100;0;98;0
WireConnection;107;0;108;0
WireConnection;107;1;109;0
WireConnection;107;2;112;0
WireConnection;108;0;110;0
WireConnection;108;1;111;0
WireConnection;110;0;113;0
WireConnection;111;0;114;0
WireConnection;85;0;92;0
WireConnection;85;1;79;0
WireConnection;115;0;92;0
WireConnection;115;1;107;0
WireConnection;116;0;115;0
WireConnection;116;1;91;0
WireConnection;94;0;85;0
WireConnection;94;1;91;0
WireConnection;106;1;116;0
WireConnection;117;0;106;0
WireConnection;117;1;118;0
WireConnection;117;2;119;0
WireConnection;102;0;37;0
WireConnection;102;1;103;0
WireConnection;102;2;104;0
WireConnection;184;0;117;0
WireConnection;194;0;193;0
WireConnection;194;1;190;0
WireConnection;195;0;194;0
WireConnection;195;1;208;0
WireConnection;216;0;194;0
WireConnection;216;1;195;0
WireConnection;216;2;217;0
WireConnection;219;0;216;0
WireConnection;219;1;220;0
WireConnection;183;0;102;0
WireConnection;17;0;16;0
WireConnection;17;1;6;0
WireConnection;27;0;17;0
WireConnection;27;1;126;0
WireConnection;27;2;233;0
WireConnection;227;0;27;0
WireConnection;227;1;232;0
WireConnection;231;0;229;0
WireConnection;243;0;39;0
WireConnection;243;1;245;0
WireConnection;243;2;246;0
WireConnection;245;0;244;0
WireConnection;246;0;244;0
WireConnection;235;0;243;0
WireConnection;235;2;237;0
WireConnection;250;0;254;0
WireConnection;34;1;235;0
WireConnection;254;0;34;0
WireConnection;254;1;248;0
WireConnection;130;1;139;0
WireConnection;240;0;238;0
WireConnection;240;1;222;0
WireConnection;240;2;259;0
WireConnection;265;0;240;0
WireConnection;44;0;251;0
WireConnection;241;0;252;0
WireConnection;251;0;250;0
WireConnection;253;0;250;2
WireConnection;252;0;250;1
WireConnection;242;0;253;0
WireConnection;37;1;94;0
WireConnection;274;0;276;0
WireConnection;274;1;279;0
WireConnection;274;2;275;0
WireConnection;277;0;274;0
WireConnection;260;0;35;0
WireConnection;260;1;261;0
WireConnection;262;0;260;0
WireConnection;256;0;262;0
WireConnection;256;1;257;0
WireConnection;256;2;264;0
WireConnection;35;1;285;0
WireConnection;36;1;289;0
WireConnection;267;0;36;0
WireConnection;267;1;268;0
WireConnection;269;0;267;0
WireConnection;270;0;269;0
WireConnection;270;1;271;0
WireConnection;270;2;272;0
WireConnection;285;0;40;0
WireConnection;285;1;287;0
WireConnection;285;2;288;0
WireConnection;287;0;286;0
WireConnection;288;0;286;0
WireConnection;289;0;41;0
WireConnection;289;1;291;0
WireConnection;289;2;292;0
WireConnection;291;0;290;0
WireConnection;292;0;290;0
WireConnection;293;0;295;0
WireConnection;293;2;294;0
WireConnection;295;0;38;0
WireConnection;295;1;297;0
WireConnection;295;2;298;0
WireConnection;297;0;296;0
WireConnection;298;0;299;0
WireConnection;33;1;293;0
WireConnection;299;0;296;0
WireConnection;299;1;300;0
WireConnection;218;0;219;0
WireConnection;18;0;227;0
WireConnection;45;0;256;0
WireConnection;273;0;270;0
WireConnection;152;0;159;0
WireConnection;305;0;33;1
WireConnection;305;1;306;0
WireConnection;347;0;305;0
WireConnection;347;1;346;0
WireConnection;348;0;347;0
WireConnection;348;1;33;1
WireConnection;317;0;314;0
WireConnection;317;1;318;0
WireConnection;316;0;317;0
WireConnection;315;0;317;0
WireConnection;332;0;329;0
WireConnection;334;0;325;1
WireConnection;325;1;328;0
WireConnection;43;0;348;0
WireConnection;328;0;327;0
WireConnection;328;1;332;0
WireConnection;328;2;331;0
WireConnection;172;0;171;0
WireConnection;172;1;170;0
WireConnection;173;0;172;0
WireConnection;173;1;174;0
WireConnection;175;0;176;0
WireConnection;175;1;174;0
WireConnection;177;0;173;0
WireConnection;177;1;175;0
WireConnection;179;0;178;0
WireConnection;179;1;177;0
WireConnection;179;2;182;0
WireConnection;198;0;197;0
WireConnection;198;1;196;0
WireConnection;199;0;198;0
WireConnection;199;1;205;0
WireConnection;200;0;206;0
WireConnection;200;1;205;0
WireConnection;201;0;199;0
WireConnection;201;1;200;0
WireConnection;204;0;202;0
WireConnection;204;1;201;0
WireConnection;214;0;204;0
WireConnection;210;0;214;0
WireConnection;210;1;207;0
WireConnection;213;0;210;0
WireConnection;213;2;212;0
WireConnection;203;0;213;0
WireConnection;180;0;179;0
WireConnection;350;0;358;0
WireConnection;350;1;342;0
WireConnection;336;0;358;0
WireConnection;337;0;339;0
WireConnection;337;1;338;0
WireConnection;339;0;336;0
WireConnection;331;0;329;0
WireConnection;344;0;342;0
WireConnection;344;1;323;0
WireConnection;323;0;358;0
WireConnection;323;1;335;0
WireConnection;323;2;322;0
WireConnection;349;0;355;0
WireConnection;349;1;344;0
WireConnection;349;2;351;0
WireConnection;355;0;350;0
WireConnection;355;1;357;0
WireConnection;310;1;374;0
WireConnection;342;0;337;0
WireConnection;342;1;323;0
WireConnection;358;0;310;0
WireConnection;358;1;359;0
WireConnection;358;2;360;0
WireConnection;319;0;349;0
WireConnection;313;0;311;0
WireConnection;313;1;315;0
WireConnection;313;2;316;0
WireConnection;376;0;375;0
WireConnection;374;0;313;0
WireConnection;374;1;376;0
WireConnection;389;5;390;0
WireConnection;389;2;391;0
WireConnection;389;24;407;0
WireConnection;394;0;389;0
WireConnection;393;0;399;0
WireConnection;393;1;394;0
WireConnection;399;0;392;0
WireConnection;399;1;401;0
WireConnection;399;2;402;0
WireConnection;401;0;400;0
WireConnection;402;0;400;0
WireConnection;404;0;388;0
WireConnection;404;1;405;0
WireConnection;404;2;406;0
WireConnection;407;0;395;0
WireConnection;407;1;408;0
WireConnection;397;0;404;0
WireConnection;388;1;393;0
WireConnection;134;0;130;1
WireConnection;233;0;231;0
WireConnection;232;0;229;0
WireConnection;419;0;429;0
WireConnection;420;0;429;0
WireConnection;429;0;421;0
WireConnection;429;1;430;0
WireConnection;418;0;417;0
WireConnection;418;1;419;0
WireConnection;418;2;420;0
WireConnection;411;0;410;0
WireConnection;411;1;413;0
WireConnection;411;2;414;0
WireConnection;413;0;412;0
WireConnection;414;0;412;0
WireConnection;452;0;451;0
WireConnection;438;0;437;0
WireConnection;436;0;411;0
WireConnection;436;1;438;0
WireConnection;415;0;385;0
WireConnection;415;1;386;0
WireConnection;415;2;416;0
WireConnection;415;3;449;0
WireConnection;415;4;453;0
WireConnection;386;1;418;0
WireConnection;435;0;441;0
WireConnection;431;0;415;0
WireConnection;385;1;450;0
WireConnection;450;0;436;0
WireConnection;450;2;452;0
WireConnection;443;0;442;0
WireConnection;444;0;442;0
WireConnection;432;5;433;0
WireConnection;432;2;434;0
WireConnection;432;18;443;0
WireConnection;432;17;444;0
WireConnection;441;0;432;0
WireConnection;441;1;440;0
WireConnection;458;1;462;0
WireConnection;462;0;466;0
WireConnection;284;0;282;0
WireConnection;284;1;283;0
WireConnection;302;0;284;0
WireConnection;302;1;304;0
WireConnection;308;0;307;0
WireConnection;308;1;302;0
WireConnection;320;0;308;0
WireConnection;320;1;321;0
WireConnection;320;2;398;0
WireConnection;320;3;457;0
WireConnection;312;0;320;0
WireConnection;62;0;312;0
WireConnection;0;2;312;0
ASEEND*/
//CHKSM=5F2AAACF9E28A8814D38C650AFE7A637FCB4E1C9