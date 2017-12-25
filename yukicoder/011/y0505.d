import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto a = readln.split.to!(long[]);

  auto ma = a[0], mi = a[0];
  foreach (ai; a[1..$]) {
    auto nma = max(ma+ai, ma-ai, ma*ai, mi+ai, mi-ai, mi*ai);
    auto nmi = min(ma+ai, ma-ai, ma*ai, mi+ai, mi-ai, mi*ai);
    if (ai != 0) {
      nma = max(nma, ma/ai, mi/ai);
      nmi = min(nmi, ma/ai, mi/ai);
    }
    ma = nma;
    mi = nmi;
  }

  writeln(ma);
}
