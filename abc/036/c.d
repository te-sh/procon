import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = new int[](n);
  foreach (i; 0..n) a[i] = readln.chomp.to!int;
  auto b = a.dup.sort().array.uniq;
  int[int] c;
  auto d = 0;
  foreach (bi; b) c[bi] = d++;
  foreach (ai; a) writeln(c[ai]);
}
