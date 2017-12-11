import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto m = readln.chomp.to!int;
  auto t = 1;
  foreach (i; 0..2017*2)
    (t *= 2017) %= m;

  (t += 2017) %= m;

  writeln(t);
}
