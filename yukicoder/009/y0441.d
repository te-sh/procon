import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, a = rd[0], b = rd[1];

  auto calc()
  {
    if (a == "1" || b == "1") return "S";
    if (a == "0" && b == "0") return "E";
    if (a == "0" || b == "0") return "S";
    if (a == "2" && b == "2") return "E";
    return "P";
  }

  writeln(calc());
}
