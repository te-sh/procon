import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx
import std.uni;       // unicode

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto m = s.matchAll("([^ｗ]+)(ｗ+)");
  auto ma = m.map!(mi => mi[2].walkLength).maxElement;
  foreach (mi; m)
    if (mi[2].walkLength == ma)
      writeln(mi[1]);
}
