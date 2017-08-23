import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx

version(unittest) {} else
void main()
{
  auto re = ["digi":  regex("nyo[^0-9A-Za-z]{0,3}$", "i"),
             "petit": regex("nyu[^0-9A-Za-z]{0,3}$", "i"),
             "rabi":  regex("[0-9A-Za-z]"),
             "gema":  regex("gema[^0-9A-Za-z]{0,3}$", "i"),
             "piyo":  regex("pyo[^0-9A-Za-z]{0,3}$", "i")];

  string line;
  while ((line = readln) !is null) {
    auto m = line.chomp.matchFirst(r"^([a-z]+) (.*)");
    auto actor = m[1], words = m[2];
    if (actor !in re || words.matchFirst(re[actor]).empty)
      writeln("WRONG!");
    else
      writeln("CORRECT (maybe)");
  }
}
