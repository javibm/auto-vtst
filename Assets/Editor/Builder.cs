using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class Builder : MonoBehaviour 
{
	[MenuItem("Test/Build")]
	static void PerformBuild ()
	{
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
