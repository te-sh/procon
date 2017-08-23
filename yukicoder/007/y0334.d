import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto k = readln.split.to!(int[]);

  auto r = winMe(k);
  if (r.equal([0,0,0]))
    writeln(-1);
  else
    writeln(r.to!(string[]).join(" "));
}

size_t[][] combis(int[] k)
{
  auto n = k.length;
  size_t[][] r;

  foreach (i1; 0..n)
    foreach (i2; i1+1..n)
      foreach (i3; i2+1..n)
        if (isKadomatsu(k[i1], k[i2], k[i3]))
          r ~= [i1, i2, i3];

  return r;
}

size_t[] winMe(int[] k)
{
  auto c = combis(k);
  if (c.empty) return [0,0,0];

  foreach (ci; c) {
    auto nk = k[0..ci[0]] ~ k[ci[0]+1..ci[1]] ~ k[ci[1]+1..ci[2]] ~ k[ci[2]+1..$];
    auto r = winMe(nk);
    if (r.equal([0,0,0])) return ci;
  }

  return [0,0,0];
}

auto isKadomatsu(int a, int b, int c)
{
  return a != b && b != c && c != a && (a > b && c > b || a < b && c < b);
}
