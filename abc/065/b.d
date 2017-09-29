import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = new int[](n), b = new bool[](n);
  foreach (i; 0..n) a[i] = readln.chomp.to!int-1;

  auto c = 0, d = 0;
  for (;;) {
    ++d;
    b[c] = true;
    c = a[c];
    if (c == 1) {
      writeln(d);
      break;
    }
    if (b[c]) {
      writeln(-1);
      break;
    }
  }
}
