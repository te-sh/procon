import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto c = readln.chomp.map!(ci => cast(int)(ci - '1')), cn = 4;
  auto s = new int[](4);
  foreach (i; 0..cn) s[i] = c.count(i).to!int;
  s.sort();
  writeln(s[$-1], " ", s[0]);
}
