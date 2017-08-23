import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  if (n % 2)
    writeln(n);
  else
    writeln(n / 2);
}
