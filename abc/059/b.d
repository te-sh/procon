import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.chomp;
  auto b = readln.chomp;
  auto s = max(a.length, b.length);
  auto a2 = a.rightJustify(s, '0');
  auto b2 = b.rightJustify(s, '0');

  if (a2 == b2)
    writeln("EQUAL");
  else if (a2 < b2)
    writeln("LESS");
  else
    writeln("GREATER");
}
