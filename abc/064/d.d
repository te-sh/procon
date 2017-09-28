import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = readln.chomp;

  auto i = 0, j = 0;
  foreach (c; s) {
    switch (c) {
    case '(':
      ++i;
      break;
    case ')':
      --i;
      if (i < 0) {
        i = 0;
        ++j;
      }
      break;
    default:
      assert(0);
    }
  }

  writeln('('.repeat.take(j), s, ')'.repeat.take(i));
}
