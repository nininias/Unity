Shader "Study/MingChao/Transformational"

{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}  // 主纹理
        _SecondaryTex ("Secondary Texture", 2D) = "white" {}  // 副纹理
        _DisortStartsNoise_1 ("DisortStartsNoise_1", 2D) = "white" {}  // 对应 _13
        _DisortStartsNoise_2 ("DisortStartsNoise_2", 2D) = "white" {}  // 对应 _14
        _Stars2 ("Stars2", 2D) = "white" {}  // 对应 _15
        _Stars1 ("Stars1", 2D) = "white" {}  // 对应 _16
        _DisortStartsNoise_6 ("DisortStartsNoise_6", 2D) = "white" {}  // 对应 _17

        // 添加新的可传递参数
        _OffsetX ("Offset X", Float) = 0.5   // 对应 _4
        _OffsetY ("Offset Y", Float) = 0.5   // 对应 _5
        _RotationIndex ("Rotation Index", Range(0, 7)) = 0   // 对应 _6，使用范围0到7
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            sampler2D _SecondaryTex;
            sampler2D _DisortStartsNoise_1;  // 对应 _13
            sampler2D _DisortStartsNoise_2;  // 对应 _14
            sampler2D _Stars2;  // 对应 _15
            sampler2D _Stars1;  // 对应 _16
            sampler2D _DisortStartsNoise_6;  // 对应 _17

            // Uniforms from the GLSL code
            uniform float4 _M0[5];
            uniform float4 _M1[7];

            // 新的参数
            float _OffsetX;  // 对应 _4，X方向的偏移
            float _OffsetY;  // 对应 _5，Y方向的偏移
            int _RotationIndex;  // 对应 _6，旋转索引

            const float2 _62[8] = { 
                float2(1.0, 1.0), float2(1.0, 1.0), float2(-1.0, 1.0), 
                float2(-1.0, -1.0), float2(1.0, -1.0), float2(1.0, 1.0), 
                float2(-1.0, 1.0), float2(-1.0, -1.0) 
            };

            // Input variables for vertex shader
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 color : COLOR;
            };

            // Utility function to modify position
            void ModifyPosition(inout float4 pos)
            {
                pos.y = -pos.y;
                pos.z = (2.0 * pos.z) - pos.w;
            }

            // Vertex Shader
            v2f vert(appdata v)
            {
                v2f o;

                // Cross product calculation
                float3 crossVec = cross(cross(v.tangent.xyz, v.normal) * v.tangent.w, v.tangent.xyz) * v.tangent.w;

                // Matrix construction
                float3x3 rotationMatrix;
                rotationMatrix[0] = _M1[0].xyz;
                rotationMatrix[1] = _M1[1].xyz;
                rotationMatrix[2] = _M1[2].xyz;
                rotationMatrix[0] *= _M1[4].xxx;
                rotationMatrix[1] *= _M1[4].yyy;
                rotationMatrix[2] *= _M1[4].zzz;

                // Position transformation based on uniform values
                float3 transformedPosition = (v.vertex.xyz * _M1[6].xyz) + _M1[5].xyz;
                float4 worldPosition = float4(transformedPosition, 1.0);
                
                float3 finalPosition = ((rotationMatrix[0] * worldPosition.x) + (rotationMatrix[1] * worldPosition.y) + (rotationMatrix[2] * worldPosition.z)) + (_M1[3].xyz + _M0[4].xyz);
                float4 outputPosition = float4(finalPosition, 1.0);

                // Texture UV manipulation
                float2 uv = v.uv;
                
                // Final vertex transformation
                ModifyPosition(outputPosition);
                
                o.pos = UnityObjectToClipPos(outputPosition); // Convert to clip space
                o.uv = uv;
                o.color = float4(crossVec, 1.0); // Example: using cross product vector as color
                
                return o;
            }

            // Fragment Shader
            float4 frag(v2f i) : SV_Target
            {
                // Sample main texture with modified UV coordinates
                float2 screenCoords = ((i.uv - float2(_OffsetX, _OffsetY) * 0.5) * _62[_RotationIndex]) + (float2(_OffsetX, _OffsetY) * 0.5);
                float4 texColor = tex2D(_MainTex, screenCoords);
                
                // Sample additional textures (example of how they can be used)
                float4 disort1 = tex2D(_DisortStartsNoise_1, screenCoords);  // 使用 _DisortStartsNoise_1
                float4 disort2 = tex2D(_DisortStartsNoise_2, screenCoords);  // 使用 _DisortStartsNoise_2
                float4 stars1 = tex2D(_Stars1, screenCoords);  // 使用 _Stars1
                float4 stars2 = tex2D(_Stars2, screenCoords);  // 使用 _Stars2
                float4 disort6 = tex2D(_DisortStartsNoise_6, screenCoords);  // 使用 _DisortStartsNoise_6

                // 简单的颜色合并或混合 (根据需求自定义)
                float4 finalColor = texColor * stars1 + disort1 * disort6;

                return finalColor;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}

