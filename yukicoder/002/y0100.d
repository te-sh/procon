import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]).map!"a - 1".array;

  auto bi = new bool[](n);
  size_t[] ci;

  for (;;) {
    auto i = bi.countUntil!"!a".to!int;
    if (i == -1) break;

    auto j = i;
    int[] di;

    do {
      bi[j] = true;
      di ~= j;
      j = ai[j];
    } while (i != j);

    ci ~= di.length;
  }

  if (ci.sort().group.filter!"a[0] % 2 == 0".all!"a[1] % 2 == 0")
    writeln("Yes");
  else
    writeln("No");
}
