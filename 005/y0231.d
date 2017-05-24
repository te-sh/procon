import std.algorithm, std.conv, std.range, std.stdio, std.string;

const deathPena = 30000L, hours = 6;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  size_t idx; long exp;
  foreach (i; 0..n) {
    auto rd = readln.split.to!(long[]), g = rd[0], d = rd[1];
    auto e = g - d * deathPena;
    if (exp <= e) {
      idx = i;
      exp = e;
    }
  }

  if (exp * hours < deathPena * 100) {
    writeln("NO");
  } else {
    writeln("YES");
    foreach (_; 0..hours)
      writeln(idx + 1);
  }
}
