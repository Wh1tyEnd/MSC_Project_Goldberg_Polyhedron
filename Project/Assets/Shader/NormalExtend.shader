// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/HexagonUVHighlight"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white"{}
	    _LineSize("OutlineSize", range(0, 0.1)) = 0.02
		_LineColor("LineColor", Color) = (0,0,0,1)
	}
	SubShader
	{
		Pass
		{
			Tags{ "LightMode" = "Always" }
			// �Ȼ��������ɫ�Ķ��㣬Ȼ������һ��pass���ƶ���
			//���ﲻ����ǰ���棬�رղü�ǰ���棬Ҳ����Ҫ��Ȼ���
			Cull Off // �ر��޳���ģ��ǰ�󶼻���ʾ
			ZWrite Off // ϵͳĬ���ǿ��ģ�Ҫ�رա��ر���Ȼ��棬����Ⱦ����������ZTest�Ľ�����Լ���Ⱦ���д��
			ZTest Always  // ��Ȳ���[һֱ��ʾ]�����������嵲ס�󣬴�pass���Ƶ���ɫ����ʾ����
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			float _LineSize;
			float4 _LineColor;
			struct v2f
			{
				float4 pos:SV_POSITION;
				float4 color : COLOR;
			};
			v2f vert(appdata_full v)
			{
				v2f o;
				// ��ȡģ�͵����յ�ͶӰ����
				o.pos = UnityObjectToClipPos(v.vertex);
				// UNITY_MATRIX_IT_MVΪ��ģ������-��������-��������꡿��ר����Է��ߵı任��
				// ���߳���MV����ģ�Ϳռ� ת�� ��ͼ�ռ�
				float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
				// ת�� ��ͼ�ռ� �� ͶӰ�ռ� ��3Dת2D��
				float2 offset = TransformViewToProjection(norm.xy);
				// �õ���offset��ģ�ͱ����ķǳ���Ȼ����Ա���
				o.pos.xy += offset * _LineSize;
				o.color = _LineColor;
				return o;
			}
			float4 frag(v2f i) : COLOR
			{
				return i.color;
			}
			ENDCG
		}
		Pass
		{
			// ֱ��ʹ�ö����Ƭ��shader��ʾ����
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct v2f 
			{
				float4 pos:SV_POSITION;
				float2 uv : TEXCOORD0;// ������������������,float2��һ��ƽ��
			};
			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			float4 frag(v2f i) : COLOR
			{
				float4 texCol = tex2D(_MainTex, i.uv);
				return texCol;
			}
			ENDCG
		}
	}
}