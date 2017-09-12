import std.algorithm, std.conv, std.range, std.stdio, std.string;

const n = 12;

version(unittest) {} else
void main()
{
  auto s = new string[](n);
  foreach (i; 0..n) s[i] = readln.chomp;
  writeln(s.count!(si => si.canFind('r')));
}
