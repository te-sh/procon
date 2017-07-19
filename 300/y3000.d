import std.algorithm, std.conv, std.range, std.stdio, std.string;

const a = "cqlmdrstfxyzbanopuvweghijk";

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  foreach (c; s) write(a[c - 'a']);
  writeln;
}
