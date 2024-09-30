using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class WeiLiNai_GlobalShader : MonoBehaviour
{
    //声明材质数组
    private Material[] materials;
    

    [Header("Global Light")][Tooltip("全局光照")]
    [Range(0.0f, 3.0f)]
    public float LightIntensity = 1.0f; //全局光照强度

    [Range(0.0f, 1.0f)]
    public float LightLerp = 0.5f;  //光照衰减率

    public Color LightColor = Color.white;  //全局光照颜色
    public Color DiffuseLightColor = Color.white; //全局漫反射光照颜色

    [Range(0.0f, 1.0f)]
    public float LightThreshold = 0.5f; //阈值 
    [Range(0.0f, 0.35f)]
    public float SoftEdge = 0.0f; //边缘光滑度
    [Range(0.0f, 1.5f)]
    public float LightSpecness = 0.5f; //光照反射度

    [Header("Hair")][Tooltip("头发材质")]
    
    [Range(0.0f, 2.0f)]
    public float AnisoSpecularShiness = 0.5f; //光照亮度

    public  Color RampColor = Color.white; //头发的颜色渐变
    public Color HightLightTintColor = Color.white; //高光颜色

    public float HightLightTintIntensity = 1.0f; //颜色强度
    [Range(0.0f, 1.0f)]
    public float HightLightLerp = 0.5f; //高光衰减率
    


    void Update()
    {  

        
       
        //获取当前物体及所有子物体的渲染器
        Renderer[] renderers = GetComponentsInChildren<Renderer>();

        //遍历渲染器，获取材质
        foreach (Renderer renderer in renderers)
        {
            //遍历每个材质
            foreach (Material material in renderer.sharedMaterials)
            {   if(material != null){
                //设置全局光照强度
                Shader.SetGlobalFloat("LightInt_G", LightIntensity);
                //设置光照衰减率
                Shader.SetGlobalFloat("LightLerp_G", LightLerp);
                //设置全局光照颜色
                Shader.SetGlobalColor("LightColor_G", LightColor);
                //设置全局漫反射光照颜色
                Shader.SetGlobalColor("TintDiffuseLightColor_G", DiffuseLightColor);
                
                Shader.SetGlobalVector("RightVec_G", transform.right);
                Shader.SetGlobalVector("ForwardVec_G", transform.forward);
                
                //设置阈值
                Shader.SetGlobalFloat("LightThreshold_G", LightThreshold);
                //设置边缘光滑度                
                Shader.SetGlobalFloat("SoftEdge_G", SoftEdge);
                //设置光照反射度
                Shader.SetGlobalFloat("LightSpecness_G", LightSpecness);
                //设置头发的颜色渐变
                Shader.SetGlobalColor("RampColor_G", RampColor);
                //设置高光颜色
                Shader.SetGlobalColor("HightLightTintColor_G", HightLightTintColor);
                //设置颜色强度
                Shader.SetGlobalFloat("HightLightTintInt_G", HightLightTintIntensity);
                //设置高光衰减率
                Shader.SetGlobalFloat("HightLightShadowLerp_G", HightLightLerp);
                //设置光照亮度
                Shader.SetGlobalFloat("AnisoSpecShininess_G", AnisoSpecularShiness);
            }    
            } 
        }
    }

}
