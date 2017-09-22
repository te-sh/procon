import std.algorithm, std.conv, std.range, std.stdio, std.string;

// path: arc069_a

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), n = rd[0], m = rd[1];
  auto c = min(n, m/2);
  m -= c*2;
  c += m/4;
  writeln(c);
}
