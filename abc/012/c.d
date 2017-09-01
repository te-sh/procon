import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  auto s = 0;
  foreach (i; 1..10)
    foreach (j; 1..10)
      s += i * j;

  auto r = s - n;
  foreach (i; 1..10)
    foreach (j; 1..10)
      if (i * j == r)
        writeln(i, " x ", j);
}
