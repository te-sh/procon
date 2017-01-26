import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto d = readln.chomp.to!int;

  auto hd = d / 2;
  auto maxS = 0;
  foreach (l; 1..hd/2+1)
    maxS = max(maxS, l * (hd - l));

  writeln(maxS);
}
