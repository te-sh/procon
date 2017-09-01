import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto b = new int[](11);
  foreach (i; 1..11)
    if (i % 2 != 0 && i % 3 != 2)
      b[i] = 0;
    else
      b[i] = b[i-1] + 1;

  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  auto r = 0;
  foreach (ai; a) r += b[ai];
  writeln(r);
}
