import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), n = rd[0], a = rd[1];
  auto x = readln.split.to!(long[]);

  auto sx = x.sum;
  writeln(sx % n == 0 && sx / n == a ? "YES" : "NO");
}
