import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  if (n <= 59)      writeln("Bad");
  else if (n <= 89) writeln("Good");
  else if (n <= 99) writeln("Great");
  else              writeln("Perfect");
}
