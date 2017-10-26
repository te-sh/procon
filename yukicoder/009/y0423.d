import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp;
  if (n == "ham")
    writeln(n);
  else
    writeln(n, "ham");
}
