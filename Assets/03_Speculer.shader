Shader "Unlit/03_Speculer"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			struct appData
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 world : TEXCOORD1;
				float3 normal : NORMAL;
			};
			v2f vert(appData v)
			{
				v2f output;
				output.vertex = UnityObjectToClipPos(v.vertex);
				output.normal = UnityObjectToWorldNormal(v.normal);
				output.world = mul(unity_ObjectToWorld, v.vertex);
				return output;
			}

			fixed4 frag(v2f input) : SV_Target
			{
				float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - input.world);
				float3 lightDir = normalize(_WorldSpaceLightPos0);
				input.normal = normalize(input.normal);
				float3 reflectDir = -lightDir + 2 * input.normal * dot(input.normal, lightDir);
				fixed4 speculer = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0;
				
				
				return speculer;
			}    
			
		    ENDCG
		}
	}
}

