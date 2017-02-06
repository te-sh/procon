import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.uni;       // unicode

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto r = n.iota.map!(_ => readln.chomp).map!calc.fold!min;

  writeln(r);
}

auto calc(string v)
{
  auto b = convertDigit(v.fold!max) + 1;
  return convert(v, b);
}

long convert(string s, int b)
{
  auto r = 0L;
  auto j = 1L;
  foreach (c; s.retro) {
    r += j * convertDigit(c);
    j *= b;
  }
  return r;
}

int convertDigit(dchar c)
{
  return c.isNumber ? c - '0' : c - 'A' + 10;
}
