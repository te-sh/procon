import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  if (n == 1) {
    writeln("! 1");
    return;
  }

  auto q = (n - 1).bsr + 1, p = (1 << q), r = 0;

  auto gi = new int[][](n, n);

  auto ask(int[][] pairs)
  {
    auto send = pairs.chain([-1, -1].repeat).take(n);
    writeln("? ", send.joiner.map!"a+1".array.to!(string[]).join(" "));
    stdout.flush();

    auto ci = readln.split;
    foreach (pair, c; lockstep(pairs, ci.take(pairs.length))) {
      auto d = c.predSwitch(">", 1, "=", 0, "<", -1);
      if (pair[0] != -1 && pair[1] != -1) {
        gi[pair[0]][pair[1]] = d;
        gi[pair[1]][pair[0]] = -d;
      }
    }
  }

  foreach (i; 1..q+1) {
    auto bs = (1 << (i - 1)), bs2 = (bs << 1);
    foreach (j; 0..bs) {
      int[][] pairs;
      foreach (k; 0..p/bs2) {
        foreach (m; 0..bs) {
          auto pair = [k * bs2 + m, k * bs2 + bs + (m + j) % bs];
          if (pair[0] < n && pair[1] < n) {
            gi[pair[0]][pair[1]] = 1;
            pairs ~= pair;
          } else {
            pairs ~= [-1, -1];
          }
        }
      }
      ask(pairs);
    }
  }

  auto ri = n.iota.array;
  ri.sort!((a, b) => gi[a][b] < 0);

  writeln("! ", ri.map!"a+1".array.to!(string[]).join(" "));
}

pragma(inline) {
  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
