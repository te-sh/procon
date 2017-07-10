import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;

  auto w = 0L, r = 0L;
  foreach_reverse (c; s)
    switch (c) {
    case 'c':
      r += w * (w-1) / 2;
      break;
    case 'w':
      ++w;
      break;
    default:
    }

  writeln(r);
}
