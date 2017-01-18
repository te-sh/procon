import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto w = readln.chomp.to!long;
  auto d = readln.chomp.to!long;

  foreach_reverse (i; 2..d+1)
    w -= w / i ^^ 2;

  writeln(w);
}
