using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System;

public class Builder : MonoBehaviour 
{
	[MenuItem("Test/Build")]
	static void PerformBuild ()
	{
		var moduleManager = System.Type.GetType("UnityEditor.Modules.ModuleManager,UnityEditor.dll");
		var isPlatformSupportLoaded = moduleManager.GetMethod("IsPlatformSupportLoaded", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.NonPublic);
		var getTargetStringFromBuildTarget = moduleManager.GetMethod("GetTargetStringFromBuildTarget", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.NonPublic);
			
		Debug.Log("JAVI "+ (bool)isPlatformSupportLoaded.Invoke(null,new object[] {(string)getTargetStringFromBuildTarget.Invoke(null, new object[] {BuildTarget.Android})}));

		EditorPrefs.SetString("AndroidSdkRoot", Environment.GetEnvironmentVariable("ANDROID_SDK_HOME"));
		EditorPrefs.SetString("JdkPath", Environment.GetEnvironmentVariable("JAVA_HOME"));
		EditorUserBuildSettings.selectedBuildTargetGroup = BuildTargetGroup.Android;
		AssetDatabase.SaveAssets();
		BuildPipeline.BuildPlayer(getScenesInBuildSettings(), Path.Combine(Path.GetFullPath("."), "test.apk"), BuildTarget.Android, new BuildOptions{});
	}

	private static string[] getScenesInBuildSettings()
    {
      List<string> temp = new List<string>();
      foreach (UnityEditor.EditorBuildSettingsScene scene in UnityEditor.EditorBuildSettings.scenes)
      {
        if (scene.enabled)
        {
          temp.Add(scene.path);
        }
      }
      return temp.ToArray();
    }
}
