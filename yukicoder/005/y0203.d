import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s1 = readln.chomp, s2 = readln.chomp, s = s1 ~ s2;
  writeln(s.group.filter!"a[0] == 'o'".map!"a[1]".maxElement);
}
