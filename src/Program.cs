using System.Diagnostics;
using System.IO;

namespace thenoah.bzflag.launcher{
  public class Program{
    public static void Main(string[] args){
      string[] bzflagPaths = Directory.GetDirectories(@"C:\Program Files (x86)", "BZFlag *");

      if(bzflagPaths.Length == 0){
        // bzflag is not installed
        return;
      }

      // get path to latest version of bzflag
      string bzflagPath = bzflagPaths[bzflagPaths.Length - 1] + @"\bzflag.exe";

      string bzflagArgs = "";

      // handle uri scheme
      if(args.Length > 0 && args[0].StartsWith("bzflag-launcher:")){
        bzflagArgs += args[0].Replace("bzflag-launcher:", "");
      }

      // start bzflag
      Process.Start(bzflagPath, bzflagArgs);
    }
  }
}