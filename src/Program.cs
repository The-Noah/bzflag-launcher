using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;

namespace thenoah.bzflag.launcher{
  public class Program{
    private static Dictionary<string, string> config = new Dictionary<string, string>();

    private static string bzflagPath;

    public static void Main(string[] args){
      // check to make sure the config file exists and parse it if it does
      if(File.Exists("config.txt")){
        // ready the config
        string[] lines = File.ReadAllLines("config.txt");

        // parse it
        foreach(string line in lines){
          string[] data = line.Split('=');

          // not a valid line or already set
          if(data.Length != 2 || config.ContainsKey(data[0])){
            continue;
          }

          config.Add(data[0], data[1]);
        }
      }

      if(config.ContainsKey("path")){
        // load path from config
        config.TryGetValue("path", out bzflagPath);

        if(!File.Exists(bzflagPath) && File.Exists(Path.Combine(bzflagPath, "bzflag.exe"))){
          bzflagPath = Path.Combine(bzflagPath, "bzflag.exe");
        }
      }else{
        FindBZFlagPath();
      }

      if(!File.Exists(bzflagPath)){
        // we can't find bzflag, quit
        throw new Exception("unable to find BZFlag");
      }

      string bzflagArgs = "";

      // handle uri scheme
      if(args.Length > 0 && args[0].StartsWith("bzflag-launcher:")){
        // convert url encoded spaces to normal spaces
        args[0] = args[0].Replace("%20", " ");

        string[] uriArgs = args[0].Replace("bzflag-launcher:", "").Split(' ');

        // team
        if(uriArgs.Length > 1){
          bzflagArgs += $"-team {uriArgs[1]} ";
        }

        // server address
        bzflagArgs += uriArgs[0];
      }

      // start bzflag
      Process.Start(bzflagPath, bzflagArgs);
    }

    private static void FindBZFlagPath(){
      string[] bzflagPaths = Directory.GetDirectories(@"C:\Program Files (x86)", "BZFlag *");

      if(bzflagPaths.Length == 0){
        // bzflag is not in the defualt location
        return;
      }

      // get path to latest version of bzflag
      bzflagPath = bzflagPaths[bzflagPaths.Length - 1] + @"\bzflag.exe";
    }
  }
}