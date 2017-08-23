import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto d = readln.chomp.to!int;
  auto hi = 3.iota.map!(_ => readln.chomp.to!int).array;

  if (d == 0) {
    if (hi[0] != hi[2] &&
        (hi[0] > hi[1] && hi[2] > hi[1] ||
         hi[0] < hi[1] && hi[2] < hi[1]))
      writeln(0);
    else
      writeln(-1);

    return;
  }

  auto r = min(calc1(d, hi.dup), calc2(d, hi.dup));
  writeln(r == int.max ? -1 : r);
}

auto calc1(int d, int[] hi)
{
  auto r = 0;

  if (hi[0] == hi[2]) {
    ++r;
    hi[0] = max(hi[0] - d, 0);
  }

  auto mh = min(hi[0], hi[2]);
  if (mh == 0) return int.max;
  if (hi[1] < mh) return r;

  auto s = (hi[1] - mh + d) / d;
  hi[1] = max(hi[1] - d * s, 0);
  r += s;

  return r;
}

auto calc2(int d, int[] hi)
{
  auto r = 0;

  if (hi[1] == 0) return int.max;

  foreach (i; [0, 2]) {
    if (hi[i] < hi[1]) continue;

    auto s = (hi[i] - hi[1] + d) / d;
    hi[i] = max(hi[i] - d * s, 0);
    r += s;
  }

  if (hi[0] == hi[2]) {
    ++r;
    hi[0] = max(hi[0] - d, 0);
  }

  if (hi[0] == hi[2]) return int.max;

  return r;
}
