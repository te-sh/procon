import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;

  int t, r, e;
  foreach (c; s) {
    switch (c) {
    case 't': ++t; break;
    case 'r': ++r; break;
    case 'e': ++e; break;
    default: break;
    }
  }

  writeln(min(t, r, e/2));
}
