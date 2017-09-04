import std.algorithm, std.conv, std.range, std.stdio, std.string;

const n = 3;

version(unittest) {} else
void main()
{
  auto r = 0;
  foreach (_; 0..3) {
    auto rd = readln.split.to!(int[]), s = rd[0], e = rd[1];
    r += s * e / 10;
  }
  writeln(r);
}
