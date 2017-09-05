import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto d = 0, i = size_t(0);
  foreach (j; 1..n) {
    auto e = ask(0, j);
    if (d < e) {
      d = e;
      i = j;
    }
  }

  foreach (j; 1..n)
    if (j != i)
      d = max(d, ask(i, j));

  writeln("! ", d);
}

auto ask(size_t i, size_t j)
{
  writeln("? ", i+1, " ", j+1);
  stdout.flush();
  return readln.chomp.to!int;
}
