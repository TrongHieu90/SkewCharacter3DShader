shader "Custom/CustomUnlitSkewY"
{
    //Skew vertex shader to give 3d character to show more face when looking top down
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Skew("Skew", Vector) = (0,0,0)
        _Offset("Offset", Vector) = (0,0,0)
        _Flatten("Flatten", float) = 1.0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            //Flatten (0 = total flat, 1 = normal size)
            float _Flatten;

            float3 _Skew;
            float3 _Offset;

            v2f vert(appdata v)
            {
                v2f o;
                
                //skew y in world position
                float4 world = mul(unity_ObjectToWorld, v.vertex);

                //naive way to skew y using model vertex
                //world.y += _Offset.y + (_Skew.y * v.vertex.y);

                //alternative: do this because vertex.y axis is not always the same from models
                //being made from different 3d software
                float4 worldOrigin = mul(unity_ObjectToWorld, float4(0,0,0,1)); //get origin point of model in world pos
                world.y += _Offset.y + (_Skew.y * (world.z - worldOrigin.z)); //minus from world position to only skew relative to local axis

                world.x += _Offset.x;
                world.z += _Offset.z;

                //convert back to object position
                v.vertex = mul(unity_WorldToObject, world);

                //convert to screen position to flatten down the y skew
                float4 screen = mul(UNITY_MATRIX_MV, v.vertex);
                screen.y *= _Flatten;

                //back to object position
                v.vertex = mul(screen, UNITY_MATRIX_IT_MV);

                //final for fragment
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.texcoord);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
    Fallback "Unlit/Texture"
}