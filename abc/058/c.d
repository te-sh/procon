import std.algorithm, std.conv, std.range, std.stdio, std.string;

// path: arc071_a

const alpha = 26, a = 'a';

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto b = new int[](alpha), bs = new int[](alpha);
  b[] = int.max;

  foreach (_; 0..n) {
    auto s = readln.chomp;
    bs[] = 0;
    foreach (c; s) ++bs[c-a];
    foreach (i; 0..alpha) b[i] = min(b[i], bs[i]);
  }

  foreach (i; 0..alpha)
    foreach (j; 0..b[i])
      write(cast(char)(a+i));
  writeln;
}
