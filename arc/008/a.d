import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int, nd = n/10, nm = n%10;

  auto ans = nd*100;
  ans += nm >= 7 ? 100 : nm*15;

  writeln(ans);
}
