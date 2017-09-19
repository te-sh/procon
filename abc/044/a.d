import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto k = readln.chomp.to!int;
  auto x = readln.chomp.to!int;
  auto y = readln.chomp.to!int;

  if (n < k)
    writeln(x * n);
  else
    writeln(x * k + y * (n - k));
}
