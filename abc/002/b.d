import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx

version(unittest) {} else
void main()
{
  auto w = readln.chomp;
  writeln(w.replaceAll(r"[aeiou]".regex, ""));
}
