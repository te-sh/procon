import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto a = new int[](n), rd = readln.chomp.splitter(' ');
  foreach (i; 0..n) {
    a[i] = rd.front.to!int;
    rd.popFront();
  }

  auto ma = 0, r = 0;
  foreach (ai; a) {
    if (ai < ma) r = max(r, ai);
    else ma = ai;
  }

  writeln(r);
}
