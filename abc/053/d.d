import std.algorithm, std.conv, std.range, std.stdio, std.string;

// path: arc068_b

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  int[int] b;
  foreach (ai; a) ++b[ai];

  auto c = b.values;
  c.sort!"a > b";

  foreach (ref ci; c) {
    if (ci < 3) break;
    ci = ci % 2 == 0 ? 2 : 1;
  }

  c.sort!"a > b";
  foreach (ref d; c.chunks(2)) {
    if (d.length == 1 || d[0] == 1 && d[1] == 1) break;
    --d[0];
    --d[1];
  }

  writeln(c.sum);
}
