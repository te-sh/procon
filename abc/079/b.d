import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto l = new long[](n+1);
  l[0] = 2;
  l[1] = 1;

  foreach (i; 2..n+1)
    l[i] = l[i-1]+l[i-2];

  writeln(l[n]);
}
