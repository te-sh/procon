import std.algorithm, std.conv, std.range, std.stdio, std.string;

const n = 3;

version(unittest) {} else
void main()
{
  auto s = new int[](n);
  foreach (i; 0..n) s[i] = readln.chomp.to!int;
  foreach (si; s) writeln(s.count!(a => a >= si));
}
