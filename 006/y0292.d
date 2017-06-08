import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, s = rd[0].array, t = rd[1].to!size_t, u = rd[2].to!size_t;

  if (t == u) {
    s = s.remove(t);
  } else if (t > u) {
    s = s.remove(t); s = s.remove(u);
  } else {
    s = s.remove(u); s = s.remove(t);
  }

  writeln(s);
}
