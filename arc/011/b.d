import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.uni;       // unicode

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto w = readln.split;
  writeln(w.map!conv.filter!(si => si != "").join(" "));
}

//           abcdefghijklmnopqrstuvwxyz
const tbl = " 112 498 38579 74063 526 0";

auto conv(string s)
{
  auto r = "";

  foreach (c; s)
    if (c.isAlpha) {
      auto a = tbl[c.toLower - 'a'];
      if (a != ' ') r ~= a;
    }

  return r;
}
