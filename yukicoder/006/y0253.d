import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto mi = 10, ma = 10 ^^ 9, c = 64, t = 0;

  auto ask(int n)
  {
    writeln("? ", n); stdout.flush();
    auto s = readln.chomp.to!int;
    ++t;
    return s;
  }

  for (;;) {
    auto s = ask(c);

    switch (s) {
    case 0:
      writeln("! ", c + t - 1);
      return;
    case -1:
      --mi;
      ma = c - 1;
      break;
    case 1:
      mi = c - 1;
      --ma;
      break;
    default:
      assert(0);
    }

    if (ma - mi <= 1)
      break;

    c = (ma + mi) / 2;
  }

  for (;;) {
    auto s1 = ask(mi);
    if (s1 == 0) {
      writeln("! ", mi + t - 1);
      return;
    }
  }
}
