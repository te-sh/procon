import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1], c = rd[2];

  if (n == 1 && m == 2 || n == 2 && m == 1 || m > 1 && n % 2 == 0 || n > 1 && m % 2 == 0)
    writeln("YES");
  else
    writeln("NO");
}
