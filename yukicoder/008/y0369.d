import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto rd = readln.chomp.splitter, r = 0;
  foreach (i; 0..n) {
    r += rd.front.to!int;
    rd.popFront();
  }
  writeln(r - readln.chomp.to!int);
}
