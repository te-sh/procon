import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  struct S { size_t i; int h; }
  auto n = readln.chomp.to!size_t;
  auto s = new S[](n);
  auto rd = readln.splitter;
  foreach (i; 0..n) {
    s[i] = S(i+1, rd.front.to!int);
    rd.popFront();
  }
  s.sort!"a.h > b.h";
  foreach (si; s) writeln(si.i);
}
